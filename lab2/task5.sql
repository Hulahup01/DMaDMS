CREATE OR REPLACE PROCEDURE restore_students_data(
    p_action_date TIMESTAMP,
    p_offset INTERVAL DAY TO SECOND := NULL
)
IS
    v_target_date TIMESTAMP;
BEGIN

    IF p_offset IS NOT NULL THEN
        v_target_date := SYSTIMESTAMP - p_offset;
    ELSE
        v_target_date := p_action_date;
    END IF;
   
    FOR rec IN (
        SELECT *
        FROM STUDENTS_AUDIT
        WHERE ACTION_DATE >= v_target_date
        ORDER BY ACTION_DATE DESC, AUDIT_ID DESC
    )
    LOOP
        IF rec.ACTION_TYPE = 'DELETE' THEN
            INSERT INTO STUDENTS (id, name, group_id)
            VALUES (rec.OLD_STUDENT_ID, rec.OLD_NAME, rec.OLD_GROUP_ID);
        ELSIF rec.ACTION_TYPE = 'INSERT' THEN
            DELETE FROM STUDENTS WHERE ID = rec.NEW_STUDENT_ID;
        ELSIF rec.ACTION_TYPE = 'UPDATE' THEN
            UPDATE STUDENTS
            SET NAME = rec.OLD_NAME,
                GROUP_ID = rec.OLD_GROUP_ID
            WHERE ID = rec.OLD_STUDENT_ID;
        END IF;
    END LOOP;
END;


DECLARE
    v_action_date TIMESTAMP := TO_TIMESTAMP('2024-02-18 15:25:00', 'YYYY-MM-DD HH24:MI:SS');
    v_offset INTERVAL DAY TO SECOND := INTERVAL '2' MINUTE;
BEGIN
    restore_students_data(v_action_date, v_offset);
END;
