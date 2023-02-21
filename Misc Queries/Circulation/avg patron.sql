/*
Jeremy Goldstein
Minuteman Library Network
Gathers numbers for an average active patron for infographic
*/

SELECT
ROUND(AVG(p.checkout_total),2) AS avg_checkout_total,
ROUND(AVG(p.checkout_count),2) AS avg_checkout_current,
DATE_PART('year',CURRENT_DATE)::INTEGER - MODE() WITHIN GROUP(ORDER BY DATE_PART('year',p.birth_date_gmt))::INTEGER AS avg_age,
CURRENT_DATE - TO_TIMESTAMP(AVG(EXTRACT(epoch FROM p.activity_gmt)))::DATE AS avg_days_since_last_activity,
(SELECT 
	ROUND(AVG(holds_per_patron),2) AS holds_per_patron
	FROM 
	(SELECT COUNT(h.id) AS holds_per_patron
	FROM sierra_view.hold h
	JOIN sierra_view.patron_record p
	ON h.patron_record_id = p.id AND p.activity_gmt::DATE > (CURRENT_DATE - INTERVAL '1 year')
	GROUP BY h.patron_record_id) AS sub_query
)

FROM
sierra_view.patron_record p
WHERE
p.activity_gmt::DATE > (CURRENT_DATE - INTERVAL '1 year')
--AND p.checkout_total > '0'