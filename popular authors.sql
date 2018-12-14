--Jeremy Goldstein with Enormous assistance from Ray Voelker
--Minuteman Library Network

--Gathers the 100 most popular authors based on current holds


DROP TABLE IF EXISTS temp_holds_data
;
--gathers hold data used by temp_location_holds_counts table
CREATE TEMP TABLE temp_holds_data AS

SELECT
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
;

SELECT
TRIM(trailing ',' from a.content) AS title,
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
temp_holds_data t
ON
b.bib_record_id = t.bib_record_id

JOIN sierra_view.subfield a
ON
t.bib_record_id = a.record_id AND a.field_type_code = 'a' AND a.tag = 'a'
WHERE
b.best_author !='' AND b.material_code IN ('a', '2')
GROUP BY 1,2
ORDER BY COUNT(TRIM(trailing ',' from a.content)) DESC
LIMIT 100;