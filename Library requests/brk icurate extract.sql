--english print items and orders for Arlington, not included withdrawn items

/*WITH br_bibs AS
(
SELECT
l.bib_record_id,
(
*/
SELECT 
ISBN
FROM(
SELECT
DISTINCT b.id,
(SELECT SUBSTRING(s.content FROM '^\d{9,12}[\d|X]')

FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS ISBN

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.language_code = 'eng'
LEFT JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id  
AND i.location_code ~ '^br'
AND i.item_status_code NOT IN ('w','n','m','$')
AND i.icode1 NOT IN ('001','002','003','004','005','006', '106', '116','118')
LEFT JOIN
sierra_view.bib_record_order_record_link ol
ON
b.bib_record_id = ol.bib_record_id
LEFT JOIN
sierra_view.order_record o
ON
ol.order_record_id = o.id AND o.accounting_unit_code_num = '6'
/*LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'*/

WHERE i.id IS NOT NULL OR o.id IS NOT NULL
AND b.material_code IN ('9','a','e','o','p','t')
)a
WHERE ISBN IS NOT NULL
/*GROUP BY 1,2
HAVING
COUNT(i.id) FILTER(WHERE v.field_content IS NOT NULL) = 0
)


SELECT
brb.isbn AS "020"

FROM
br_bibs brb
*/
