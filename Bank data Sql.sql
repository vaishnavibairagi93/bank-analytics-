create database Bank ;

use Bank;

select * from bank_data;

# Alter table bank_data change Column `State Abbr` as State_Abbr varchar(20);


#========= 1. Total Loan Amount Funded ============#
# Alter table bank_data change Column `Total Rec Prncp`Total_Rec_Prncp int;
SELECT SUM(Total_Rec_Prncp) AS Total_Loan_Amount_Funded FROM bank_data;


#========= 2-Total Loans ============#

# Alter table bank_data change Column `Account ID`Account_ID varchar(50);
SELECT COUNT(DISTINCT(Account_ID)) AS Total_Loans FROM bank_data;



#=========  3-Total Collection ===========#
# Alter table bank_data change Column `Total Rrec int`Total_Rrec int;
SELECT 
  SUM(Total_Rec_Prncp) AS Total_Principal_Collected,
  SUM(Total_Rrec) AS Total_Interest_Collected,
  SUM((Total_Rec_Prncp)+ (Total_Rrec)) AS Total_Collection
FROM bank_data;




#============= 4-Total interest ==========#
SELECT SUM(Total_Rrec) AS Total_Interest FROM  bank_data;


#============ 5-Branch-Wise (Interest, Fees, Total Revenue)  ===========#
# Alter table bank_data change Column `Branch Name`Branch_Name Varchar(50);
# Alter table bank_data change Column `Total Fees`Total_Fees int;


SELECT 
  Branch_Name,
  SUM(Total_Rrec) AS Total_Interest_Revenue,
  SUM(Total_Fees) AS Total_Fee_Revenue,
  SUM((Total_Rrec) + (Total_Fees)) AS Total_Revenue
FROM bank_data
GROUP BY Branch_Name
ORDER BY Total_Revenue DESC;


#========== 6-State-Wise Loan ==========#
SELECT 
  State_Abbr AS State,
  COUNT(DISTINCT (Account_ID)) AS Total_Loans
FROM bank_data
GROUP BY State_Abbr
ORDER BY Total_Loans DESC;



#========== 7. Religion-Wise Loan ===========#
SELECT 
  Religion,
  COUNT(DISTINCT(Account_ID)) AS Total_Loans
FROM bank_data
GROUP BY Religion
ORDER BY Total_Loans DESC;





#================ 8-Product Group-Wise Loan =========#
Alter table bank_data change column `Product Id` Product_Id varchar(100);

SELECT 
  Product_id,
  COUNT(DISTINCT(Account_ID)) AS Total_Loans,
  SUM((Total_Rec_Prncp)) AS Total_Loan_Amount_Funded
FROM bank_data
GROUP BY Product_id
ORDER BY Total_Loans DESC;





#============== 9-Disbursement Trend ===============#
SELECT 
  DATE_FORMAT(`Disbursement Date`, '%Y-%m') AS Disbursement_Month,
  COUNT(DISTINCT `Account_ID`) AS Total_Loans,
  SUM(`Total_Rec_Prncp`) AS Total_Amount_Funded
FROM Bank_Data
GROUP BY DATE_FORMAT(`Disbursement Date`, '%Y-%m')
ORDER BY Disbursement_Month;



#=========== 10-Grade-Wise Loan ==========#
SELECT 
  Grrade,
  COUNT(DISTINCT (Account_ID)) AS Total_Loans,
  SUM(Total_Rec_Prncp) AS Total_Loan_Amount_Funded
FROM bank_data
GROUP BY Grrade
ORDER BY Total_Loan_Amount_Funded DESC;



#============ 11. Count of Default Loan===============#
Alter table bank_data change Column `Loan Status`Loan_Status varchar(20);


SELECT 
  COUNT(DISTINCT (Account_ID)) AS Default_Loan_Count
FROM bank_data
WHERE default_loan= 'y';


#============= 12. Count of Delinquent Clients =============#
select * from bank_data;
Alter table bank_data change Column `Client id` Client_id int;
Alter table bank_data change Column `Total Rec Late fee`Total_Rec_Late_fee float;


SELECT COUNT(DISTINCT Client_id) AS Delinquent_Client_Count
FROM bank_data
WHERE `Is Delinquent Loan` = 'Y';


#===============13. Delinquent Loans Rate ===========#
SELECT 
  CAST(COUNT(CASE WHEN (Total_Rec_Late_fee) > 0 THEN 1 END) AS FLOAT) * 100 / 
  COUNT(DISTINCT (Account_ID)) AS Delinquent_Loan_Rate_Percentage
FROM bank_data;



#================14. Default Loan Rate ==============#
Alter table bank_data change Column `Is Default Loan` default_loan text;

SELECT 
  CAST(COUNT(CASE WHEN (default_loan) = 'Y' THEN 1 END) AS FLOAT) * 100 / 
  COUNT(DISTINCT (Account_ID)) AS Default_Loan_Rate_Percentage
FROM bank_data;




#================15. Loan Status-Wise Loan ============#
SELECT 
  (Loan_Status),
  COUNT(DISTINCT (Account_ID)) AS Total_Loans
FROM bank_data
GROUP BY (Loan_Status)
ORDER BY Total_Loans DESC;



#===============16. Age Group-Wise Loan===========#
SELECT 
  CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    WHEN Age > 60 THEN '60+'
    ELSE 'Unknown'
  END AS Age_Group,
  COUNT(DISTINCT (Account_ID)) AS Total_Loans,
  SUM(Total_Rec_Prncp) AS Total_Loan_Amount
FROM bank_data
GROUP BY 
  CASE 
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    WHEN Age > 60 THEN '60+'
    ELSE 'Unknown'
  END
ORDER BY Age_Group;



#===============17. No Verified Loan =============#
Alter table bank_data change column`Verification Status` Verification_Status varchar(30);
SELECT 
  Verification_Status,
  COUNT(DISTINCT(Account_ID)) AS Loan_Count
FROM bank_data
GROUP BY Verification_Status;



#============== 18. Loan Maturity============#

SELECT COUNT(*) AS no_verified_loan_count
FROM Bank_Data
WHERE Verification_Status = 'Not Verified';



