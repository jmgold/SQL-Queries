/*
Jeremy Goldstein
Minuteman Library Network

clean up pub date
*/
SELECT
bib_number,
MAX(GREATEST(publish_year,year_260::NUMERIC,year_264::NUMERIC)) AS pub_year
FROM
(SELECT
rm.record_type_code||rm.record_num||
COALESCE(
    CAST(
        NULLIF(
        (
            ( rm.record_num % 10 ) * 2 +
            ( rm.record_num / 10 % 10 ) * 3 +
            ( rm.record_num / 100 % 10 ) * 4 +
            ( rm.record_num / 1000 % 10 ) * 5 +
            ( rm.record_num / 10000 % 10 ) * 6 +
            ( rm.record_num / 100000 % 10 ) * 7 +
            ( rm.record_num / 1000000 % 10  ) * 8 +
            ( rm.record_num / 10000000 ) * 9
         ) % 11,
         10
         )
  AS CHAR(1)
  ),
  'x'
 ) AS bib_number,
CASE
	WHEN b.publish_year > EXTRACT(YEAR FROM CURRENT_DATE)+1 THEN ('20'||SUBSTRING(b.publish_year::VARCHAR,1,2))::INTEGER
	ELSE b.publish_year
END AS publish_year,
NULLIF(SUBSTRING(regexp_replace(s260.content, '\D','','g'),1,4), '') AS year_260,
NULLIF(SUBSTRING(regexp_replace(s264.content, '\D','','g'),1,4), '') AS year_264

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_location bl
ON
b.bib_record_id = bl.bib_record_id AND bl.location_code ~ '^blm'
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
LEFT JOIN
sierra_view.subfield s260
ON
rm.id = s260.record_id AND s260.marc_tag = '260' AND s260.tag = 'c'
LEFT JOIN
sierra_view.subfield s264
ON
rm.id = s264.record_id AND s264.marc_tag = '264' AND s264.tag = 'c'
)inner_query

GROUP BY 1