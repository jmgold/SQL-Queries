--Jeremy Goldstein
--Minuteman Library Network

--Gathers the most requested title in each language.  Works but too little data to be useful.


DROP TABLE IF EXISTS temp_holds_data
;
--gathers hold data used by temp_location_holds_counts table
CREATE TEMP TABLE temp_holds_data AS
SELECT
lp.name,
h.record_id,
r.record_type_code, 
r.record_num,
--reconciles bib,item and volume level holds
CASE
    WHEN r.record_type_code = 'i' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_item_record_link as l
        WHERE
        l.item_record_id = h.record_id
        LIMIT 1
    )
    WHEN r.record_type_code = 'j' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_volume_record_link as l
        WHERE
        l.volume_record_id = h.record_id
        LIMIT 1
    )
    WHEN r.record_type_code = 'b' THEN (
        h.record_id
    )
    ELSE NULL
END AS bib_record_id

FROM
sierra_view.hold as h

JOIN
sierra_view.record_metadata as r
ON
  r.id = h.record_id

JOIN
sierra_view.bib_record b
ON
h.record_id = b.id

JOIN
sierra_view.language_property_myuser lp
ON
b.language_code =lp.code
;

--gathers hold count for each language
DROP TABLE IF EXISTS temp_language_holds_counts;
CREATE TEMP TABLE temp_language_holds_counts AS
SELECT
t.name,
t.bib_record_id,
count(t.bib_record_id) as count_holds_on_title

FROM
temp_holds_data as t

GROUP BY
t.name,
t.bib_record_id

HAVING
count(t.bib_record_id) > 1

ORDER BY
t.name,
count_holds_on_title
;

--Produces final list
SELECT
DISTINCT ON (field_booklist_entry_location)
c.name AS field_booklist_entry_location,
--Encore Link
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(t.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author,
--Cover image from Syndetics
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover,
t.count_holds_on_title

FROM (
    SELECT
    t2.name,
    MAX(t2.count_holds_on_title) as max_count

    FROM
    temp_language_holds_counts as t2

    GROUP BY
    t2.name
) AS c


JOIN
temp_language_holds_counts as t
ON
  t.name = c.name
  AND t.count_holds_on_title = c.max_count

JOIN
sierra_view.bib_record_property b
ON
t.bib_record_id = b.bib_record_id
--Grab ISBN for cover image
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'

GROUP BY
1,2,3,4,6
ORDER BY
1
;