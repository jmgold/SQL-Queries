/*
Jeremy Goldstein
Minuteman Library Network

Counts either items or titles owned by a location, grouped by a variety of categories.
*/
WITH call_number_mod AS(
SELECT
i.item_record_id,
CASE
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ ('^.+'||SPLIT_PART(b.best_author_norm, ' ',1)) THEN SPLIT_PART(i.call_number_norm,SPLIT_PART(b.best_author_norm, ' ',1),1)
	WHEN i.call_number_norm ~ ('^.+'||SPLIT_PART(REGEXP_REPLACE(b.best_title_norm,'\*|\+|\?|\{',''), ' ',1)) THEN SPLIT_PART(i.call_number_norm,SPLIT_PART(b.best_title_norm, ' ',1),1)
	ELSE i.call_number_norm
	END AS call_number_norm

FROM
sierra_view.item_record_property i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
)

SELECT
{{Grouping}},
/*
alternative groupings
ln.name AS "language"
m.name AS mat_type,
i.icode1 AS scat,
it.name AS itype,
*/



COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'act') AS ACTON,
/*
Change i.id to DISTINCT b.id to gather title count instead, like so
COUNT(DISTINCT b.id) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'act') AS ACTON,
*/
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'arl') AS ARLINGTON,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ar2') AS "ARLINGTON/FOX",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ash') AS ASHLAND,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'bed') AS BEDFORD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'blm') AS BELMONT,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'brk') AS BROOKLINE,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'br2') AS "BROOKLINE/COOLIDGE CORNER",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'br3') AS "BROOKLINE/PUTTERHAM",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'cam') AS CAMBRIDGE,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca3') AS "CAMBRIDGE/OUTREACH",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca4') AS "CAMBRIDGE/BOUDREAU",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca5') AS "CAMBRIDGE/CENT SQ",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca6') AS "CAMBRIDGE/COLLINS",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca7') AS "CAMBRIDGE/OCONNELL",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca8') AS "CAMBRIDGE/ONEILL",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ca9') AS "CAMBRIDGE/VALENTE",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'con') AS CONCORD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'co2') AS "CONCORD/FOWLER",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ddm') AS DEDHAM,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'dd2') AS "DEDHAM/ENDICOTT",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'dea') AS DEAN,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'dov') AS DOVER,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fpl') AS FRAMINGHAM,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fp2') AS "FRAMINGHAM/MCAULIFFE",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fp3') AS "FRAMINGHAM/BOOKMOBILE",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'fst') AS "FRAMINGHAM STATE",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'frk') AS FRANKLIN,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'hol') AS HOLLISON,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'las') AS LASELL,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'lex') AS LEXINGTON,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'lin') AS LINCOLN,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'may') AS MAYNARD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'mld') AS MEDFIELD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'med') AS MEDFORD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'mwy') AS MEDWAY,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'mil') AS MILLIS,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'nat') AS NATICK,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'na2') AS "NATICK/BACON",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'na3') AS "NATICK/BOOKMOBILE",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'nee') AS NEEDHAM,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'nor') AS NORWOOD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ntn') AS NEWTON,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'pmc') AS "PINE MANOR",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'reg') AS REGIS,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'shr') AS SHERBORN,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'som') AS SOMERVILLE,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'so2') AS "SOMERVILLE/EAST",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'so3') AS "SOMERVILLE/WEST",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'sto') AS STOW,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'sud') AS SUDBURY,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wal') AS WALTHAM,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wat') AS WATERTOWN,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wyl') AS WAYLAND,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wel') AS WELLESLEY,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'we2') AS "WELLESLEY/HILLS",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'we3') AS "WELLESLEY/FELLS",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wsn') AS WESTON,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wwd') AS WESTWOOD,
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'ww2') AS "WESTWOOD/ISLINGTON",
COUNT({{bib_or_item}}) FILTER(WHERE SUBSTRING(i.location_code FROM 1 FOR 3) = 'wob') AS WOBURN

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
call_number_mod ic
ON
i.id = ic.item_record_id
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

WHERE
i.item_status_code NOT IN ({{Item_Status_Codes}})

GROUP BY 1
ORDER BY 1