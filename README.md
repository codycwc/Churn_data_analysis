
# Customer Churn Analysis

## Project Overview

This project involves analyzing customer churn data to understand patterns and factors affecting customer retention. Using SQL for data analysis, the project explores churn rates across different customer segments and contract types. A Tableau dashboard will be created to visually represent the findings and enhance data interpretation.

## Data

- **Dataset:** https://www.kaggle.com/datasets/blastchar/telco-customer-churn

## Key Queries and Analysis

### 1. **Data Preparation**

- Standardized data and removed duplicates in excel.
- Created a new table `customer_churn2` for analysis.

### 2. **Exploratory Data Analysis**

- **Overall Churn Rates:** Calculated total churn and churn percentage.
- **Contract Type Analysis:** Analyzed churn rates by contract type.
- **Internet Service Analysis:** Evaluated churn by internet service type.
- **Total Charges Correlation:** Investigated how total charges affect churn rates.

### 3. **Detailed Churn Rate Analysis**

- **Threshold Analysis:** Compared churn rates for customers with total charges above $500, $1,500, and $2,500.
- **Customer Demographics:** Analyzed churn rates for senior and non-senior citizens.

### 4. **Comparative Analysis**

- Used CTEs to compare churn rates across different total charges thresholds and demographics.

### 5. **Tableau Dashboard**

- **Objective:** Tableau dashboard that visually represents churn rates, customer segments, and contract types.
- **Features:** Interactive charts and graphs to allow users to explore churn patterns and factors affecting customer retention.

## Findings

- Higher total charges correlate with lower churn rates.
- Month-to-month contracts show higher churn rates.
- Churn rates vary with internet service types.
- Senior citizens have higher churn rates compared to non-senior citizens.


## Tools Used

- Excel for data cleaning.
- SQL for data querying.
- Tableau for data visualization.
