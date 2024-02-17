CREATE OR REPLACE TRIGGER trg_cascade_delete_on_group
AFTER DELETE ON GROUPS
FOR EACH ROW
BEGIN
    DELETE FROM STUDENTS
    WHERE GROUP_ID = :OLD.ID;
END;
