USE telecom_churn;

SELECT * FROM telecom_cleaned LIMIT 5;

#  Business Questions this company is facing:

# Q1. What is our overall churn rate — how bad is the problem?
SELECT 
	count(*) as total_customers,
    ROUND(SUM(CASE WHEN churn='Yes' THEN 1 ELSE 0 END )*100/COUNT(*),1) AS churn_rate_pct
    FROM telecom_cleaned; 
    # 26.5% customer are churn that lead to major loss for a company 
    
    
# Q2. How much monthly revenue are we losing because of churned customers?

SELECT
  ROUND(SUM(MonthlyCharges), 0) AS total_revenue,
  ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 0) AS revenue_at_risk,
  ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) * 100.0 / SUM(MonthlyCharges), 1) AS pct_at_risk
FROM telecom_cleaned;

# Q3. Which contract type is causing the most churn — where should we focus retention efforts?

SELECT Contract,count(*) as total_customers,
	SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END ) as churned,
    SUM(CASE WHEN Churn='NO' THEN 1 ELSE 0 END ) as retained,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END )*100/COUNT(*) ,1) as Churn_rate_pct,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END) ,0) AS revenue_at_risk
    FROM  telecom_cleaned 
    GROUP BY  Contract
    ORDER BY Churn_rate_pct;

# Q4. At what stage of a customer's journey do they leave most — early, mid, or late?

SELECT 
	TenureGroup,
    count(*) as total_customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END ) as Churned,
    ROUND(SUM( CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100/ COUNT(*),1) as Churn_rate_pct,
    ROUND(SUM( CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END),0) as revenue_at_risk
    FROM telecom_cleaned
    GROUP BY TenureGroup
    ORDER BY Churn_rate_pct ;

# Q5. Who are our highest risk customers RIGHT NOW that we should call immediately?

WITH high_risk AS(
	SELECT 
		customerID,
        gender,
        SeniorCitizen,
        Contract,
        Tenure,
        TenureGroup,
        InternetService,
        OnlineSecurity,
        MonthlyCharges,
        NumAddOnServices
	FROM telecom_cleaned
	WHERE Contract='Month-to-month'
	AND  TenureGroup='0-12 months'
    AND Churn='No'
),
ranked AS (
	SELECT *,
		RANK() OVER(ORDER BY MonthlyCharges DESC) as priority_rank
        FROM high_risk
)
SELECT * FROM ranked WHERE priority_rank<=20
ORDER BY priority_rank;


# Q6. Which internet service type is costing us the most revenue through churn?

SELECT 
	InternetService,
    COUNT(*) as total_customer,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END ) as Churned_customer,
    ROUND(SUM( CASE WHEN Churn='Yes' THEN 1 ELSE 0 END )*100/COUNT(*) ,1) as churn_rate_pct,
    ROUND(SUM( CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END),0 ) AS revenue_lost,
    ROUND(SUM(MonthlyCharges),0) AS total_revenue,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END)* 100/SUM(MonthlyCharges),1) as revenue_lost_pct
    FROM telecom_cleaned
    GROUP BY InternetService
    ORDER BY revenue_lost;


# Q7. Among our high-paying customers (>$70/month), which contract type has the most revenue at risk?
SELECT 
	Contract,
	count(*) as high_risk_customer,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)*100/COUNT(*),1) as churn_rate_pct,
    ROUND(SUM(CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END),0) as revenue_at_risk,
    ROUND(AVG(MonthlyCharges),1) AS avg_monthly_charges
    FROM telecom_cleaned
    WHERE MonthlyCharges>70
    GROUP BY Contract 
    ORDER BY revenue_at_risk DESC  ;
    
# Q8. Who are the top 5 highest paying churned customers per contract type — who did we lose that hurt the most?
WITH Churned_customer AS (
SELECT 
	customerID,
    Contract,
    MonthlyCharges,
    Tenure,
    TenureGroup,
    InternetService
	FROM telecom_cleaned
    WHERE Churn='Yes'
),
	ranked as (
    SELECT*,
    RANK() OVER(
    partition by Contract 
    ORDER BY MonthlyCharges DESC 
    )AS rnk
    FROM Churned_customer
) 
SELECT * FROM ranked
WHERE rnk<=5 
ORDER BY Contract ,rnk
LIMIT 5;

