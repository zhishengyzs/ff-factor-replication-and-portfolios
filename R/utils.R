# R/utils.R
library(DBI)
library(RSQLite)
library(dplyr)
library(readr)

connect_db <- function(db_path) {
  DBI::dbConnect(RSQLite::SQLite(), db_path)
}

# --- performance helpers (monthly data) ---
ann_mean   <- function(x) mean(x, na.rm = TRUE) * 12
ann_sd     <- function(x) sd(x, na.rm = TRUE) * sqrt(12)
ann_sharpe <- function(x) ann_mean(x) / ann_sd(x)

# drawdown on a return series (total returns, not excess)
drawdown <- function(r) {
  wealth <- cumprod(1 + r)
  peak   <- cummax(wealth)
  (wealth / peak) - 1
}

# --- caching helpers ---
save_rds <- function(obj, path) saveRDS(obj, path)
read_rds <- function(path) readRDS(path)

load_or_build <- function(path, builder_fn, rebuild = FALSE) {
  if (!rebuild && file.exists(path)) return(readRDS(path))
  obj <- builder_fn()
  saveRDS(obj, path)
  obj
}

# --- safe date conversion for FF tables stored as ints ---
ff_date_from_int <- function(x) as.Date(x, origin = "1960-01-01")

# -------------------------------------------------------------------
# assign_portfolio()
#
# Assigns assets to characteristic-sorted portfolios using NYSE-based
# breakpoints, following standard Fama–French sorting conventions.
#
# Inputs:
#   - data: data frame containing the sorting variable and exchange code
#   - sorting_variable: column to be sorted on (unquoted)
#   - percentiles: numeric vector of breakpoint probabilities (e.g. c(0.5), c(0.3, 0.7))
#
# Output:
#   - Integer vector of portfolio assignments (1 = lowest, K = highest)
#
# Notes:
#   - Breakpoints are computed using NYSE stocks only
#   - Portfolio labels are assigned to the full cross-section
# -------------------------------------------------------------------
assign_portfolio <- function(data, sorting_variable, percentiles) {
  breakpoints <- data %>%
    dplyr::filter(exchange == "NYSE") %>%
    dplyr::pull({{ sorting_variable }}) %>%
    stats::quantile(
      probs = c(0, percentiles, 1),
      na.rm = TRUE,
      names = FALSE
    )
  
  findInterval(
    dplyr::pull(data, {{ sorting_variable }}),
    breakpoints,
    all.inside = TRUE
  )
}

# -------------------------------------------------------------------
# nw_coeftest()
#
# Computes Newey–West heteroskedasticity- and autocorrelation-consistent
# (HAC) standard errors for a linear regression model.
#
# Inputs:
#   - model: fitted lm() object
#   - lag: number of lags used in the Newey–West estimator (default = 6)
#
# Output:
#   - Coefficient table with HAC standard errors, t-stats, and p-values
# -------------------------------------------------------------------
nw_coeftest <- function(model, lag = 6) {
  lmtest::coeftest(model, vcov = sandwich::NeweyWest(model, lag = lag))
}

# -------------------------------------------------------------------
# replication_row()
#
# Runs: official ~ replicated and returns a tidy summary row
# using Newey–West standard errors.
#
# Inputs:
#   - data: data.frame containing the series
#   - official: column name (string) for the official factor
#   - replicated: column name (string) for the replicated factor
#   - name: label for the factor row
#   - lag: Newey–West lag length (default = 6)
#
# Output:
#   - Tibble with alpha, beta, Newey–West t-stat/p-value for beta, and R^2
# -------------------------------------------------------------------
replication_row <- function(data, official, replicated, name, lag = 6) {
  fml <- stats::reformulate(replicated, response = official)
  model <- stats::lm(fml, data = data, na.action = stats::na.omit)
  nw_se <- nw_coeftest(model, lag = lag)
  
  tibble::tibble(
    Factor = name,
    Alpha  = unname(nw_se["(Intercept)", 1]),
    Beta   = unname(nw_se[2, 1]),
    t_NW   = unname(nw_se[2, 3]),
    p_NW   = unname(nw_se[2, 4]),
    R2     = summary(model)$r.squared
  )
}
