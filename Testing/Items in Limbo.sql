/*

Calculate time spent in transit or sitting on holdshelf
find titles/locations with most time items are out of use
*/
SELECT
REPLACE(loc.name,'/Pickup','') AS library,
ROUND(AVG(CURRENT_DATE - h.on_holdshelf_gmt::DATE)) AS avg_on_holdshelf_time,
MAX(CURRENT_DATE - h.on_holdshelf_gmt::DATE)
FROM
sierra_view.location_myuser loc
JOIN
sierra_view.hold h
ON
loc.code = h.pickup_location_code AND h.on_holdshelf_gmt IS NOT NULL AND h.note != 'NCIP hold'

WHERE
loc.code ~ 'z$' AND loc.code != 'zzzzz'

GROUP BY 1
ORDER BY 1