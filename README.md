# Telecom Customer Churn Analysis

**Identified $139,130/month revenue at risk (30.5% of total) and the customer segments most vulnerable to churn**

---

## 🎯 Business Problem

Telecom companies lose massive revenue when customers leave. This analysis answers:
- **Which customer segments are at highest churn risk?**
- **How much revenue is at stake?**
- **What actions should retention teams prioritize?**

**Key Finding:** 26.5% of customers churn (1 in 4), representing **$139,130 monthly revenue at risk**.

---

## 📊 Dataset Overview

| Attribute | Detail |
|-----------|--------|
| Rows | 7,043 customers |
| Columns | 21 (demographics, contract details, charges, services) |
| Churn Rate | 26.5% (1,869 customers) |

**Source:** [Telco Customer Churn Dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)

---

## 🔧 What I Did

### Data Cleaning & Feature Engineering
- Converted `TotalCharges` text → numeric, filled 11 blanks with 0
- Created 4 new features:
  - **`TenureGroup`**: Bucketed tenure (0-12, 13-24, 25-48, 49-72 months) → New customers churn at 47.7%
  - **`NumAddOnServices`**: Engagement score (0-6) → 31% have zero addons = highest risk
  - **`AvgMonthlySpend`**: Detects price changes correlating with churn
  - Simplified 6 addon columns ("No internet service" → "No")

### Exploratory Data Analysis (6 charts)
**Top churn drivers:**
1. **Contract type:** Month-to-month = 42.7% churn vs 2.8% for 2-year
2. **Tenure:** 0-12 months = 47.7% churn (newest customers most vulnerable)
3. **Internet service:** Fiber optic customers churn highest (44.3%)
4. **Add-on services:** More services = less churn
5. **Monthly charges:** $70-100 range hurts most

### Machine Learning Model
- **Algorithm:** Logistic Regression (`max_iter=1000`)
- **Split:** 80/20 train-test (5,634 train, 1,409 test)
- **Accuracy:** 85%+ 
- **Top predictor:** Contract type (strongest coefficient)

### Advanced SQL Queries (8 queries)
- Churn rate, revenue at risk, segments by contract/tenure/internet
- High-risk filter: month-to-month + >$70 charges = **52.7% churn**
- **CTE:** High-value at-risk customers
- **Window function:** TOP 5 churned per contract type (RANK)

### Power BI Dashboard
- 5 visuals: KPI cards, churn by contract/tenure, top drivers, revenue at risk
- Live MySQL connection

---

## 🎨 Key Findings

| Segment | Churn Rate | Revenue at Risk |
|---------|----------|-----------------|
| Month-to-month contract | 42.7% | $89,200 |
| New customers (0-12mo) | 47.7% | $66,400 |
| Fiber optic internet | 44.3% | $71,800 |
| **High-risk segment** (month-to-month + >$70) | **52.7%** | **$48,900** |
| Zero add-on services | 38.2% | $53,100 |
| 2-year contract | 2.8% | $3,200 |

**Bottom Line:** $139,130/month at risk = 30.5% of total revenue

---

## 💡 Recommendation

**Target month-to-month fiber optic customers in their first 12 months with contract upgrade incentives.**

**Actions:**
1. Offer 6-month discount to upgrade to 1-year contract
2. Bundle 2+ add-on services at discounted rate (engagement = retention)
3. Proactive outreach at month 9-10 (before typical churn window)
4. Priority retention for customers with >$70 monthly charges

**Expected Impact:** Reducing high-risk segment churn by 15% = **$7,335/month saved**

---

## 🛠️ Tools

**Python** (Pandas, Matplotlib, Sklearn) → **MySQL** (CTEs, window functions) → **Power BI** (live dashboard)

---

## 📁 Project Structure
├── data/telecom_cleaned.csv
├── notebooks/telecom_with_ML.ipynb
├── sql/churn_queries.sql
├── dashboard/telecom_dashboard.pbix
├── images/eda_charts.png
└── README.md
