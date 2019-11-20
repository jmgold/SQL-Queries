/*
Jeremy Goldstein
Minuteman Library Network

Identifies popular titles from x months/years ago based on checkouts in the reading history table
*/

SELECT
b.best_title,
b.best_author,
COUNT(b.id)

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.reading_history h
ON
b.bib_record_id = h.bib_record_metadata_id
AND --h.checkout_gmt::DATE = NOW():: DATE - INTERVAL '14 years'
BETWEEN (NOW()::DATE - INTERVAL '62 months') AND (NOW()::DATE - INTERVAL '58 months')

WHERE
b.material_code = 'a'

GROUP BY 1,2
ORDER BY 3 DESC

LIMIT 50