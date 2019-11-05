/*
Jeremy Goldstein
Minuteman Library Network

Pulls most rececently created checkin-box with a status of arrived from each title.
Passed owning location as a variable
*/

SELECT
t1.rec_num AS bib_number,
t1.title,
t1.enum_level_a AS volume,
t1.enum_level_b AS "number",
t1.cover_date

FROM 
(SELECT
id2reckey(b.bib_record_id)||'a' AS rec_num,
b.best_title as title,
MAX(hb.id) as max_id,
hb.enum_level_a,
hb.enum_level_b,
CONCAT(hb.chron_level_i,'-',hb.chron_level_j,'-'||hb.chron_level_k) as cover_date
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_holding_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.holding_record h
ON
l.holding_record_id = h.id
JOIN
sierra_view.holding_record_location hl
ON
h.id = hl.holding_record_id AND hl.location_code ~ {{Location}}
JOIN
sierra_view.holding_record_card hc
ON
h.id = hc.holding_record_id
JOIN
sierra_view.holding_record_cardlink cl
ON
hc.id = cl.holding_record_card_id
JOIN
sierra_view.holding_record_box hb
ON
cl.id = hb.holding_record_cardlink_id AND box_status_code = 'A'
GROUP BY 1,2,4,5,6
ORDER BY 2) t1

JOIN 
(SELECT 
b.best_title, 
MAX(hb.id) AS max_id 
FROM 
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_holding_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.holding_record h
ON
l.holding_record_id = h.id 
JOIN
sierra_view.holding_record_location hl
ON
h.id = hl.holding_record_id AND hl.location_code ~ {{Location}}
JOIN
sierra_view.holding_record_card hc
ON
h.id = hc.holding_record_id
JOIN
sierra_view.holding_record_cardlink cl
ON
hc.id = cl.holding_record_card_id
JOIN
sierra_view.holding_record_box hb
ON
cl.id = hb.holding_record_cardlink_id AND box_status_code = 'A'
GROUP BY 1) t2

ON
t1.max_id = t2.max_id
ORDER BY 2