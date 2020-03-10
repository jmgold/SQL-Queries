/*
Jeremy Goldstein
Minuteman Library Network

Unused item report limited by checking/created date and collection
request from Hadi Amjadi
*/

SELECT
--Using regexp replace to strip out delimiters from call # field
REGEXP_REPLACE(ip.call_number, '\|\w', '', 'g') AS "CALL #(ITEM)",
b.best_author AS "AUTHOR",
b.best_title AS "TITLE",
i.location_code AS "LOCATION",
ip.barcode AS "BARCODE",
i.checkout_total AS "TOT CHKOUT",
i.last_checkin_gmt::DATE AS "LCHKIN",
r.creation_date_gmt::DATE AS "CREATED(ITEM)",
i.item_status_code AS "STATUS",
--If there is not a last checkin date then use cration date instead
CASE WHEN i.last_checkin_gmt IS NULL THEN r.creation_date_gmt::DATE
	ELSE i.last_checkin_gmt::DATE
	END AS "SORT"

--item_record table provides location and status codes, last checkin date and the checkout total
FROM
sierra_view.item_record i
--link to associated item record with bib record
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
--bib_record_property table provides title and author fields
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
--item_record_property table provides call # and barcode fields
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
--record_metadata table provides record creation date field
JOIN
sierra_view.record_metadata r
ON
i.id = r.id

--Where clause defines filters to be used
WHERE
CASE WHEN i.last_checkin_gmt IS NULL THEN r.creation_date_gmt::DATE
	ELSE i.last_checkin_gmt::DATE
	--fill in the single quotes after the word interval with the the time period you wish to filter to
	--For example INTERVAL '7 YEARS" will limit results to titles that have not been used in 7 years or more from today
	END <= NOW()::DATE - INTERVAL '7 YEARS'
--Enter location codes you wish to limit to in the parenthesis.
--By using an IN operator you may enter as many	locations as you wish, separated by commas
--For example i.location_code IN ('001vi','abc','cde','fgh')
AND i.location_code IN ('00lvi')
--can also limit to items starting with a given call number
--call_number_norm using a normalized form of the call number that strips out punctuation and capitalization
--% is a wildcard chracter for 0 or more characters
--For example LIKE 'fiction%' will search for any call number starting with fiction and then followed by anything
AND ip.call_number_norm LIKE 'vie fiction%'

--Sorts by the 10th field above, being the sort column
ORDER BY 10
