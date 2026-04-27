-- Delinquency Prediction Dataset
-- Basic Profiling


SELECT *
FROM delinquency_prediction_dataset;

-- Play with name of schema but need to refresh it to extract data

ALTER TABLE delinquency_prediction_dataset RENAME TO delinquency_p;
ALTER TABLE delinquency_p RENAME TO delinquency_pd;

ALTER TABLE delinquency_pd
RENAME COLUMN ï»¿Customer_ID TO Customer_ID;         # use to rename column name or can use alter table

SELECT *
FROM delinquency_pd;

-- USE this when u have not cleaned or pre-processed ur data before

SELECT customer_id,Employment_Status
FROM delinquency_pd
WHERE Employment_Status LIKE 'EMP%';

UPDATE delinquency_pd
SET Employment_Status = 'Employed'
WHERE LOWER(Employment_Status) IN ('EMP%', 'EMP');

UPDATE delinquency_pd
SET Employment_Status = 'Retired'
WHERE LOWER(Employment_Status) = 'retired';

SELECT DISTINCT(Employment_Status)
FROM delinquency_pd;

-- total customers count
SELECT COUNT(*) AS total_customer
FROM delinquency_pd;     # Note: if u have not fill the blank with 0/null/ imputate values  

-- check for missing income values

SELECT 
COUNT(*) AS total_rows,
COUNT(income) AS non_null_income,
count(*) - COUNT(Income) AS missing_income 
FROM delinquency_pd;

-- unique employment categories

SELECT Employment_Status, COUNT(*) AS count
FROM delinquency_pd
GROUP BY Employment_Status
ORDER BY count DESC;

SELECT customer_id, Employment_status, credit_card_type, location
FROM delinquency_pd;

SELECT DISTINCT(credit_card_type)
FROM delinquency_pd;

SELECT Credit_Card_Type, COUNT(*) AS count
FROM delinquency_pd
GROUP BY Credit_Card_Type
ORDER BY count DESC;

SELECT Location, COUNT(*) AS count
FROM delinquency_pd
GROUP BY Location
ORDER BY count DESC;

SELECT Customer_id, Month_1, Month_2, Month_3, Month_4, Month_5, Month_6
FROM delinquency_pd;

-- Delinquency rate by employment status

SELECT Employment_Status,
COUNT(*) AS total_customers, 
SUM(delinquent_account) AS delinquent_count,
ROUND(100 * SUM(delinquent_account) / COUNT(*), 1) AS delinquent_rate_pct
FROM delinquency_pd
GROUP BY Employment_Status
ORDER BY delinquent_rate_pct DESC;

-- Early warning signal 

SELECT Customer_ID, Employment_Status, Month_4, Month_5, Month_6
FROM delinquency_pd
WHERE Employment_Status = 'Self-employed'
  AND Month_4 IN ('Late','Missed')
  AND Month_5 IN ('Late','Missed')
  AND Month_6 IN ('Late','Missed');
  
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
  ROUND(100.0 * SUM(Delinquent_Account) / COUNT(*), 1) AS delinquency_rate_pct
FROM delinquency_pd
GROUP BY credit_tier
ORDER BY MIN(Credit_Score) DESC;

SELECT Month_1, COUNT(*) AS count
FROM delinquency_pd 
GROUP BY Month_1
ORDER BY count DESC;    # similar can be done for others 

-- Create a numeric version

SELECT Customer_ID,
  CASE Month_1 WHEN 'On-time' THEN 0 WHEN 'Late' THEN 1 ELSE 2 END AS Month_1,
  CASE Month_2 WHEN 'On-time' THEN 0 WHEN 'Late' THEN 1 ELSE 2 END AS Month_2,
  CASE Month_3 WHEN 'On-time' THEN 0 WHEN 'Late' THEN 1 ELSE 2 END AS Month_3,
  CASE Month_4 WHEN 'On-time' THEN 0 WHEN 'Late' THEN 1 ELSE 2 END AS Month_4,
  CASE Month_5 WHEN 'On-time' THEN 0 WHEN 'Late' THEN 1 ELSE 2 END AS Month_5,
  CASE Month_6 WHEN 'On-time' THEN 0 WHEN 'Late' THEN 1 ELSE 2 END AS Month_6
  FROM delinquency_pd;
  
-- Payment trend over 6 months

SELECT 'Month_1' AS month, Month_1 AS status, COUNT(*) AS customers FROM delinquency_pd GROUP BY Month_1
UNION ALL
SELECT 'Month_2', Month_2, COUNT(*) FROM delinquency_pd GROUP BY Month_2
UNION ALL
SELECT 'Month_3', Month_3, COUNT(*) FROM delinquency_pd GROUP BY Month_3
UNION ALL
SELECT 'Month_4', Month_4, COUNT(*) FROM delinquency_pd GROUP BY Month_4
UNION ALL
SELECT 'Month_5', Month_5, COUNT(*) FROM delinquency_pd GROUP BY Month_5
UNION ALL
SELECT 'Month_6', Month_6, COUNT(*) FROM delinquency_pd GROUP BY Month_6
ORDER BY Month, customers DESC;

-- High risk customber flag

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
  FROM delinquency_pd
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

-- card holder likely to deliquent

SELECT DISTINCT(credit_card_type),COUNT(*) AS count
FROM delinquency_pd
GROUP BY Credit_Card_Type
ORDER BY count DESC;

