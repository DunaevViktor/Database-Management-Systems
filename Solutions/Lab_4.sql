--1.
INSERT INTO OPERATION VALUES (1006,0,10,
(SELECT DISTINCT id_type FROM OPERATION as operation_temp GROUP BY id_type
HAVING count(*) = (SELECT Max(sum_type) FROM (SELECT id_type, count(*) as sum_type FROM OPERATION GROUP BY id_type) as temp)),
200,to_date('20-12-2018','dd-mm-yyyy'), 'Test Operation', 'BYN', 10,7,290);

--2.
UPDATE OPERATION
Set id_mem = (SELECT id_mem FROM 
(SELECT id_mem , abs(21 - id_mem) as differ
FROM MEMBER WHERE (DATE_FORMAT(now(),'%Y')) - (DATE_FORMAT(MEMBER.birthdate,'%Y')) >= 18)
WHERE differ = (SELECT min(differ) FROM (SELECT id_mem , abs(21 - id_mem) as differ
FROM MEMBER WHERE (DATE_FORMAT(now(),'%Y')) - (DATE_FORMAT(MEMBER.birthdate,'%Y')) >= 18)))

WHERE id_mem IN (SELECT id_mem FROM MEMBER
WHERE (DATE_FORMAT(now(),'%Y')) - (DATE_FORMAT(MEMBER.birthdate,'%Y'))<18);

--3.
CREATE TABLE ARCHIVE (
			ID INT NOT NULL AUTO_INCREMENT,
 			NAME VARCHAR(200) NULL,
 			id_type INT NOT NULL,
			summ INT NOT NULL,
			last_date DATE NOT NULL, PRIMARY KEY (ID))

	ENGINE=InnoDB;

INSERT INTO ARCHIVE VALUES (

1,

(SELECT name_mem FROM MEMBER
JOIN OPERATION on OPERATION.id_mem = MEMBER.id_mem
WHERE id_type = (SELECT id_type FROM OPERATION
WHERE date_op < now()-INTERVAL 3 MONTH)
AND date_op < now()-INTERVAL 3 MONTH),

(SELECT id_type FROM OPERATION
WHERE date_op < now()-INTERVAL 3 MONTH),

(SELECT sum(summ) FROM OPERATION 
WHERE id_type = (SELECT id_type FROM OPERATION
WHERE date_op < now()-INTERVAL 3 MONTH)
AND date_op < now()-INTERVAL 3 MONTH),

(SELECT max(date_op) from OPERATION
WHERE id_type = (SELECT id_type FROM OPERATION
WHERE date_op < now()-INTERVAL 3 MONTH)
AND date_op < now()-INTERVAL 3 MONTH)
);

DELETE FROM OPERATION
WHERE date_op < now()-INTERVAL 3 MONTH;