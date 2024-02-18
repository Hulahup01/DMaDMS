DROP TABLE IF EXISTS STUDENTS_AUDIT;

CREATE TABLE STUDENTS_AUDIT (
    AUDIT_ID NUMBER PRIMARY KEY,
    ACTION_TYPE VARCHAR2(10),
    OLD_STUDENT_ID NUMBER,
    NEW_STUDENT_ID NUMBER,
    OLD_NAME VARCHAR2(100),
    NEW_NAME VARCHAR2(100),
    OLD_GROUP_ID NUMBER,
    NEW_GROUP_ID NUMBER,
    ACTION_DATE TIMESTAMP
);


DROP SEQUENCE IF EXISTS students_audit_id_seq;

CREATE SEQUENCE students_audit_id_seq START WITH 1 INCREMENT BY 1;


CREATE OR REPLACE TRIGGER trg_students_audit
AFTER INSERT OR UPDATE OR DELETE ON STUDENTS
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
    ELSIF DELETING THEN
        v_action := 'DELETE';
    END IF;

    INSERT INTO STUDENTS_AUDIT (
        audit_id,
        action_type,
        old_student_id,
        new_student_id,
        old_name,
        new_name,
        old_group_id, 
        new_group_id,
        action_date
        )
    VALUES (
        STUDENTS_AUDIT_ID_SEQ.NEXTVAL,
        v_action,
        :OLD.ID,
        :NEW.ID,
        :OLD.NAME,
        :NEW.NAME,
        :OLD.GROUP_ID,
        :NEW.GROUP_ID,
        SYSTIMESTAMP
        );
END;
