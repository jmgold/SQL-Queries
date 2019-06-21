/*
Jeremy Goldstein
Minuteman Library Network

Calculates time that each item spent on the holdshelf in the past month
*/

--Identifies items that were both placed on the holdshelf and subsequently checked out within the past month
DROP TABLE IF EXISTS fulfilled_holds;
CREATE TEMP TABLE fulfilled_holds AS
SELECT
item_record_id
FROM
sierra_view.circ_trans
WHERE
op_code = 'i'
INTERSECT
SELECT
item_record_id
FROM
sierra_view.circ_trans
WHERE
op_code = 'f';

--isolates checkin transactions
DROP TABLE IF EXISTS checkin;
CREATE TEMP TABLE checkin AS
SELECT
item_record_id,
transaction_gmt
FROM
sierra_view.circ_trans
WHERE
op_code = 'i'
AND
transaction_gmt > NOW() - INTERVAL '1 month';

--isolates filled hold transactions
DROP TABLE IF EXISTS filled;
CREATE TEMP TABLE filled AS
SELECT
item_record_id,
transaction_gmt
FROM
sierra_view.circ_trans
WHERE
op_code = 'f';

SELECT
SUBSTRING(s.name,1,3) AS location,
f.item_record_id AS id,
c.itype_code_num AS Itype_code,
i.name AS Itype_label,
ch.transaction_gmt AS checkin_gmt,
f.transaction_gmt AS filled_gmt,
AGE(f.transaction_gmt,ch.transaction_gmt) AS time_on_holdshelf
FROM
fulfilled_holds fh
JOIN
sierra_view.circ_trans c
ON
fh.item_record_id = c.item_record_id
JOIN
sierra_view.statistic_group_myuser s
ON
c.stat_group_code_num = s.code
JOIN
filled f
ON
fh.item_record_id = f.item_record_id
JOIN
checkin ch
ON
f.item_record_id = ch.item_record_id AND f.transaction_gmt > ch.transaction_gmt
JOIN
sierra_view.itype_property_myuser i
ON
c.itype_code_num = i.code
WHERE op_code IN ('f','i')
AND SUBSTRING(s.name,1,3) NOT IN ('Com','mls')
GROUP BY 1,2,3,4,5,6
ORDER BY 1,2,3,4,5 DESC