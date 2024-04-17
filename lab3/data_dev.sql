DROP USER IF EXISTS dev CASCADE;

CREATE USER dev IDENTIFIED BY qwerty;
GRANT ALL PRIVILEGES TO system;
GRANT ALL PRIVILEGES TO hr;
GRANT ALL PRIVILEGES TO dev;

-- TABLES --

CREATE TABLE dev.dev_users (
    id NUMBER PRIMARY KEY,
    username VARCHAR2(50),
    email VARCHAR2(100)
);

CREATE TABLE dev.dev_orders (
    id NUMBER PRIMARY KEY,
    user_id NUMBER,
    amount NUMBER,
    status VARCHAR2(20),
    FOREIGN KEY (user_id) REFERENCES dev.dev_users(id)
);

CREATE TABLE dev.dev_products (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    price NUMBER
);

CREATE TABLE dev.common_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    description VARCHAR2(255)
);

CREATE TABLE dev.diff_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    status VARCHAR2(20)  
);

-- LOOPS -- 

-- CREATE TABLE dev.loop_table (
--     id NUMBER PRIMARY KEY,
--     name VARCHAR2(50),
--     parent_group_id NUMBER REFERENCES dev.loop_table(id)
-- );
-- DROP TABLE dev.loop_table;

-- PROCEDURES --

CREATE OR REPLACE PROCEDURE dev.create_table_dev AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE dev_table (id NUMBER, name VARCHAR2(100))';
END;

CREATE OR REPLACE PROCEDURE dev.create_proc_dev AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE dev_proc AS BEGIN NULL; END;';
END;

CREATE OR REPLACE PROCEDURE dev.create_index_dev AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX dev_index ON dev_table(id)';
END;

CREATE OR REPLACE PROCEDURE dev.common_proc AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('This is a common procedure.');
END;

CREATE OR REPLACE PROCEDURE dev.diff_proc(arg1 VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Procedure diff_proc from DEV is called with argument: ' || arg1);
END;

-- FUNCTIONS --

CREATE OR REPLACE FUNCTION dev.dev_function_1 RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is dev function 1.';
END;

CREATE OR REPLACE FUNCTION dev.dev_function_2 RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is dev function 2.';
END;

CREATE OR REPLACE FUNCTION dev.common_func RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is a common function.';
END;

CREATE OR REPLACE FUNCTION dev.diff_func(arg1 VARCHAR2) RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is DEV diff function with argument: ' || arg1;
END;


-- INDEXES --

CREATE NORMAL INDEX dev.idx_dev_products ON dev.dev_products(name);

CREATE NORMAL INDEX dev.idx_common_table ON dev.common_table(name);