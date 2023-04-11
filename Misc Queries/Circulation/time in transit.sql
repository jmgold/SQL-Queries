/*
Jeremy Goldstein
Minuteman Library Network

For past month, calculate avg time copies of popular titles spent in transit or sitting on the holdshelf
*/

--Days spent in transit
WITH in_transit AS(
SELECT
l.bib_record_id,
COUNT(i.id) AS items_in_transit,
ROUND(AVG(CURRENT_DATE - SUBSTRING(v.field_content FROM 5 FOR 11)::DATE),1) AS avg_days_in_transit

FROM
sierra_view.item_record i
JOIN sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'm' AND v.field_content LIKE '%IN TRANSIT%'
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id

WHERE
i.item_status_code = 't'
--filter out titles that were just put in transit to avoid skewing data
AND SUBSTRING(v.field_content FROM 5 FOR 11)::DATE != CURRENT_DATE
--filter out items that became lost in transit
AND SUBSTRING(v.field_content FROM 5 FOR 11)::DATE > (CURRENT_DATE - INTERVAL '1 month')
GROUP BY 1

)

--calculate days spent on holdshelf and merge with in_transit data
SELECT 
b.best_title,
rm.record_type_code||rm.record_num||'a' AS bnumber,
SUM(h.removed_gmt::DATE - h.on_holdshelf_gmt::DATE) AS days_on_shelf,
COUNT(h.*) AS times_on_shelf,
SUM(h.removed_gmt::DATE - h.on_holdshelf_gmt::DATE)/COUNT(h.*) AS avg_days_on_shelf,
t.items_in_transit,
t.avg_days_in_transit,
SUM(h.removed_gmt::DATE - h.on_holdshelf_gmt::DATE)/COUNT(h.*) + COALESCE(t.avg_days_in_transit,0) AS total_days_out_of_circ

FROM
sierra_view.hold_removed h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
LEFT JOIN in_transit t
ON
l.bib_record_id = t.bib_record_id

WHERE
on_holdshelf_gmt IS NOT NULL

GROUP BY 1,2,6,7
ORDER BY 4 DESC
