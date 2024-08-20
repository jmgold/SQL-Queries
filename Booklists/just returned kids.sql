/*
Jeremy Goldstein
Minuteman Library Network

Just returned Item list for www.minlib.net
*/
SELECT
'https://catalog.minlib.net/Record/b'||rm.record_num AS field_booklist_entry_encore_url,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
CASE
	--use ISBN for print materials
	WHEN b.material_code IN ('a','2','4','9','c','i','o')
		THEN (SELECT
		'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
		FROM
		sierra_view.subfield s
		WHERE
		b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
		ORDER BY s.occ_num
		LIMIT 1)
	--use UPC for everything else
	ELSE (
		SELECT
		'https://syndetics.com/index.aspx?upc='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
		FROM
		sierra_view.subfield s
		WHERE
		b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
		ORDER BY s.occ_num
		LIMIT 1)
END AS field_booklist_entry_cover

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
JOIN
sierra_view.circ_trans c
ON
b.bib_record_id = c.bib_record_id AND c.op_code = 'i' AND c.transaction_gmt > (CURRENT_DATE - INTERVAL '1 day')
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND SUBSTRING(i.location_code,4,1) IN ('j','y')

GROUP BY 1,2,3,4,c.transaction_gmt
ORDER BY c.transaction_gmt DESC
LIMIT 50