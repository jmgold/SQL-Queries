--Jeremy Goldstein
--Minuteman Library network

--Top 50 most requested videos in the network
SELECT
--keyword based Encore search by best title, limited to dvd or blu-ray
'http://find.minlib.net/iii/encore/search/C__S%28'||replace(replace(b.best_title,' ', E'%20'),'.','')||'%29%20f%3A%28u%20%7C%205%29'   AS "URL",
replace(b.best_title,'.', ''),
COUNT(h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
--limited to dvd, blu-ray
h.record_id = b.bib_record_id and b.material_code IN ('5', 'u')
GROUP BY 2,1
ORDER BY 3 desc
LIMIT 50