SELECT
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) < 10) AS "Under 10",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) BETWEEN 11 AND 19) AS "11 to 19",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) BETWEEN 21 AND 29) AS "21 to 29",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) BETWEEN 31 AND 39) AS "31 to 39",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) BETWEEN 41 AND 49) AS "41 to 49",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) BETWEEN 51 AND 59) AS "51 to 59",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt)) BETWEEN 61 AND 69) AS "61 to 69",
COUNT(DISTINCT p.id) FILTER(WHERE DATE_PART('YEAR',AGE(p.birth_date_gmt))  > 69) AS "70+",
COUNT(DISTINCT p.id) FILTER(WHERE p.birth_date_gmt IS NULL) AS "Age Unknown", 
COUNT(t.id) AS "checkout total"

FROM
sierra_view.circ_trans t
JOIN
sierra_view.patron_record p
ON
t.patron_record_id = p.id

WHERE
t.op_code = 'o'
AND t.item_location_code ~ '^win'
AND t.itype_code_num IN ('33','34')