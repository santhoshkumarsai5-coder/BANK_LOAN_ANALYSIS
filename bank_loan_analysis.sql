/* =====================================================
   BANK LOAN DATA ANALYSIS PROJECT
   All KPI + MTD + PMTD + YTD + MoM Queries
   ===================================================== */


/* =====================================================
   1. CREATE TABLE
   ===================================================== */

DROP TABLE IF EXISTS loan_data;

CREATE TABLE loan_data (
    id BIGINT PRIMARY KEY,
    address_state VARCHAR(20),
    application_type VARCHAR(50),
    emp_length VARCHAR(20),
    emp_title VARCHAR(150),
    grade VARCHAR(10),
    home_ownership VARCHAR(50),
    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,
    loan_status VARCHAR(50),
    next_payment_date DATE,
    member_id BIGINT,
    purpose VARCHAR(50),
    sub_grade VARCHAR(10),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income NUMERIC(12,2),
    dti NUMERIC(10,6),
    installment NUMERIC(12,2),
    int_rate NUMERIC(12,2),
    loan_amount NUMERIC(12,2),
    total_acc INT,
    total_payment NUMERIC(12,2)
);



/* =====================================================
   2. TOTAL KPI QUERIES
   ===================================================== */

-- Total Applications
SELECT COUNT(id) AS total_applications
FROM loan_data;


-- Total Funded Amount
SELECT SUM(loan_amount) AS total_funded
FROM loan_data;


-- Total Amount Received
SELECT SUM(total_payment) AS total_received
FROM loan_data;


-- Average Interest Rate
SELECT ROUND(AVG(int_rate)*100,2) AS avg_interest_rate
FROM loan_data;


-- Average DTI
SELECT ROUND(AVG(dti)*100,2) AS avg_dti
FROM loan_data;



/* =====================================================
   3. GOOD vs BAD LOANS
   ===================================================== */

-- Loan Count by Type

SELECT
    CASE
        WHEN loan_status IN ('Fully Paid','Current')
        THEN 'good_loan'
        ELSE 'bad_loan'
    END AS loan_type,
    COUNT(*) AS total_count
FROM loan_data
GROUP BY loan_type;



-- Funded Amount by Loan Type

SELECT
    CASE
        WHEN loan_status IN ('Fully Paid','Current')
        THEN 'good_loan'
        ELSE 'bad_loan'
    END AS loan_type,
    SUM(loan_amount) AS funded_amount
FROM loan_data
GROUP BY loan_type;



/* =====================================================
   4. LOAN STATUS PERCENTAGE
   ===================================================== */

WITH cte AS (
    SELECT
        loan_status,
        COUNT(*) AS total
    FROM loan_data
    GROUP BY loan_status
)

SELECT
    loan_status,
    total,
    ROUND(
        total * 100 /
        SUM(total) OVER(),2
    ) AS percent
FROM cte;



/* =====================================================
   5. FUNDED vs RECEIVED %
   ===================================================== */

WITH cte AS (
    SELECT
        SUM(loan_amount) AS funded,
        SUM(total_payment) AS received
    FROM loan_data
)

SELECT
    funded,
    received,
    ROUND(received*100/funded,2) AS percent
FROM cte;



/* =====================================================
   6. MONTHLY RISK TREND
   ===================================================== */

SELECT

    DATE_TRUNC('month', issue_date)::date AS month,

    COUNT(*) AS total_loans,

    COUNT(*) FILTER
    (WHERE loan_status='Charged Off') AS charged_off,

    COUNT(*) FILTER
    (WHERE loan_status='Current') AS current_loans,

    COUNT(*) FILTER
    (WHERE loan_status='Fully Paid') AS fully_paid,

    ROUND(AVG(dti)*100,2) AS avg_dti,

    ROUND(AVG(int_rate)*100,2) AS avg_rate

FROM loan_data

GROUP BY 1
ORDER BY 1;



/* =====================================================
   7. DTI vs LOAN STATUS
   ===================================================== */

SELECT
    loan_status,
    ROUND(AVG(dti),3) AS avg_dti
FROM loan_data
GROUP BY loan_status;



/* =====================================================
   8. MTD QUERIES
   ===================================================== */

-- MTD Applications

SELECT COUNT(id) AS mtd_applications
FROM loan_data
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE);



-- MTD Funded

SELECT SUM(loan_amount) AS mtd_funded
FROM loan_data
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE);



-- MTD Received

SELECT SUM(total_payment) AS mtd_received
FROM loan_data
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE);



-- MTD Avg Rate

SELECT ROUND(AVG(int_rate)*100,2)
FROM loan_data
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE);



-- MTD Avg DTI

SELECT ROUND(AVG(dti)*100,2)
FROM loan_data
WHERE issue_date >= DATE_TRUNC('month', CURRENT_DATE);



/* =====================================================
   9. PMTD QUERIES
   ===================================================== */

SELECT COUNT(*) AS pmtd_applications
FROM loan_data
WHERE issue_date >=
DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
AND issue_date <
DATE_TRUNC('month', CURRENT_DATE);



SELECT SUM(loan_amount) AS pmtd_funded
FROM loan_data
WHERE issue_date >=
DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
AND issue_date <
DATE_TRUNC('month', CURRENT_DATE);



/* =====================================================
   10. YTD QUERIES
   ===================================================== */

SELECT COUNT(*) AS ytd_applications
FROM loan_data
WHERE issue_date >=
DATE_TRUNC('year', CURRENT_DATE);



SELECT SUM(loan_amount) AS ytd_funded
FROM loan_data
WHERE issue_date >=
DATE_TRUNC('year', CURRENT_DATE);



SELECT SUM(total_payment) AS ytd_received
FROM loan_data
WHERE issue_date >=
DATE_TRUNC('year', CURRENT_DATE);



/* =====================================================
   11. MOM CALCULATION
   ===================================================== */

WITH mtd AS (

    SELECT SUM(loan_amount) AS amount
    FROM loan_data
    WHERE issue_date >=
    DATE_TRUNC('month', CURRENT_DATE)

),

pmtd AS (

    SELECT SUM(loan_amount) AS amount
    FROM loan_data
    WHERE issue_date >=
    DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')

    AND issue_date <
    DATE_TRUNC('month', CURRENT_DATE)

)

SELECT

    mtd.amount,
    pmtd.amount,

    ROUND(
        (mtd.amount - pmtd.amount)
        *100 / pmtd.amount ,2

    ) AS mom_percent

FROM mtd, pmtd;
