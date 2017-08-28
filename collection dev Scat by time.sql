SELECT
icode1 AS "Scat",
COUNT (id) AS "Item total",
COUNT (id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 month')) AS "1 month",
ROUND(CAST(COUNT(id) FILTER(WHERE last_checkout_gmt >= (localtimestamp - interval '1 month')) AS NUMERIC (12,2)) / CAST(count (id) AS NUMERIC (12,2)), 6) AS "Percentage_1 month",
COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '1 months')) AND (last_checkout_gmt >= (localtimestamp - interval '3 months'))) AS "3 months",
COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '3 months')) AND (last_checkout_gmt >= (localtimestamp - interval '1 year'))) AS "1 year",
COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '1 year')) AND (last_checkout_gmt >= (localtimestamp - interval '2 years'))) AS "2 years",
COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '2 years')) AND (last_checkout_gmt >= (localtimestamp - interval '3 years'))) AS "3 years",
COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '3 years')) AND (last_checkout_gmt >= (localtimestamp - interval '4 years'))) AS "4 years",
COUNT (id) FILTER(WHERE (last_checkout_gmt < (localtimestamp - interval '4 years')) AND (last_checkout_gmt >= (localtimestamp - interval '5 years'))) AS "5 years"
FROM
sierra_view.item_record
WHERE location_code LIKE 'ntn%'
GROUP BY 1
ORDER BY 1;
