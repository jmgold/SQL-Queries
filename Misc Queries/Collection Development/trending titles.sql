/*
Jeremy Goldstein
Minuteman Library Network
Retrives top 50 titles based on recently placed holds
*/

WITH holds_count AS
(
SELECT
t.bib_record_id,
COUNT(t.bib_record_id) AS holds_on_title

FROM
(SELECT
CASE
	WHEN r.record_type_code = 'i' THEN (
		SELECT
		l.bib_record_id
		FROM
		sierra_view.bib_record_item_record_link as l
		WHERE
		l.item_record_id = h.record_id
		LIMIT 1)
    
    WHEN r.record_type_code = 'b' THEN h.record_id
    ELSE NULL
END AS bib_record_id

FROM
sierra_view.hold h
JOIN
sierra_view.record_metadata as r
ON
r.id = h.record_id

WHERE
h.placed_gmt::DATE > (CURRENT_DATE - INTERVAL '2 days') 
) t

GROUP BY
t.bib_record_id
HAVING
COUNT(t.bib_record_id) > 1

ORDER BY
holds_on_title
)

SELECT
ROW_NUMBER() OVER (ORDER BY hc.holds_on_title DESC) AS field_booklist_entry_rank,
rm.record_type_code||rm.record_num||'a' AS bib_number,
best_title as title,
b.best_author AS author,
hc.holds_on_title

FROM
holds_count AS hc
JOIN
sierra_view.bib_record_property b
ON
hc.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
hc.bib_record_id = rm.id

GROUP BY 2,3,4,5
ORDER BY hc.holds_on_title DESC
LIMIT 50