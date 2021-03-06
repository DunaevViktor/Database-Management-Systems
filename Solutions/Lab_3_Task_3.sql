-- 1. Расходные операции по месяцам, вывести в виде таблицы ( ноябрь и перечень и тд)
-- стобцы дни , строки перечень расходных операций

SELECT to_char(to_date(OPERATION.date_op, 'DD-MM-YYYY'), 'Month') AS Month, OPERATION.description
FROM OPERATION
ORDER BY EXTRACT(month FROM date_op)

--2. В какие месяцы (название) были минимальные остатки денежных средств.

-- version 1

SELECT MIN (Ostatok) as "VALUE" FROM
(
SELECT to_char(to_date(OPERATION.date_op, 'DD-MM-YYYY'), 'Month') AS Month,
SUM (OPERATION.summ) AS Ostatok
FROM OPERATION
GROUP BY to_char(to_date(OPERATION.date_op, 'DD-MM-YYYY'), 'Month')
)

--version 2

SELECT * FROM (
SELECT to_char(to_date(OPERATION.date_op, 'DD-MM-YYYY'),'Month') As Month, SUM(OPERATION.summ) AS sum
FROM OPERATION
GROUP BY to_char(to_date(OPERATION.date_op, 'DD-MM-YYYY'),'Month')
ORDER BY sum)
WHERE rownum = 1

--3.Доходные суммы разбить по категориям (если доход до 1 баз вел - низкий, от 1 до 5 - средний, 
-- от 5 до 10 - высокий, выше 10 - очень высокий), вывести по именам членов семьи 

JOIN MEMBER on MEMBER.id_mem = OPERATION.id_mem;

SELECT name_mem,
    CASE
       WHEN OPERATION.summ BETWEEN 0 AND 50 THEN 'low'
       WHEN OPERATION.summ BETWEEN 51 AND 100 THEN 'midlle'
       WHEN OPERATION.summ BETWEEN 101 AND 300 THEN 'hight'
       WHEN OPERATION.summ BETWEEN 301 AND 500 THEN 'very hight'
       ELSE 'very hight'
    END as "TEST_BLOCK"
    FROM MEMBER;
	
-- 4. Максимальные расходы за период в условиях зароса в виде (начало периода - конец периода)
-- вывести название операции и имя члена