SELECT
AVG(checkout_total) FILTER (where checkout_total > '0') as avg_checkout_total,
MODE() WITHIN GROUP(order by date_part('year',birth_date_gmt)) FILTER (where checkout_total > '0') as avg_birth_year,
MODE() WITHIN GROUP(order by(activity_gmt::date)) FILTER (where checkout_total > '0') as avg_active
FROM
sierra_view.patron_record
WHERE
activity_gmt > (localtimestamp - interval '2 years')