DROP TABLE IF EXISTS STUDENT;
DROP TYPE IF EXISTS STUDENT_TYPE;
DROP TABLE IF EXISTS READER;
DROP TYPE IF EXISTS READER_TYPE;
DROP TABLE IF EXISTS COURSE;
DROP TYPE IF EXISTS COURSE_TYPE;
DROP TABLE IF EXISTS LOGS;

-- TABLES AND THEIR TYPES
CREATE TABLE STUDENT
(
    ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    NAME VARCHAR(20),
    BIRTHDATE DATE
);

CREATE TYPE STUDENT_TYPE AS OBJECT
(
    ID NUMBER,
    Name VARCHAR(20),
    BIRTHDATE DATE
);


CREATE TABLE READER
(
    ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    NAME VARCHAR(20)
);

CREATE TYPE READER_TYPE AS OBJECT
(
    ID NUMBER,
    NAME VARCHAR(20)
);


CREATE TABLE COURSE
(
    ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    TITLE VARCHAR(50),
    READER_ID NUMBER,
    CONSTRAINT COURSE_READER_FK FOREIGN KEY (READER_ID) REFERENCES READER (ID) ON DELETE CASCADE
);

CREATE TYPE COURSE_TYPE AS OBJECT
(
    ID NUMBER,
    Title VARCHAR(50),
    READER_ID NUMBER
);


-- LOG TABLE
CREATE TABLE LOGS
(
    ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    OPERATION VARCHAR2(10) NOT NULL,
    TABLE_NAME VARCHAR2(20) NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL,
    NEW ANYDATA,
    OLD ANYDATA
);


-- TRIGGERS
CREATE OR REPLACE TRIGGER STUDENT_LOG_TRIGGER
    BEFORE INSERT OR UPDATE OR DELETE
    ON STUDENT
    FOR EACH ROW
DECLARE
BEGIN
    CASE
        WHEN INSERTING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('INSERT', SYSTIMESTAMP, 'STUDENT',
                         ANYDATA.CONVERTOBJECT(STUDENT_TYPE(:NEW.ID, :NEW.NAME, :NEW.BIRTHDATE)), NULL);
        WHEN DELETING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('DELETE', SYSTIMESTAMP, 'STUDENT', NULL,
                         ANYDATA.CONVERTOBJECT(STUDENT_TYPE(:OLD.ID, :OLD.NAME, :OLD.BIRTHDATE)));
        WHEN UPDATING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('UPDATE', SYSTIMESTAMP, 'STUDENT',
                         ANYDATA.CONVERTOBJECT(STUDENT_TYPE(:NEW.ID, :NEW.NAME, :NEW.BIRTHDATE)),
                         ANYDATA.CONVERTOBJECT(STUDENT_TYPE(:OLD.ID, :OLD.NAME, :OLD.BIRTHDATE)));
        END CASE;
END;


CREATE OR REPLACE TRIGGER COURSE_LOG_TRIGGER
    BEFORE INSERT OR UPDATE OR DELETE
    ON COURSE
    FOR EACH ROW
DECLARE
BEGIN
    CASE
        WHEN INSERTING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('INSERT', SYSTIMESTAMP, 'COURSE',
                         ANYDATA.CONVERTOBJECT(COURSE_TYPE(:NEW.ID, :NEW.TITLE, :NEW.READER_ID)), NULL);
        WHEN DELETING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('DELETE', SYSTIMESTAMP, 'COURSE', NULL,
                         ANYDATA.CONVERTOBJECT(COURSE_TYPE(:OLD.ID, :OLD.TITLE, :OLD.READER_ID)));
        WHEN UPDATING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('UPDATE', SYSTIMESTAMP, 'COURSE',
                         ANYDATA.CONVERTOBJECT(COURSE_TYPE(:NEW.ID, :NEW.TITLE, :NEW.READER_ID)),
                         ANYDATA.CONVERTOBJECT(COURSE_TYPE(:OLD.ID, :OLD.TITLE, :OLD.READER_ID)));
        END CASE;
END;

CREATE OR REPLACE TRIGGER READER_LOG_TRIGGER
    BEFORE INSERT OR UPDATE OR DELETE
    ON READER
    FOR EACH ROW
DECLARE
BEGIN
    CASE
        WHEN INSERTING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('INSERT', SYSTIMESTAMP, 'READER',
                         ANYDATA.CONVERTOBJECT(READER_TYPE(:NEW.ID, :NEW.NAME)), NULL);
        WHEN DELETING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('DELETE', SYSTIMESTAMP, 'READER', NULL,
                         ANYDATA.CONVERTOBJECT(READER_TYPE(:OLD.ID, :OLD.NAME)));
        WHEN UPDATING
            THEN INSERT INTO LOGS (OPERATION,
                                   CREATED_AT,
                                   TABLE_NAME,
                                   NEW,
                                   OLD)
                 VALUES ('UPDATE', SYSTIMESTAMP, 'READER',
                         ANYDATA.CONVERTOBJECT(READER_TYPE(:NEW.ID, :NEW.NAME)),
                         ANYDATA.CONVERTOBJECT(READER_TYPE(:OLD.ID, :OLD.NAME)));
        END CASE;
END;