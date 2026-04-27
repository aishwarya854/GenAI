-- Delinquency Prediction Dataset
-- Basic Profiling


SELECT *
FROM delinquencyrisk;

ALTER TABLE delinquencyrisk RENAME COLUMN ï»¿Customer_ID TO customer_ID;   
                                                                 # use to rename column name or can use alter table
ALTER TABLE delinquencyrisk RENAME TO delinquency;
SELECT * FROM delinquency;
SELECT DISTINCT(Employment_Status)
FROM delinquency;


-- total customers count
SELECT COUNT(*) AS total_customer
FROM delinquency;

-- check for missing income values

SELECT 
COUNT(*) AS total_rows,
COUNT(income) AS non_null_income,
count(*) - COUNT(Income) AS missing_income 
FROM delinquency;

-- Replace missing Income with median
SELECT customer_ID, Income, Credit_Score, Loan_Balance FROM delinquency
WHERE income IS NULL;

SELECT AVG(Income) AS median_income
FROM (
    SELECT Income,
           ROW_NUMBER() OVER (ORDER BY Income) AS row_num,
           COUNT(*) OVER () AS total_rows
    FROM delinquency
    WHERE Income IS NOT NULL
) AS ordered
WHERE row_num IN (FLOOR((total_rows + 1)/2), CEIL((total_rows + 1)/2));

UPDATE delinquency
SET income = (SELECT AVG(Income) AS median_income
FROM (
    SELECT Income,
           ROW_NUMBER() OVER (ORDER BY Income) AS row_num,
           COUNT(*) OVER () AS total_rows
    FROM delinquency
    WHERE Income IS NOT NULL
) AS ordered
WHERE row_num IN (FLOOR((total_rows + 1)/2), CEIL((total_rows + 1)/2)))
WHERE income IS NULL;

-- Replace missing Credit_Score with median
SELECT credit_score
FROM delinquency
WHERE Credit_Score IS NULL;
-- When u want to get and update value at once in table method 2 
SET @median_val = (
    SELECT AVG(val)
    FROM (
        SELECT credit_score AS val,
               ROW_NUMBER() OVER (ORDER BY credit_score) AS row_num,
               COUNT(*) OVER () AS total_count
        FROM delinquency
        WHERE Credit_Score IS NOT NULL
    ) AS ranked
    WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2)));
UPDATE delinquency
SET Credit_Score = @median_val
WHERE Credit_Score IS NULL;

SELECT credit_score FROM delinquency;

-- Use this cross-validate UR output

SELECT customer_id, credit_score
FROM delinquency
HAVING credit_score LIKE 586;

-- Replace missing Loan_Balance with median
SET @median_val = (
SELECT AVG(val) 
FROM (
        SELECT loan_balance AS val,
               ROW_NUMBER() OVER (ORDER BY loan_balance) AS row_num,
               COUNT(*) OVER () AS total_count
        FROM delinquency
        WHERE loan_balance IS NOT NULL
    ) AS ranked
    WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2)));
UPDATE delinquency
SET loan_balance = @median_val
WHERE loan_balance IS NULL;

SELECT loan_balance FROM delinquency;
SELECT customer_id,loan_balance
FROM delinquency;
	
/* UPDATE delinquency
SET Loan_Balance = 45776
WHERE Loan_Balance IS NULL; only when u have already calculated the value, u can directly enter as well */

-- unique employment categories

SELECT Employment_Status, COUNT(*) AS count
FROM delinquency
GROUP BY Employment_Status
ORDER BY count DESC;

SELECT customer_id, Employment_status, credit_card_type, location
FROM delinquency;

-- Categorizing data

SELECT DISTINCT(credit_card_type)
FROM delinquency;

SELECT Credit_Card_Type, COUNT(*) AS count
FROM delinquency
GROUP BY Credit_Card_Type
ORDER BY count DESC;

SELECT Location, COUNT(*) AS count
FROM delinquency
GROUP BY Location
ORDER BY count DESC;

-- Delinquency rate by employment status

SELECT Employment_Status,
COUNT(*) AS total_customers, 
SUM(delinquent_account) AS delinquent_count,
ROUND(
		100 * SUM(delinquent_account) / COUNT(*), 1
        ) AS delinquent_rate_pct
FROM delinquency
GROUP BY Employment_Status
ORDER BY delinquent_rate_pct DESC;

-- credit risk segmentation with case when

SELECT 
  CASE 
    WHEN Credit_Score >= 750 THEN 'Excellent (750+)'
    WHEN Credit_Score >= 650 THEN 'Good (650-749)'
    WHEN Credit_Score >= 550 THEN 'Fair (550-649)'
    ELSE 'Poor (below 550)'
  END AS credit_tier,
  COUNT(*) AS customers,
  ROUND(AVG(Missed_Payments), 1) AS avg_missed_payments,
  ROUND(
    100.0 * SUM(Delinquent_Account) / COUNT(*), 1
  ) AS delinquency_rate_pct
FROM delinquency
WHERE Credit_Score IS NOT NULL
GROUP BY credit_tier
ORDER BY MIN(Credit_Score) DESC;

-- Payment trend over 6 months

SELECT 'Month_1' AS month, Month_1 AS status, COUNT(*) AS customers FROM delinquency GROUP BY Month_1
UNION ALL
SELECT 'Month_2', Month_2, COUNT(*) FROM delinquency GROUP BY Month_2
UNION ALL
SELECT 'Month_3', Month_3, COUNT(*) FROM delinquency GROUP BY Month_3
UNION ALL
SELECT 'Month_4', Month_4, COUNT(*) FROM delinquency GROUP BY Month_4
UNION ALL
SELECT 'Month_5', Month_5, COUNT(*) FROM delinquency GROUP BY Month_5
UNION ALL
SELECT 'Month_6', Month_6, COUNT(*) FROM delinquency GROUP BY Month_6
ORDER BY month, status;

