--Jeremy Goldstein
--Minuteman Library Network

--top 100 most checked out titles in the network for the decade

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "field_booklist_entry_encore_url",
b.best_title as title,
REGEXP_REPLACE(REGEXP_REPLACE(TRIM(REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1)),'^\d{4}- ',''),' prf$','') AS field_booklist_entry_author,
SUM(i.checkout_total),
'https://syndetics.com/index.aspx?upc='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND SUBSTRING(i.location_code,4,1) NOT IN ('j')
WHERE
b.publish_year > '2009' AND b.material_code = 'j'
GROUP BY 2,1,3
ORDER BY 4 desc
LIMIT 100