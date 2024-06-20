/* A subquery, also known as an inner query or nested query, is a query nested inside another query such as SELECT, INSERT, UPDATE, or DELETE. 
Subqueries can be used to perform operations that are difficult or impossible to perform with a single query, enabling complex queries by breaking them into simpler, manageable parts.

Types of Subqueries
Single-row subqueries: Return a single row and are often used with comparison operators like =, <, >, etc.
Multi-row subqueries: Return multiple rows and are often used with IN, ANY, ALL, etc.
Scalar subqueries: Return a single value and can be used in expressions.
Correlated subqueries: Refer to columns in the outer query and are executed once for each row processed by the outer query.

Examples in the Context of the Ola Database
*/

-- Single-row subquery: Find the driver who completed the most expensive ride.

SELECT dname 
FROM drivers 
WHERE did = (
    SELECT did 
    FROM rides 
    ORDER BY fare DESC 
    LIMIT 1
);

-- Multi-row subquery: Find all customers who have taken a ride with driver 'Amit'.

SELECT cname 
FROM customers 
WHERE cid IN (
    SELECT cid 
    FROM rides 
    WHERE did = (
        SELECT did 
        FROM drivers 
        WHERE dname = 'Amit'
    )
);

-- Scalar subquery: Find the average fare of rides and list the rides that are above this average.

SELECT * 
FROM rides 
WHERE fare > (
    SELECT AVG(fare) 
    FROM rides
);

-- Correlated subquery: Find all drivers who have given rides to customers living in 'Mumbai'.

SELECT DISTINCT dname 
FROM drivers d 
WHERE EXISTS (
    SELECT 1 
    FROM rides r 
    JOIN customers c ON r.cid = c.cid 
    WHERE d.did = r.did AND c.addr = 'Mumbai'
);

-- Practical Use in Ola Database
-- Finding the name of customers who have taken rides costing more than 200:

SELECT cname 
FROM customers 
WHERE cid IN (
    SELECT cid 
    FROM rides 
    WHERE fare > 200
);

-- Identifying rides with incomplete payment status:

SELECT ride_id 
FROM rides 
WHERE ride_id IN (
    SELECT ride_id 
    FROM payment 
    WHERE status <> 'completed'
);

-- Listing employees in the 'Sales' department who do not have a manager:

SELECT ename 
FROM employee 
WHERE department = 'Sales' 
AND manager_id IS NULL;

-- Getting the names of drivers who have not given any rides yet:

SELECT dname 
FROM drivers 
WHERE did NOT IN (
    SELECT did 
    FROM rides
);