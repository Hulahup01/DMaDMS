DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 10000 LOOP
        INSERT INTO MyTable (id, val)
        VALUES (v_counter, FLOOR(DBMS_RANDOM.VALUE(1, 10000)));
        v_counter := v_counter + 1;
    END LOOP;
    COMMIT;
END;


SELECT * FROM MyTable ORDER BY id;