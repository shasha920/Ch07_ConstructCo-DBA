#Write the SQL code required to list the employee number, last name, first name, and middle initial of all employees whose last names start with Smith. 
#In other words, the rows for both Smith and Smithfield should be included in the listing. 
#Sort the results by employee number. Assume case sensitivity. Display the attributes shown in the results presented in Figure P7.1.
select EMP_NUM,EMP_LNAME,EMP_FNAME, EMP_INITIAL
from EMPLOYEE
where upper(EMP_LNAME) like 'SMITH%'
order by 1;

#Using the EMPLOYEE, JOB, and PROJECT tables in the Ch07_ConstructCo database, write the SQL code that will join the JOB, EMPLOYEE, and PROJECT tables
#using common attributes. Display the attributes shown in the results presented in Figure P7.2, sorted by project value.
select PROJ_NAME, PROJ_VALUE, PROJ_BALANCE, EMP_LNAME, EMP_FNAME, EMP_INITIAL,e.JOB_CODE,JOB_DESCRIPTION,JOB_CHG_HOUR
from JOB j join EMPLOYEE e on j.JOB_CODE=e.JOB_CODE
           join PROJECT p on e.EMP_NUM=p.EMP_NUM
order by 2;


#Write the SQL code that will produce the same information that was shown in Problem 2, but sorted by the employee’s last name. 
#The results of running that query are shown in Figure P7.3.
select PROJ_NAME, PROJ_VALUE, PROJ_BALANCE, EMP_LNAME, EMP_FNAME, EMP_INITIAL,e.JOB_CODE,JOB_DESCRIPTION,JOB_CHG_HOUR
from JOB j join EMPLOYEE e on j.JOB_CODE=e.JOB_CODE
           join PROJECT p on e.EMP_NUM=p.EMP_NUM
order by 4;

#Write the SQL code that will list only the distinct project numbers in the ASSIGNMENT table, sorted by project number. 
#The results of running that query are shown in Figure P7.4.
select distinct PROJ_NUM
from ASSIGNMENT
order by 1;


#Write the SQL code to validate the ASSIGN_CHARGE values in the ASSIGNMENT table. Your query should retrieve the assignment number, employee number, 
#project number, the stored assignment charge (ASSIGN_CHARGE), and the calculated assignment charge (CALC_ASSIGN_CHARGE, calculated 
#by multiplying ASSIGN_CHG_HR by ASSIGN_HOURS and rounded to two decimal places). Sort the results by the assignment number. 
#The results of running that query are shown in Figure P7.5.
select ASSIGN_NUM, EMP_NUM, PROJ_NUM, ASSIGN_CHARGE, ROUND(ASSIGN_CHG_HR * ASSIGN_HOURS,2) AS CALC_ASSIGN_CHARGE
from ASSIGNMENT
order by 1;


#Using the data in the ASSIGNMENT table, write the SQL code that will yield the total number of hours worked for each employee 
#and the total charges stemming from those hours worked, sorted by employee number. The results of running that query are shown in Figure P7.6.
select a.EMP_NUM, EMP_LNAME, ROUND(sum(ASSIGN_HOURS),1) AS SumOfASSIGN_HOURS, ROUND(sum(ASSIGN_CHARGE),2) AS SumOfASSIGN_CHARGE
from ASSIGNMENT a join EMPLOYEE e on a.EMP_NUM=e.EMP_NUM
group by 1,2
order by 1;

#Write a query to produce the total number of hours and charges for each of the projects represented in the ASSIGNMENT table, sorted by project number. 
#The output is shown in Figure P7.7.
select PROJ_NUM, ROUND(SUM(ASSIGN_HOURS),1) AS SumOfASSIGN_HOURS, ROUND(SUM(ASSIGN_CHARGE),2) AS SumOfASSIGN_CHARGE
from ASSIGNMENT
group by 1
order by 1;


#Write the SQL code to generate the total hours worked and the total charges made by all employees. The results are shown in Figure P7.8.
select ROUND(SUM(ASSIGN_HOURS),1) AS SumOfSumOfASSIGN_HOURS, ROUND(SUM(ASSIGN_CHARGE),2) AS SumOfSumOfASSIGN_CHARGE
from ASSIGNMENT;


