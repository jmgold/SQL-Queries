/*
Jeremy Goldstein
Minuteman Library Network

Gathers various patron record statistics grouped on a choice of geography
Census block geoids are stored in patron census fields and can be used to
join results to census data
*/

SELECT
{{geo}},
/*Possible options
SUBSTRING(a.postal_code,'^\d{5}') AS zip_code

CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content||tract.content||SUBSTRING(block.content,1,1)
END AS geoid

CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content||tract.content
END AS geoid

CASE
	WHEN stateid.content IS NULL THEN 'no data'
	WHEN stateid.content = '' THEN stateid.content
	ELSE stateid.content||county.content
END AS geoid
*/
COUNT(DISTINCT p.id) AS total_patrons,
SUM(p.checkout_total) AS total_checkouts,
SUM(p.renewal_total) AS total_renewals,
SUM(p.checkout_total + p.renewal_total) AS total_circ,
SUM(p.checkout_count) AS total_checkouts_current,
COUNT(DISTINCT h.id) AS total_holds_current,
ROUND(AVG(DATE_PART('year',AGE(CURRENT_DATE,p.birth_date_gmt::DATE)))) AS avg_age,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= {{new_date}}) AS total_new_patrons,
--set date you wish to use for determining if a patron is considered to be new
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= {{active_date}}) AS total_active_patrons,
--set date you wish to use to determine if a patron is considered to be active
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= {{active_date}}) AS NUMERIC (12,2))) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2)), 4) ||'%' AS pct_active,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_blocked_patrons,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as numeric (12,2)) / cast(COUNT(DISTINCT p.id) as numeric (12,2))),4) ||'%' AS pct_blocked

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND a.patron_record_address_type_id = '1'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
LEFT JOIN
sierra_view.hold h
ON
p.id = h.patron_record_id
--for census field
LEFT JOIN
sierra_view.subfield stateid
ON
stateid.record_id = p.id AND stateid.field_type_code = 'k' AND stateid.tag = 's'
LEFT JOIN
sierra_view.subfield county
ON
county.record_id = p.id AND county.field_type_code = 'k' AND county.tag = 'c'
LEFT JOIN
sierra_view.subfield tract
ON
tract.record_id = p.id AND tract.field_type_code = 'k' AND tract.tag = 't'
LEFT JOIN
sierra_view.subfield block
ON
block.record_id = p.id AND block.field_type_code = 'k' AND block.tag = 'b'


WHERE p.ptype_code IN ({{ptype}})

GROUP BY 1
ORDER BY 2 DESC