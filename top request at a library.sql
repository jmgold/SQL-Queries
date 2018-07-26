--Jeremy Goldstein
--jgoldstein@minlib.net
--Minuteman Library Network

--Query returns the record with the largest number of holds for each pickup location

SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'actz'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'actz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ar%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ar%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'ashz'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'ashz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'bedz'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'bedz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'blmz'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'blmz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'br%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'br%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'co%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'co%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'de%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'de%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'dd%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'dd%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'do%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'do%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fp%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fp%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fs%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fs%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fr%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fr%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ho%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ho%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'la%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'la%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'le%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'le%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'li%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'li%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ma%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ma%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ml%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ml%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'me%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'me%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'mw%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'mw%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'mi%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'mi%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'na%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'na%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ne%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ne%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'nt%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'nt%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'no%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'no%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'pmcz'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'pmcz'
GROUP BY 1,2
LIMIT 1
)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 're%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 're%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'sh%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'sh%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'so%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'so%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'st%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'st%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'su%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'su%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wl%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wl%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wa%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wa%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wy%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wy%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'we%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'we%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ws%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ws%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ww%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ww%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wi%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wi%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (h.pickup_location_code)
h.pickup_location_code,
b.best_title,
b.best_author,
COUNT(h.id)
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wo%'
GROUP BY 1,2,3
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wo%'
GROUP BY 1,2)AS Q)
ORDER BY 1