#Write a query to count the number of invoices.
select COUNT(*)
from INVOICE;


#Write a query to count the number of customers with a balance of more than $500.
select COUNT(*)
from CUSTOMER
where CUS_BALANCE>500;


#Generate a listing of all purchases made by the customers, using the output shown in Figure P7.11 as your guide. Sort the results by customer code, 
#invoice number, and product description.
select i.CUS_CODE, i.INV_NUMBER, i.INV_DATE, p.P_DESCRIPT, l.LINE_UNITS, l.LINE_PRICE
from INVOICE i join LINE l ON i.INV_NUMBER=l.INV_NUMBER
               join PRODUCT p on p.P_CODE=l.P_CODE
order by 1,2,4;


#Using the output shown in Figure P7.12 as your guide, generate a list of customer purchases, including the subtotals for each of the invoice line numbers.
#The subtotal is a derived attribute calculated by multiplying LINE_UNITS by LINE_PRICE. Sort the output by customer code, invoice number,
#and product description. Be certain to use the column aliases as shown in the figure.
select i.CUS_CODE, i.INV_NUMBER,p.P_DESCRIPT,l.LINE_UNITS AS 'Units Bought', l.LINE_PRICE AS 'Unit Price',ROUND(l.LINE_UNITS* l.LINE_PRICE,2) AS Subtotal
from INVOICE i join LINE l ON i.INV_NUMBER=l.INV_NUMBER
               join PRODUCT p on p.P_CODE=l.P_CODE
order by 1,2,3;

#Write a query to display the customer code, balance, and total purchases for each customer. 
#Total purchase is calculated by summing the line subtotals (as calculated in Problem 12) for each customer.
#Sort the results by customer code, and use aliases as shown in Figure P7.13.

select c.CUS_CODE,c.CUS_BALANCE, ROUND(sum(l.LINE_UNITS* l.LINE_PRICE),2) AS 'Total Purchases'
from INVOICE i join LINE l ON i.INV_NUMBER=l.INV_NUMBER
               join CUSTOMER c on c.CUS_CODE=i.CUS_CODE
group by 1,2
order by 1;

#Modify the query in Problem 13 to include the number of individual product purchases made by each customer. 
#(In other words, if the customer’s invoice is based on three products, one per LINE_NUMBER, you count three product purchases.
#Note that in the original invoice data, customer 10011 generated three invoices, which contained a total of six lines, #
each representing a product purchase.) Your output values must match those shown in Figure P7.14, sorted by customer code.

select c.CUS_CODE,c.CUS_BALANCE, ROUND(sum(l.LINE_UNITS* l.LINE_PRICE),2) AS 'Total Purchases',count(*) AS 'Number of Purchases'
from INVOICE i join LINE l ON i.INV_NUMBER=l.INV_NUMBER
               join CUSTOMER c on c.CUS_CODE=i.CUS_CODE
group by 1,2
order by 1;

#Use a query to compute the total of all purchases, the number of purchases, and the average purchase amount made by each customer. 
#Your output values must match those shown in Figure P7.15. Sort the results by customer code.
select c.CUS_CODE,c.CUS_BALANCE, ROUND(sum(l.LINE_UNITS* l.LINE_PRICE),2) AS 'Total Purchases',count(*) AS 'Number of Purchases', ROUND(AVG(l.LINE_UNITS* l.LINE_PRICE),2) AS 'Average Purchase Amount'
from INVOICE i join LINE l ON i.INV_NUMBER=l.INV_NUMBER
               join CUSTOMER c on c.CUS_CODE=i.CUS_CODE
group by 1,2
order by 1;


#Create a query to produce the total purchase per invoice, generating the results shown in Figure P7.16, sorted by invoice number. 
#The invoice total is the sum of the product purchases in the LINE that corresponds to the INVOICE.
select INV_NUMBER, ROUND(sum(LINE_UNITS*LINE_PRICE),2) AS 'Invoice Total'
from LINE 
group by 1
order by 1;


