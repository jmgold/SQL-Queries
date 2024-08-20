--Jeremy Goldstein
--Minuteman Library Network

--top 100 most checked out titles in the network for the year

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "field_booklist_entry_encore_url",
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id AND SUBSTRING(i.location_code,4,1) NOT IN ('j')
JOIN
sierra_view.record_metadata m
ON
i.id = m.id
WHERE
b.publish_year > '2009' AND b.material_code = 'a' AND m.creation_date_gmt::DATE < '2019-01-01'
AND NOT (i.location_code ~ '^lex' AND i.icode1 = '221')
GROUP BY 1,2,3,4
ORDER BY AVG(ROUND((CAST((i.checkout_total * 14) AS NUMERIC (12,2)) / (CURRENT_DATE - m.creation_date_gmt::DATE)),6)) desc
LIMIT 100