show databases;
use sql_project;

CREATE TABLE sales
		(
			transactions_id	INT,
            sale_date DATE,
            sale_time TIME,
            customer_id INT,
            gender VARCHAR(15),
            age INT,
            category VARCHAR(15),
            quantiy INT,
            price_per_unit FLOAT,
            cogs FLOAT,
            total_sale FLOAT
		);

select * from sales LIMIT 10;

SELECT count(*) from sales;

-- NULL HANDLING IN MYSQL

select * from sales where transactions_id IS NULL;
select* from sales where price_per_unit IS NULL;

SELECT * FROM sales where 
			transactions_id IS NULL
            or
            sale_date IS NULL
            or
            sale_time IS NULL
            or 
            customer_id IS NULL
            or 
            gender IS NULL
            or 
            age IS NULL
            or 
            category IS NULL
            or 
            quantiy IS NULL
            or 
            price_per_unit IS NULL
            or
            cogs IS NULL
            or
            total_sale IS NULL;
            

SELECT COUNT(*) FROM sales;
SELECT COUNT( DISTINCT customer_id) AS CUSTOMERS FROM sales;


-- BUSINESS PROBLEM AND DATA ANALYSIS

-- SALE ON 2022-11-05

SELECT * FROM sales where sale_date= '2022-11-05';


-- Retrive where category is clothing and quantity sold>3 in month of nov -2022

Select  category, sum(quantiy) 
	from sales
    where category ='Clothing'
    AND
    quantiy>3
		AND 
        DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
        

-- write a sql query to calculate the total sales (total_sale) for each category;

select category , sum(total_sale) from sales group by category;

-- write a sql query  to find the avg age of customer who purchaced items from the 'Beauty' Category

select category ,round(avg(age),2) from sales group by category having category ='Beauty';

-- write a sql query to find all transactions where total sale is greater than 1000.

select * from sales where total_sale>1000;

-- total no of transactions made by each gender in each category

select category, gender, count(*) from sales group by category,gender;


-- Q7.>> Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT *,
       RANK() OVER(
           PARTITION BY year
           ORDER BY avg_sale DESC
       ) AS sales_rank
FROM monthly_sales;
    

-- write a sql query to find the top 5 customer based on the highest total sales

select customer_id, sum(total_sale) as total_sales  from sales group by customer_id order by total_sales desc limit 5;

-- write a sql query to create each shift and number of order (Example Morning <=12, Afternoon Between 12 &17, Evening>17

with hourly_sale
As
(
select * ,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'MORNING'
        WHEN extract(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
        End as shift
	From sales
)
select shift, COUNT(*) as total_orders from hourly_sale Group by shift;