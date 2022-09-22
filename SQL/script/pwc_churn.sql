
/* WRITING BASIC QUERIES TO GET INFORMATION FROM THE PWC CHURN DATASET */

-- 1. Total number of customers (churning and staying)

SELECT COUNT(*)
FROM pwc_churn.churn_dataset;

-- There was a total of 7043 customers

-- 2. Total number of customers who churned/stayed

SELECT Churn, COUNT(customerID) AS count
FROM pwc_churn.churn_dataset
GROUP BY Churn;

-- 1869customers vhurned while 5174 customers stayed

-- 3. How many customers are senior citizens

SELECT COUNT(*)
FROM pwc_churn.churn_dataset
WHERE SeniorCitizen=1;

-- There are 1142 senior citizens

-- 4. Total number of customers and their respective contract type

SELECT Contract, COUNT(customerID)
FROM pwc_churn.churn_dataset
GROUP BY Contract;

SELECT Contract, COUNT(customerID), Churn
FROM pwc_churn.churn_dataset
GROUP BY Contract,Churn;

-- OBSERVATION: The company is mostly patronised by customers who subscribe Month-to-Month. Out of 3875 monthly subscribers, 1655 churned.

-- 5. Total number of customers and their respective payment method

SELECT PaperlessBilling, COUNT(customerID)
FROM pwc_churn.churn_dataset
GROUP BY PaperlessBilling;

-- 6. Make changes to the table; if a customer has "No phone service" and "No internet service", then it they should be set as "No"

UPDATE pwc_churn.churn_dataset
SET MultipleLines='No'
WHERE MultipleLines='No phone service';

UPDATE pwc_churn.churn_dataset
SET OnlineSecurity='No'
WHERE OnlineSecurity='No internet service';

UPDATE pwc_churn.churn_dataset
SET OnlineBackup='No'
WHERE OnlineBackup='No internet service';

UPDATE pwc_churn.churn_dataset
SET DeviceProtection='No'
WHERE DeviceProtection='No internet service';

UPDATE pwc_churn.churn_dataset
SET TechSupport='No'
WHERE TechSupport='No internet service';

UPDATE pwc_churn.churn_dataset
SET StreamingTV='No'
WHERE StreamingTV='No internet service';

UPDATE pwc_churn.churn_dataset
SET StreamingMovies='No'
WHERE StreamingMovies='No internet service';

SELECT *
FROM pwc_churn.churn_dataset; -- Checking if this worked

-- 7. What is the churn rate based on the number of tenure in month(s)

SELECT tenure, COUNT(customerID) AS churn_count
FROM pwc_churn.churn_dataset
WHERE Churn='Yes'
GROUP BY tenure
ORDER BY churn_count DESC;

-- OBSERVATION: Customers who churned were mostly those that have only been with the company for 1-5 months.

-- 8. What are the internet service types of customers.

SELECT InternetService, COUNT(customerID) AS churn_count
FROM pwc_churn.churn_dataset
WHERE Churn='Yes'
GROUP BY InternetService;

-- There are 2 types of internet services; DSL and Fiber Optic, with 2421 and 3096 customers respectively. 1526 customers do not have internet service

-- 9. What are the payment method

SELECT PaymentMethod, COUNT(customerID) AS customer_count
FROM pwc_churn.churn_dataset
GROUP BY PaymentMethod;

SELECT PaymentMethod, COUNT(customerID) AS customer_count
FROM pwc_churn.churn_dataset
WHERE Churn='Yes'
GROUP BY PaymentMethod;

-- 10. Sum total of monthly charges for both churning and staying customers

SELECT ROUND(SUM(MonthlyCharges),2) AS MonthlyCharges
FROM pwc_churn.churn_dataset
WHERE Churn='No';

SELECT ROUND(SUM(MonthlyCharges),2) AS MonthlyCharges
FROM pwc_churn.churn_dataset
WHERE Churn='Yes';

-- 11. Sum total of total charges for both churning and staying customers

SELECT ROUND(SUM(TotalCharges),2) AS TotalCharges
FROM pwc_churn.churn_dataset
WHERE Churn='No';

SELECT ROUND(SUM(TotalCharges),2) AS TotalCharges
FROM pwc_churn.churn_dataset
WHERE Churn='Yes';

-- 12. What is the monthly charges of custumners who stayed/churned based on their contract type
SELECT Contract, ROUND(SUM(MonthlyCharges),2) AS MonthlyCharges
FROM pwc_churn.churn_dataset
WHERE Churn='No'
GROUP BY Contract;

SELECT Contract, ROUND(SUM(MonthlyCharges),2) AS MonthlyCharges
FROM pwc_churn.churn_dataset
WHERE Churn='Yes'
GROUP BY Contract;

-- 13. What is the total charges of customers who stayed/churned based on their contract type

SELECT Contract, ROUND(SUM(TotalCharges),2) AS TotalCharges
FROM pwc_churn.churn_dataset
WHERE Churn='No'
GROUP BY Contract;

SELECT Contract, ROUND(SUM(TotalCharges),2) AS TotalCharges
FROM pwc_churn.churn_dataset
WHERE Churn='Yes'
GROUP BY Contract;

-- 14. Churn based on gender

SELECT gender, COUNT(customerID)
FROM pwc_churn.churn_dataset
WHERE Churn='Yes'
GROUP BY gender;

-- 3555 Males and 3488 Females with 930 and 939 of them churning respectively

-- 15. What is the relationship status of the customers

SELECT Partner, COUNT(customerID) AS count
FROM pwc_churn.churn_dataset
GROUP BY Partner;

-- 3402 customers have partners, whle 3641 customers do not have partners

-- 16. What is the average monthly charges of customers based on their contract with the company
SELECT Contract, AVG(MonthlyCharges)
FROM pwc_churn.churn_dataset
GROUP BY Contract;
