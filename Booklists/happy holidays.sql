(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND i.itype_code_num NOT IN ('100', '101', '104', '105', '108', '150', '151', '152', '155', '156', '159', '160')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') LIKE '%christmas%' AND (REPLACE(d.index_entry, ' ', '') LIKE '%decorations%' OR REPLACE(d.index_entry, ' ', '') LIKE '%history%' OR REPLACE(d.index_entry, ' ', '') LIKE '%cook%')
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 25)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
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
AND i.itype_code_num NOT IN ('100', '101', '104', '105', '108', '150', '151', '152', '155', '156', '159', '160')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') LIKE '%hanukkah%'
WHERE
b.material_code = 'a' AND b.publish_year >= '1980'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 15)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
--AND i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND i.itype_code_num NOT IN ('100', '101', '104', '105', '108', '150', '151', '152', '155', '156', '159', '160')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') LIKE '%kwanza%' --AND (v.field_content LIKE '%decorations%' OR v.field_content LIKE '%history%' OR v.field_content LIKE '%cooking%' OR v.field_content LIKE '%Cook%')
WHERE
b.material_code = 'a' AND b.publish_year >= '1980'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 10)
