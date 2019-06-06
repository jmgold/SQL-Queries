/*
Jeremy Goldstein
Minuteman Library Network
Patrons created by hour 
limited by agency code and date range
*/

SELECT
m.creation_date_gmt::DATE,
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 08) AS "8am",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 09) AS "9am",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 10) AS "10am",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 11) AS "11am",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 12) AS "12pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 13) AS "1pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 14) AS "2pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 15) AS "3pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 16) AS "4pm",
--5:30 split out to focus on particular closing times
COUNT(p.id) FILTER (WHERE (EXTRACT(HOUR from m.creation_date_gmt) = 17 AND EXTRACT(MINUTE FROM M.creation_date_gmt) < 30)) AS "5pm",
COUNT(p.id) FILTER (WHERE (EXTRACT(HOUR from m.creation_date_gmt) = 17 AND EXTRACT(MINUTE FROM M.creation_date_gmt) >= 30)) AS "530pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 18) AS "6pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 19) AS "7pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 20) AS "8pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 21) AS "9pm",
COUNT(p.id) FILTER (WHERE EXTRACT(HOUR from m.creation_date_gmt) = 22) AS "10pm"
--COUNT(p.id)
FROM
sierra_view.patron_view p
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num AND m.record_type_code = 'p' AND p.patron_agency_code_num = '41'
WHERE
m.creation_date_gmt::DATE >= '2019-05-01' 
GROUP BY 1
ORDER BY 1