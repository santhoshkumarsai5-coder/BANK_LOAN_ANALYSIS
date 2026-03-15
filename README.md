# 📊 Bank Loan Data Analysis – SQL KPI Project

## 📌 Project Overview

This project demonstrates advanced SQL analysis on a **Bank Loan dataset** to calculate KPIs, risk metrics, and time-based performance indicators such as:

* Total KPIs
* Good vs Bad Loan analysis
* Loan Status distribution
* Monthly risk trend
* MTD / PMTD / YTD calculations
* MoM growth analysis

The goal of this project is to simulate **real-world banking analytics dashboard queries** used in finance and lending companies.

---

## 🛠 Tools & Technologies

* PostgreSQL
* SQL
* Data Analysis
* Aggregations
* Window Functions
* CTE (Common Table Expressions)
* Date Functions

---

## 📂 Dataset Description

The dataset contains loan level information including:

| Column           | Description                        |
| ---------------- | ---------------------------------- |
| id               | Loan ID                            |
| address_state    | State of borrower                  |
| application_type | Individual / Joint                 |
| emp_length       | Employment length                  |
| emp_title        | Job title                          |
| grade            | Loan grade                         |
| home_ownership   | Home ownership                     |
| issue_date       | Loan issue date                    |
| loan_status      | Current / Fully Paid / Charged Off |
| annual_income    | Borrower income                    |
| dti              | Debt to income ratio               |
| int_rate         | Interest rate                      |
| loan_amount      | Loan funded                        |
| total_payment    | Amount received                    |
| purpose          | Loan purpose                       |

---

## 🧱 Table Creation

```sql
CREATE TABLE loan_data (...)
```

The table is created using appropriate data types for financial analysis.

---

## 📊 KPI Calculations

### Total Applications

```sql
SELECT COUNT(id)
FROM loan_data;
```

### Total Funded Amount

```sql
SELECT SUM(loan_amount)
FROM loan_data;
```

### Total Amount Received

```sql
SELECT SUM(total_payment)
FROM loan_data;
```

### Average Interest Rate

```sql
SELECT AVG(int_rate)
FROM loan_data;
```

### Average DTI

```sql
SELECT AVG(dti)
FROM loan_data;
```

---

## ✅ Good vs Bad Loan Analysis

Loans are classified as:

* Good Loan → Fully Paid, Current
* Bad Loan → Charged Off

```sql
CASE
WHEN loan_status IN ('Fully Paid','Current')
THEN 'good_loan'
ELSE 'bad_loan'
END
```

Used to calculate:

* Loan count
* Funded amount
* Risk %

---

## 📈 Loan Status Percentage

Using CTE + Window Functions

```sql
SUM(total) OVER()
```

This calculates percentage contribution of each loan status.

---

## 📉 Monthly Risk Trend

Monthly trend using

```sql
DATE_TRUNC('month', issue_date)
```

Metrics:

* Total loans
* Charged off loans
* Current loans
* Fully paid loans
* Avg DTI
* Avg Interest rate

Used in dashboards.

---

## 📅 MTD (Month-To-Date) Calculations

```sql
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE)
```

Used for:

* MTD applications
* MTD funded
* MTD received
* MTD avg rate
* MTD avg DTI

---

## 📅 PMTD (Previous Month-To-Date)

```sql
CURRENT_DATE - INTERVAL '1 month'
```

Used for comparison with current month.

---

## 📅 YTD (Year-To-Date)

```sql
DATE_TRUNC('year', CURRENT_DATE)
```

Used for yearly KPI tracking.

---

## 📊 MoM (Month-over-Month Growth)

Using CTE:

```sql
WITH mtd AS (...)
pmtd AS (...)
```

Used to calculate:

* Growth %
* Performance change
* Funding trend

---

## 📌 Key SQL Concepts Used

* CTE
* Window Functions
* CASE
* FILTER
* DATE_TRUNC
* INTERVAL
* Aggregations
* KPI calculations

---

## 📊 Use Case

This project simulates SQL work done in:

* Banks
* Fintech companies
* Lending platforms
* Risk analytics teams
* Data analyst dashboards

---

## 📁 Repository Structure

```
bank-loan-analysis/
│
├── bank_loan_kpi_analysis.sql
├── dataset.csv
└── README.md
```

---

## ⭐ Author

Santhosh Kumar
SQL | Data Analytics | PostgreSQL | Data Warehouse Projects