SELECT Customer_ID, Credit_Utilization,
ROUND(Credit_Utilization,2) AS Credit_utilization1
FROM delinquency_pd
ORDER BY Credit_utilization1 DESC;
-- to get Patterns and anamolies between variables
SELECT Customer_ID, Credit_Score, 
ROUND(Credit_Utilization,2) AS Credit_utilization,
ROUND(Debt_to_Income_Ratio,2) AS Debt_to_income_ratio,
Age, Location, Employment_Status, Credit_Card_Type
FROM delinquency_pd
WHERE credit_utilization > '0.7'
ORDER BY Credit_Score DESC;   

-- ============================================
-- CREATE NEW TABLE WITH NUMERIC PAYMENT CODES
-- ============================================

CREATE TABLE customer_payment_status AS
SELECT 
    Customer_ID,
    Age,
    Income,
    Credit_Score,
    Credit_Utilization,
    Missed_Payments,
    Delinquent_Account,
    Loan_Balance,
    Debt_to_Income_Ratio,
    Employment_Status,
    Account_Tenure,
    Credit_Card_Type,
    Location,
    
    -- Convert payment history to numeric codes
    CASE 
        WHEN Month_1 = 'On-time' THEN 0
        WHEN Month_1 = 'Late' THEN 1
        WHEN Month_1 = 'Missed' THEN 2
        ELSE NULL
    END AS Month_1_Numeric,
    
    CASE 
        WHEN Month_2 = 'On-time' THEN 0
        WHEN Month_2 = 'Late' THEN 1
        WHEN Month_2 = 'Missed' THEN 2
        ELSE NULL
    END AS Month_2_Numeric,
    
    CASE 
        WHEN Month_3 = 'On-time' THEN 0
        WHEN Month_3 = 'Late' THEN 1
        WHEN Month_3 = 'Missed' THEN 2
        ELSE NULL
    END AS Month_3_Numeric,
    
    CASE 
        WHEN Month_4 = 'On-time' THEN 0
        WHEN Month_4 = 'Late' THEN 1
        WHEN Month_4 = 'Missed' THEN 2
        ELSE NULL
    END AS Month_4_Numeric,
    
    CASE 
        WHEN Month_5 = 'On-time' THEN 0
        WHEN Month_5 = 'Late' THEN 1
        WHEN Month_5 = 'Missed' THEN 2
        ELSE NULL
    END AS Month_5_Numeric,
    
    CASE 
        WHEN Month_6 = 'On-time' THEN 0
        WHEN Month_6 = 'Late' THEN 1
        WHEN Month_6 = 'Missed' THEN 2
        ELSE NULL
    END AS Month_6_Numeric

FROM delinquency_pd;

SELECT * FROM customer_payment_status;

-- ============================================
-- CREATE AGGREGATED RISK FEATURES
-- ============================================

WITH payment_numeric AS (
    SELECT 
        Customer_ID,
        -- Convert to numeric (using CASE directly or function)
        CASE WHEN Month_1 = 'On-time' THEN 0 WHEN Month_1 = 'Late' THEN 1 WHEN Month_1 = 'Missed' THEN 2 END AS M1,
        CASE WHEN Month_2 = 'On-time' THEN 0 WHEN Month_2 = 'Late' THEN 1 WHEN Month_2 = 'Missed' THEN 2 END AS M2,
        CASE WHEN Month_3 = 'On-time' THEN 0 WHEN Month_3 = 'Late' THEN 1 WHEN Month_3 = 'Missed' THEN 2 END AS M3,
        CASE WHEN Month_4 = 'On-time' THEN 0 WHEN Month_4 = 'Late' THEN 1 WHEN Month_4 = 'Missed' THEN 2 END AS M4,
        CASE WHEN Month_5 = 'On-time' THEN 0 WHEN Month_5 = 'Late' THEN 1 WHEN Month_5 = 'Missed' THEN 2 END AS M5,
        CASE WHEN Month_6 = 'On-time' THEN 0 WHEN Month_6 = 'Late' THEN 1 WHEN Month_6 = 'Missed' THEN 2 END AS M6
    FROM delinquency_pd
)

SELECT 
    Customer_ID,
    -- Total risk score (sum of numeric codes, higher = worse)
    (M1 + M2 + M3 + M4 + M5 + M6) AS total_risk_score,
    
    -- Average payment behavior (0 to 2 scale)
    (M1 + M2 + M3 + M4 + M5 + M6) / 6.0 AS avg_risk_score,
    
    -- Count of missed payments (code = 2)
    (CASE WHEN M1 = 2 THEN 1 ELSE 0 END +
     CASE WHEN M2 = 2 THEN 1 ELSE 0 END +
     CASE WHEN M3 = 2 THEN 1 ELSE 0 END +
     CASE WHEN M4 = 2 THEN 1 ELSE 0 END +
     CASE WHEN M5 = 2 THEN 1 ELSE 0 END +
     CASE WHEN M6 = 2 THEN 1 ELSE 0 END) AS missed_count,
    
    -- Count of late payments (code = 1)
    (CASE WHEN M1 = 1 THEN 1 ELSE 0 END +
     CASE WHEN M2 = 1 THEN 1 ELSE 0 END +
     CASE WHEN M3 = 1 THEN 1 ELSE 0 END +
     CASE WHEN M4 = 1 THEN 1 ELSE 0 END +
     CASE WHEN M5 = 1 THEN 1 ELSE 0 END +
     CASE WHEN M6 = 1 THEN 1 ELSE 0 END) AS late_count,
    
    -- Consecutive late/missed in last 3 months (for risk flag)
    CASE 
        WHEN (M4 >= 1 AND M5 >= 1) OR (M5 >= 1 AND M6 >= 1) THEN 1 
        ELSE 0 
    END AS consecutive_risk_recent,
    
    -- Worst payment status in last 3 months
    GREATEST(M4, M5, M6) AS worst_status_recent

FROM payment_numeric;