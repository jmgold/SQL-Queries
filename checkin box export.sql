/*
Jeremy Goldstein
Minuteman Library Network

extracts checkin box data from serials
*/

SELECT
b.best_title,
cb.enum_level_a,
cb.enum_level_b,
cb.chron_level_i||'-'||cb.chron_level_j||'-'||cb.chron_level_k as cover_date,
cb.chron_level_i_trans_date||'-'||cb.chron_level_j_trans_date||'-'||cb.chron_level_k_trans_date as transaction_date
from
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_holding_record_link l
on b.bib_record_id = l.bib_record_id
JOIN
sierra_view.holding_record h
ON
--limit to a given accounting unit
l.holding_record_id = h.id AND h.accounting_unit_code_num = '29'
JOIN
sierra_view.holding_record_card c
ON h.id = c.holding_record_id
JOIN
sierra_view.holding_record_cardlink cl
ON
c.id = cl.holding_record_card_id
JOIN
sierra_view.holding_record_box cb
ON
cl.id = cb.holding_record_cardlink_id
--Limit to expected titles
WHERE
cb.box_status_code = 'E'
ORDER BY 1,2
