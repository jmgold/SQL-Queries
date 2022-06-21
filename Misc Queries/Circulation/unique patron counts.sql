/*
Jeremy Goldstein
Minuteman Library Network

checkouts and hold placed counts by location with unique patron count
*/

SELECT
TO_CHAR(c.transaction_gmt, 'MM-DD-YY') AS "date",
l.name AS library,
--s.location_code AS library,
COUNT(DISTINCT c.id) AS checkouts_items,
COUNT(DISTINCT c.patron_record_id) AS checkouts_patrons,
COALESCE(ROUND(COUNT(DISTINCT c.id)::NUMERIC/NULLIF(COUNT(DISTINCT c.patron_record_id),0),2),0) AS avg_checkouts_per_patron,
COUNT(DISTINCT h.id) AS holds_placed_items,
COUNT(DISTINCT h.patron_record_id) AS holds_placed_patrons,
COALESCE(ROUND(COUNT(DISTINCT h.id)::NUMERIC/NULLIF(COUNT(DISTINCT h.patron_record_id),0),2),0) AS avg_holds_placed_per_patron

FROM
sierra_view.circ_trans c
JOIN
sierra_view.statistic_group_myuser s
ON
c.stat_group_code_num = s.code
JOIN
sierra_view.location_myuser l
ON
s.location_code = l.code
FULL OUTER JOIN
sierra_view.hold h
ON
s.location_code = SUBSTRING(h.pickup_location_code,1,3) AND c.transaction_gmt::DATE = h.placed_gmt::DATE

WHERE
c.op_code = 'o'
AND c.transaction_gmt::DATE = NOW()::DATE - INTERVAL '1 day'
GROUP BY 1,2
ORDER BY 1,2