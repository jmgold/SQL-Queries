/*
Jeremy Goldstein
Minuteman Library Network
Based on code shared by Ray Voelker

Identifies potentially duplicated patron records based on matching birth_date and near matching name
*/

DROP TABLE IF EXISTS dupes;
CREATE TEMP TABLE dupes AS

SELECT
r.creation_date_gmt as created,
e.index_entry as barcode,
r.record_num AS patron_record_num,
pn.last_name || ', ' ||pn.first_name || COALESCE(' ' || NULLIF(pn.middle_name, ''), '') AS name,
pr.birth_date_gmt as birth_date,
pr.ptype_code,
pr.home_library_code,
pr.activity_gmt,
pr.expiration_date_gmt::DATE AS expiration_date

FROM
sierra_view.patron_record_fullname as pn
JOIN
sierra_view.patron_record as pr
ON
pr.record_id = pn.patron_record_id
JOIN
sierra_view.record_metadata as r
ON
r.id = pr.record_id
LEFT JOIN
sierra_view.phrase_entry AS e
ON
e.record_id = r.id AND e.index_tag = 'b' AND e.varfield_type_code = 'b'
  
WHERE
SUBSTRING(pn.last_name,1,4) || ', ' ||SUBSTRING(pn.first_name,1,3) || COALESCE(' ' || NULLIF(pn.middle_name, ''), '') || ' ' || pr.birth_date_gmt 
IN
(
	SELECT
	SUBSTRING(n.last_name,1,4) || ', ' ||SUBSTRING(n.first_name,1,3) || COALESCE(' ' || NULLIF(n.middle_name, ''), '') || ' ' || p.birth_date_gmt AS patron_name
	-- count(*) as matches

	FROM
	sierra_view.record_metadata AS r
	JOIN
	sierra_view.patron_record AS p
	ON
	p.record_id = r.id
	JOIN
	sierra_view.patron_record_fullname AS n
	ON
	n.patron_record_id = r.id
		
	WHERE 
	r.record_type_code = 'p'
	-- and r.creation_date_gmt >= '2017-05-01'

	GROUP BY
	p.birth_date_gmt,	patron_name, p.ptype_code
	HAVING COUNT(*) > 1
)
;

SELECT
t1.created,
MAX(t1.barcode) AS barcode,
'p'||t1.patron_record_num||'a' AS patron_num,
STRING_AGG(t1.name,'|') AS NAME,
t1.birth_date,
t1.ptype_code,
t1.home_library_code,
t1.activity_gmt,
t1.expiration_date

FROM dupes AS t1
JOIN (
SELECT
MAX(patron_record_num) AS max_record_num,
NAME,
ptype_code,
birth_date,
created

FROM
dupes
GROUP BY 5,2,3,4
)t2
ON t1.birth_date = t2.birth_date AND t1.patron_record_num = t2.max_record_num 

--WHERE t1.ptype_code = '2'
GROUP BY 3,1,5,6,7,8,9
HAVING COUNT(t1.name) = 1
ORDER BY 4,6,1,3