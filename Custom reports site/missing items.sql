/*
Jeremy Goldstein
Minuteman Library Network

Identifies titles with copies that are likely missing given recent checkout history and the number of billed/lost/missing copies
*/
SELECT
id2reckey(i.id)||'a' AS item_number,
id2reckey(c.bib_record_id)||'a' AS bib_number,
c.title,
i.last_checkout_gmt::DATE AS last_out_date,
i.item_status_code,
i.location_code,
c.recent_network_wide_turnover
FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = '' AND m.creation_date_gmt < (NOW() - INTERVAL '1 year')
JOIN
sierra_view.bib_record_item_record_link bl
ON
i.id = bl.item_record_id
JOIN
(
SELECT
b.bib_record_id,
b.best_title AS title,
ROUND(1.0 * (SUM(i.last_year_to_date_checkout_total) + SUM(i.year_to_date_checkout_total))/COUNT(i.id),2) AS recent_network_wide_turnover

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.record_metadata m
ON
i.id = m.id AND m.campus_code = ''
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.bcode3 NOT IN ('g','o','c','r','z','q','n','!')
--{{#if Exclude}}
LEFT JOIN
sierra_view.subfield v
ON
i.id = v.record_id AND v.field_type_code = 'v'
--{{/if Exclude}}

WHERE
b.material_code IN ({{mat_type}})
GROUP BY 1,2
HAVING 
(SUM(i.last_year_to_date_checkout_total) + SUM(i.year_to_date_checkout_total))/COUNT(i.id) > 3
{{#if Exclude}}
--use to weed out items with volume fields, which in some cases may throw off results
AND COUNT(v.*) = 0 
{{/if Exclude}}

ORDER BY 3 DESC
)c
ON
bl.bib_record_id = c.bib_record_id


WHERE
((i.item_status_code NOT IN ('n','$','w','o','r','e','q','!') 
AND i.last_checkout_gmt < (NOW() - INTERVAL '1 year'))
OR i.item_status_code IN ('m','z'))
AND i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND NOT EXISTS (
SELECT
i.id
FROM
sierra_view.checkout co
WHERE
co.item_record_id = i.id
)