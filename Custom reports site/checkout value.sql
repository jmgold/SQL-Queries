/*
Jeremy Goldstein
Minuteman Library Network

Calculates the value of all items owned by your library checked out in a given time period
Is passed variables for date range, location and the field to group data by
*/

SELECT
*,
'' AS "CHECKOUT VALUE",
'' AS "https://sic.minlib.net/reports/26"
FROM
(
SELECT
{{grouping}},
/*Options are
it.name AS itype
ln.name AS language
m.name AS mat_type
i.icode1 AS scat_code
i.location_code AS location
*/
CAST(SUM(i.price) AS MONEY) AS value,
COUNT(DISTINCT c.id) AS circ_count,
(CAST(SUM(i.price) AS MONEY) / COUNT(DISTINCT c.id)) as value_per_circ

FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN sierra_view.bib_record b
ON
l.bib_record_id = b.id
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.material_property_myuser M
ON
bp.material_code = m.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code

WHERE
c.op_code IN ('o', 'r')
AND
c.transaction_gmt::DATE {{relative_date}}
/*
	relative_date possible values
	= (NOW()::DATE - INTERVAL '1 day') (yesterday)
	BETWEEN (NOW()::DATE - INTERVAL '1 week') AND (NOW()::DATE - INTERVAL '1 day') (last week)
	BETWEEN (NOW()::DATE - INTERVAL '1 month') AND (NOW()::DATE - INTERVAL '1 day') (last month)
	*/
AND
i.location_code ~ '{{location}}'
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
GROUP BY 1
ORDER BY 1
)a