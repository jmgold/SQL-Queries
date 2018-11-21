/*
Jeremy Goldstein
Minuteman Library Network

Pulls most rececently created checkin-box with a status of arrived from each title.
*/

SELECT
t1.title,
t1.chron

FROM 
(SELECT
b.best_title as title,
MAX(hb.id) as max_id,
hb.chron_level_j||'/'||hb.chron_level_i as chron
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_holding_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.holding_record h
ON
l.holding_record_id = h.id AND h.accounting_unit_code_num = '34'
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
GROUP BY 1,3
ORDER BY 1) t1

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
l.holding_record_id = h.id AND h.accounting_unit_code_num = '34'
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
ORDER BY 1
