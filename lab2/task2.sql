CREATE OR REPLACE TRIGGER trg_unique_id
BEFORE INSERT ON STUDENTS
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM STUDENTS
    WHERE ID = :NEW.ID;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ID должен быть уникальным');
    END IF;
END;


CREATE OR REPLACE TRIGGER trg_unique_id_groups
BEFORE INSERT ON GROUPS
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM GROUPS
    WHERE ID = :NEW.ID;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ID должен быть уникальным');
    END IF;
END;

-- ================================

DROP SEQUENCE IF EXISTS students_id_seq;
DROP SEQUENCE IF EXISTS groups_id_seq;

CREATE SEQUENCE students_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE groups_id_seq START WITH 1 INCREMENT BY 1;


CREATE OR REPLACE TRIGGER trg_autoincrement_students_id
BEFORE INSERT ON STUDENTS
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        :NEW.ID := students_id_seq.NEXTVAL;
    END IF;
END;


CREATE OR REPLACE TRIGGER trg_autoincrement_groups_id
BEFORE INSERT ON GROUPS
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN
        :NEW.ID := groups_id_seq.NEXTVAL;
    END IF;
END;

-- ================================

CREATE OR REPLACE TRIGGER trg_unique_group_name
BEFORE INSERT OR UPDATE ON GROUPS
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM GROUPS
    WHERE UPPER(NAME) = UPPER(:NEW.NAME);

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Группа с таким названием уже существует');
    END IF;
END;