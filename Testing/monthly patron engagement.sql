/*
Jeremy Goldstein
Minuteman Library Newtork
Compares monthly patron activity by ptype
*/

WITH visits AS (
SELECT
DISTINCT p.id,
COUNT(DISTINCT t.transaction_gmt::DATE) FILTER (WHERE t.op_code IN ('o','u')) AS visits,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code = 'o') AS checkout_total,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code = 'o' AND t.application_name NOT IN ('circ','sierra')) AS self_checkout_total,
COUNT(DISTINCT t.id) FILTER (WHERE t.op_code ~ 'n') AS hold_total,
COUNT(DISTINCT t.id) AS transaction_total,
COUNT(DISTINCT s.location_code) FILTER (WHERE s.location_code NOT IN ('','cmcat','mls') AND t.op_code IN ('o','i','u')) AS locations_visited,
COUNT(DISTINCT t.id) FILTER (WHERE s.location_code != SUBSTRING(p.home_library_code,1,3) AND s.location_code NOT IN ('','cmcat','mls')) AS away_transactions

FROM
sierra_view.patron_record p
JOIN
sierra_view.circ_trans t
ON
p.id = t.patron_record_id
JOIN
sierra_view.statistic_group_myuser s
ON
t.stat_group_code_num = s.code

WHERE 
t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 MONTH'

GROUP BY 1
)

SELECT
p.ptype_code,
pt.name AS ptype_name,
COUNT(DISTINCT p.id) AS total_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 MONTH') AS patrons_added,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 MONTH' AND (p.patron_agency_code_num = '47' OR b.index_entry = rm.record_num::VARCHAR)) AS online_registrations,
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= CURRENT_DATE - INTERVAL '1 MONTH') AS total_active_last_month,
COALESCE(COUNT(DISTINCT p.id) FILTER (WHERE v.id IS NOT NULL),0) AS patrons_with_Sierra_transactions,
COALESCE(COUNT(DISTINCT p.id) FILTER (WHERE v.id IS NOT NULL AND v.visits > 0),0) AS patrons_with_checkouts,
COUNT(DISTINCT p.id) FILTER (WHERE v.visits > 1) AS patrons_with_checkouts_multiple_days,
COUNT(DISTINCT p.id) FILTER(WHERE v.away_transactions > 0) AS patrons_visited_non_home_library,
COUNT(DISTINCT p.id) FILTER(WHERE v.locations_visited > 1) AS patrons_visited_multiple_libraries,
COALESCE(SUM(v.visits),0) AS total_checkout_transactions,
--average for patrons active in past month
COALESCE(ROUND(AVG(v.visits) FILTER (WHERE v.visits IS NOT NULL),2),0) AS avg_monthly_visits,
COALESCE(SUM(v.checkout_total),0) AS total_checkouts,
COALESCE(SUM(v.self_checkout_total),0) AS total_self_checkouts,
COALESCE(ROUND(AVG(v.checkout_total) FILTER (WHERE v.checkout_total IS NOT NULL),2),0) AS avg_monthly_checkouts,
COALESCE(ROUND(SUM(v.checkout_total)/SUM(v.visits),2),0) AS avg_checkouts_per_visit,
COALESCE(SUM(v.hold_total),0) AS hold_total,
COUNT(DISTINCT p.id) FILTER(WHERE COALESCE(v.hold_total, 0) > 0) AS patrons_placing_holds,
COALESCE(ROUND(SUM(v.hold_total)/NULLIF(COUNT(DISTINCT p.id) FILTER(WHERE COALESCE(v.hold_total, 0) > 0),0),2),0) AS avg_holds_placed,
ROUND((COUNT(DISTINCT p.id) FILTER(WHERE p.is_reading_history_opt_in IS TRUE))/(COUNT(DISTINCT p.id)::NUMERIC) * 100, 2) AS pct_uses_reading_history

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
JOIN
sierra_view.phrase_entry b
ON
p.id = b.record_id AND b.index_tag = 'b'
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value
LEFT JOIN
visits v
ON
p.id = v.id

WHERE p.ptype_code NOT IN ('19','25','150','175','206','254')

GROUP BY 1,2