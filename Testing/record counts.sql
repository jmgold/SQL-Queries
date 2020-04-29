SELECT
l.name AS location,
COUNT(i.id) AS item_count,
COALESCE(c_count.checkin_count,0) AS checkin_count,
COALESCE(o_count.order_count,0) AS order_count

FROM
sierra_view.item_record i
FULL OUTER JOIN
(SELECT
h.location_code,
COUNT(h.holding_record_id) AS checkin_count
FROM
sierra_view.holding_record_location h
GROUP BY 1
) c_count
ON
i.location_code = c_count.location_code
FULL OUTER JOIN
(SELECT
o.location_code,
COUNT(o.order_record_id) AS order_count
FROM
sierra_view.order_record_cmf o
GROUP BY 1
) o_count
ON
i.location_code = o_count.location_code
JOIN
sierra_view.location_myuser l
ON
l.code = i.location_code OR l.code = c_count.location_code OR l.code = o_count.location_code

GROUP BY 1,3,4
ORDER BY 1



