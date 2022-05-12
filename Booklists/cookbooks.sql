/*
Jeremy Goldstein
Minuteman Library Newtork
Used to generate booklist at www.minlib.net
*/
SELECT 
a.field_booklist_entry_encore_url,
a.title,
a.field_booklist_entry_author,
a.field_booklist_entry_cover
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
--Generate cover image from Syndetics
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover,
SUM(i.checkout_total)
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
--AND
--i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
--Limit to adult collections
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
--Limit to English
JOIN
sierra_view.bib_record r
ON b.bib_record_id = r.id AND r.language_code = 'eng'
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
 
WHERE
b.material_code = 'a' AND b.publish_year >= (DATE_PART('year', NOW())-2) 
AND b.bib_record_id IN
(
SELECT
l.bib_record_id

FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.item_record_property ip
ON
l.item_record_id = ip.item_record_id AND ip.call_number_norm LIKE '%641.5%'
)
GROUP BY 1,2,3
ORDER BY SUM(i.checkout_total)
LIMIT 200
) a
ORDER BY RANDOM()
LIMIT 50;