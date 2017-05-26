--Finds records with more holds than items where another record exists with the same title and mattype
--Aims to find instances where holds have pooled on incorrect records

SELECT
id2reckey(b.id)||'a' AS "Record Number",
brp.best_title AS "Title",
brp.best_author AS "Author",
CASE
    WHEN brp.material_code = '2' THEN 'Large Print'
    WHEN brp.material_code = '3' THEN 'Periodical'
    WHEN brp.material_code = '4' THEN 'Spoken CD'
    WHEN brp.material_code = '5' THEN 'DVD'
    WHEN brp.material_code = '6' THEN 'Film/Strip'
    WHEN brp.material_code = '7' THEN 'Music Cassette'
    WHEN brp.material_code = '8' THEN 'LP'
    WHEN brp.material_code = '9' THEN 'Juv Book + CD'
    WHEN brp.material_code = 'a' THEN 'Book'
    WHEN brp.material_code = 'b' THEN 'Archival Material'
    WHEN brp.material_code = 'c' THEN 'Music Score'
    WHEN brp.material_code = 'e' THEN 'Map'
    WHEN brp.material_code = 'g' THEN 'VHS'
    WHEN brp.material_code = 'h' THEN 'Downloadable eBook'
    WHEN brp.material_code = 'i' THEN 'Spoken Cassette'
    WHEN brp.material_code = 'j' THEN 'Music CD'
    WHEN brp.material_code = 'k' THEN '2D Visual Material'
    WHEN brp.material_code = 'l' THEN 'Downloadable Video'
    WHEN brp.material_code = 'm' THEN 'Software'
    WHEN brp.material_code = 'n' THEN 'Console Game'
    WHEN brp.material_code = 'o' THEN 'Kit'
    WHEN brp.material_code = 'p' THEN 'Mixed Material'
    WHEN brp.material_code = 'q' THEN 'Equipment'
    WHEN brp.material_code = 'r' THEN '3D Object'
    WHEN brp.material_code = 's' THEN 'Downloadable Audiobook'
    WHEN brp.material_code = 't' THEN 'Manuscript'
    WHEN brp.material_code = 'u' THEN 'Blu-ray'
    WHEN brp.material_code = 'v' THEN 'eReader/Tablet'
    WHEN brp.material_code = 'w' THEN 'Downloadable Music'
    WHEN brp.material_code = 'x' THEN 'Playaway Video'
    WHEN brp.material_code = 'y' THEN 'Online'
    WHEN brp.material_code = 'z' THEN 'Playaway Audio'
    ELSE 'unexpected code '||brp.material_code
END     AS "MatType",
count(distinct h.id) as "hold_count"
FROM sierra_view.bib_view b
JOIN sierra_view.bib_record_property brp
ON b.id=brp.bib_record_id
LEFT JOIN sierra_view.bib_record_item_record_link bri
on bri.bib_record_id=b.id
LEFT JOIN sierra_view.hold h
ON (h.record_id=b.id OR h.record_id=bri.item_record_id) AND h.status='0'
WHERE
brp.best_title IN (
SELECT brp.best_title
FROM sierra_view.bib_record_property brp
GROUP BY 1
HAVING
COUNT (brp.id)>1 and COUNT (DISTINCT brp.material_code)=1)
GROUP BY 1, 2, 3, 4
HAVING
count(distinct h.id)> count(distinct bri.id)
ORDER BY 4,2;
