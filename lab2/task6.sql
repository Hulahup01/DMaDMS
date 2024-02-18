CREATE OR REPLACE TRIGGER trg_student_change_group
AFTER INSERT OR DELETE OR UPDATE ON STUDENTS
FOR EACH ROW
DECLARE
    v_old_group_id NUMBER;
    v_new_group_id NUMBER;
BEGIN
    IF UPDATING OR DELETING THEN
        v_old_group_id := :OLD.GROUP_ID;
    END IF;
   
    IF INSERTING OR UPDATING THEN
        v_new_group_id := :NEW.GROUP_ID;
    END IF;

    IF UPDATING OR DELETING THEN
        UPDATE GROUPS
        SET C_VAL = (SELECT C_VAL FROM GROUPS WHERE id = v_old_group_id) - 1
        WHERE ID = v_old_group_id;
    END IF;

    IF INSERTING OR UPDATING THEN
        UPDATE GROUPS
        SET C_VAL = (SELECT C_VAL FROM GROUPS WHERE id = v_new_group_id) + 1
        WHERE ID = v_new_group_id;
    END IF;
END;