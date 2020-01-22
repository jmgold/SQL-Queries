/*
Jeremy Goldstein
Minuteman Library Network

Report provides an age of collection overview grouped around a selected fixed field.
*/
SELECT
{{grouping}},
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year > 2019) AS "2020-",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 2010 AND 2019) AS "2010-2019",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 2000 AND 2009) AS "2000-2009",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1990 AND 1999) AS "1990-1999",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1980 AND 1989) AS "1980-1989",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1970 AND 1979) AS "1970-1979",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1960 AND 1969) AS "1960-1969",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1950 AND 1959) AS "1950-1959",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1940 AND 1949) AS "1940-1949",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1930 AND 1939) AS "1930-1939",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1920 AND 1929) AS "1920-1929",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1910 AND 1919) AS "1920-1919",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year BETWEEN 1900 AND 1909) AS "1910-1909",
COUNT(DISTINCT i.id) FILTER (WHERE bp.publish_year < 1900) AS "< 1900"
--and so on

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
JOIN
sierra_view.material_property_myuser m
ON
b.bcode2 = m.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code

WHERE location_code ~ {{location}}

GROUP BY 1
ORDER BY 1