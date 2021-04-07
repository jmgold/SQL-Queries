WITH patron_count AS (
SELECT
l.name AS home_library,
COUNT(p.id) AS total_patrons
FROM
sierra_view.patron_record p
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(p.home_library_code,1,3) = l.code


GROUP BY 1
)

SELECT
DISTINCT l.name AS checkout_location,
SUM(DISTINCT p.total_patrons) AS total_patrons,
COUNT(DISTINCT f.patron_record_id) AS total_patrons_with_fines,
COUNT(DISTINCT f.patron_record_id) FILTER(WHERE i.item_status_code = 'n') total_patrons_billed_items,
COUNT(DISTINCT i.id) FILTER(WHERE i.item_status_code = 'n') AS billed_item_count,
SUM(i.price) FILTER(WHERE i.item_status_code = 'n')::MONEY AS billed_item_value,
COUNT(DISTINCT f.patron_record_id) FILTER(WHERE CURRENT_DATE - f.due_gmt::DATE > 60) total_patrons_overdue_60,
COUNT(DISTINCT f.patron_record_id) FILTER(WHERE CURRENT_DATE - f.due_gmt::DATE > 90) total_patrons_overdue_90,
COUNT(DISTINCT f.patron_record_id) FILTER(WHERE CURRENT_DATE - f.due_gmt::DATE > 180) total_patrons_overdue_180

FROM
sierra_view.fine f
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(f.charge_location_code,1,2) = SUBSTRING(l.code,1,2) AND l.code ~ '^[a-z]{3}$' AND l.code != 'mls'
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id
JOIN
patron_count p
ON
l.name = SPLIT_PART(p.home_library,'/',1)

WHERE SUBSTRING(f.charge_location_code,1,3) NOT IN ('','cmc','mb2','mbc','nby','non','trn','urs','zzz','mti')

GROUP BY 1
ORDER BY 1
