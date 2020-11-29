-- 01.Добавьте в таблицу SALARY столбец TAX (налог) для вычисления ежемесячного
--подоходного налога на зарплату по прогрессивной шкале.

 ALTER TABLE SALARY ADD (TAX NUMBER(15));

-- 02-a.с помощью простого цикла (loop) с курсором и оператора if;

 CREATE OR REPLACE PROCEDURE TAX_SIMPLE_LOOP_IF AS
     SUMSAL NUMBER(16);
 BEGIN
     FOR R IN (SELECT * FROM SALARY)
     LOOP
         SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
             WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

         IF SUMSAL < 20000 THEN
             UPDATE SALARY SET TAX = R.SALVALUE * 0.09
                 WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
         ELSIF SUMSAL < 30000 THEN
             UPDATE SALARY SET TAX = R.SALVALUE * 0.12
                 WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
         ELSE
             UPDATE SALARY SET TAX = R.SALVALUE * 0.15
                 WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
         END IF;
     END LOOP;
     COMMIT;
 END;
 /

  -- 02-b. с помощью простого цикла (loop) с курсором и оператора case;

 CREATE OR REPLACE PROCEDURE TAX_LOOP_CUR_CASE AS
     SUMSAL NUMBER(16);
     CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY FOR UPDATE OF TAX;
     R CUR%ROWTYPE;
 BEGIN
     OPEN CUR;
     LOOP
         FETCH CUR INTO R;
         EXIT WHEN CUR%NOTFOUND;
         SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
             WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

         UPDATE SALARY SET TAX =
             CASE
                 WHEN SUMSAL < 20000 THEN R.SALVALUE * 0.09
                 WHEN SUMSAL < 30000 THEN R.SALVALUE * 0.12
                 ELSE R.SALVALUE * 0.15
             END

             WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
     END LOOP;
     CLOSE CUR;
     COMMIT;
 END TAX_LOOP_CUR_CASE;
 /

 -- 02-c.с помощью курсорного цикла FOR;

 CREATE OR REPLACE PROCEDURE TAX_CUR_LOOP_CASE AS
     SUMSAL NUMBER;
     CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY FOR UPDATE OF TAX;
 BEGIN
    FOR R IN CUR LOOP
          SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
             WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

         UPDATE SALARY SET TAX =
             CASE
                 WHEN SUMSAL < 20000 THEN R.SALVALUE * 0.09
                 WHEN SUMSAL < 30000 THEN R.SALVALUE * 0.12
                 ELSE R.SALVALUE * 0.15
             END

             WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
     END LOOP;
     COMMIT;
 END TAX_CUR_LOOP_CASE;
 /

 -- 02-d.с помощью курсора с параметром, передавая номер сотрудника, для которого
 -- необходимо посчитать налог.

 CREATE  OR  REPLACE  PROCEDURE  TAX_PARAM (EMPID  NUMBER)  AS
     CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY
         WHERE EMPNO = EMPID
         FOR UPDATE OF TAX;
     SUMSAL NUMBER(16);
 BEGIN
     FOR R IN CUR LOOP
         SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
             WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

         UPDATE SALARY SET TAX =
             CASE
                 WHEN SUMSAL < 20000 THEN R.SALVALUE * 0.09
                 WHEN SUMSAL < 30000 THEN R.SALVALUE * 0.12
                 ELSE R.SALVALUE * 0.15
             END

             WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
     END LOOP;
     COMMIT;
 END  TAX_PARAM;
 /

  -- 04.Создайте функцию, вычисляющую налог на зарплату за всё время начислений для
  -- конкретного сотрудника.

 CREATE  OR  REPLACE  PROCEDURE  TAX_PARAM_LESS (EMPID  NUMBER, UNDER_20k NUMBER,
     OVER_20k NUMBER,
     OVER_30k NUMBER)  AS
     CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY
         WHERE EMPNO = EMPID
         FOR UPDATE OF TAX;
     SUMSAL NUMBER(16);
 BEGIN
     FOR R IN CUR LOOP
         SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
             WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

         UPDATE SALARY SET TAX =
             CASE
                 WHEN SUMSAL < 20000 THEN R.SALVALUE * UNDER_20k
                 WHEN SUMSAL < 30000 THEN R.SALVALUE * OVER_20k
                 ELSE R.SALVALUE * OVER_30k
             END

             WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
     END LOOP;
     COMMIT;
 END  TAX_PARAM_LESS;
 /

 -- 05.Создайте процедуру, вычисляющую суммарный налог на зарплату сотрудника за
 -- всё время начислений.

 CREATE  OR  REPLACE  FUNCTION  FTAX_PARAM_LESS (
     EMPID  NUMBER,
     UNDER_20k NUMBER,
     OVER_20k NUMBER,
     OVER_30k NUMBER) RETURN NUMBER  AS

     CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY
         WHERE EMPNO = EMPID;
     SUMSAL NUMBER(16);
     RESULT NUMBER(16);
 BEGIN
     RESULT := 0;
     FOR R IN CUR LOOP
         SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
             WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

         RESULT := RESULT +
             CASE
                 WHEN SUMSAL < 20000 THEN R.SALVALUE * UNDER_20k
                 WHEN SUMSAL < 30000 THEN R.SALVALUE * OVER_20k
                 ELSE R.SALVALUE * OVER_30k
             END;

     END LOOP;
     RETURN RESULT;
 END  FTAX_PARAM_LESS;
 /
 SELECT FTAX_PARAM_LESS(EMPNO, 1, 2, 3) FROM SALARY
 /

 -- 06.Создайте пакет, включающий в свой состав процедуру вычисления налога для всех
 -- сотрудников

 CREATE OR REPLACE PACKAGE TAX_EVAL AS
     PROCEDURE TAX_SIMPLE_LOOP_IF;
     PROCEDURE TAX_PARAM (EMPID NUMBER);
     PROCEDURE TAX_PARAM_LESS (
         UNDER_20k NUMBER,
         OVER_20k NUMBER,
         OVER_30k NUMBER,
         EMPID  NUMBER
     );
 END TAX_EVAL;
 /
 CREATE OR REPLACE PACKAGE BODY TAX_EVAL AS
     PROCEDURE TAX_SIMPLE_LOOP_IF AS
         SUMSAL NUMBER(16);
     BEGIN
         FOR R IN (SELECT * FROM SALARY)
         LOOP
             SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
                 WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

             IF SUMSAL < 20000 THEN
                 UPDATE SALARY SET TAX = R.SALVALUE * 0.09
                     WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
             ELSIF SUMSAL < 30000 THEN
                 UPDATE SALARY SET TAX = R.SALVALUE * 0.12
                     WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
             ELSE
                 UPDATE SALARY SET TAX = R.SALVALUE * 0.15
                     WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
             END IF;
         END LOOP;
         COMMIT;
     END;

     PROCEDURE  TAX_PARAM (EMPID  NUMBER)  AS
         CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY
             WHERE EMPNO = EMPID
             FOR UPDATE OF TAX;
         SUMSAL NUMBER(16);
     BEGIN
         FOR R IN CUR LOOP
             SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
                 WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

             UPDATE SALARY SET TAX =
                 CASE
                     WHEN SUMSAL < 20000 THEN R.SALVALUE * 0.09
                     WHEN SUMSAL < 30000 THEN R.SALVALUE * 0.12
                     ELSE R.SALVALUE * 0.15
                 END

                 WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
         END LOOP;
         COMMIT;
     END  TAX_PARAM;

     PROCEDURE  TAX_PARAM_LESS (
     UNDER_20k NUMBER,
     OVER_20k NUMBER,
     OVER_30k NUMBER,
     EMPID  NUMBER)  AS
         CURSOR CUR IS SELECT EMPNO, SALVALUE, TAX, YEAR, MONTH FROM SALARY
             WHERE EMPNO = EMPID;
         SUMSAL NUMBER(16);
     BEGIN
         FOR R IN CUR LOOP
             SELECT SUM(SALVALUE) INTO SUMSAL FROM SALARY S
                 WHERE S.EMPNO = R.EMPNO AND S.MONTH < R.MONTH AND S.YEAR = R.YEAR;

             UPDATE SALARY SET TAX =
                 CASE
                     WHEN SUMSAL < 20000 THEN R.SALVALUE * UNDER_20k
                     WHEN SUMSAL < 30000 THEN R.SALVALUE * OVER_20k
                     ELSE R.SALVALUE * OVER_30k
                 END

                 WHERE EMPNO = R.EMPNO AND MONTH = R.MONTH AND YEAR = R.YEAR;
         END LOOP;
         COMMIT;
     END  TAX_PARAM_LESS;
 END TAX_EVAL;
 /

 -- 07.Создайте триггер, действующий при обновлении данных в таблице SALARY.

 CREATE OR REPLACE TRIGGER CHECK_SALARY
     BEFORE UPDATE OF SALVALUE ON SALARY FOR EACH ROW
 DECLARE
     CURSOR CUR(EMPID CAREER.EMPNO%TYPE) IS
         SELECT MINSALARY FROM JOB
             WHERE JOBNO = (SELECT JOBNO FROM CAREER WHERE EMPID = EMPNO AND ENDDATE IS NULL);
     R JOB.MINSALARY%TYPE;
 BEGIN
     OPEN CUR(:NEW.EMPNO);
     FETCH CUR INTO R;
     IF :NEW.SALVALUE < R THEN
         :NEW.SALVALUE := :OLD.SALVALUE;
     END IF;
     CLOSE CUR;
 END CHECK_SALARY;
 /

 -- 08.Создайте триггер, действующий при удалении записи из таблицы CAREER.

 CREATE OR REPLACE TRIGGER CHECK_NOT_NULL
     BEFORE DELETE ON CAREER
     FOR EACH ROW
 BEGIN
     IF :OLD.ENDDATE IS NULL
         THEN INSERT INTO CAREER VALUES (:OLD.JOBNO, :OLD.EMPNO, :OLD.DEPTNO, :OLD.STARTDATE, :OLD.ENDDATE);
     END IF;
 END CHECK_NOT_NULL;
 /

 -- 09.Создайте триггер, действующий на добавление или изменение данных в таблице EMP

 CREATE OR REPLACE TRIGGER ON_EMP_INSERT_UPDATE
     BEFORE INSERT OR UPDATE ON EMP
     FOR EACH ROW
 BEGIN
     IF :NEW.BIRTHDATE IS NULL THEN
         DBMS_OUTPUT.PUT_LINE('BIRTHDATE IS NULL');
     END IF;

     IF :NEW.BIRTHDATE < to_date('01-01-1940', 'dd-mm-yyyy') THEN
         DBMS_OUTPUT.PUT_LINE('PENSIONER');
     END IF;

     :NEW.EMPNAME := UPPER(:NEW.EMPNAME);
 END ON_EMP_INSERT_UPDATE;
 /

 -- 10.Создайте программу изменения типа заданной переменной из символьного типа
 -- (VARCHAR2) в числовой тип (NUMBER).
 
 CREATE OR REPLACE FUNCTION VarcharToNumber (
str VARCHAR2
) RETURN NUMBER AS 
BEGIN
RETURN to_number(str);
EXCEPTION
WHEN VALUE_ERROR THEN RAISE_APPLICATION_ERROR( -20003,'ERROR: argument is not a number');
