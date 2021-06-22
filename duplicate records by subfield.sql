/*
finds duplicate subfields across bib records
Shared by Ray Voelker over Sierra mailing list 6/9/21
*/

WITH field_037_info AS (
    SELECT
    s.content,
    s.varfield_id,
    r.id as bib_record_id,
    r.record_num as bib_record_num

    FROM
    sierra_view.subfield as s

    JOIN
    sierra_view.record_metadata as r
    ON
    r.id = s.record_id
    AND r.record_type_code = 'b'
    AND r.campus_code = ''

    WHERE
    s.marc_tag = '037'
    AND s.tag = 'a'
)

SELECT
content as content_037_sub_a,
string_agg('b' || bib_record_num::TEXT || 'a', ', ') as bib_record_numbers,
COUNT(DISTINCT bib_record_id)

FROM
field_037_info

GROUP BY
content_037_sub_a

HAVING
COUNT(DISTINCT bib_record_id) > 1

--LIMIT 100