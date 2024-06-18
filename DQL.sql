/* DQL Commands
GROUP BY, ORDER BY, HAVING BY */

/* Data Query Language (DQL) commands in SQL are primarily used to retrieve data from a database. 
The primary and most commonly used DQL command is the SELECT statement. */

/* SELECT 
The SELECT statement is used to query the database and retrieve data. The basic syntax is: */

/* SELECT column1, column2, ...
FROM table_name; */

-- SELECT CAUSES AND OPTIONS

/*GROUP BY
 Used to group rows that have the same values in specified columns.

 SELECT column1, COUNT(*)
FROM table_name
GROUP BY column1; */

-- HAVING BY
/* The HAVING clause in SQL is used in conjunction with the GROUP BY clause to filter groups
   based on a specified condition. It is applied to the summarized or aggregated rows after the 
   grouping has been done. The HAVING clause works similarly to the WHERE clause, but it operates
   on groups instead of individual rows. 
   
   SELECT column1, COUNT(*)
FROM table_name
GROUP BY column1
HAVING COUNT(*) > 1;
*/

-- ORDER BY
 /* Used to sort the result set.
 
 SELECT column1, column2
FROM table_name
ORDER BY column1 [ASC|DESC];
*/

-- --------------------------------------------------QUESTIONS----------------------------------------------------------------------------
/*
GROUP BY:
1. Find the total number of orders for each customer.
2. Calculate the total sales amount for each product.
3. Find the total sales and the average sales per customer for each region.
4. Find the average order amount for each customer who has placed more than 5 orders.

ORDER BY:
1. List all employees' names and their departments, sorted by department name in ascending order. If two employees are in the same department, they should be sorted by their hire date in ascending order.
2. Retrieve the product names and their sales amounts, sorted by sales amount in descending order. Only include products that have sales amounts greater than 1000.
3. Get the names and salaries of all employees, but only show those whose salaries are in the top 10% of all salaries, sorted by salary in descending order.

HAVING BY:
1. Identify the stores that have sold more than 100 distinct products with an average sale price greater than $50.
2. List the employees who have worked on at least three projects and have an average project completion time of less than 30 days.
3. Find the departments that have an average employee salary greater than the overall average salary of the company.
/*

/*--------------------------------------------------------------ANSWERS------------------------------------------------------------------------*/
/* GROUP BY: */

 SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;

  
SELECT product_id, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY product_id;


SELECT region, SUM(sales_amount) AS total_sales, AVG(sales_amount) AS average_sales_per_customer
FROM sales
GROUP BY region;


SELECT customer_id, AVG(order_amount) AS average_order_amount
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 5;

/* ORDER BY */

SELECT name, department, hire_date
FROM employees
ORDER BY department ASC, hire_date ASC;

SELECT product_name, sales_amount
FROM sales
WHERE sales_amount > 1000
ORDER BY sales_amount DESC;

SELECT name, salary
FROM employees
WHERE salary > (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salary) FROM employees)
ORDER BY salary DESC;

/* HAVING BY */

SELECT store_id
FROM sales
GROUP BY store_id
HAVING COUNT(DISTINCT product_id) > 100 AND AVG(sale_price) > 50;

SELECT employee_id
FROM project_assignments
GROUP BY employee_id
HAVING COUNT(DISTINCT project_id) >= 3 AND AVG(DATEDIFF(completion_date, start_date)) < 30;

SELECT department_id, AVG(salary) as avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);



