--Jeremy Goldstein
--jgoldstein@minlib.net

--Generates a booklist of 25 random books that are currently available, published within 5 years.
--in an adult collection, and in a given subject area

SELECT *
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS "URL",
b.best_title,
b.best_author
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
AND SUBSTRING(i.location_code,4,1) NOT IN ('j', 'y')
JOIN
sierra_view.varfield_view v
ON
b.bib_record_id = v.record_id AND v.varfield_type_code = 'd' 
--Limit to a subject
AND v.field_content LIKE '%comics%'
WHERE
b.material_code = 'a' AND b.publish_year >= '2014') a
ORDER BY RANDOM()
LIMIT 25;