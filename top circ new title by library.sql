/*
Jeremy Goldstein
Minuteman Library network

Retrieves the top circulating title at each library based on items created within the past year
*/

DROP TABLE IF EXISTS temp_item_data
;
--gathers checkout data used by temp_loc_circ_counts table
CREATE TEMP TABLE temp_item_data AS
SELECT
l.name AS library,
i.id as item_id,
i.checkout_total,
i.renewal_total

FROM
sierra_view.item_view i

--pull library name from location code
JOIN
sierra_view.location_myuser l
on substring(i.location_code from 1 for 3) = l.code 

--filter to items created in the past year
WHERE
i.record_creation_date_gmt > (localtimestamp - interval '1 year')
AND substring(i.location_code from 1 for 3) NOT IN ('mls', 'int', 'cmc')

;

DROP TABLE IF EXISTS temp_loc_circ_counts;
CREATE TEMP TABLE temp_loc_circ_counts AS
SELECT
t.library,
b.bib_record_id,
(SUM(t.checkout_total) + SUM(t.renewal_total)) as circ_total

FROM
temp_item_data as t

JOIN
sierra_view.bib_record_item_record_link l
ON
t.item_id = l.item_record_id
JOIN sierra_view.bib_record_property b
ON
--limit to books
l.bib_record_id = b.bib_record_id AND b.material_code = 'a'

GROUP BY
t.library,
b.bib_record_id

--filter out items that have not circed
HAVING
(SUM(t.checkout_total) + SUM(t.renewal_total)) > 1

ORDER BY
t.library,
circ_total
;

SELECT
--DISTINCT ON (field_booklist_entry_location)
t.library AS field_booklist_entry_location,
--Encore Link
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(t.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author,
--Cover image from Syndetics
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover,
t.circ_total
FROM
(
SELECT
t2.library,
MAX(t2.circ_total) as max_circ
FROM
temp_loc_circ_counts as t2
GROUP BY 1
) AS C

JOIN
temp_loc_circ_counts as t
ON
c.library = t.library AND c.max_circ = t.circ_total
JOIN
sierra_view.bib_record_property b
ON
t.bib_record_id = b.bib_record_id
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'

GROUP BY 1,2,3,4,6
ORDER BY 1;

