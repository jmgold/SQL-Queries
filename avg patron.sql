--Jeremy Goldstein
--Minuteman Library Network
--Gathers numbers for an average active patron for infographic

SELECT
AVG(p.checkout_total) as avg_checkout_total,
AVG(p.checkout_count) as avg_checkout_current,
MODE() WITHIN GROUP(order by date_part('year',p.birth_date_gmt)) as avg_birth_year,
MODE() WITHIN GROUP(order by(p.activity_gmt::date)) as avg_active,
(SELECT AVG(holds_per_patron) as holds_per_patron
FROM 
(SELECT COUNT(h.id) AS holds_per_patron FROM sierra_view.hold h JOIN sierra_view.patron_view p ON h.patron_record_id = p.id AND p.activity_gmt > (localtimestamp - interval '1 year') GROUP BY h.patron_record_id) AS sub_query)
FROM
sierra_view.patron_record p
WHERE
p.activity_gmt > (localtimestamp - interval '1 year')
AND
p.checkout_total > '0'