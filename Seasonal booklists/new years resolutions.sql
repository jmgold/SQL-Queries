--Jeremy Goldstein
--Minuteman Library Network
--
--Produces list of available New Years resolution titles in adult collections for posting at https://www.minlib.net/booklists/recommended-reads/new-years
--To diversify titles, query is made up of subquerries that each return a set number of titles in different subject areas 

(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
B.best_title as title,
B.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
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
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' 
--Limit to a subject
AND LOWER(v.field_content) NOT LIKE '%fiction%' AND LOWER(v.field_content) LIKE '%housekeeping%'
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3) a
--Return random results each time query is run
ORDER BY RANDOM()
LIMIT 10)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
B.best_title as title,
B.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
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
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' 
--Limit to a subject
AND LOWER(v.field_content) NOT LIKE '%fiction%' AND (Lower(v.field_content) LIKE '%weight loss%' OR LOWER(v.field_content) LIKE '%reducing diets%')
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3) a
ORDER BY RANDOM()
LIMIT 15)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
B.best_title as title,
B.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
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
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' 
--Limit to a subject
AND LOWER(v.field_content) NOT LIKE '%fiction%' AND LOWER(v.field_content) LIKE '%kindness%'
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3) a
ORDER BY RANDOM()
LIMIT 5)
UNION
(SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
B.best_title as title,
B.best_author as field_booklist_entry_author,
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
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
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' 
--Limit to a subject
AND LOWER(v.field_content) NOT LIKE '%fiction%' AND LOWER(v.field_content) LIKE '%physical fitness%'
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
--Limit to books and a date range
WHERE
b.material_code = 'a' AND b.publish_year >= '2000'
GROUP BY 1,2,3) a
ORDER BY RANDOM()
LIMIT 15)