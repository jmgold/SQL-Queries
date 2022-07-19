/*
Jeremy Goldstein
Minuteman Library Network

Captures the daily value of all items checked out in each stat group for each itype and mattype.
In Minuteman used as data source for a daily checkout value dashboard built in Google Data Studio
*/
SELECT
to_char(o.transaction_gmt,'YYYY-MM-DD') AS "Date",
SUBSTRING(s.name,1,3) AS "Stat Group",
loc.name AS Library,
it.name AS iType,
M.name AS "Mat Type",
SUM(i.price)::MONEY AS VALUE,
COUNT(DISTINCT o.id) AS checkouts

FROM
sierra_view.circ_trans o
JOIN
sierra_view.item_record i
ON
o.item_record_id = i.id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.statistic_group_myuser s
ON
i.checkout_statistic_group_code_num = s.code
JOIN
sierra_view.location_myuser loc
ON
SUBSTRING(s.name,1,3) = loc.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.material_property_myuser M
ON
b.material_code = M.code

WHERE o.op_code = 'o' AND o.transaction_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'

GROUP BY 1,2,3,4,5
