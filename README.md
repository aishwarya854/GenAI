# GenAI
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
3. EDA: `jupyter notebook EDA.ipynb`

## Why This Matters
Showcases end-to-end analytics for fintech: From raw data to AI strategy. Ideal for data analyst/consulting roles in SQL, BI tools (Tableau/Power BI), and AI ethics.

**Connect**: [LinkedIn](your-linkedin) | [Portfolio](your-site)
