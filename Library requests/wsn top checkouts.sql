/*
Jeremy Goldstein
Minuteman Library Network

Top checkouts list for weekly social media post at Weston
*/
SELECT
b.best_title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1),
b.publish_year,
m.creation_date_gmt::DATE AS created_date,
COUNT(l.bib_record_id) AS total_checkouts
FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata m
ON
b.bib_record_id = m.id
WHERE
--limit to checkouts
c.op_code = 'o' 
AND c.transaction_gmt::DATE >= (NOW()::DATE - INTERVAL '7 days')
--limit by transaction location
AND c.stat_group_code_num BETWEEN '800' AND '802'
GROUP BY 1,2,3,4
ORDER BY COUNT(l.bib_record_id) DESC
LIMIT 100