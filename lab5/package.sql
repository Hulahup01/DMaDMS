-- PACKAGE BACKUP

CREATE OR REPLACE PACKAGE BACKUP IS
    PROCEDURE RESTORE(TIME_OFFSET INTERVAL DAY TO SECOND);
    PROCEDURE RESTORE_DATE(DATE_TO_RESTORE DATE);
    PROCEDURE RESTORE(DATE_TO_RESTORE DATE);
    PROCEDURE RESTORE_TS(TS TIMESTAMP);
END;

CREATE OR REPLACE PACKAGE BODY BACKUP IS

    PROCEDURE RESTORE_DATE(DATE_TO_RESTORE DATE) IS
    BEGIN
        BACKUP.RESTORE_TS(TO_TIMESTAMP(DATE_TO_RESTORE));
    END;

    PROCEDURE RESTORE_READER_ACTION(ACTION LOGS%ROWTYPE) IS
        NEW_READER_OBJ READER_TYPE;
        OLD_READER_OBJ READER_TYPE;
        INVALID_OBJ EXCEPTION;
    BEGIN
        IF ACTION.OPERATION = 'INSERT' THEN
            IF ACTION.NEW.GETOBJECT(NEW_READER_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            INSERT INTO READER (ID, NAME)
            VALUES (NEW_READER_OBJ.ID, NEW_READER_OBJ.NAME);
        END IF;
        IF ACTION.OPERATION = 'UPDATE' THEN
            IF ACTION.OLD.GETOBJECT(OLD_READER_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            IF ACTION.NEW.GETOBJECT(NEW_READER_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            UPDATE READER
            SET ID = NEW_READER_OBJ.ID,
                NAME = NEW_READER_OBJ.NAME
            WHERE ID = OLD_READER_OBJ.ID;
        END IF;
        IF ACTION.OPERATION = 'DELETE' THEN
            IF ACTION.OLD.GETOBJECT(OLD_READER_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            DELETE
            FROM READER
            WHERE ID = OLD_READER_OBJ.ID;
        END IF;
    END;

    PROCEDURE RESTORE_COURSE_ACTION(ACTION LOGS%ROWTYPE) IS
        NEW_COURSE_OBJ COURSE_TYPE;
        OLD_COURSE_OBJ COURSE_TYPE;
        INVALID_OBJ EXCEPTION;
    BEGIN
        IF ACTION.OPERATION = 'INSERT' THEN
            IF ACTION.NEW.GETOBJECT(NEW_COURSE_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            INSERT INTO COURSE (ID, READER_ID, TITLE)
            VALUES (NEW_COURSE_OBJ.ID, NEW_COURSE_OBJ.READER_ID, NEW_COURSE_OBJ.TITLE);
        END IF;
        IF ACTION.OPERATION = 'UPDATE' THEN
            IF ACTION.OLD.GETOBJECT(OLD_COURSE_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            IF ACTION.NEW.GETOBJECT(NEW_COURSE_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            UPDATE COURSE
            SET ID = NEW_COURSE_OBJ.ID,
                READER_ID = NEW_COURSE_OBJ.READER_ID,
                TITLE = NEW_COURSE_OBJ.TITLE
            WHERE ID = OLD_COURSE_OBJ.ID;
        END IF;
        IF ACTION.OPERATION = 'DELETE' THEN
            IF ACTION.OLD.GETOBJECT(OLD_COURSE_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            DELETE
            FROM COURSE
            WHERE ID = OLD_COURSE_OBJ.ID;
        END IF;
    END;

    PROCEDURE RESTORE_STUDENT_ACTION(ACTION LOGS%ROWTYPE) IS
        NEW_STUDENT_OBJ STUDENT_TYPE;
        OLD_STUDENT_OBJ STUDENT_TYPE;
        INVALID_OBJ EXCEPTION;
    BEGIN
        IF ACTION.OPERATION = 'INSERT' THEN
            IF ACTION.NEW.GETOBJECT(NEW_STUDENT_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            INSERT INTO STUDENT (ID, NAME, BIRTHDATE)
            VALUES (NEW_STUDENT_OBJ.ID, NEW_STUDENT_OBJ.NAME, NEW_STUDENT_OBJ.BIRTHDATE);
        END IF;
        IF ACTION.OPERATION = 'UPDATE' THEN
            IF ACTION.OLD.GETOBJECT(NEW_STUDENT_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            IF ACTION.NEW.GETOBJECT(OLD_STUDENT_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            UPDATE STUDENT
            SET ID        = NEW_STUDENT_OBJ.ID,
                BIRTHDATE = NEW_STUDENT_OBJ.BIRTHDATE,
                NAME      = NEW_STUDENT_OBJ.NAME
            WHERE ID = OLD_STUDENT_OBJ.ID;
        END IF;
        IF ACTION.OPERATION = 'DELETE' THEN
            IF ACTION.OLD.GETOBJECT(OLD_STUDENT_OBJ) != DBMS_TYPES.SUCCESS THEN
                RAISE INVALID_OBJ;
            END IF;
            DELETE
            FROM STUDENT
            WHERE ID = OLD_STUDENT_OBJ.ID;
        END IF;
    END;

    PROCEDURE RESTORE_TS(TS TIMESTAMP) IS
        LAST_LOG_ID NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE STUDENT';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE COURSE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE READER';
        SELECT MAX(ID) INTO LAST_LOG_ID FROM LOGS;

        FOR ACTION IN (SELECT *
                       FROM LOGS
                       WHERE CREATED_AT <= TS
                       ORDER BY CREATED_AT)
            LOOP
                CASE ACTION.TABLE_NAME
                    WHEN 'STUDENT'
                        THEN BACKUP.RESTORE_STUDENT_ACTION(ACTION);
                    WHEN 'COURSE'
                        THEN BACKUP.RESTORE_COURSE_ACTION(ACTION);
                    WHEN 'READER'
                        THEN BACKUP.RESTORE_READER_ACTION(ACTION);
                    END CASE;
            END LOOP;
        DELETE
        FROM LOGS
        WHERE ID > LAST_LOG_ID;
    END;

    PROCEDURE RESTORE(TIME_OFFSET INTERVAL DAY TO SECOND) IS
        TS TIMESTAMP;
    BEGIN
        TS := SYSTIMESTAMP - TIME_OFFSET;
        BACKUP.RESTORE_TS(TS);
    END;

    PROCEDURE RESTORE(DATE_TO_RESTORE DATE) IS
    BEGIN
        BACKUP.RESTORE_TS(TO_TIMESTAMP(DATE_TO_RESTORE));
    END;
    
END;


-- PACKAGE REPORTS

CREATE OR REPLACE FUNCTION OBJ_TO_STRING(DATA ANYDATA, TABLE_NAME VARCHAR2) RETURN VARCHAR2 IS
    STUDENT_OBJ  STUDENT_TYPE;
    READER_OBJ   READER_TYPE;
    COURSE_OBJ COURSE_TYPE;
BEGIN
    IF DATA IS NULL THEN
        RETURN '{----}';
    END IF;

    IF TABLE_NAME = 'STUDENT' AND DATA.GETOBJECT(STUDENT_OBJ) = DBMS_TYPES.SUCCESS THEN
        RETURN '{ID: ' || STUDENT_OBJ.ID || '}, {NAME: ' || STUDENT_OBJ.NAME || '}, {BIRTHDATE: ' || STUDENT_OBJ.BIRTHDATE || '}';
    ELSIF TABLE_NAME = 'READER' AND DATA.GETOBJECT(READER_OBJ) = DBMS_TYPES.SUCCESS THEN
        RETURN '{ID: ' || READER_OBJ.ID || '}, {NAME: ' || READER_OBJ.NAME || '}';
    ELSIF TABLE_NAME = 'COURSE' AND DATA.GETOBJECT(COURSE_OBJ) = DBMS_TYPES.SUCCESS THEN
        RETURN '{ID: ' || COURSE_OBJ.ID || '}, {COURSE_ID: ' || COURSE_OBJ.READER_ID || '}, {TITLE: ' || COURSE_OBJ.TITLE || '}';
    END IF;

    RETURN 'UNKNOWN';
END;

CREATE OR REPLACE PACKAGE REPORTS AS
    PROCEDURE GET_REPORT;
    PROCEDURE GET_REPORT(TS TIMESTAMP);
END;

CREATE OR REPLACE PACKAGE BODY REPORTS AS
    LAST_REPORT_DATE TIMESTAMP := TO_DATE('2024/05/08', 'yyyy/mm/dd');

    PROCEDURE GET_REPORT IS
    BEGIN
        GET_REPORT(LAST_REPORT_DATE);
    END;

    PROCEDURE GET_REPORT(TS TIMESTAMP) IS
        L_CLOB     CLOB;
        LOGS_COUNT NUMBER;
    BEGIN
        SELECT COUNT(*) INTO LOGS_COUNT FROM LOGS WHERE LOGS.CREATED_AT > TS;
        IF LOGS_COUNT = 0 THEN
            L_CLOB := '<!DOCTYPE html>
                        <html lang="en">
                        <head>
                            <meta charset="UTF-8">
                            <meta http-equiv="X-UA-Compatible" content="IE=edge">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Report</title>
                            <style>
						        body {
						            font-family: Arial, sans-serif;
						            margin: 0;
						            padding: 0;
						        }
                                h1, h2 {
                                    text-align: center;
                                }
						    </style>
                        </head>
                        <body>
                            <h1>REPORT</h1>
                            <h2>[' || LAST_REPORT_DATE || '] - [' || SYSTIMESTAMP || ']</h2>
                            <h2>NO LOGS</h2>
                        </body>
                        </html>';
        ELSE
            L_CLOB := '<!DOCTYPE html>
                        <html lang="en">
                        <head>
						    <meta charset="UTF-8">
						    <meta http-equiv="X-UA-Compatible" content="IE=edge">
						    <meta name="viewport" content="width=device-width, initial-scale=1.0">
						    <title>Report</title>
						    <style>
						        body {
						            font-family: Arial, sans-serif;
						            margin: 0;
						            padding: 0;
						        }
                                h1, h2 {
                                    text-align: center;
                                }
						        header {
						            background-color: #333;
						            color: white;
						            padding: 20px;
						            text-align: center;
						        }
						        table {
						            width: 100%;
						            border-collapse: collapse;
						            margin-top: 20px;
						        }
						        th, td {
						            border: 1px solid #ddd;
						            padding: 8px;
						            text-align: left;
						        }
						        th {
						            background-color: #333;
						            color: white;
						        }
						        tr:nth-child(even) {
						            background-color: #f2f2f2;
						        }
						    </style>
						</head>
                        <body>
                            <h1>REPORT</h1>
                            <h2>[' || LAST_REPORT_DATE || '] - [' || SYSTIMESTAMP || ']</h2>
                            <table>
                                <tr>
                                    <th>OPERATION</th>
                                    <th>TABLE</th>
                                    <th>DATE</th>
                                    <th>OLD</th>
                                    <th>NEW</th>
                                </tr>';

            FOR L_REC IN (SELECT * FROM LOGS WHERE LOGS.CREATED_AT > TS ORDER BY CREATED_AT)
            LOOP
                L_CLOB := L_CLOB || '<tr>
                                        <td>' || L_REC.OPERATION || '</td>
                                        <td>' || L_REC.TABLE_NAME || '</td>
                                        <td>' || L_REC.CREATED_AT || '</td>
                                        <td>' || OBJ_TO_STRING(L_REC.OLD, L_REC.TABLE_NAME) || '</td>
                                        <td>' || OBJ_TO_STRING(L_REC.NEW, L_REC.TABLE_NAME) || '</td>
                                    </tr>';
            END LOOP;

            L_CLOB := L_CLOB || '</table>
                        </body>
                        </html>';
        END IF;

        DBMS_OUTPUT.PUT_LINE('-==[' || LAST_REPORT_DATE || ']=====================================================================================================');
        DBMS_OUTPUT.PUT_LINE(L_CLOB);
        DBMS_OUTPUT.PUT_LINE('=====================================================================================================');
        LAST_REPORT_DATE := SYSTIMESTAMP;
    END;
END;