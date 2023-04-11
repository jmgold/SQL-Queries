/*
Jeremy Goldstein
Minuteman Library Network

Counts the usage of each itype by each location within the consortia
*/
SELECT
'itype' AS code,
i.itype_code_num AS itype_code,
it.name AS itype,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ac') AS Acton,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ar') AS Arlington,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ash') AS Ashland,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^bed') AS Bedford,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^blm') AS Belmont,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^br') AS Brookline,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ca') AS Cambridge,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^dd') AS Dedham,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^de') AS Dean,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^do') AS Dover,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^fp') AS Framingham,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^fs') AS Framingham_State,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^fr') AS Franklin,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ho') AS Holliston,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^la') AS Lasell,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^le') AS Lexington,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^li') AS Lincoln,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ma') AS Maynard,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ml') AS Medfield,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^me') AS Medford,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^mw') AS Medway,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^mi') AS Millis,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^na') AS Natick,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ne') AS Needham,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^nt') AS Newton,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^no') AS Norwood,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ol') AS Olin,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^re') AS Regis,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^sh') AS Sherborn,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^so') AS Somerville,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^st') AS Stow,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^su') AS Sudbury,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^wl') AS Waltham,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^wa') AS Watertown,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^wy') AS Wayland,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^we') AS Wellesley,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ws') AS Weston,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^ww') AS Westwood,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^wi') AS Winchester,
COUNT(i.id) FILTER(WHERE i.location_code ~ '^wo') AS Woburn,
COUNT(i.id) AS Total

FROM
sierra_view.item_record i
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

GROUP BY 1,2,3
ORDER BY 1,2