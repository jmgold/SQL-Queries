WITH category_list AS(
SELECT
b.bib_record_id,
CASE
	WHEN b.material_code = '4' THEN 'AUDIOBOOK'
	WHEN b.material_code IN ('5','u') THEN 'DVD'
	WHEN i.itype_code_num BETWEEN '100' AND '133' THEN 'YA'	
	WHEN b.material_code = '2' THEN 'LARGE PRINT'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^mystery' THEN 'MYSTERY'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^science fiction' THEN 'SCIENCE FICTION'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^biography' THEN 'BIOGRAPHY'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^cookbooks' THEN 'COOKBOOKS'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^graphic' THEN 'GRAPHIC NOVELS'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^fiction' THEN 'FICTION'
	WHEN REGEXP_REPLACE(ip.call_number_norm,'^(new|lucky u)/s','') ~ '^\d{3}' THEN 'NON-FICTION'
END AS category

FROM
sierra_view.circ_trans t
JOIN
sierra_view.item_record i
ON
t.item_record_id = i.id AND i.location_code ~ '^we'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id

WHERE t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '2 weeks'
)

SELECT *
FROM (
SELECT
cl.category,
b.best_title AS title,
b.best_author AS author,
rm.record_type_code||rm.record_num||'a' AS bnumber,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS url,
ROW_NUMBER() OVER(PARTITION BY cl.category ORDER BY COUNT(DISTINCT t.id) FILTER(WHERE t.ptype_code = '37') DESC,rm.creation_date_gmt DESC) AS rank,
COUNT(DISTINCT t.id) FILTER(WHERE t.ptype_code = '37') AS wel_ptype_transactions,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code = 'o') AS checkout_total,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code = 'o' AND t.stat_group_code_num BETWEEN '750' AND '779') AS wel_checkout_total,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code LIKE 'n%') AS holds_placed,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code LIKE 'n%' AND t.patron_home_library_code ~ '^we') AS wel_holds_placed

FROM
category_list cl
JOIN
sierra_view.bib_record_item_record_link l
ON
cl.bib_record_id = l.bib_record_id AND cl.category IS NOT NULL
JOIN
sierra_view.circ_trans t
ON
l.bib_record_id = t.bib_record_id
JOIN
sierra_view.bib_record_property b
ON
cl.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id

WHERE t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '2 weeks'
AND t.op_code IN ('o','nb','ni')
--AND t.ptype_code = '37'

GROUP BY 1,2,3,4,5,rm.creation_date_gmt) inner_query
WHERE rank <= 10
ORDER BY category, rank
/*
-Adult fiction
-Mystery
-Science Fiction
-Graphic Novels
-YA
Non-fiction
-Biography
-Cookbooks
-DVDs
-Audiobooks
*/