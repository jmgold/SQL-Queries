/*
Jeremy Goldstein
Minuteman Library Network

Counts the number of paid or cancelled orders in each location created in prior fiscal years
Used for annual order record deletion
*/
SELECT
SUBSTRING(o.location_code,1,2),
COUNT(DISTINCT o.order_record_id)

FROM
sierra_view.order_record_cmf o
JOIN
sierra_view.record_metadata rm
ON
o.order_record_id = rm.id AND rm.creation_date_gmt::DATE <= '2018-07-01'
JOIN
sierra_view.order_record ord
ON
o.order_record_id = ord.id AND ord.order_status_code IN ('a','z')
GROUP BY 1