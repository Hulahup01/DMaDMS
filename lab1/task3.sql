CREATE OR REPLACE FUNCTION checkEvenOddCount RETURN VARCHAR2 IS
    v_even_count NUMBER := 0;
    v_odd_count NUMBER := 0;
BEGIN
   
    SELECT COUNT(CASE WHEN MOD(val, 2) = 0 THEN 1 END),
           COUNT(CASE WHEN MOD(val, 2) <> 0 THEN 1 END)
    INTO v_even_count, v_odd_count
    FROM MyTable;

    IF v_even_count > v_odd_count THEN
        RETURN 'TRUE';
    ELSIF v_even_count < v_odd_count THEN
        RETURN 'FALSE';
    ELSE
        RETURN 'EQUAL';
    END IF;
END;


DECLARE
    result VARCHAR2(10);
BEGIN
    result := checkEvenOddCount;
    DBMS_OUTPUT.PUT_LINE('Result: ' || result);
END;
