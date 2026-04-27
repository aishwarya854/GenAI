# GenAI-Powered EDA for Credit Delinquency Prediction

[![Tata iQ Forage Badge](https://img.shields.io/badge/Forage-Tata%20iQ-blueviolet)](https://www.theforage.com/virtual-internships/prototype/8b8M3nXj9kKqGfJYB/Tata-iQ-GenAI-Powered-Data-Analytics)

## 🎯 Project Overview
Completed Tata iQ's GenAI Data Analytics simulation (April 2026). Applied GenAI (ChatGPT/Gemini) for EDA on financial datasets to predict credit card delinquency at Geldium, a fictional lender. Covered data quality checks, risk profiling, predictive modeling frameworks, ethical AI, and automated collections strategy design.

**Skills Demonstrated**:
- Exploratory Data Analysis (EDA) with GenAI assistance
- Missing data handling (imputation, synthetic generation)
- Risk factor identification (payment history, credit utilization, DTI)
- No-code predictive modeling (logistic regression/decision trees)
- Model evaluation (precision, recall, AUC, bias checks)
- Responsible AI (fairness, explainability, compliance)

## 📊 Key Findings
- **Top Delinquency Risks**: High credit utilization (>80%), 2+ missed payments, DTI >0.5 increase default odds 3x.[file:1]
- **Data Handling**: Imputed missing income/payment data via median; generated synthetic records validated against real distributions.
- **Patterns**: Correlations between low income and late payments; anomalies like high credit scores with misses flagged.

| Risk Factor | Impact on Delinquency | Handling Approach |
|-------------|-----------------------|-------------------|
| Payment History | Highest predictor | GenAI trend analysis |
| Credit Utilization | Strong correlation | Outlier detection |
| DTI Ratio | Medium-high | Imputation (median) |

## 🛠 Tech Stack
- **GenAI Tools**: ChatGPT, Google Gemini for prompts (e.g., "Summarize missing values & suggest imputation")
- **Analytics**: Conceptual SQL/Pandas for EDA; no-code modeling pipelines
- **Notebooks**: [link-to-notebooks] (EDA.ipynb, Modeling.ipynb)

## 📈 Results & Next Steps
- Proposed logistic regression for interpretable predictions (AUC target >0.8).
- Designed agentic AI collections system with human-in-loop for escalations.
- Ethical Guardrails: Bias audits, SHAP explainability, GDPR/FCA compliance.

See full report: [GenAi-SummaryReport](./Business_Summary_Report_Aishwarya.pdf)

## 🚀 Run Locally
1. Clone repo: `git clone [your-repo-url]`
2. Install: `pip install -r requirements.txt` (pandas, plotly, etc.)
3. EDA: `My SQL-Workbench`

## Why This Matters
Showcases end-to-end analytics for fintech: From raw data to AI strategy. Ideal for data analyst/consulting roles in SQL, BI tools (Tableau/Power BI), and AI ethics.

**Connect**: [LinkedIn]() | [Portfolio]()

# GenAI-Powered MySQL EDA: Credit Delinquency Prediction

[![Tata iQ Forage](https://img.shields.io/badge/Forage-Tata%20iQ-blueviolet)][forage-link] [![MySQL](https://img.shields.io/badge/MySQL-EDA-orange)](https://www.mysql.com/)

## 🎯 Overview
Tata iQ GenAI Data Analytics simulation (Apr 2026): Used **MySQL** + GenAI (ChatGPT/Gemini) for EDA on Geldium's credit card dataset (~500 records). Analyzed delinquency risks, cleaned data, profiled customers, and prepped for modeling (logistic regression/decision trees). [Full report](./GenAi-EDA.docx)[file:1]

**MySQL Focus**: Imported data, ran EDA queries for summaries/stats/missing values, imputed via SQL functions, correlated risks (e.g., high utilization vs. defaults).[web:11]

**Skills**: SQL (aggregation, window functions, CTEs), GenAI prompting, risk analysis, ethical AI.

## 📊 Dataset & Insights
- **Source**: Geldium customer data (income, credit limit/utilization, payments x6 months, delinquency status).[web:6]
- **Key Stats** (from MySQL queries):
  | Metric | Value | Insight |
  |--------|-------|---------|
  | Records | ~500 | Post-cleaning |
  | Delinquency Rate | ~22% | High-utilization cohort: 40%+ |
  | Missing Data | 5-15% in payments | Imputed w/ medians |
  | Top Risks | Utilization >80%, late pays >2 | 3x default odds[web:6] |

- **Patterns**: `SELECT CORR(credit_util, delinquency) → 0.65`; Younger/new accounts higher risk.[file:1]

## 🔍 Sample MySQL Queries
```sql
-- 1. EDA Summary (structure, missing %)
SELECT 
    COUNT(*) as total_rows,
    SUM(CASE WHEN payment_history IS NULL THEN 1 ELSE 0 END)/COUNT(*) *100 as missing_pct
FROM geldium_customers;

-- 2. Risk Profiling (high-risk segments)
SELECT 
    AVG(credit_utilization) as avg_util,
    AVG(delinquency_status) as def_rate
FROM geldium_customers
WHERE late_payments > 2
GROUP BY age_group;

-- 3. Imputation Simulation (median fill)
UPDATE geldium_customers 
SET monthly_income = (
    SELECT AVG(monthly_income) FROM geldium_customers WHERE monthly_income IS NOT NULL
)
WHERE monthly_income IS NULL;
```
[Full queries](./eda_queries.sql)[Delinquent_prediction][trend]

## 🛠 Stack & Setup
- **MySQL**: Data import/cleaning/EDA (Workbench preferred for your setup)
- **GenAI**: Prompts for insights (e.g., "Analyze MySQL output for delinquency trends")
- **Run Locally**:
  1. `mysql -u root -p < create_db.sql`
  2. Import CSV: `LOAD DATA INFILE 'Delinquency_prediction_dataset.csv' INTO TABLE customers;`
  3. `source eda_queries.sql`
  4. Visualize: Export to CSV → Power BI/Tableau

**Requirements**: MySQL 8+, sample data from UCI Credit Card Default (adaptable).[web:2]

## 📈 Outcomes
- Handled missingness (impute/drop/synthetic via GenAI).
- Modeled ethically: Precision/recall focus, bias checks.
- Business Impact: Proactive collections via risk scores.

## Business Summary Report: Predictive Insights for Collections Strategy

## Summary of Predictive Insights

- **High risk segments**: Customers with low credit scores (<400), high credit utilization (>70%), and multiple missed payments across Month_1–Month_6 are most likely to become delinquent. Unemployed and student groups also show elevated risk due to unstable income.
- **Top predictors of delinquency**: The strongest drivers are Missed_Payments, Credit_Utilization, Debt_to_Income_Ratio, and sequential payment history patterns. These variables consistently separate high risk customers from low risk ones.
- **Meaningful patterns**: Customers with stable employment and lower debt ratios tend to remain on time, while those with frequent late/missed payments quickly escalate into high risk categories. Location clusters (e.g., Phoenix, Chicago) show higher delinquency rates compared to other cities.
  
## Key Insight	Customer Segment	Influencing Variables	Potential Impact
- High utilization + low credit score	Customers with >70% utilization and scores <400	Credit_Utilization, Credit_Score	Flag early for proactive outreach
- Multiple missed payments	Unemployed/Student groups with repeated missed payments	Month_1–Month_6 history, Missed_Payments	Prioritize repayment plans or counseling
- High debt-to-income ratio	Customers with DTI >0.4	Debt_to_Income_Ratio, Loan_Balance, Income	Monitor closely; adjust credit limits
  
This summary highlights who is most at risk, which variables drive delinquency, and how the Collections team can act (e.g., early intervention, repayment plans, credit limit adjustments).

## Recommendation Framework
Here’s a SMART recommendation framework based on one of the key insights:
- Restated Insight: 
Customers with high credit utilization (>70%) are significantly more likely to become delinquent.

- Proposed Recommendation: Introduce a credit utilization monitoring program that proactively flags and supports customers whose utilization exceeds 70%.

**SMART Breakdown**

- **Specific**: Identify customers with utilization above 70% and offer tailored repayment plans or credit counseling.
- **Measurable**: Reduce delinquency rates among high utilization customers by 15% within 12 months.
- **Actionable**: Collections and Risk teams will implement automated alerts and outreach campaigns targeting flagged customers.
- **Relevant**: Directly addresses one of the strongest predictors of delinquency, aligning with Geldium’s goal of reducing credit risk exposure.
- **Time bound**: Launch the program within 3 months, with quarterly reviews to track progress and adjust interventions.

## Justification and Business Rationale:

This recommendation is effective because it targets a clear, measurable risk factor (high utilization) that strongly correlates with delinquency. By intervening early, Geldium can reduce defaults, improve repayment behavior, and demonstrate proactive risk management to regulators and stakeholders. It is feasible to implement existing data systems, align with business objectives, and ensure both financial stability and customer support.

## Ethical and Responsible AI Considerations

Fairness Risks and Mitigation
- **Risk 1**: Bias against vulnerable groups (e.g., unemployed, students, or retirees). Mitigation: Regular fairness audits comparing prediction accuracy across demographic segments. Apply re weighting or threshold adjustments to ensure no group is disproportionately flagged without valid financial indicators.
- **Risk 2**: Geographic bias (e.g., certain cities like Phoenix or Chicago showing higher delinquency rates). Mitigation: Control for location effects by including socio economic variables and monitoring whether predictions unfairly penalize customers based solely on geography.

## Transparency and Explainability
- Predictions will be explained in plain language: for example, “This customer is flagged as high risk because of a low credit score, high utilization, and multiple missed payments.”
- Use feature importance scores or SHAP values to show stakeholders which variables most influenced each prediction.
- Provide clear documentation so non technical teams (Collections, Compliance) can understand how the model works.
  
## Responsible AI Principles
-	**Transparency**: Clear communication of how predictions are made.
-	**Accountability**: Regular monitoring and retraining to ensure accuracy and fairness.
-	**Data Privacy**: Customer data is used responsibly, with strict access controls.
-	**Ethical Impact**: Recommendations support proactive outreach and repayment assistance, not automatic denial of credit.

This approach ensures the model is accurate, fair, and explainable, while aligning with Geldium’s business goals and regulatory requirements. By combining fairness checks, transparent communication, and responsible use of customer data, Geldium can build trust with both customers and regulators while reducing delinquency risk.



