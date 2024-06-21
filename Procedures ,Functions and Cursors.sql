USE ola;
-- DELIMITER COMMAND:
/*
1. Purpose:
   - The DELIMITER command is used to change the standard delimiter (like a semicolon (;)), to a different character.
2. Usage:
   - When defining stored procedures, functions, or other multi-statement constructs that contain semicolons within their body.
   - This allows you to specify a different character as the delimiter to avoid prematurely terminating the entire statement.
3. Syntax:
   - The syntax for the DELIMITER command is as follows:
     DELIMITER new_delimiter;
4. Example:
   - Changing the delimiter to //:
     DELIMITER //
     CREATE PROCEDURE procedure_name()
     BEGIN
         SQL statements
     END //
     DELIMITER ;
5. Resetting the delimiter:
   - After defining the stored procedure or function, you should reset the delimiter back to the standard semicolon (;) using:
     DELIMITER ;
*/

-- CREATE PROCEDURE
/*
Procedures in SQL allow you to encapsulate a series of SQL statements into a reusable unit.
~ Syntax:
    DELIMITER //
        CREATE PROCEDURE procedure_name(parameter1 datatype, parameter2 datatype, ...)
        BEGIN
            Procedure logic goes here
        END //
    DELIMITER ;
*/

-- EXAMPLE:
-- Procedure to select all rides
DELIMITER //
CREATE PROCEDURE select_all_rides()
BEGIN
    SELECT * FROM rides;
END //
DELIMITER ;

-- EXECUTING PROCEDURES
/*
Once a procedure is created, you can execute it using the CALL statement followed by the procedure name and any required parameters.
~ Syntax:
-- CALL procedure_name(parameter1, parameter2, ...);
*/

-- EXAMPLE:
-- Calling the select_all_rides procedure
CALL select_all_rides();

-- DROPPING PROCEDURES
/*
If a procedure is no longer needed, it can be dropped using the DROP PROCEDURE statement.
~ Syntax:
    DROP PROCEDURE procedure_name;
*/

-- EXAMPLE:
-- Dropping select_all_rides
DROP PROCEDURE select_all_rides;


-- FUNCTION CREATION
/*
To create a function, you need to define its name, input parameters (if any), and the data type of the value it returns.
The function logic (the code that performs the task) goes inside the BEGIN and END blocks.
~ Syntax:
    CREATE FUNCTION function_name(parameter1 data_type, parameter2 data_type, ...)
    RETURNS return_data_type
    AS
    BEGIN
        -- Function logic here
    END;
*/