SELECT(Month_1) AS Month, COUNT(*) AS customer
FROM delinquency
GROUP BY (Month_1)
ORDER BY month;

-- create table just in case u want to refer to

CREATE TABLE payment_status_codes (
    code INT PRIMARY KEY,
    description VARCHAR(20)
);

INSERT INTO payment_status_codes (code, description) VALUES
(0, 'On-time'),
(1, 'Late'),
(2, 'Missed');
SELECT * FROM payment_status_codes;

SELECT 
    d.Customer_ID, d.Month_1, p.description AS Month_1_status
FROM
    delinquency d
        JOIN
    payment_status_codes p ON d.Month_1 = p.code;
    
-- OR quick inline mapping

SELECT Customer_ID,
       Month_1,
       CASE Month_1
           WHEN 0 THEN 'On-time'
           WHEN 1 THEN 'Late'
           WHEN 2 THEN 'Missed'
       END AS Month_1_status
FROM delinquency;

-- Customer's payment history over 6 months, showing the frequency they were on-time,late or missed their payment

SELECT 
    Customer_ID,

    -- Count On-time payments
    ( (Month_1 = 0) + (Month_2 = 0) + (Month_3 = 0) +
      (Month_4 = 0) + (Month_5 = 0) + (Month_6 = 0) ) AS On_time_count,

    -- Count Late payments
    ( (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
      (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1) ) AS Late_count,

    -- Count Missed payments
    ( (Month_1 = 2) + (Month_2 = 2) + (Month_3 = 2) +
      (Month_4 = 2) + (Month_5 = 2) + (Month_6 = 2) ) AS Missed_count

FROM delinquency;

-- high risk customber flag

WITH risk_scored AS (
  SELECT 
    Customer_ID,
    Location,
    Credit_Score,
    Missed_Payments,
    Debt_to_Income_Ratio,
    Delinquent_Account,
    -- Custom risk score formula
    (Missed_Payments * 20) + 
    (Debt_to_Income_Ratio * 100) + 
    (CASE WHEN Credit_Score < 550 THEN 30 ELSE 0 END) AS risk_score
  FROM delinquency
)
SELECT 
  Customer_ID,
  Location,
  risk_score,
  RANK() OVER (
    PARTITION BY Location 
    ORDER BY risk_score DESC
  ) AS risk_rank_in_city
FROM risk_scored
ORDER BY Location, risk_rank_in_city
LIMIT 20;

SELECT 
    Customer_ID,

    -- Count On-time payments
    ( (Month_1 = 0) + (Month_2 = 0) + (Month_3 = 0) +
      (Month_4 = 0) + (Month_5 = 0) + (Month_6 = 0) ) AS On_time_count,

    -- Count Late payments
    ( (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
      (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1) ) AS Late_count,

    -- Count Missed payments
    ( (Month_1 = 2) + (Month_2 = 2) + (Month_3 = 2) +
      (Month_4 = 2) + (Month_5 = 2) + (Month_6 = 2) ) AS Missed_count,

    -- Risk Score: Late = 1 point, Missed = 2 points
    ( (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
      (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1) )
    +
    ( (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
      (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2 )
    AS Risk_Score

FROM delinquency;
-- risk score gives you single numeric features that summarizes payment behavior, and is easy to use in predictive models(higher score =higher delinquency risk)

SELECT 
    Customer_ID,

    -- Risk Score: Late = 1 point, Missed = 2 points
    (
      (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
      (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
    )
    +
    (
      (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
      (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
    ) AS Risk_Score,

    -- Bucket into categories based on risk
    CASE 
        WHEN (
          (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
          (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
        )
        +
        (
          (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
          (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
        ) <= 2 THEN 'Low Risk'

        WHEN (
          (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
          (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
        )
        +
        (
          (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
          (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
        ) BETWEEN 3 AND 6 THEN 'Medium Risk'

        ELSE 'High Risk'
    END AS Risk_Category

FROM delinquency;

-- based on 

SELECT 
    Customer_ID,
    (
      (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
      (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
    )
    +
    (
      (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
      (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
    ) AS Risk_Score,

    CASE 
        WHEN (
          (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
          (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
        )
        +
        (
          (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
          (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
        ) <= 2 THEN 'Low Risk'
        WHEN (
          (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
          (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
        )
        +
        (
          (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
          (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
        ) BETWEEN 3 AND 6 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS Risk_Category
FROM delinquency;

SELECT Risk_Category, COUNT(*) AS Customer_Count
FROM (
    -- Use the classification query from Step 1 here
    SELECT 
        Customer_ID,
        (
          (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
          (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
        )
        +
        (
          (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
          (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
        ) AS Risk_Score,
        CASE 
            WHEN (
              (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
              (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
            )
            +
            (
              (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
              (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
            ) <= 2 THEN 'Low Risk'
            WHEN (
              (Month_1 = 1) + (Month_2 = 1) + (Month_3 = 1) +
              (Month_4 = 1) + (Month_5 = 1) + (Month_6 = 1)
            )
            +
            (
              (Month_1 = 2)*2 + (Month_2 = 2)*2 + (Month_3 = 2)*2 +
              (Month_4 = 2)*2 + (Month_5 = 2)*2 + (Month_6 = 2)*2
            ) BETWEEN 3 AND 6 THEN 'Medium Risk'
            ELSE 'High Risk'
        END AS Risk_Category
    FROM delinquency
) AS classified
GROUP BY Risk_Category;
