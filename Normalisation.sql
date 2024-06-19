 /* Normalization: 
 Normalization is a process used in databases to organize data to reduce redundancy and improve data integrity. 
 The goal is to decompose a database into smaller, more manageable pieces while maintaining relationships between data.

--Types of normalization:
--1)First normal form:
--> Multi valued attr should not be present
--> Primary key is present in the table
--> Repeating groups
--> Duplicate rows should not be there
-- Un-normalized Table:
/*
CustomerID   	Name	          Orders
1	          Emily Watson	         101, 102, 103
2	         Jane Smith	         04, 105

--1NF:
CustomerID	      Name	    OrderID
1	          Emily Watson	     101
1	          Emily Watson	     102
1	          Emily Watson	     103
2	          Jane Smith	     104
2	          Jane Smith	     105
*/
/* 2)Second Normal Form(2NF):

-> Should be in 1NF
-> No partial dependency - 
All non key attr should be completely dependent
on primary key
1NF Table:
OrderID    	CustomerID	CustomerName
101	          1	          Emily Watson
102		      1           Emily Watson
103		      1           Emily Watson
104		      2           Jane Smith
105		      2           Jane Smith

2NF:
Orders Table:
OrderID	     CustomerID
101	           1
102            1
103	           1
104	           2
105	           2
Customers Table:
CustomerID	         CustomerName
1	                  Emily Watson
2	                  Jane Smith
*/
/* 3)Third Normal Form: Meet all the requirements of 2NF and all the attributes are functionally dependent only on the primary key.
2NF Orders Table:
OrderID   	CustomerID	     OrderDate	    SalesRep
101	          1	             2023-01-10	     Rep1
102	          1	             2023-01-15	     Rep1
103	          1	             2023-01-20	     Rep1
104	          2	             2023-02-10    	 Rep2
105	          2	             2023-02-15	     Rep2

3NF (Decomposed into three tables):
Orders Table:
OrderID	    CustomerID	   OrderDate
101	            1	        2023-01-10
102	            1	        2023-01-15
103	            1	        2023-01-20
104	            2	        2023-02-10
105	            2	        2023-02-15
Customers Table:
CustomerID	       CustomerName
1	                 Emily Watson
2	                 Jane Smith
SalesReps Table:
SalesRep	     CustomerID
Rep1                1
Rep2	            2
*/
/* 4)Boyce-Code Normal Form (BCNF):

-->It is in 3NF.
-->Every non-trivial functional dependency X -> Y, X is a superkey.
--5)Fourth Normal Form (4NF):
-->It is in BCNF.
-->It has no multi-valued dependencies.
--6)Fifth Normal Form (5NF):
-->It is in 4NF.
-->It has no join dependency that is not implied by the candidate keys.
*/
