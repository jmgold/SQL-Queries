/*
Jeremy Goldstein
Minuteman Library Network

Calculates the value of all items owned by your library checked out in a given time period
Is passed variables for date range, location and the field to group data by
*/

SELECT
{{grouping}},
CAST(SUM(i.price) AS MONEY) AS value,
COUNT(c.id) AS circ_count,
(CAST(SUM(i.price) AS MONEY) / COUNT(c.id)) as value_per_circ
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
JOIN sierra_view.bib_record b
ON
l.bib_record_id = b.id
JOIN
sierra_view.material_property mp
ON
b.bcode2 = mp.code
JOIN
sierra_view.material_property_name m
ON 
mp.id = m.material_property_id
JOIN
sierra_view.itype_property ip
ON
i.itype_code_num = ip.code_num
JOIN
sierra_view.itype_property_name it
ON 
ip.id = it.itype_property_id
JOIN
sierra_view.language_property lp
ON
b.language_code = lp.code
JOIN
sierra_view.language_property_name ln
ON
lp.id = LN.language_property_id
WHERE
c.op_code IN ('o', 'r')
AND
c.transaction_gmt::DATE >= {{relative_date}}
AND
i.location_code ~ {{location}}
GROUP BY 1
ORDER BY 1;