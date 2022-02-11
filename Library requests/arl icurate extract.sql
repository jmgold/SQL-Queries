--english print items and orders for Arlington, not included withdrawn items

DROP TABLE IF EXISTS arl_bibs;

CREATE TEMP TABLE arl_bibs AS

SELECT
l.bib_record_id

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
LEFT JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id  
AND i.location_code ~ '^arl' AND SUBSTRING(i.location_code,4,1) != 'j'
AND i.item_status_code NOT IN ('w')
LEFT JOIN
sierra_view.bib_record_order_record_link ol
ON
b.bib_record_id = ol.bib_record_id
LEFT JOIN
sierra_view.order_record o
ON
ol.order_record_id = o.id AND o.accounting_unit_code_num = '2'
LEFT JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'v'

WHERE i.id IS NOT NULL OR o.id IS NOT NULL
GROUP BY 1
HAVING
COUNT(i.id) FILTER(WHERE v.field_content IS NOT NULL) = 0
;

DROP TABLE IF EXISTS isbn;

CREATE TEMP TABLE isbn AS

SELECT
s.record_id,
SUBSTRING(s.content FROM '^\d{9,12}[\d|X]') AS "isbns"
FROM arl_bibs b
JOIN
sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
;

SELECT
i.isbns AS "020"
--COALESCE(STRING_AGG(DISTINCT SUBSTRING(s3.content FROM '^\d+'),'|'),'') AS "024"

FROM
isbn i
JOIN
sierra_view.bib_record_property b
ON
i.record_id = b.bib_record_id AND b.material_code IN ('9','a','e','o','p','t')
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.language_code = 'eng'
LEFT JOIN
sierra_view.subfield o
ON
i.record_id = o.record_id AND o.marc_tag = '001'
/*LEFT JOIN
sierra_view.subfield s3
ON
bi.bib_record_id = s3.record_id AND s3.marc_tag = '024' AND s3.tag = 'a'

WHERE 
s3.content IS NOT NULL*/