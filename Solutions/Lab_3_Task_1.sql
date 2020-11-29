/*1. Выдать информацию о местоположении отдела продаж (SALES) компании. */
SELECT DEPTADDR FROM DEPT WHERE DEPTNAME = 'SALES';

/*2. Выдать информацию об отделах, расположенных в Chicago и New York. */
SELECT * FROM DEPT WHERE DEPTADDR = 'CHICAGO' OR DEPTADDR = 'NEW YORK';

/*3.Найти минимальную заработную плату, начисленную в 2009 году.*/
SELECT MIN(SALVALUE) FROM SALARY WHERE YEAR = 2009;

/*4. Выдать информацию обо всех работниках, родившихся не позднее 1 января 1960 года.*/
SELECT * FROM EMP WHERE BIRTHDATE <= DATE '1960-01-01';

/*5. Подсчитать число работников, сведения о которых имеются в базе данных .*/
SELECT  COUNT(*) FROM EMP;

/*6. Найти работников, чьё имя состоит из одного слова. Имена выдать на нижнем регистре, с удалением стоящей справа буквы t. */
SELECT RTRIM(LOWER(EMPNAME) , 't') FROM EMP WHERE EMPNAME NOT LIKE '% %';

/*7. Выдать информацию о работниках, указав дату рождения в формате день(число), месяц(название), год(название).*/
SELECT EMPNO, EMPNAME, TO_CHAR(BIRTHDATE, 'DD - Month - Year')  FROM EMP ;
SELECT EMPNO, EMPNAME, TO_CHAR(BIRTHDATE, 'DD - Month - YYYY')  FROM EMP ;

/*8. Выдать информацию о должностях, изменив названия должности “CLERK” и “DRIVER” на “WORKER”.*/
SELECT JOBNO, DECODE(JOBNAME, 'CLERK', 'WORKER','DRIVER', 'WORKER', JOBNAME), MINSALARY FROM JOB;

/*9. Определите среднюю зарплату за годы, в которые были начисления не менее чем за три месяца.*/
SELECT YEAR, AVG(SALVALUE) FROM SALARY GROUP BY YEAR HAVING COUNT(MONTH) >= 3;

/*10. Выведете ведомость получения зарплаты с указанием имен служащих.*/
SELECT SALARY.SALVALUE, EMP.EMPNAME FROM SALARY, EMP WHERE SALARY.EMPNO=EMP.EMPNO;

/*11. Укажите сведения о начислении сотрудникам зарплаты, попадающей в вилку: минимальный оклад по должности - минимальный оклад по должности плюс пятьсот. Укажите соответствующую вилке должность.*/
SELECT EMP.EMPNAME, JOB.JOBNAME, SALARY.SALVALUE, JOB.MINSALARY
    FROM SALARY
        INNER JOIN EMP
            ON SALARY.EMPNO = EMP.EMPNO
        INNER JOIN CAREER
            ON CAREER.EMPNO = EMP.EMPNO
        INNER JOIN JOB
            ON JOB.JOBNO = CAREER.JOBNO
    WHERE SALARY.SALVALUE > JOB.MINSALARY
        AND SALARY.SALVALUE < JOB.MINSALARY + 500;

/*12.Укажите сведения о заработной плате, совпадающей с минимальными окладами по должностям (с указанием этих должностей).*/
SELECT JOB.JOBNAME, SALARY.SALVALUE
    FROM SALARY
        INNER JOIN JOB
    ON SALARY.SALVALUE = JOB.MINSALARY;

/*13. Найдите сведения о карьере сотрудников с указанием вместо номера сотрудника его имени.*/
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE  FROM EMP NATURAL JOIN CAREER;

/*14.Найдите сведения о карьере сотрудников с указанием вместо номера сотрудника его имени.*/
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE  FROM EMP INNER JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;

/*15. Выдайте сведения о карьере сотрудников с указанием их имён, наименования должности, и названия отдела.*/
SELECT EMP.EMPNAME, DEPT.DEPTNAME, JOB.JOBNAME  FROM EMP
 NATURAL JOIN  DEPT
 NATURAL JOIN  JOB;

/*16. ВНЕШНЕЕ ОБЪЕДИНЕНИЕ*/
  SELECT  EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE
      FROM  EMP  RIGHT OUTER JOIN CAREER
      ON  EMP.EMPNO=CAREER.EMPNO;

 SELECT  EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE
     FROM  EMP  LEFT OUTER JOIN CAREER
     ON  EMP.EMPNO=CAREER.EMPNO;
     
 SELECT  EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE
     FROM  EMP  FULL OUTER JOIN CAREER
     ON  EMP.EMPNO=CAREER.EMPNO;