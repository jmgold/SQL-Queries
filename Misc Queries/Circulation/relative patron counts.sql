SELECT
p.ptype_code,
pt.name AS ptype_name,
COUNT(p.id) AS patron_count,
SUM(p.checkout_count) AS total_checkout,
COUNT(p.id) FILTER (WHERE p.owed_amt >= 100 OR p.mblock_code != '-') AS blocked_patron_count,
ROUND(100.0 * COUNT(p.id) / (SELECT COUNT(id) FROM sierra_view.patron_record),2) AS relative_patron_count,
ROUND(100.0 * SUM(p.checkout_count) / (SELECT SUM(checkout_count) FROM sierra_view.patron_record),2) AS relative_total_checkout,
ROUND(100.0 * COUNT(p.id) FILTER (WHERE p.owed_amt >= 10 OR p.mblock_code != '-') / (SELECT COUNT(id) FILTER (WHERE owed_amt >= 10 OR mblock_code != '-') FROM sierra_view.patron_record),2) AS relative_blocked_patrons

FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value
JOIN
sierra_view.location_myuser loc
ON
SUBSTRING(p.home_library_code,1,3) = loc.code

GROUP BY 1,2
ORDER BY 6 DESC