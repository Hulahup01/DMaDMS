CREATE OR REPLACE PROCEDURE insertRecord(p_id IN NUMBER, p_val IN NUMBER) IS
BEGIN
    INSERT INTO MyTable (id, val) VALUES (p_id, p_val);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Record inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting record: ' || SQLERRM);
END insertRecord;


CREATE OR REPLACE PROCEDURE updateRecord(p_id IN NUMBER, p_new_val IN NUMBER) IS
BEGIN
    UPDATE MyTable SET val = p_new_val WHERE id = p_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Record updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error updating record: ' || SQLERRM);
END updateRecord;


CREATE OR REPLACE PROCEDURE deleteRecord(p_id IN NUMBER) IS
BEGIN
    DELETE FROM MyTable WHERE id = p_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Record deleted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error deleting record: ' || SQLERRM);
END deleteRecord;


BEGIN
    updateRecord(1, 200);
END;


BEGIN
    deleteRecord(1);
END;


BEGIN
    insertRecord(1, 199);
END;


SELECT * FROM MYTABLE ORDER BY id;