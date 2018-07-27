SELECT
DISTINCT ON (b.language_code)
b.language_code,
p.best_title,
p.best_author,
COUNT(h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property p
ON
h.record_id = p.bib_record_id
JOIN
sierra_view.bib_record b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a'
AND b.language_code = 'chi'
GROUP BY 1,2,3
HAVING COUNT (h.id) = (SELECT MAX(C) FROM (SELECT b.language_code,p.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property p
ON
h.record_id = p.bib_record_id
JOIN
sierra_view.bib_record b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a'
AND b.language_code = 'chi'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (b.language_code)
b.language_code,
p.best_title,
p.best_author,
COUNT(h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property p
ON
h.record_id = p.bib_record_id
JOIN
sierra_view.bib_record b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a'
AND b.language_code = 'rus'
GROUP BY 1,2,3
HAVING COUNT (h.id) = (SELECT MAX(C) FROM (SELECT b.language_code,p.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property p
ON
h.record_id = p.bib_record_id
JOIN
sierra_view.bib_record b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a'
AND b.language_code = 'rus'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (b.language_code)
b.language_code,
p.best_title,
p.best_author,
COUNT(h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property p
ON
h.record_id = p.bib_record_id
JOIN
sierra_view.bib_record b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a'
AND b.language_code = 'spa'
GROUP BY 1,2,3
HAVING COUNT (h.id) = (SELECT MAX(C) FROM (SELECT b.language_code,p.best_title,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property p
ON
h.record_id = p.bib_record_id
JOIN
sierra_view.bib_record b
ON
p.bib_record_id = b.id
WHERE
p.material_code = 'a'
AND b.language_code = 'spa'
GROUP BY 1,2)AS Q)
ORDER BY 1