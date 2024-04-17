DROP USER IF EXISTS prod CASCADE;

CREATE USER prod IDENTIFIED BY qwerty;
GRANT ALL PRIVILEGES TO system;
GRANT ALL PRIVILEGES TO hr;
GRANT ALL PRIVILEGES TO dev;

-- TABLES --

CREATE TABLE prod.prod_users (
    id NUMBER PRIMARY KEY,
    username VARCHAR2(50),
    email VARCHAR2(100)
);

CREATE TABLE prod.prod_orders (
    id NUMBER PRIMARY KEY,
    user_id NUMBER,
    amount NUMBER,
    status VARCHAR2(20),
    FOREIGN KEY (user_id) REFERENCES prod.prod_users(id)
);

CREATE TABLE prod.prod_products (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    price NUMBER
);

CREATE TABLE prod.common_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    description VARCHAR2(255)
);

CREATE TABLE prod.diff_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
);
 
-- PROCEDURES --

CREATE OR REPLACE PROCEDURE prod.create_table_prod AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE prod_table (id NUMBER, name VARCHAR2(100))';
END;

CREATE OR REPLACE PROCEDURE prod.create_proc_prod AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE prod_proc AS BEGIN NULL; END;';
END;

CREATE OR REPLACE PROCEDURE prod.create_index_prod AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX prod_index ON prod_table(id)';
END;

CREATE OR REPLACE PROCEDURE prod.common_proc AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('This is a common procedure.');
END;

CREATE OR REPLACE PROCEDURE prod.diff_proc(arg1 NUMBER) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Procedure do_something_prod is called with argument: ' || TO_CHAR(arg1));
END;

-- FUNCTIONS --

CREATE OR REPLACE FUNCTION prod.prod_function_1 RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is prod function 1.';
END;

CREATE OR REPLACE FUNCTION prod.prod_function_2 RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is prod function 2.';
END;

CREATE OR REPLACE FUNCTION prod.common_func RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is a common function.';
END;

CREATE OR REPLACE FUNCTION prod.diff_func(arg1 NUMBER) RETURN VARCHAR2 AS
BEGIN
    RETURN 'This is prod diff function with argument: ' || TO_CHAR(arg1);
END;


-- INDEXES --

CREATE NORMAL INDEX prod.idx_prod_products ON prod.prod_products(name);

CREATE NORMAL INDEX prod.idx_common_table ON prod.common_table(name);

