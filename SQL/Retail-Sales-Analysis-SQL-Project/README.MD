# Retail Sales Analysis using SQL

## Project Overview

This project demonstrates how SQL can be used to perform data cleaning, exploratory data analysis (EDA), and business intelligence reporting on a retail sales dataset.

The goal is to analyze customer purchasing behavior, sales trends, category performance, and transaction patterns using MySQL.

The project covers:

* Database creation and setup
* Data exploration
* NULL value detection
* Aggregate functions
* Grouping and filtering
* Date and time analysis
* Window functions
* Common Table Expressions (CTEs)
* Business-oriented SQL queries

---

# Database Setup

## Display Available Databases

```sql
SHOW DATABASES;
```

### Explanation

Displays all databases available in the MySQL server.

Example Output:

| Database           |
| ------------------ |
| mysql              |
| information_schema |
| sql_project        |

---

## Select Database

```sql
USE sql_project;
```

### Explanation

Sets `sql_project` as the active database for all subsequent SQL operations.

---

# Table Creation

```sql
CREATE TABLE sales
(
    transactions_id INT,
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
```

## Column Description

| Column          | Description                   |
| --------------- | ----------------------------- |
| transactions_id | Unique transaction identifier |
| sale_date       | Date of purchase              |
| sale_time       | Time of purchase              |
| customer_id     | Customer identifier           |
| gender          | Gender of customer            |
| age             | Customer age                  |
| category        | Product category              |
| quantiy         | Number of units purchased     |
| price_per_unit  | Price per unit                |
| cogs            | Cost of goods sold            |
| total_sale      | Total transaction amount      |

---

# Data Exploration

## View Sample Records

```sql
SELECT * FROM sales LIMIT 10;
```

### Explanation

Displays the first 10 records from the table to understand the dataset structure.

---

## Count Total Records

```sql
SELECT COUNT(*) FROM sales;
```

### Explanation

Returns the total number of rows present in the sales table.

---

# Data Cleaning

## Check for NULL Transaction IDs

```sql
SELECT *
FROM sales
WHERE transactions_id IS NULL;
```

### Explanation

Identifies records where transaction IDs are missing.

---

## Check for Missing Unit Prices

```sql
SELECT *
FROM sales
WHERE price_per_unit IS NULL;
```

### Explanation

Detects rows containing missing product prices.

---

## Find Records with Any NULL Value

```sql
SELECT *
FROM sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```

### Explanation

Returns all rows containing at least one missing value.

This step is essential before performing any analysis.

---

# Basic Statistics

## Total Number of Transactions

```sql
SELECT COUNT(*)
FROM sales;
```

### Explanation

Calculates total transactions recorded in the dataset.

---

## Total Unique Customers

```sql
SELECT COUNT(DISTINCT customer_id) AS customers
FROM sales;
```

### Explanation

Finds the number of unique customers who made purchases.

---

# Business Analysis

## Sales on a Specific Date

```sql
SELECT *
FROM sales
WHERE sale_date = '2022-11-05';
```

### Business Question

What transactions occurred on November 5, 2022?

### Insight

Useful for investigating sales activity on a particular day.

---

## Clothing Sales Analysis

```sql
SELECT category,
       SUM(quantiy)
FROM sales
WHERE category = 'Clothing'
AND quantiy > 3
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
```

### Business Question

How many clothing items were sold in November 2022 where the quantity purchased exceeded 3?

### Concepts Used

* Filtering
* Aggregation
* Date formatting

---

## Total Sales by Category

```sql
SELECT category,
       SUM(total_sale)
FROM sales
GROUP BY category;
```

### Business Question

Which product categories generated the highest revenue?

### Concepts Used

* SUM()
* GROUP BY

---

## Average Age of Beauty Customers

```sql
SELECT category,
       ROUND(AVG(age),2)
FROM sales
GROUP BY category
HAVING category = 'Beauty';
```

### Business Question

What is the average age of customers purchasing Beauty products?

### Concepts Used

* AVG()
* HAVING
* GROUP BY

---

## High-Value Transactions

```sql
SELECT *
FROM sales
WHERE total_sale > 1000;
```

### Business Question

Which transactions generated revenue greater than ₹1000?

### Use Case

Identify premium customers and expensive purchases.

---

## Transactions by Gender and Category

```sql
SELECT category,
       gender,
       COUNT(*)
FROM sales
GROUP BY category, gender;
```

### Business Question

How many purchases were made by each gender across product categories?

### Concepts Used

* Multi-column GROUP BY
* COUNT()

---

# Monthly Sales Ranking

## Average Monthly Sales and Best Month per Year

```sql
WITH monthly_sales AS
(
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM sales
    GROUP BY YEAR(sale_date),
             MONTH(sale_date)
)

SELECT *,
       RANK() OVER
       (
           PARTITION BY year
           ORDER BY avg_sale DESC
       ) AS sales_rank
FROM monthly_sales;
```

### Business Question

Which month performed best within each year?

### Concepts Used

* CTE
* Window Functions
* RANK()
* PARTITION BY

### Example

| Year | Month | Avg Sale | Rank |
| ---- | ----- | -------- | ---- |
| 2022 | 11    | 850      | 1    |
| 2022 | 8     | 760      | 2    |

Rank 1 indicates the best-performing month.

---

# Top Customers

## Top 5 Customers by Revenue

```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### Business Question

Who are the top revenue-generating customers?

### Concepts Used

* SUM()
* ORDER BY
* LIMIT

---

# Sales Shift Analysis

## Classifying Orders by Shift

```sql
WITH hourly_sale AS
(
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12
                    THEN 'Morning'

               WHEN EXTRACT(HOUR FROM sale_time)
                    BETWEEN 12 AND 17
                    THEN 'Afternoon'

               ELSE 'Evening'
           END AS shift
    FROM sales
)

SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

### Business Question

During which shift are the most orders placed?

### Shift Definition

| Shift     | Time Range   |
| --------- | ------------ |
| Morning   | Before 12 PM |
| Afternoon | 12 PM – 5 PM |
| Evening   | After 5 PM   |

### Concepts Used

* CTE
* CASE Statement
* Time Extraction
* Aggregation

---

# SQL Concepts Demonstrated

This project covers:

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* LIMIT
* Aggregate Functions

  * COUNT()
  * SUM()
  * AVG()
* Date Functions

  * YEAR()
  * MONTH()
  * DATE_FORMAT()
* Window Functions

  * RANK()
* Common Table Expressions (CTEs)
* CASE Statements
* NULL Handling
* DISTINCT

---

# Key Insights Generated

1. Revenue generated by each category.
2. Best-performing months each year.
3. Top spending customers.
4. Customer demographics by category.
5. High-value transactions.
6. Sales distribution across different shifts.
7. Clothing sales performance in November 2022.
8. Customer engagement and transaction patterns.

---

# Technologies Used

* MySQL 8.0
* SQL
* Relational Databases
* Window Functions
* Common Table Expressions (CTEs)

---

# Learning Outcomes

By completing this project, I gained hands-on experience with:

* SQL querying and optimization
* Data cleaning techniques
* Business-oriented analytics
* Window functions and ranking
* Customer and sales analysis
* Real-world retail data exploration

This project serves as a foundational SQL analytics portfolio project demonstrating practical database querying and business intelligence skills.

