--Jeremy Goldstein
--Minuteman Library Network

--top 50 trending titles in the network
DROP TABLE IF EXISTS temp_location_holds_counts;

CREATE TEMP TABLE temp_location_holds_counts AS

SELECT
t.bib_record_id,
count(t.bib_record_id) as count_holds_on_title

FROM
(SELECT
CASE
    WHEN r.record_type_code = 'i' THEN (
        SELECT
        l.bib_record_id
        FROM
        sierra_view.bib_record_item_record_link as l
        WHERE
        l.item_record_id = h.record_id
        LIMIT 1)
    
    WHEN r.record_type_code = 'b' THEN h.record_id
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
)AS t

GROUP BY
t.bib_record_id

HAVING
count(t.bib_record_id) > 1

ORDER BY
count_holds_on_title
;

SELECT
ROW_NUMBER() OVER (ORDER BY t.count_holds_on_title DESC) AS field_booklist_entry_rank,
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(t.bib_record_id)   AS "field_booklist_entry_encore_url",
best_title as title,
SPLIT_PART(b.best_author,' ',1)||' '||REPLACE(TRANSLATE(SPLIT_PART(b.best_author,' ',2),'.',','),',','') AS field_booklist_entry_author,
(SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1) AS field_booklist_entry_cover

FROM
temp_location_holds_counts AS t
JOIN
sierra_view.bib_record_property b
ON
--limited to books
t.bib_record_id = b.bib_record_id AND b.material_code = 'a' AND b.best_title NOT LIKE '%Non-MLN%'


GROUP BY 2,3,4,5,t.count_holds_on_title
ORDER BY t.count_holds_on_title desc
LIMIT 50