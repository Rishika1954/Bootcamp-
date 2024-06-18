/* SQL (Structured Query Language) provides a rich set of built-in functions 
They are used to perform various operations on data stored in a database. 
These functions are categorized into different types: 

1. Aggregate Functions
2. String Functions
3. Numeric Functions
4. Date and Time Functions
5. Conversion Functions
6. Conditional Functions
*/

# Aggregate Functions
/* Aggregate functions perform calculations on multiple rows of a table's column and return a single value. 
These are often used with GROUP BY to group results by one or more columns.

COUNT(): Returns the number of rows that match a specified criterion. Example: SELECT COUNT(*) FROM employees;
SUM(): Returns the total sum of a numeric column. Example: SELECT SUM(salary) FROM employees;
AVG(): Returns the average value of a numeric column. Example: SELECT AVG(salary) FROM employees;
MAX(): Returns the maximum value in a set. Example: SELECT MAX(salary) FROM employees;
MIN(): Returns the minimum value in a set. Example: SELECT MIN(salary) FROM employees; */

# String Functions
/* String functions perform operations on string values and return a string or numeric value.

UPPER(): Converts a string to uppercase. Example: SELECT UPPER(first_name) FROM employees;
LOWER(): Converts a string to lowercase. Example: SELECT LOWER(first_name) FROM employees;
LENGTH(): Returns the length of a string. Example: SELECT LENGTH(first_name) FROM employees;
SUBSTRING(): Extracts a substring from a string. Example: SELECT SUBSTRING(first_name, 1, 3) FROM employees;
TRIM(): Removes leading and trailing spaces from a string. Example: SELECT TRIM(first_name) FROM employees;
REPLACE(): Replaces all occurrences of a substring within a string with another substring. Example: SELECT REPLACE(first_name, 'a', 'o') FROM employees;
*/

# Numeric Functions
/* Numeric functions perform operations on numeric values and return a numeric value.

ROUND(): Rounds a number to a specified number of decimal places. Example: SELECT ROUND(salary, 2) FROM employees;
CEIL(): Returns the smallest integer greater than or equal to a number. Example: SELECT CEIL(salary) FROM employees;
FLOOR(): Returns the largest integer less than or equal to a number. Example: SELECT FLOOR(salary) FROM employees;
ABS(): Returns the absolute value of a number. Example: SELECT ABS(-5) AS absolute_value;
POWER(): Returns the value of a number raised to the power of another number. Example: SELECT POWER(2, 3) AS result;
*/

# Date and Time Functions
/* Date and time functions perform operations on date and time values and return date, time, or numeric values.

NOW(): Returns the current date and time. Example: SELECT NOW();
CURDATE(): Returns the current date. Example: SELECT CURDATE();
CURTIME(): Returns the current time. Example: SELECT CURTIME();
DATE_ADD(): Adds a time/date interval to a date and then returns the date. Example: SELECT DATE_ADD(CURDATE(), INTERVAL 7 DAY);
DATEDIFF(): Returns the number of days between two dates. Example: SELECT DATEDIFF('2024-12-31', '2024-01-01') AS days_difference;
DATE_FORMAT(): Formats a date according to a specified format. Example: SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS formatted_date;
*/

# QUESTIONS TO PRACTICE
/* Aggregate Functions :

1) What is an aggregate function in SQL?
2) Explain the difference between COUNT(*) and COUNT(column_name).
3) What SQL statement would you use to find the total sales from a column named sale_amount in a table called sales?
4) Imagine you have a table orders with columns order_id, customer_id, and order_amount. Write a query to find the total amount spent by each customer.

/* String Functions :

1) How can you split a string into multiple parts based on a delimiter in SQL?
2) Explain the usage of the REGEXP_REPLACE function in SQL.
3) Describe how you would handle case-sensitive comparisons of strings in SQL queries.
4) Explain the difference between LIKE and SUBSTRING functions in SQL.

/* Numeric Functions :

1) What does the CEILING function do?
2) Explain the purpose of the ABS function.
3) What does the RAND() function do?
4) Explain the use of the SIGN function.

/* Date and Time Functions :

1) How can you retrieve the current date ?
2) How do you calculate the difference in days between two dates ?
3) How can you extract the day of the week from a date?
4)  How do you round a datetime value to the nearest hour?

# ANSWERS
/*
Aggregate Functions:
1) An aggregate function in SQL performs a calculation on a set of values and returns a single value. 
Examples include SUM, AVG, COUNT, MIN, and MAX.
2) COUNT(*) counts all rows in a table, regardless of NULL values.
COUNT(column_name) counts the number of non-NULL values in the specified column.
3) SELECT SUM(sale_amount) FROM sales;
4) SELECT customer_id, SUM(order_amount) AS total_spent
FROM orders
GROUP BY customer_id;

String Functions:
1) SELECT value
FROM STRING_SPLIT('apple,orange,banana', ',');
2) REGEXP_REPLACE is used in databases that support regular expressions, like Oracle or PostgreSQL.
 It replaces substrings that match a regular expression pattern with a specified replacement string.
 For example, in PostgreSQL:
    SELECT REGEXP_REPLACE('Hello 123 World', '\d+', 'NUM');
3) SELECT *
FROM myTable
WHERE column_name COLLATE Latin1_General_CS_AS = 'CaseSensitiveValue';
4) LIKE is used to search for a specified pattern in a string using wildcards (% for zero or more characters, _ for a single character).
SUBSTRING extracts a substring from a string based on starting position and length.

Numeric Functions:
1) The CEILING function returns the smallest integer greater than or equal to a specified numeric expression.
2) The ABS function returns the absolute (positive) value of a numeric expression. For example:
          SELECT ABS(-10);
3) The RAND() function generates a random float value between 0 and 1.
4) The SIGN function returns the sign of a numeric expression (-1 if negative, 0 if zero, 1 if positive). For example:
        SELECT SIGN(-15), SIGN(0), SIGN(20);

Date and Time Functions :
1)use GETDATE() or CURRENT_TIMESTAMP. In MySQL, use CURDATE() or CURRENT_DATE(). In PostgreSQL, use CURRENT_DATE.
2)  In SQL Server: DATEDIFF(DAY, start_date, end_date). In MySQL and PostgreSQL: (end_date - start_date).
3) In SQL Server: DATEPART(WEEKDAY, your_date) (where 1 = Sunday, 2 = Monday, etc.). In MySQL and PostgreSQL: DAYOFWEEK(your_date) (where 1 = Sunday, 2 = Monday, etc.).
4) SELECT DATEADD(HOUR, DATEDIFF(HOUR, 0, your_datetime_column) + CASE WHEN DATEPART(MINUTE, your_datetime_column) >= 30 THEN 1 ELSE 0 END, 0).
*/

