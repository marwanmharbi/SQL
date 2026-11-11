create database project;
use project;
show tables;
SELECT * FROM online_retail_ii;
-- 1. Calculate total revenue --
SELECT round(sum(Quantity*price),0) as Total_Rev From online_retail_ii;

--  2. Find the top 10 products by revenue. -- 
SELECT Description, round(Quantity*price,0) as Rev from online_retail_ii
order by Rev desc
limit 10;

--  Identify the top 5 countries by sales-- 
SELECT Country, round(sum(Quantity*price),0)as Rev from online_retail_ii
group by country
order by Rev desc
limit 5;

ALTER TABLE online_retail_ii RENAME COLUMN `Customer ID` TO CustomerID;



--  4. Find customers who made more than one purchase -- 
select customerID , count(Invoice) from online_retail_ii
group by customerID having count(Invoice)>1;

ALTER TABLE online_retail_ii RENAME COLUMN `ï»¿Invoice` TO Invoice;

-- 5. Calculate each customer's total spending --

Select customerID, SUM(Quantity*price) as Spending From online_retail_ii
Group by customerID;

-- 6. Find customers who have not purchased again within 30 days of their first purchase.

-- select customerid, min(invoicedate) as first_purchase from online_retail_ii group by customerid;
Select t1.customerID from (
SELECT customerID, MIN(InvoiceDate) AS first_purchase
    FROM online_retail_ii
    WHERE customerID IS NOT NULL
    GROUP BY customerID
) t1
LEFT JOIN  t2 
    ON t1.customerID = t2.customerID
    -- Step 2: Check for subsequent transactions inside their personal 30-day window
    AND t2.InvoiceDate > t1.first_purchase
    AND t2.InvoiceDate <= DATE_ADD(t1.first_purchase, INTERVAL 30 DAY)
-- Step 3: Keep only the customers where no secondary transactions were found
WHERE t2.customerID IS NULL;


-- Write Querry to check ttal rev. by Month and assign a rak to each quarter based on their value.
SELECT monthname(invoicedate) as Invoice_Month, SUM(Quantity*price) as Total_Rev,  dense_rank() over(order by SUM(Quantity*price) desc) as Qtr_Rank
From online_retail_ii group by Invoice_Month;

describe online_retail_ii;
-- Change date from text to Date 

UPDATE online_retail_ii 
SET invoicedate = STR_TO_DATE(invoicedate, '%c/%e/%Y %H:%i');

alter table online_retail_ii modify column invoicedate datetime;