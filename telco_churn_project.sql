SELECT *
FROM customer_churn;

-- create new table to do analysis on
CREATE TABLE customer_churn2
LIKE customer_churn;

INSERT customer_churn2
SELECT *
FROM customer_churn;

SELECT * 
FROM customer_churn2;

-- exploratory data analysis

-- churned data
SELECT COUNT(*) AS total_churn, COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned,
COUNT(*) - COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS not_churned
FROM customer_churn2;

-- percent churned
SELECT ROUND(COUNT(CASE WHEN churn = 'Yes' THEN 1 END) / COUNT(*) * 100, 2) AS percent_churned
FROM customer_churn2;

-- month-to-month contracts are much more likely to churn
SELECT Contract, churn, COUNT(*) AS num_contract_churned
FROM customer_churn2
GROUP BY churn, contract
ORDER BY churn;

-- churn rate by internet type
SELECT internetservice, COUNT(*) AS num_customers
FROM customer_churn2
GROUP BY InternetService;

SELECT DISTINCT(internetservice) AS internet, churn, COUNT(*) AS num_churned
FROM customer_churn2
WHERE churn = 'Yes' AND InternetService != 'No'
GROUP BY internet, churn;

-- explore churn rate correlation with total charges
SELECT totalcharges, churn, COUNT(CASE WHEN churn ='Yes' THEN 1 END) AS churned
FROM customer_churn2
WHERE TotalCharges > 1500
GROUP BY TotalCharges, churn
ORDER by TotalCharges desc;

-- total charges > 500
SELECT SUM(churned) num_churned, COUNT(*) AS num_charges_greater_500 FROM(
SELECT totalcharges, churn, COUNT(CASE WHEN churn ='Yes' THEN 1 END) AS churned
FROM customer_churn2
WHERE TotalCharges > 500
GROUP BY TotalCharges, churn
ORDER by TotalCharges desc)
counttable;

SELECT ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS percent_churned
FROM customer_churn2
WHERE TotalCharges > 500;

-- totalcharges > 1500
SELECT SUM(churned) num_churned, COUNT(*) AS num_charges_greater_1500 FROM(
SELECT totalcharges, churn, COUNT(CASE WHEN churn ='Yes' THEN 1 END) AS churned
FROM customer_churn2
WHERE TotalCharges > 1500
GROUP BY TotalCharges, churn
ORDER by TotalCharges desc)
counttable;

SELECT ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS percent_churned
FROM customer_churn2
WHERE TotalCharges > 1500;

-- totalcharges > 2500
SELECT SUM(churned) num_churned, COUNT(*) AS num_charges_greater_2500 FROM(
SELECT totalcharges, churn, COUNT(CASE WHEN churn ='Yes' THEN 1 END) AS churned
FROM customer_churn2
WHERE TotalCharges > 2500
GROUP BY TotalCharges, churn
ORDER by TotalCharges desc)
counttable;

SELECT ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS percent_churned
FROM customer_churn2
WHERE TotalCharges > 2500;

-- results - as totalcharge increases, percent churned decreases
WITH percent_churned_gt_500 AS (
    SELECT ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_churned
    FROM customer_churn2
    WHERE TotalCharges > 500
),
percent_churned_gt_1500 AS (
    SELECT ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_churned
    FROM customer_churn2
    WHERE TotalCharges > 1500
),
percent_churned_gt_2500 AS (
    SELECT ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_churned
    FROM customer_churn2
    WHERE TotalCharges > 2500
)
SELECT 
    COALESCE(gt500.percent_churned, 0) AS percent_churned_gt_500,
    COALESCE(gt1500.percent_churned, 0) AS percent_churned_gt_1500,
    COALESCE(gt2500.percent_churned, 0) AS percent_churned_gt_2500
FROM 
    percent_churned_gt_500 gt500
    CROSS JOIN percent_churned_gt_1500 gt1500
    CROSS JOIN percent_churned_gt_2500 gt2500;
    
-- churn by gender - no correlation
SELECT gender, churn, COUNT(*)
FROM customer_churn2
GROUP BY gender, churn
ORDER BY gender;

-- churn by senior citizen
SELECT seniorcitizen, churn, COUNT(*)
FROM customer_churn2
GROUP BY seniorcitizen, churn
ORDER BY SeniorCitizen;

SELECT SUM(CASE WHEN seniorcitizen = 1 AND churn = 'Yes' THEN 1 END) senior_citizen_churned,
	COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END) total_senior_citizen
FROM customer_churn2;

SELECT ROUND(senior_citizen_churned / total_senior_citizen * 100, 2) as percent_senior_churned FROM(
SELECT SUM(CASE WHEN seniorcitizen = 1 AND churn = 'Yes' THEN 1 END) senior_citizen_churned,
	COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END) total_senior_citizen
FROM customer_churn2)
counttable;

-- churn by non senior citizen
SELECT ROUND(non_senior_citizen_churned / total_non_senior_citizen * 100, 2) as percent_non_senior_churned FROM(
SELECT SUM(CASE WHEN seniorcitizen = 0 AND churn = 'Yes' THEN 1 END) non_senior_citizen_churned,
	COUNT(CASE WHEN seniorcitizen = 0 THEN 1 END) total_non_senior_citizen
FROM customer_churn2)
counttable;

-- senior citizens are more likely to churn
WITH percent_senior_churned AS (
	SELECT 
		ROUND(senior_citizen_churned / total_senior_citizen * 100, 2) as percent_senior_churned FROM(
	SELECT 
		SUM(CASE WHEN seniorcitizen = 1 AND churn = 'Yes' THEN 1 END) senior_citizen_churned,
		COUNT(CASE WHEN seniorcitizen = 1 THEN 1 END) total_senior_citizen
		FROM customer_churn2) 
        AS counttable
),
percent_non_senior_churned AS (
	SELECT 
		ROUND(non_senior_citizen_churned / total_non_senior_citizen * 100, 2) as percent_non_senior_churned FROM(
	SELECT 
		SUM(CASE WHEN seniorcitizen = 0 AND churn = 'Yes' THEN 1 END) non_senior_citizen_churned,
		COUNT(CASE WHEN seniorcitizen = 0 THEN 1 END) total_non_senior_citizen
		FROM customer_churn2) 
        AS counttable
)
SELECT 
	sc.percent_senior_churned,
    nsc.percent_non_senior_churned
FROM
	percent_senior_churned sc
    CROSS JOIN percent_non_senior_churned nsc;
    


