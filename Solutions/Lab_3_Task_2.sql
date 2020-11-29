--1.Найти имена сотрудников, получивших за годы начисления зарплаты минимальную зарплату.
SELECT EMP.EMPNAME FROM EMP INNER JOIN SALARY ON EMP.EMPNO = SALARY.EMPNO
    WHERE SALARY.SALVALUE = (SELECT MIN(SALVALUE) FROM SALARY);

--2.Найти имена сотрудников, работавших или работающих в тех же отделах, в
-- которых работал или работает сотрудник с именем RICHARD MARTIN.
SELECT DISTINCT EMPNAME FROM EMP  JOIN CAREER ON CAREER.EMPNO = EMP.EMPNO  WHERE DEPTNO IN(SELECT CAREER.DEPTNO
    FROM CAREER
        INNER JOIN EMP
    ON CAREER.EMPNO = EMP.EMPNO WHERE EMPNAME = 'RICHARD MARTIN');

--3.Найти имена сотрудников, работавших или работающих в тех же отделах и
-- должностях, что и сотрудник RICHARD MARTIN&.
SELECT DISTINCT EMPNAME FROM EMP  JOIN CAREER ON CAREER.EMPNO = EMP.EMPNO  WHERE DEPTNO IN(SELECT CAREER.DEPTNO
    FROM CAREER
        INNER JOIN EMP
    ON CAREER.EMPNO = EMP.EMPNO WHERE EMPNAME = 'RICHARD MARTIN') AND JOBNO IN(SELECT CAREER.JOBNO
    FROM CAREER
        INNER JOIN EMP
    ON CAREER.EMPNO = EMP.EMPNO WHERE EMPNAME = 'RICHARD MARTIN');

--4.Найти сведения о номерах сотрудников, получивших за какой-либо месяц зарплату
--большую, чем средняя зарплата за 2007 г. или большую чем средняя зарплата за 2008г.
SELECT DISTINCT EMPNO FROM SALARY WHERE SALVALUE > ANY(SELECT AVG(SALVALUE) FROM SALARY WHERE YEAR = 2007 OR YEAR = 2008 GROUP BY YEAR);

--5.Найти сведения о номерах сотрудников, получивших зарплату за какой-либо месяц
--большую, чем средние зарплаты за все годы начислений.
SELECT DISTINCT EMPNO FROM SALARY WHERE SALVALUE > ALL(SELECT AVG(SALVALUE) FROM SALARY GROUP BY YEAR);

--6.Определить годы, в которые начисленная средняя зарплата была больше средней
--зарплаты за все годы начислений.
SELECT YEAR,AVG(SALVALUE) FROM SALARY GROUP BY YEAR  HAVING AVG(SALVALUE) > (SELECT AVG(SALVALUE) FROM SALARY);

--7.Определить номера отделов, в которых работали или работают сотрудники,
--имеющие начисления зарплаты.
SELECT DEPTNO FROM DEPT WHERE DEPTNO IN(SELECT DEPTNO FROM CAREER NATURAL JOIN SALARY WHERE SALVALUE IS NOT NULL);

--8.Определить номера отделов, в которых работали или работают сотрудники,
--имеющие начисления зарплаты.
SELECT DEPTNO FROM DEPT WHERE EXISTS(SELECT SALVALUE FROM SALARY NATURAL JOIN CAREER);

--9.Определить номера отделов, для сотрудников которых не начислялась зарплата.
SELECT DEPTNO FROM DEPT WHERE NOT EXISTS(SELECT SALVALUE FROM SALARY NATURAL JOIN CAREER);

--10.Вывести сведения о карьере сотрудников с указанием названий и адресов отделов
--вместо номеров отделов.
SELECT EMPNAME, DEPTNAME, DEPTADDR FROM EMP  NATURAL JOIN CAREER  NATURAL JOIN DEPT ;

--11.Определить целую часть средних зарплат, по годам начисления.
SELECT CAST (AVG(SALVALUE) AS INT) FROM SALARY GROUP BY YEAR;

--12.Разделите сотрудников на возрастные группы: A) возраст 20-30 лет; B) 31-40 лет;
--C) 41-50; D) 51-60 или возраст не определён.
SELECT EMPNAME,
    CASE
       WHEN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDATE)) BETWEEN 20 AND 30 THEN 'A'
       WHEN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDATE)) BETWEEN 31 AND 40 THEN 'B'
       WHEN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDATE)) BETWEEN 41 AND 50 THEN 'C'
        WHEN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDATE)) BETWEEN 51 AND 60 THEN 'D'
        ELSE 'D'
    END
    FROM EMP;

--13.Перекодируйте номера отделов, добавив перед номером отдела буквы BI для
--номеров <=20, буквы LN для номеров >=30.
SELECT DEPTNO,
    CASE
       WHEN DEPTNO <= 20 THEN CONCAT('BI', CAST (DEPTNO AS VARCHAR(10)))
       WHEN DEPTNO >=30 THEN CONCAT('LN', CAST (DEPTNO AS VARCHAR(10)))
    END
    FROM DEPT;

--14.Выдать информацию о сотрудниках из таблицы EMP, заменив отсутствие данного
--о дате рождения датой 01-01-1000.
SELECT EMPNO, EMPNAME, COALESCE(BIRTHDATE, to_date('01-01-1000', 'DD-MM-YYYY')) FROM EMP;
