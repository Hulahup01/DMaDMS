CREATE OR REPLACE FUNCTION generateInsertStatement(p_id IN NUMBER, p_val_string IN VARCHAR2) RETURN VARCHAR2 IS
    v_insert_statement VARCHAR2(4000);
    v_val VARCHAR2(4000);
BEGIN
    BEGIN
        v_val := TO_NUMBER(p_val_string);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error: Value is not a valid number.';
    END;

    v_insert_statement := 'INSERT INTO MyTable (id, val) VALUES (' || p_id || ', ' || v_val || ');';

    RETURN v_insert_statement;
END;


DECLARE
    insert_statement VARCHAR2(4000);
BEGIN
    insert_statement := generateInsertStatement(123, '42'); 
    DBMS_OUTPUT.PUT_LINE(insert_statement);
END;