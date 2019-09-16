SELECT
p.ptype_code,
COUNT(p.id) AS patron_count,
SUM(p.checkout_count) AS total_checkout,
COUNT(p.id) FILTER (WHERE p.owed_amt >= 10 OR p.mblock_code != '-') AS blocked_patron_count,
ROUND(1.0 * COUNT(p.id) / (SELECT COUNT(id) FROM sierra_view.patron_record),4) AS relative_patron_count,
ROUND(1.0 * SUM(p.checkout_count) / (SELECT SUM(checkout_count) FROM sierra_view.patron_record),4) AS relative_total_checkout,
ROUND(1.0 * COUNT(p.id) FILTER (WHERE p.owed_amt >= 10 OR p.mblock_code != '-') / (SELECT COUNT(id) FILTER (WHERE owed_amt >= 10 OR mblock_code != '-') FROM sierra_view.patron_record),4) AS relative_blocked_patrons

FROM
sierra_view.patron_record p

GROUP BY 1
ORDER BY 1