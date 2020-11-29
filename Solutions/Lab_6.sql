--2.
SELECT name_mem, id_mem, 
CASE name_mem
   WHEN 'Me' THEN 'found'
END as "not found" 
FROM MEMBER

--3.
SELECT description, summ,
CASE
     WHEN summ > 200 THEN 'rich'
END as "Are you rich?"
FROM OPERATION

--4.
SELECT name_mem, summ FROM MEMBER
JOIN OPERATION on OPERATION.id_mem = MEMBER.id_mem

--5.
CREATE VIEW view_for_5 AS
    SELECT
        OPERATION.*
    FROM
        OPERATION
            WHERE
        date_op > to_date('01-01-2017','dd-mm-yyyy');

--6.
SELECT * FROM MEMBER
WHERE id_mem in (SELECT id_mem FROM OPERATION GROUP BY id_mem)

--7.
SELECT * FROM MEMBER
WHERE id_mem in (
SELECT id_mem FROM OPERATION
JOIN MEMBER on MEMBER.id_mem = OPERATION.id_mem
)

--8.
SELECT id_mem, NULLIF(name_mem, 'Me') AS Real_Name FROM MEMBER

--9.
SELECT COALESCE(id_mem,name_mem) FROM MEMBER

--10.
SELECT * FROM (SELECT * FROM OPERATION ORDER BY summ DESC) as temp
LIMIT 2

--11.
SELECT date_op FROM OPERATION
GROUP BY date_op with ROLLUP

--12.
CREATE TABLE t1 (
    a INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    message CHAR(20))

ENGINE=MyISAM;

CREATE TABLE t2 (
    a INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    message CHAR(20))

ENGINE=MyISAM;

INSERT INTO t1 (message) VALUES ('Testing'),('table'),('t1');
INSERT INTO t2 (message) VALUES ('Testing'),('table'),('t2');

CREATE TABLE total (
    a INT NOT NULL AUTO_INCREMENT,
    message CHAR(20), INDEX(a))

ENGINE=MERGE UNION=(t1,t2) INSERT_METHOD=LAST;