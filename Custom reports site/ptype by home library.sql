/*
Jeremy Goldstein
Minuteman Library Network

Counts up patrons whose home library does not match their ptype
*/
SELECT
pt.name AS ptype,
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^act') AS "Acton",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ac2') AS "Acton/West",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^arl') AS "Arlington",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ar2') AS "Arlington/Fox",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ash') AS "Ashland",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^bed') AS "Bedford",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^blm') AS "Belmont",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^brk') AS "Brookline",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^br2') AS "Brookline/Coolidge Corner",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^br3') AS "Brookline/Putterham",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^cam') AS "Cambridge",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca3') AS "Cambridge/Outreach",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca4') AS "Cambridge/Boudreau",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca5') AS "Cambridge/Central Sq",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca6') AS "Cambridge/Collins",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca7') AS "Cambridge/OConnell",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca8') AS "Cambridge/ONeill",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ca9') AS "Cambridge/Valente",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^con') AS "Concord",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^co2') AS "Concord/Fowler",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ddm') AS "Dedham",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^dd2') AS "Dedham/Endicott",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^dea') AS "Dean",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^dov') AS "Dover",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^fpl') AS "Framingham",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^fp2') AS "Framingham/McAuliffe",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^fp3') AS "Framingham/Bookmobile",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^fst') AS "Framingham State",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^frk') AS "Franklin",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^hol') AS "Holliston",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^las') AS "Lasell",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^lex') AS "Lexington",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^lin') AS "Lincoln",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^may') AS "Maynard",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^mld') AS "Medfield",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^med') AS "Medford",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^mwy') AS "Medway",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^mil') AS "Millis",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^nat') AS "Natick",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^na2') AS "Natick/Bacon",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^na3') AS "Natick/Bookmobile",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^nee') AS "Needham",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^nor') AS "Norwood",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ntn') AS "Newton",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^oln') AS "Olin",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^reg') AS "Regis",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^shr') AS "Sherborn",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^som') AS "Somerville",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^so2') AS "Somerville/East",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^so3') AS "Somerville/West",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^sto') AS "Stow",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^sud') AS "Sudbury",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wal') AS "Waltham",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wat') AS "Watertown",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wyl') AS "Wayland",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wel') AS "Wellesley",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^we2') AS "Wellesley/Hills",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^we3') AS "Wellesley/Fells",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wsn') AS "Weston",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wwd') AS "Westwood",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^ww2') AS "Westwood/Islington",
COUNT(p.id) FILTER(WHERE p.home_library_code ~ '^wob') AS "Woburn",
COUNT(p.id) FILTER(WHERE p.home_library_code IN ('','zzzzz') OR p.home_library_code IS NULL) AS "No Home",
COUNT(p.id) AS "Total"

FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value

WHERE
p.ptype_code NOT IN (
--exclude academic ptypes
--'9','13','16','44','45','47','116','147','159','163','166','175','194','195','197',
--exclude misc ptypes that are not tied to MLN municipalities
'19','25','42','43','199','200','201','202','203','204','205','206','207','254','255'
)

GROUP BY 1
ORDER BY 1