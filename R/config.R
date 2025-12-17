# R/config.R
# Central configuration for paths + output folders

library(here)

# 1) Database path
DB_PATH <- Sys.getenv("TIDY_FINANCE_DB", unset = here::here("data", "tidy_finance_r.sqlite"))

# 2) Output locations
DIR_DATA_PROCESSED <- here::here("data", "processed")
DIR_RESULTS_TABLES <- here::here("results", "tables")
DIR_RESULTS_FIGS   <- here::here("results", "figures")

dir.create(DIR_DATA_PROCESSED, recursive = TRUE, showWarnings = FALSE)
dir.create(DIR_RESULTS_TABLES, recursive = TRUE, showWarnings = FALSE)
dir.create(DIR_RESULTS_FIGS,   recursive = TRUE, showWarnings = FALSE)

assert_db_exists <- function() {
  if (!file.exists(DB_PATH)) {
    stop(
      "Database not found.\n",
      "Set env var TIDY_FINANCE_DB to your SQLite path, e.g.\n",
      "  Sys.setenv(TIDY_FINANCE_DB = '/path/to/tidy_finance_r.sqlite')\n",
      "Or place it at: data/raw/tidy_finance_r.sqlite\n",
      call. = FALSE
    )
  }
}