#Use a query to show the invoices and invoice totals in Figure P7.17. Sort the results by customer code and then by invoice number.
select i.CUS_CODE, l.INV_NUMBER, ROUND(sum(l.LINE_UNITS*l.LINE_PRICE),2) AS 'Invoice Total'
from LINE l join INVOICE i on l.INV_NUMBER=i.INV_NUMBER 
group by 1,2
order by 1,2;

#Write a query to produce the number of invoices and the total purchase amounts by customer, using the output shown in Figure P7.18 as your guide. 
#Note the results are sorted by customer code. (Compare this summary to the results shown in Problem 17.)
select i.CUS_CODE, count(distinct l.INV_NUMBER)AS 'Number of Invoices', ROUND(sum(l.LINE_UNITS*l.LINE_PRICE),2) AS 'Total Customer Purchases'
from LINE l join INVOICE i on l.INV_NUMBER=i.INV_NUMBER 
group by 1
order by 1;

#Write a query to generate the total number of invoices, the invoice total for all of the invoices, the smallest of the customer purchase amounts, the largest of the customer purchase amounts,
#and the average of all the customer purchase amounts. Your output must match Figure P7.19.
select sum(Number_Invoices) AS 'Total Invoices',ROUND(sum(Total_Purchases),2) AS 'Total Sales',min(Total_Purchases) AS 'Minimum Customer Purchases',max(Total_Purchases) AS 'Largest Customer Purchases',ROUND(avg(Total_Purchases),2) AS 'Average Customer Purchases'
from(select i.CUS_CODE AS CUS_CODE, count(distinct l.INV_NUMBER)AS Number_Invoices, ROUND(sum(l.LINE_UNITS*l.LINE_PRICE),2) AS Total_Purchases
from LINE l join INVOICE i on l.INV_NUMBER=i.INV_NUMBER 
group by 1)a;


#List the balances of customers who have made purchases during the current invoice cycle—that is, for the customers who appear in the INVOICE table. Sort the results by customer code, as shown in Figure P7.20.
select distinct i.CUS_CODE, c.CUS_BALANCE
from CUSTOMER c inner join INVOICE i on c.CUS_CODE=i.CUS_CODE
order by 1;


#Provide a summary of customer balance characteristics for customers who made purchases. Include the minimum balance, maximum balance, and average balance, as shown in Figure P7.21.
select min(CUS_BALANCE) AS 'Minimum Balance', MAX(CUS_BALANCE) AS 'Maximum Balance', ROUND(avg(CUS_BALANCE),2) AS 'Average Balance'
from CUSTOMER c inner join INVOICE i on c.CUS_CODE=i.CUS_CODE;


#Create a query to find the balance characteristics for all customers, including the total of the outstanding balances. The results of this query are shown in Figure P7.22.
select sum(CUS_BALANCE) AS 'Total Balance',min(CUS_BALANCE) AS 'Minimum Balance',max(CUS_BALANCE) AS 'Maximum Balance',ROUND(avg(CUS_BALANCE),2) AS 'Average Balance'
from CUSTOMER;


#Find the listing of customers who did not make purchases during the invoicing period. Sort the results by customer code. Your output must match the output shown in Figure P7.23.
select CUS_CODE,CUS_BALANCE
from CUSTOMER 
where CUS_CODE NOT IN (select CUS_CODE
from INVOICE)
order by 1;

#Find the customer balance summary for all customers who have not made purchases during the current invoicing period. The results are shown in Figure P7.24.
select sum(CUS_BALANCE) AS 'Total Balance',min(CUS_BALANCE) AS 'Minimum Balance',max(CUS_BALANCE) AS 'Maximum Balance',ROUND(avg(CUS_BALANCE),2) AS 'Average Balance'
from CUSTOMER
where CUS_CODE NOT IN (select CUS_CODE
from INVOICE);

#Create a query that summarizes the value of products currently in inventory. 
#Note that the value of each product is a result of multiplying the units currently in inventory by the unit price. 
#Sort the results in descending order by subtotal, as shown in Figure P7.25.
select P_DESCRIPT, P_QOH,P_PRICE,(P_QOH* P_PRICE) AS 'Subtotal'
from PRODUCT
order by 4 desc;

#Find the total value of the product inventory. The results are shown in Figure P7.26.
select sum(P_QOH* P_PRICE) AS 'Total Value of Inventory'
from PRODUCT;