-- EXAMPLE:
-- Function to calculate total fare for a driver
DELIMITER $$
CREATE FUNCTION get_total_fare(did INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_fare INT;
    SELECT SUM(fare) INTO total_fare
    FROM rides
    WHERE did = did;
    RETURN total_fare;
END $$
DELIMITER ;

-- FUNCTION EXECUTION
/*
To execute (call) a function, you use the SELECT statement along with the function name and any required input parameters.
~ Syntax:
SELECT function_name(parameter1, parameter2, ...);
*/

-- EXAMPLE:
-- Calling the function
SELECT get_total_fare(1);

-- DROPPING FUNCTION
/*
If you no longer need a function, you can drop (delete) it using the DROP FUNCTION statement.
~ Syntax:
DROP FUNCTION [IF EXISTS] function_name;
*/

-- EXAMPLE:
-- Dropping the function
DROP FUNCTION IF EXISTS get_total_fare;

-- IN
/*
This IN is a part of procedures
IN parameters in MySQL stored procedures allow you to pass values into the procedure.
These values are read-only within the procedure and cannot be modified.
*/

-- EXAMPLE:
-- Creating a procedure with IN parameter
DELIMITER //
CREATE PROCEDURE get_ride_details(IN ride_id INT)
BEGIN
    SELECT * FROM rides WHERE ride_id = ride_id;
END //
DELIMITER ;

-- Calling Procedure
CALL get_ride_details(1001);

-- OUT
/*
This OUT is a part of procedures
OUT parameters in MySQL stored procedures allow you to return values from a procedure.
These values can be accessed by the calling program after the procedure execution.
*/

-- EXAMPLE:
-- Creating a procedure with OUT parameter to get the count of rides
DELIMITER //
CREATE PROCEDURE get_ride_count(OUT ride_count INT)
BEGIN
    SELECT COUNT(*) INTO ride_count FROM rides;
END //
DELIMITER ;

-- Calling the OUT Procedure
CALL get_ride_count(@ride_count);
SELECT @ride_count as ride_count;

-- CURSOR
/*
1. Purpose:
    - Cursors in SQL are used to retrieve and process rows one by one from the result set of a query.
2. Declaration:
    - Cursors are declared using the DECLARE CURSOR statement, specifying the SELECT query whose result set will be processed.
3. Opening:
    - A cursor must be opened using the OPEN statement before fetching rows.
    - Opening a cursor positions the cursor before the first row.
4. Fetching:
    - Rows from the result set are fetched one by one using the FETCH statement.
    - Each fetch operation advances the cursor to the next row in the result set.
5. Closing:
    - After processing all rows, the cursor should be closed using the CLOSE statement.
    - Closing a cursor releases the resources associated with the result set and frees memory.
*/

/There exists two types of cursors based on their creation by user or not: user-defined and pre-defined/

/* 
~ User-Defined Cursors:
    1. Purpose:
        - User-defined cursors are declared by the user to process rows retrieved from a query result set.
        - They are particularly useful when you need to perform custom operations on individual rows.
    2. Declaration:
        - User-defined cursors are declared within a stored procedure or function using the DECLARE CURSOR statement.
        - Syntax: DECLARE cursor_name CURSOR FOR SELECT_statement;
    3. Opening:
        - The cursor is opened using the OPEN cursor_name statement.
        - Syntax: OPEN cursor_name;
    4. Fetching:
        - Rows are fetched one at a time using the FETCH cursor_name INTO variable_list statement.
        - Syntax: FETCH cursor_name INTO variable1, variable2, ...;
    5. Closing:
        - The cursor is closed using the CLOSE cursor_name statement.
        - Syntax: CLOSE cursor_name;

~ Pre-Defined Cursors:
    1. Purpose:
        - Pre-defined cursors, also known as implicit cursors, are automatically created by the database system to handle the result sets of certain SQL operations.
        - These cursors are managed internally by the system and do not require explicit declaration or management by the user.
    2. Use Case:
        - Pre-defined cursors are used in SQL operations like SELECT INTO, INSERT, UPDATE, DELETE, and other DML statements.
        - The database system handles the opening, fetching, and closing of these cursors transparently.
    3. Automatic Handling:
        - The database system implicitly creates and manages pre-defined cursors without user intervention.
        - Users do not need to declare, open, fetch, or close these cursors explicitly.
    4. No User Declaration:
        - Pre-defined cursors are not declared by users and do not require explicit syntax.
        - Users interact with the result sets directly through the SQL statements.
*/

-- EXAMPLE:
-- Using cursor to get all ride details
DELIMITER //
CREATE PROCEDURE cursor_example()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE ride_id INT;
    DECLARE cid INT;
    DECLARE did INT;
    DECLARE fare INT;
    DECLARE ride_cursor CURSOR FOR SELECT ride_id, cid, did, fare FROM rides;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN ride_cursor;

    read_loop: LOOP
        FETCH ride_cursor INTO ride_id, cid, did, fare;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Here you can process each row
        SELECT ride_id, cid, did, fare;
    END LOOP;

    CLOSE ride_cursor;
END //
DELIMITER ;

-- Calling the Procedure with Cursor
CALL cursor_example();


-- LOOP
/*
1. Purpose:
    - Loops in MySQL stored procedures are used to repeatedly execute a block of SQL code until a specified condition is met.
2. Types of Loops:
    - LOOP ... END LOOP: A simple loop that repeatedly executes a block of code.
    - WHILE ... DO ... END WHILE: A loop that executes a block of code as long as a specified condition is true.
    - REPEAT ... UNTIL ... END REPEAT: A loop that executes a block of code until a specified condition becomes true.
3. Common Usage:
    - Looping through result sets, performing iterative calculations, and executing repetitive tasks in stored procedures.
*/

/*
~ Simple Loop:
    - Syntax: 
        LOOP
            -- SQL code
        END LOOP;
    - Example:
        DELIMITER $$
        CREATE PROCEDURE simple_loop_example()
        BEGIN
            DECLARE counter INT DEFAULT 0;
            simple_loop: LOOP
                SET counter = counter + 1;
                IF counter >= 10 THEN
                    LEAVE simple_loop;
                END IF;
            END LOOP;
            SELECT counter;
        END $$
        DELIMITER ;
*/

/*
~ WHILE Loop:
    - Syntax: 
        WHILE condition DO
            -- SQL code
        END WHILE;
    - Example:
        DELIMITER $$
        CREATE PROCEDURE while_loop_example()
        BEGIN
            DECLARE counter INT DEFAULT 0;
            WHILE counter < 10 DO
                SET counter = counter + 1;
            END WHILE;
            SELECT counter;
        END $$
        DELIMITER ;
*/

/*
~ REPEAT Loop:
    - Syntax: 
        REPEAT
            -- SQL code
        UNTIL condition END REPEAT;
    - Example:
        DELIMITER $$
        CREATE PROCEDURE repeat_loop_example()
        BEGIN
            DECLARE counter INT DEFAULT 0;
            REPEAT
                SET counter = counter + 1;
            UNTIL counter >= 10 END REPEAT;
            SELECT counter;
        END $$
        DELIMITER ;
*/

/* 
EXAMPLE:
Using a WHILE loop to get all ride details
DELIMITER //
CREATE PROCEDURE while_loop_example()
BEGIN
    DECLARE counter INT DEFAULT 0;
    DECLARE ride_count INT;
    DECLARE ride_id INT;
    DECLARE cid INT;
    DECLARE did INT;
    DECLARE fare INT;

    SELECT COUNT(*) INTO ride_count FROM rides;

    WHILE counter < ride_count DO
        SELECT ride_id, cid, did, fare INTO ride_id, cid, did, fare
        FROM rides
        LIMIT counter, 1;

        -- Here you can process each row
        SELECT ride_id, cid, did, fare;

        SET counter = counter + 1;
    END WHILE;
END //
DELIMITER ;

-- Calling the Procedure with WHILE loop
CALL while_loop_example();