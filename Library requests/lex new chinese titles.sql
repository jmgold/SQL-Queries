SELECT
rm.record_type_code||rm.record_num||'a' AS item_number,
CASE
	WHEN vt.field_content IS NULL THEN b.best_title
	ELSE REGEXP_REPLACE(SUBSTRING(vt.field_content FROM 11),'\|[a-z]',' ','g')
END AS title,
b.best_title,
REGEXP_REPLACE(SUBSTRING(vt.field_content FROM 11),'\|[a-z]',' ','g') AS chinese_title,
CASE
	WHEN va.field_content IS NULL THEN b.best_author
	ELSE REGEXP_REPLACE(SUBSTRING(va.field_content FROM 11),'\|[a-z]',' ','g')
END AS author,
b.best_author,
REGEXP_REPLACE(SUBSTRING(va.field_content FROM 11),'\|[a-z]',' ','g') AS chinese_author,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS url

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^lex'
JOIN
sierra_view.bib_record br
ON
b.bib_record_id = br.id AND br.language_code = 'chi'
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND rm.creation_date_gmt::DATE >= '2020-01-01'
LEFT JOIN
sierra_view.varfield vt
ON
b.bib_record_id = vt.record_id AND vt.marc_tag = '880' AND vt.field_content ~ '^/|6245'
LEFT JOIN
sierra_view.varfield va
ON
b.bib_record_id = va.record_id AND va.marc_tag = '880' AND va.field_content ~ '^/|6100'
