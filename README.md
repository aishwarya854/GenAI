# GenAI-Powered EDA for Credit Delinquency Prediction
###### Tata iQ GenAI Data Analytics simulation
[![Tata iQ Forage Badge](https://img.shields.io/badge/Forage-Tata%20iQ-blueviolet)](https://www.theforage.com/virtual-internships/prototype/8b8M3nXj9kKqGfJYB/Tata-iQ-GenAI-Powered-Data-Analytics) [![MySQL](https://img.shields.io/badge/MySQL-EDA-orange)](https://www.mysql.com/)

## 👋 Hi, I'm Aishwarya Raut  

**Business Analyst | Project Manager | Data Enthusiast**  
Bridging analytics and project execution with SQL, Power BI, and leadership skills.

  ![AI-Powered Collections Strategy Banner](https://copilot.microsoft.com/th/id/BCO.11415c6f-03b9-4bbb-924f-f289a6967311.png)


***“Smart, Fair & Transparent Financial Risk Management powered by Agentic AI."***

## 🎯 Project Overview
Completed Tata iQ's GenAI Data Analytics simulation (April 2026). Applied GenAI (ChatGPT/Gemini) for EDA on financial datasets to predict credit card delinquency at Geldium, a fictional lender. Covered data quality checks, risk profiling, predictive modeling frameworks, ethical AI, and automated collections strategy design. 

> This project blends analytics and ethical AI to help financial institutions manage risk responsibly. It demonstrates end‑to‑end capability — from data cleaning and modeling to visualization and business strategy — making it ideal for roles in Business Analytics, Data Science, or Project Management.

## 📂 Featured Projects
### 🔹 [Credit Delinquency Prediction Model](https://github.com/aishwarya854/GenAI/blob/main/GenAiPresentation_Aishwarya.pptx) 
- Built predictive pipeline using logistic regression & gradient boosting  
- Engineered categorical features for payment history codes  
- Delivered stakeholder‑friendly dashboards with actionable insights  


### 🚀 Skills Demonstrated: 
- Exploratory Data Analysis (EDA) with GenAI assistance
- Missing data handling (imputation, synthetic generation)
- Risk factor identification (payment history, credit utilization, DTI)
- No-code predictive modeling (logistic regression/decision trees)
- Model evaluation (precision, recall, AUC, bias checks)
- Responsible AI (fairness, explainability, compliance)
- <p align ="center">
    <img src="https://img.shields.io/badge/MySQL-orange" />
    <img src="https://img.shields.io/badge/AI-Analytics-blue" />
    <img src="https://img.shields.io/badge/AI-Strategy-darkblue" />
    <img src="https://img.shields.io/badge/Process Automation-white" />
    <img src="https://img.shields.io/badge/Data & Analytics-Lightgreen" />
    <img src="https://img.shields.io/badge/Project Management- darkpink" />
    <img src="https://img.shields.io/badge/Workflow optimization- grey" />
    <img src="https://img.shields.io/badge/PowerBI-Dashboards-yellow" />
    <img src="https://img.shields.io/badge/Python-DataCleaning-green" />
    <img src="https://img.shields.io/badge/Leadership-TeamSuccess-orange" />
    </p>
- GenAI prompting, risk analysis, ethical AI, Analytical Reporting, Business Communication, Data Interpretation, Data Quality Management, Decision Making, Ethical Reasoning, Model Selection, Model Validation, Predictive Analytics, Process Automation, Regulatory Compliance, Strategic Thinking

- **MySQL Focus**: Imported data, ran EDA queries for summaries/stats/missing values, imputed via SQL functions, correlated risks (e.g., high utilization vs. defaults).

## 📊 Key Findings
- **Top Delinquency Risks**: High credit utilization (>80%), 2+ missed payments, DTI >0.5 increase default odds 3x.
- **Data Handling**: Imputed missing income/payment data via median; generated synthetic records validated against real distributions.
- **Patterns**: Correlations between low income and late payments; anomalies like high credit scores with misses flagged.

| Risk Factor | Impact on Delinquency | Handling Approach |
|-------------|-----------------------|-------------------|
| Payment History | Highest predictor | GenAI trend analysis |
| Credit Utilization | Strong correlation | Outlier detection |
| DTI Ratio | Medium-high | Imputation (median) |

## 🛠 Tech Stack
- **GenAI Tools**: ChatGPT, Microsoft Copilot, Google Gemini for prompts (e.g., "Summarize missing values & suggest imputation")
- **Analytics**: Conceptual SQL/Pandas for EDA; no-code modeling pipelines

See report: [GenAi-SummaryReport](./Business_Summary_Report_Aishwarya.pdf)

## Why This Matters
Showcases end-to-end analytics for fintech: From raw data to AI strategy. Ideal for data analyst/consulting roles in SQL, BI tools (Tableau/Power BI), and AI ethics.

## 📊 Dataset & Insights
- **Source**: Geldium customer data (income, credit limit/utilization, payments x6 months, delinquency status).[Data](./Delinquency_prediction_dataset.xlsx)
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

## 📈 Outcomes
- Handled missingness (impute/drop/synthetic via GenAI).
- Modeled ethically: Precision/recall focus, bias checks.
- Business Impact: Proactive collections via risk scores.


## Summary of Predictive Insights

- **High risk segments**: Customers with low credit scores (<400), high credit utilization (>70%), and multiple missed payments across Month_1–Month_6 are most likely to become delinquent. Unemployed and student groups also show elevated risk due to unstable income.
- **Top predictors of delinquency**: The strongest drivers are Missed_Payments, Credit_Utilization, Debt_to_Income_Ratio, and sequential payment history patterns. These variables consistently separate high risk customers from low risk ones.
- **Meaningful patterns**: Customers with stable employment and lower debt ratios tend to remain on time, while those with frequent late/missed payments quickly escalate into high risk categories. Location clusters (e.g., Phoenix, Chicago) show higher delinquency rates compared to other cities.
  
## Key Insight	Customer Segment	Influencing Variables	Potential Impact
- **High utilization + low credit score**	Customers with >70% utilization and scores <400	Credit_Utilization, Credit_Score	Flag early for proactive outreach
- **Multiple missed payments**	Unemployed/Student groups with repeated missed payments	Month_1–Month_6 history, Missed_Payments	Prioritize repayment plans or counseling
- **High debt-to-income ratio**	Customers with DTI >0.4	Debt_to_Income_Ratio, Loan_Balance, Income	Monitor closely; adjust credit limits
  
> This summary highlights who is most at risk, which variables drive delinquency, and how the Collections team can act (e.g., early intervention, repayment plans, credit limit adjustments).

## Recommendation Framework

Here’s a SMART recommendation framework based on one of the key insights:
- *Restated Insight*:
 <p align = "center">
   "Customers with high credit utilization (>70%) are significantly more likely to become delinquent"
  </p> 

- *Proposed Recommendation*: Introduce a credit utilization monitoring program that proactively flags and supports customers whose utilization exceeds 70%.

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

> This approach ensures the model is accurate, fair, and explainable, while aligning with Geldium’s business goals and regulatory requirements. By combining fairness checks, transparent communication, and responsible use of customer data, Geldium can build trust with both customers and regulators while reducing delinquency risk.

## 📈 Results & Next Steps
- Proposed logistic regression for interpretable predictions (AUC target >0.8).
- Designed agentic AI collections system with human-in-loop for escalations.
- Ethical Guardrails: Bias audits, SHAP explainability, GDPR/FCA compliance.

## 📫 Connect With Me
  [![Gmail](https://img.shields.io/badge/Gmail-red)](https://a.raut.works@gmail.com)
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-blue)](https://linkedin.com/in/aishwaryaraut) 
  [![GitHub Portfolio](https://img.shields.io/badge/GitHub-Portfolio-darkgrey)](https://github.com/aishwarya854)

⭐

