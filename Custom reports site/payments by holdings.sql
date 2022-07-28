/*
Jeremy Goldstein
Minuteman Library Network

Provides estimates for the amount paid and the cost per circ for various segments of the library's collection
Numbers are rough estimates as there is not a direct link between order and item records in Sierra
and many cases exist in which an item cannot be associated with an order or vice versa
*/

--Gathers the payment data for each bib record, to be joined with a similar item data table.
WITH payments AS (
SELECT
bo.bib_record_id,
SUM(p.paid_amount) AS paid_amount,
SUM(p.copies) AS copies_paid

FROM
sierra_view.order_record_paid p
JOIN
sierra_view.order_record o
ON
p.order_record_id = o.id
AND 
CASE
	--location using the form ^ac as the first 2 characters of our location codes designate the organization
	WHEN  {{location}} = '^ac' THEN o.accounting_unit_code_num = '1'
	WHEN  {{location}} = '^ar' THEN o.accounting_unit_code_num = '2'
	WHEN  {{location}} = '^as' THEN o.accounting_unit_code_num = '3'
	WHEN  {{location}} = '^be' THEN o.accounting_unit_code_num = '4'
	WHEN  {{location}} = '^bl' THEN o.accounting_unit_code_num = '5'
	WHEN  {{location}} = '^br' THEN o.accounting_unit_code_num = '6'
	WHEN  {{location}} = '^ca' THEN o.accounting_unit_code_num = '7'
	WHEN  {{location}} = '^co' THEN o.accounting_unit_code_num = '8'
	WHEN  {{location}} = '^dd' THEN o.accounting_unit_code_num = '9'
	WHEN  {{location}} = '^de' THEN o.accounting_unit_code_num = '10'
	WHEN  {{location}} = '^do' THEN o.accounting_unit_code_num = '11'
	WHEN  {{location}} = '^fp' THEN o.accounting_unit_code_num = '12'
	WHEN  {{location}} = '^fr' THEN o.accounting_unit_code_num = '13'
	WHEN  {{location}} = '^fs' THEN o.accounting_unit_code_num = '14'
	WHEN  {{location}} = '^ho' THEN o.accounting_unit_code_num = '15'
	WHEN  {{location}} = '^la' THEN o.accounting_unit_code_num = '16'
	WHEN  {{location}} = '^le' THEN o.accounting_unit_code_num = '17'
	WHEN  {{location}} = '^li' THEN o.accounting_unit_code_num = '18'
	WHEN  {{location}} = '^ma' THEN o.accounting_unit_code_num = '19'
	WHEN  {{location}} = '^me' THEN o.accounting_unit_code_num = '21'
	WHEN  {{location}} = '^mi' THEN o.accounting_unit_code_num = '22'
	WHEN  {{location}} = '^ml' THEN o.accounting_unit_code_num = '23'
	WHEN  {{location}} = '^mw' THEN o.accounting_unit_code_num = '25'
	WHEN  {{location}} = '^na' THEN o.accounting_unit_code_num = '26'
	WHEN  {{location}} = '^ne' THEN o.accounting_unit_code_num = '28'
	WHEN  {{location}} = '^no' THEN o.accounting_unit_code_num = '29'
	WHEN  {{location}} = '^nt' THEN o.accounting_unit_code_num = '30'
	WHEN  {{location}} = '^ol' THEN o.accounting_unit_code_num = '24'
	WHEN  {{location}} = '^so' THEN o.accounting_unit_code_num = '31'
	WHEN  {{location}} = '^st' THEN o.accounting_unit_code_num = '32'
	WHEN  {{location}} = '^su' THEN o.accounting_unit_code_num = '33'
	WHEN  {{location}} = '^wl' THEN o.accounting_unit_code_num = '37'
	WHEN  {{location}} = '^wa' THEN o.accounting_unit_code_num = '34'
	WHEN  {{location}} = '^wy' THEN o.accounting_unit_code_num = '41'
	WHEN  {{location}} = '^we' THEN o.accounting_unit_code_num = '35'
	WHEN  {{location}} = '^wi' THEN o.accounting_unit_code_num = '36'
	WHEN  {{location}} = '^wo' THEN o.accounting_unit_code_num = '38'
	WHEN  {{location}} = '^ws' THEN o.accounting_unit_code_num = '39'
	WHEN  {{location}} = '^ww' THEN o.accounting_unit_code_num = '40'
	WHEN  {{location}} = '^re' THEN o.accounting_unit_code_num = '43'
	WHEN  {{location}} = '^sh' THEN o.accounting_unit_code_num = '27'
END
AND p.paid_date_gmt::DATE BETWEEN {{paid_start_date}} AND {{paid_end_date}}
JOIN
sierra_view.bib_record_order_record_link bo
ON
o.id = bo.order_record_id

GROUP BY 1
),
items AS (
SELECT
bi.bib_record_id,
/*
grouping options
STRING_AGG(DISTINCT i.location_code, ', ') --location
STRING_AGG(DISTINCT i.icode1::VARCHAR, ', ') --scat_code
STRING_AGG(DISTINCT m.name, ', ') --mat_type
STRING_AGG(DISTINCT ln.name, ', ') --language
STRING_AGG(DISTINCT it.name, ', ') --itype
*/
{{grouping}} AS grouping,
COUNT(i.id) AS item_total,
SUM(i.checkout_total + i.renewal_total) AS total_circ

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link bi
ON
i.id = bi.item_record_id AND i.location_code ~ {{location}}
JOIN
sierra_view.bib_record b
ON
bi.bib_record_id = b.id
JOIN
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code
JOIN
sierra_view.material_property_myuser m
ON
b.bcode2 = m.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id
AND rmi.creation_date_gmt::DATE BETWEEN {{cat_start_date}} AND {{cat_end_date}}

GROUP BY 1
)

SELECT
DISTINCT i.grouping,
SUM(i.item_total) AS items_added,
SUM(p.copies_paid) AS copies_paid,
SUM(p.paid_amount)::MONEY AS paid_total,
SUM(i.total_circ) AS total_circ,
ROUND(SUM(p.paid_amount)/NULLIF(SUM(i.total_circ),0),2)::MONEY AS cost_per_circ

FROM
payments p
JOIN
items i
ON
p.bib_record_id = i.bib_record_id

GROUP BY 1

UNION

SELECT 
'unmatched',
SUM(items_added),
SUM(copies_paid),
SUM(paid_total)::MONEY,
SUM(total_circ),
ROUND(SUM(paid_total)/NULLIF(SUM(total_circ),0),2)::MONEY AS cost_per_circ

FROM(
SELECT
'unmatched payments',
NULL AS items_added,
SUM(p.copies_paid)  AS copies_paid,
SUM(p.paid_amount) AS paid_total,
NULL AS total_circ,
NULL AS cost_per_circ

FROM
payments p

WHERE p.bib_record_id NOT IN (
SELECT
i.bib_record_id
FROM items i
)

UNION

SELECT
'unmatched items',
SUM(i.item_total) AS items_added,
NULL  AS copies_paid,
NULL AS paid_total,
SUM(i.total_circ) AS total_circ,
NULL AS cost_per_circ

FROM
items i

WHERE i.bib_record_id NOT IN (
SELECT
p.bib_record_id
FROM payments p
)
)inner_query

ORDER BY 1
