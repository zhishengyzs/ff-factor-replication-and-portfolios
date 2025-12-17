## Fama–French Factor Replication and Portfolio Construction

This project implements a full end-to-end replication of canonical U.S. equity risk factors and evaluates multiple portfolio construction approaches using those factors.  

The analysis emphasizes **factor construction fidelity**, **replication diagnostics**, and **portfolio-level performance comparisons**, following academic and practitioner standards.

---

### Project Overview

The project consists of three main components:

1. **Factor Replication**
   - Replication of Fama–French equity factors (SMB, HML, RMW, CMA) using CRSP–Compustat data
   - Independent replication of the Momentum factor (MOM, 12–2 specification)
   - Validation via time-series regressions against official factor returns with Newey–West standard errors

2. **Portfolio Construction**
   - Long-only market and fixed-weight multi-factor portfolios
   - Risk-based and optimization-based factor portfolios:
     - Equal-weight
     - Risk-parity (1/volatility proxy)
     - Mean–variance (Σ⁻¹μ, normalized)
   - Comparison of annualized return, volatility, Sharpe ratio, and cumulative performance

3. **Robustness Analysis**
   - Alternative momentum specifications (e.g., 6–1 momentum, volatility-scaled momentum)
   - Performance comparison across momentum variants

---

### Data (Not Included)

Raw and processed datasets are **not included** in this repository due to size and licensing constraints.

The analysis assumes access to a local SQLite database containing CRSP, Compustat, and Fama–French factor tables (e.g., via the `tidy_finance_r` schema).

Expected local setup:
- SQLite database: `data/tidy_finance_r.sqlite`
- Intermediate outputs: `data/processed/` (generated automatically)

All data paths are centralized and configurable.

#### Data Source and Attribution

The underlying CRSP–Compustat data and Fama–French factor tables were provided by the course instructor via the `tidy_finance_r` database for educational use.

All data preprocessing, factor construction, portfolio analysis, robustness checks, and repository engineering were independently implemented by the author.

---

### Methodology Notes

- Portfolio breakpoints follow standard Fama–French conventions
- Monthly returns are used throughout
- Replication regressions use **Newey–West HAC standard errors**
- Cumulative performance is reported using **cumulative returns**, not wealth indices
- Emphasis is placed on **replication quality and economic interpretability**, not overfitting

---

### Project Engineering and Reproducibility

- Environment managed with `renv`
- Cached intermediate results to avoid unnecessary recomputation
- Notebooks are modular and can be run independently once data access is configured

Beyond the analytical components, this repository was independently restructured and engineered to meet reproducible research and data science standards:

- Refactored exploratory notebooks into a clean, modular project layout
- Centralized file paths and configuration for portability
- Abstracted repeated logic into reusable utility functions
- Implemented intermediate result caching to improve runtime efficiency
- Managed version control, environment reproducibility (`renv`), and repository hygiene

These steps reflect applied data science and research engineering practices commonly used in production research workflows.

---

### Disclaimer

This project is for educational and research purposes only.  

This project was completed as part of  
**ACTUPS5846 — Quantitative Risk Management**  at Columbia University.

**Instructor:** Jun Zhuo 

Data access and high-level project guidance were provided through the course.  

---

### References

- FTSE Russell. *Factor Investing Considerations.* https://www.lseg.com/content/dam/ftse-russell/en_us/documents/research/factor-investing-considerations.pdf
- Robeco. *Guide to Factor Investing in Equity Markets.* https://www.robeco.com/files/docm/docu-robeco-guide-to-factor-investing-global.pdf
- MSCI. *Foundations of Factor Investing.* https://www.msci.com/documents/1296102/1336482/Foundations_of_Factor_Investing.pdf
