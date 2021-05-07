/*
Jeremy Goldstein
Minuteman Library Network
Gathers the top titles in the network ,that are not owned locally, limited to one or more languages, grouped by a choice of performance metrics
*/

WITH hold_count AS
	(SELECT
	l.bib_record_id,
	COUNT(DISTINCT h.id) AS count_holds_on_title
	--reconciles bib,item and volume level holds

	FROM
	sierra_view.hold h
	JOIN
	sierra_view.bib_record_item_record_link l
	ON
	h.record_id = l.item_record_id OR h.record_id = l.bib_record_id

	GROUP BY 1
	HAVING
	COUNT(DISTINCT h.id) > 1
)

SELECT
'b'||mb.record_num||'a' AS bib_number,
b.best_title AS title,
CASE
	WHEN vt.field_content IS NULL THEN b.best_title
   ELSE REGEXP_REPLACE(SPLIT_PART(REGEXP_REPLACE(vt.field_content,'^.*\|a',''),'|',1),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
END AS title_nonroman,
b.best_author AS author,
CASE
	WHEN va.field_content IS NULL THEN b.best_author
   ELSE REGEXP_REPLACE(REPLACE(REPLACE(REGEXP_REPLACE(va.field_content,'^.*\|a',''),'|d',' '),'|q',' '),'\s?(\.|\,|\:|\/|\;|\=)\s?$','')
END AS author_nonroman,
b.publish_year,
{{grouping}}

/*
Grouping options
AVG(ROUND((CAST((i.checkout_total * 14) AS NUMERIC (12,2)) / (CURRENT_DATE - m.creation_date_gmt::DATE)),6)) FILTER (WHERE m.creation_date_gmt::DATE != CURRENT_DATE) AS utilization
ROUND(CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2))/CAST(COUNT (i.id) AS NUMERIC (12,2)), 2) AS turnover
SUM(i.year_to_date_checkout_total + i.last_year_to_date_checkout_total) AS total_checkouts
SUM(i.checkout_total + i.renewal_total) AS total_circulation
SUM(i.checkout_total) AS total_checkouts
SUM(i.year_to_date_checkout_total) AS total_year_to_date_checkouts
SUM(i.last_year_to_date_checkout_total) AS total_last_year_to_date_checkouts
COALESCE(h.count_holds_on_title,0) AS total_holds
*/

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
i.id = l.item_record_id AND i.item_status_code NOT IN ({{item_status_codes}})
AND {{age_level}}
	/*
	SUBSTRING(i.location_code,4,1) NOT IN ('y','j') --adult
	SUBSTRING(i.location_code,4,1) = 'j' --juv
	SUBSTRING(i.location_code,4,1) = 'y' --ya
	i.location_code ~ '\w' --all
	*/
JOIN
sierra_view.record_metadata m
ON
i.id = m.id
JOIN
sierra_view.bib_record br
ON
l.bib_record_id = br.id
AND br.bcode3 NOT IN ('g','o','r','z','l','q','n')
JOIN
sierra_view.record_metadata mb
ON
b.bib_record_id = mb.id
LEFT JOIN
hold_count AS h
ON
b.bib_record_id = h.bib_record_id
LEFT JOIN
sierra_view.varfield vt
ON
b.bib_record_id = vt.record_id AND vt.marc_tag = '880' AND vt.field_content ~ '^/|6245'
LEFT JOIN
sierra_view.varfield va
ON
b.bib_record_id = va.record_id AND va.marc_tag = '880' AND va.field_content ~ '^/|6100'

WHERE
b.material_code IN ({{mat_type}})
AND br.language_code IN ({{language}})

GROUP BY
1,2,3,4,5,6,h.count_holds_on_title
HAVING
COUNT(i.id) FILTER (WHERE i.location_code ~ '{{location}}') = 0
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND COUNT(i.id) FILTER (WHERE i.location_code !~ '{{location}}' AND m.creation_date_gmt::DATE < {{created_date}}) > 0
ORDER BY 7 DESC
LIMIT {{qty}}