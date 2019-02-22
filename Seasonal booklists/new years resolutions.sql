/*
Jeremy Goldstein
Minuteman Library Network

Produces list of available New Years resolution titles in adult collections for posting at https://www.minlib.net/booklists/recommended-reads/new-years
To diversify titles, query is made up of subquerries that each return a set number of titles in different subject areas 
*/

(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record br
ON
--Limit to english language books
b.bib_record_id = br.id AND br.language_code = 'eng'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
--Limit to available titles, with a circulating status that is not in a childrens or YA collection
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') NOT LIKE '%fiction%' AND REPLACE(d.index_entry, ' ', '') LIKE '%housekeeping%'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3,4) a
--Return random results each time query is run
ORDER BY RANDOM()
LIMIT 10)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record br
ON
--Limit to english language books
b.bib_record_id = br.id AND br.language_code = 'eng'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
--Limit to available titles, with a circulating status that is not in a childrens or YA collection
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') NOT LIKE '%fiction%' AND (REPLACE(d.index_entry, ' ', '') LIKE '%weightloss%' OR REPLACE(d.index_entry, ' ', '') LIKE '%reducingdiets%')
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 15)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record br
ON
--Limit to english language books
b.bib_record_id = br.id AND br.language_code = 'eng'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') NOT LIKE '%fiction%' AND REPLACE(d.index_entry, ' ', '') LIKE '%kindness%'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 5)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
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
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.bib_record br
ON
--Limit to english language books
b.bib_record_id = br.id AND br.language_code = 'eng'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
JOIN
sierra_view.phrase_entry d
ON
b.bib_record_id = d.record_id AND d.varfield_type_code = 'd'
--Limit to a subject
AND REPLACE(d.index_entry, ' ', '') NOT LIKE '%fiction%' AND REPLACE(d.index_entry, ' ', '') LIKE '%physicalfitness%'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3,4) a
ORDER BY RANDOM()
LIMIT 15)
