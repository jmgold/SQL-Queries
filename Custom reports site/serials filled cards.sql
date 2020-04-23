/*
Jeremy Goldstein
Minuteman Library Network

Identifies checkin cards that are nearly filled so staff may proactively make space for new issues
*/

SELECT
bp.best_title AS title,
ID2RECKEY(bp.bib_record_id)||'a' AS bib_number,
ID2RECKEY(h.id)||'a' AS checkin_number,
COUNT(b.id) AS box_count,
COUNT(b.id) FILTER (WHERE b.box_status_code = 'A') AS arrived_box_count,
CASE
	WHEN card.status_code = 'C' THEN 'current'
	WHEN card.status_code = 'I' THEN 'incompete'
	WHEN card.status_code = 'U' THEN 'unused'
END AS card_status,
hl.location_code,
CASE
	WHEN cl.frequency_code = 'a' THEN 'annual'
	WHEN cl.frequency_code = 'b' THEN 'bimonthly'
	WHEN cl.frequency_code = 'c' THEN 'semiweekly'
	WHEN cl.frequency_code = 'd' THEN 'daily'
	WHEN cl.frequency_code = 'e' THEN 'biweekly'
	WHEN cl.frequency_code = 'f' THEN 'semiannual'
	WHEN cl.frequency_code = 'g' THEN 'biennial'
	WHEN cl.frequency_code = 'h' THEN 'triennial'
	WHEN cl.frequency_code = 'i' THEN '3 times per week'
	WHEN cl.frequency_code = 'j' THEN '3 times per month'
	WHEN cl.frequency_code = 'm' THEN 'monthly'
	WHEN cl.frequency_code = 'n' THEN 'weekdays'
	WHEN cl.frequency_code = 'p' THEN '10 per year'
	WHEN cl.frequency_code = 'q' THEN 'quarterly'
	WHEN cl.frequency_code = 's' THEN 'semimonthly'
	WHEN cl.frequency_code = 't' THEN '3 times per year'
	WHEN cl.frequency_code = 'w' THEN 'weekly'
	WHEN cl.frequency_code = 'x' THEN 'irregular'
	ELSE 'custom'
END AS frequency,
s.name AS retention
FROM
sierra_view.holding_record_box b
JOIN
sierra_view.holding_record_cardlink cl
ON
b.holding_record_cardlink_id = cl.id
JOIN
sierra_view.holding_record_card card
ON
cl.holding_record_card_id = card.id
JOIN
sierra_view.holding_record h
ON
card.holding_record_id = h.id
JOIN
sierra_view.bib_record_holding_record_link l
ON
h.id = l.holding_record_id
JOIN
sierra_view.bib_record_property bp
ON
l.bib_record_id = bp.bib_record_id
JOIN
sierra_view.holding_record_location hl
ON
h.id = hl.holding_record_id AND hl.location_code ~ {{location}}
JOIN
sierra_view.user_defined_scode2_myuser s
ON
h.scode2 = s.code

--Excludes cards marked as filled
WHERE
card.status_code != 'F'

GROUP BY 1,2,3,6,7,8,9
HAVING COUNT(b.id) >= {{box_count}}

ORDER BY 1