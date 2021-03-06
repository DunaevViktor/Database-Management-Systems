--1

CREATE OR REPLACE VIEW PENSIONER AS SELECT * FROM EMP WHERE (SYSDATE - EMP.BIRTHDATE)/365 >= 55;

SELECT * FROM PENSIONER;


--2

CREATE OR REPLACE VIEW DISMISSED AS
	SELECT e.EMPNAME AS name, c.ENDDATE AS end_date, d.DEPTNAME AS dept_name, j.JOBNAME AS job_name
        FROM CAREER c
	INNER JOIN EMP e
	ON e.EMPNO = c.EMPNO
	INNER JOIN DEPT d
	ON d.DEPTNO = c.DEPTNO
	INNER JOIN JOB j
	ON j.JOBNO = c.JOBNO
	WHERE c.ENDDATE IS NOT NULL;

SELECT * FROM DISMISSED;

--3

CREATE OR REPLACE VIEW ALLINFO AS SELECT e.EMPNAME AS Sotrudnik, j.JOBNAME AS Dolzhnost, ss.sum_sal AS Itogo_3_kv
	FROM EMP e
	INNER JOIN (
		SELECT EMPNO, SUM(SALVALUE) AS sum_sal
		FROM SALARY
                WHERE MONTH >=7 AND MONTH <=9 AND YEAR=2010
		GROUP BY EMPNO) ss
	ON ss.EMPNO = e.EMPNO
	INNER JOIN (SELECT * FROM CAREER
			WHERE CAREER.ENDDATE IS NULL AND CAREER.DEPTNO IS NOT NULL) c
	ON c.EMPNO=ss.EMPNO
	INNER JOIN JOB j
	ON j.JOBNO = c.JOBNO;

--4

CREATE OR REPLACE VIEW DISMISSED_INFO AS SELECT fe.name, CONCAT(CONCAT(s3.MONTH, ','), s3.SALVALUE) AS Month_Salary
	FROM fired_emp fe
	INNER JOIN EMP e
	ON e.EMPNAME=fe.name
	INNER JOIN (
		SELECT s.EMPNO, s.SALVALUE, s.MONTH
                FROM  SALARY s
		INNER JOIN (
		    SELECT EMPNO 
		    FROM SALARY
		    GROUP BY EMPNO
		    HAVING COUNT(*)>=2) s2
		ON s.EMPNO=s2.EMPNO) s3
	ON s3.EMPNO=e.EMPNO;
    
SELECT * FROM DISMISSED_INFO;
