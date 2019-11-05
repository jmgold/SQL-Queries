/*
Jeremy Goldstein
Minuteman Library Network

Counts either items or titles owned by a location, grouped by a variety of categories.
*/

SELECT
ln.name AS "language",
/*
alternative groupings
m.name AS mat_type,
i.icode1 AS scat,
it.name AS itype,
*/



COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'act') AS ACTON,
/*
Change i.id to DISTINCT b.id to gather title count instead, like so
COUNT(DISTINCT b.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'act') AS ACTON,
*/
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'arl') AS ARLINGTON,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ar2') AS "ARLINGTON/FOX",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ash') AS ASHLAND,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'bed') AS BEDFORD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'blm') AS BELMONT,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'brk') AS BROOKLINE,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'br2') AS "BROOKLINE/COOLIDGE CORNER",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'br3') AS "BROOKLINE/PUTTERHAM",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'cam') AS CAMBRIDGE,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca3') AS "CAMBRIDGE/OUTREACH",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca4') AS "CAMBRIDGE/BOUDREAU",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca5') AS "CAMBRIDGE/CENT SQ",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca6') AS "CAMBRIDGE/COLLINS",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca7') AS "CAMBRIDGE/OCONNELL",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca8') AS "CAMBRIDGE/ONEILL",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca9') AS "CAMBRIDGE/VALENTE",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'con') AS CONCORD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'co2') AS "CONCORD/FOWLER",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ddm') AS DEDHAM,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'dd2') AS "DEDHAM/ENDICOTT",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'dea') AS DEAN,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'dov') AS DOVER,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fpl') AS FRAMINGHAM,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fp2') AS "FRAMINGHAM/MCAULIFFE",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fp3') AS "FRAMINGHAM/BOOKMOBILE",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fst') AS "FRAMINGHAM STATE",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'frk') AS FRANKLIN,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'hol') AS HOLLISON,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'las') AS LASELL,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'lex') AS LEXINGTON,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'lin') AS LINCOLN,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'may') AS MAYNARD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'mld') AS MEDFIELD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'med') AS MEDFORD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'mwy') AS MEDWAY,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'mil') AS MILLIS,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'nat') AS NATICK,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'na2') AS "NATICK/BACON",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'na3') AS "NATICK/BOOKMOBILE",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'nee') AS NEEDHAM,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'nor') AS NORWOOD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ntn') AS NEWTON,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'pmc') AS "PINE MANOR",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'reg') AS REGIS,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'shr') AS SHERBORN,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'som') AS SOMERVILLE,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'so2') AS "SOMERVILLE/EAST",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'so3') AS "SOMERVILLE/WEST",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'sto') AS STOW,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'sud') AS SUDBURY,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wal') AS WALTHAM,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wat') AS WATERTOWN,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wyl') AS WAYLAND,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wel') AS WELLESLEY,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'we2') AS "WELLESLEY/HILLS",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'we3') AS "WELLESLEY/FELLS",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wsn') AS WESTON,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wwd') AS WESTWOOD,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ww2') AS "WESTWOOD/ISLINGTON",
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wob') AS WOBURN

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id
JOIN
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code
JOIN
sierra_view.material_property_myuser m
ON
b.bcode2 = m.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

GROUP BY 1
ORDER BY 1