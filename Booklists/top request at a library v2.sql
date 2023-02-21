--Jeremy Goldstein with Enormous assistance from Ray Voelker
--Minuteman Library Network

--Gathers the most requested title at each location in the network, for booklist located at https://www.minlib.net/booklists/recommended-reads/top-request-by-library


DROP TABLE IF EXISTS temp_holds_data
;
--gathers hold data used by temp_location_holds_counts table
CREATE TEMP TABLE temp_holds_data AS
SELECT
h.pickup_location_code,
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
;

--gathers hold count for each title at a pickup location
DROP TABLE IF EXISTS temp_location_holds_counts;
CREATE TEMP TABLE temp_location_holds_counts AS
SELECT
t.pickup_location_code,
t.bib_record_id,
count(t.bib_record_id) as count_holds_on_title

FROM
temp_holds_data as t

--Filter out out-of-network ILL's
WHERE
t.pickup_location_code != 'mlsz'

GROUP BY
t.pickup_location_code,
t.bib_record_id

HAVING
count(t.bib_record_id) > 1

ORDER BY
t.pickup_location_code,
count_holds_on_title
;

--Produces final list
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
--Encore Link
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(t.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
--Cover image from Syndetics
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
    t2.pickup_location_code,
    MAX(t2.count_holds_on_title) as max_count

    FROM
    temp_location_holds_counts as t2

    GROUP BY
    t2.pickup_location_code
) AS c

--Pull location name
JOIN
sierra_view.location_myuser l
ON
substring(c.pickup_location_code from 1 for 3) = l.code

JOIN
temp_location_holds_counts as t
ON
  t.pickup_location_code = c.pickup_location_code
  AND t.count_holds_on_title = c.max_count

JOIN
sierra_view.bib_record_property b
ON
t.bib_record_id = b.bib_record_id


GROUP BY
1,2,3,4,5
ORDER BY
1
;
