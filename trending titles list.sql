--Jeremy Goldstein
--Minuteman Library Network

--top 50 trending titles in the network
DROP TABLE IF EXISTS temp_holds_data
;

CREATE TEMP TABLE temp_holds_data AS
SELECT
h.record_id,
r.record_type_code, 
r.record_num,
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
WHERE
h.placed_gmt > (localtimestamp - interval '2 days')
;

DROP TABLE IF EXISTS temp_location_holds_counts;
CREATE TEMP TABLE temp_location_holds_counts AS
SELECT
t.bib_record_id,
count(t.bib_record_id) as count_holds_on_title

FROM
temp_holds_data as t

GROUP BY
t.bib_record_id

HAVING
count(t.bib_record_id) > 1

ORDER BY
count_holds_on_title
;

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(c.bib_record_id)   AS "field_booklist_entry_encore_url",
best_title as title,
best_author as field_booklist_entry_author,
t.count_holds_on_title,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover

FROM (
    SELECT
    t2.bib_record_id,
    MAX(t2.count_holds_on_title) as max_count

    FROM
    temp_location_holds_counts as t2

    GROUP BY
    t2.bib_record_id
) AS c

JOIN
temp_location_holds_counts as t
ON
  t.bib_record_id = c.bib_record_id
  AND t.count_holds_on_title = c.max_count
  
JOIN
sierra_view.bib_record_property b
ON
--limited to books
t.bib_record_id = b.bib_record_id-- and b.material_code = 'a'


GROUP BY 1,2,3,4,5
ORDER BY 4 desc
LIMIT 50