# Bank Loan Data Analysis — SQL KPI Project

> End-to-end SQL analytics project simulating a real-world banking dashboard with KPIs, risk metrics, and time-based performance calculations.

---

## Overview

This project performs structured analysis on a bank loan dataset using PostgreSQL. It covers the full analytics lifecycle — from raw data modelling to KPI reporting — and mirrors the kind of work done by data analysts at banks, fintech companies, and lending platforms.

**What this project answers:**
- How many loans are good vs bad, and what's the risk exposure?
- How is the portfolio performing this month vs last month?
- What does the monthly charged-off trend look like?
- Are high-DTI borrowers more likely to default?

---

## Tech Stack

| Tool | Usage |
|---|---|
| PostgreSQL | Primary database and query engine |
| SQL | All analysis, KPIs, and aggregations |
| CTEs | Multi-step calculations and MoM comparisons |
| Window Functions | Percentage distributions across loan statuses |
| Date Functions | MTD, PMTD, YTD, and monthly trend slicing |

---

## Dataset

Loan-level data with 15+ fields per record:

| Column | Type | Description |
|---|---|---|
| `id` | BIGINT | Unique loan identifier |
| `address_state` | VARCHAR | Borrower's state |
| `application_type` | VARCHAR | Individual or Joint |
| `emp_length` | VARCHAR | Employment tenure |
| `emp_title` | VARCHAR | Job title |
| `grade` / `sub_grade` | VARCHAR | Loan risk grade |
| `home_ownership` | VARCHAR | Rent / Own / Mortgage |
| `issue_date` | DATE | Loan origination date |
| `loan_status` | VARCHAR | Current / Fully Paid / Charged Off |
| `annual_income` | NUMERIC | Borrower's annual income |
| `dti` | NUMERIC | Debt-to-income ratio |
| `int_rate` | NUMERIC | Interest rate |
| `loan_amount` | NUMERIC | Funded loan amount |
| `total_payment` | NUMERIC | Amount received from borrower |
| `purpose` | VARCHAR | Reason for the loan |

---

## KPI Modules

### 1. Total Portfolio KPIs

Core metrics for the entire loan book:

```sql
SELECT COUNT(id)          AS total_applications  FROM loan_data;
SELECT SUM(loan_amount)   AS total_funded         FROM loan_data;
SELECT SUM(total_payment) AS total_received       FROM loan_data;
SELECT ROUND(AVG(int_rate) * 100, 2) AS avg_interest_rate FROM loan_data;
SELECT ROUND(AVG(dti) * 100, 2)      AS avg_dti            FROM loan_data;
```

---

### 2. Good Loan vs Bad Loan

Loans are classified based on repayment status:

| Classification | Statuses |
|---|---|
| Good Loan | `Fully Paid`, `Current` |
| Bad Loan | `Charged Off` |

```sql
SELECT
    CASE
        WHEN loan_status IN ('Fully Paid', 'Current') THEN 'good_loan'
        ELSE 'bad_loan'
    END AS loan_type,
    COUNT(*)           AS total_count,
    SUM(loan_amount)   AS funded_amount
FROM loan_data
GROUP BY loan_type;
```

---

### 3. Loan Status Distribution

Uses a CTE + window function to calculate the percentage share of each loan status:

```sql
WITH cte AS (
    SELECT loan_status, COUNT(*) AS total
    FROM loan_data
    GROUP BY loan_status
)
SELECT
    loan_status,
    total,
    ROUND(total * 100.0 / SUM(total) OVER(), 2) AS pct_share
FROM cte;
```

---

### 4. Monthly Risk Trend

Tracks loan health month-over-month — useful for spotting seasonal risk or deteriorating portfolio quality:

```sql
SELECT
    DATE_TRUNC('month', issue_date)::date AS month,
    COUNT(*)                                                    AS total_loans,
    COUNT(*) FILTER (WHERE loan_status = 'Charged Off')         AS charged_off,
    COUNT(*) FILTER (WHERE loan_status = 'Current')             AS current_loans,
    COUNT(*) FILTER (WHERE loan_status = 'Fully Paid')          AS fully_paid,
    ROUND(AVG(dti) * 100, 2)                                    AS avg_dti,
    ROUND(AVG(int_rate) * 100, 2)                               AS avg_rate
FROM loan_data
GROUP BY 1
ORDER BY 1;
```

---

### 5. Time-Period KPIs

#### MTD — Month-to-Date
```sql
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE)
```

#### PMTD — Previous Month-to-Date
```sql
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
  AND issue_date <  DATE_TRUNC('month', CURRENT_DATE)
```

#### YTD — Year-to-Date
```sql
WHERE issue_date >= DATE_TRUNC('year', CURRENT_DATE)
```

---

### 6. MoM Growth (Month-over-Month)

Compares current month funded amount against the previous month:

```sql
WITH mtd AS (
    SELECT SUM(loan_amount) AS amount FROM loan_data
    WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE)
),
pmtd AS (
    SELECT SUM(loan_amount) AS amount FROM loan_data
    WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
      AND issue_date <  DATE_TRUNC('month', CURRENT_DATE)
)
SELECT
    mtd.amount  AS mtd_funded,
    pmtd.amount AS pmtd_funded,
    ROUND((mtd.amount - pmtd.amount) * 100.0 / pmtd.amount, 2) AS mom_growth_pct
FROM mtd, pmtd;
```

---

## Key SQL Concepts

- **CTEs** — Multi-step metric pipelines and MoM comparisons
- **Window Functions** — `SUM() OVER()` for percentage distributions
- **FILTER clause** — Conditional aggregation without nested subqueries
- **DATE_TRUNC + INTERVAL** — Clean period slicing for MTD / PMTD / YTD
- **CASE expressions** — Loan classification logic
- **Aggregations** — COUNT, SUM, AVG across grouped dimensions

---

## Repository Structure

```
bank-loan-analysis/
├── bank_loan_kpi_analysis.sql   ← All queries (KPIs, risk, trends, time-based)
├── dataset.csv                  ← Raw loan-level data
└── README.md
```

---

## Use Cases

This project simulates analytics work done in:

- Retail and commercial banking
- Fintech and lending platforms
- Risk and credit analytics teams
- Financial data analyst dashboards

---

## Author

**Santhosh Kumar**  
SQL · Data Analytics · PostgreSQL · Data Warehouse Projects
