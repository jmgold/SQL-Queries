SELECT
REPLACE(ip.call_number,'|a','') AS call_number,
ip.barcode,
COUNT(t.id) FILTER(WHERE t.op_code = 'o') AS checkout_total,
COUNT(t.id) FILTER(WHERE t.op_code = 'r') AS renewal_total,
COUNT(t.id) FILTER(WHERE t.op_code IN ('o','r')) AS circulation_total
FROM
sierra_view.circ_trans t
JOIN
sierra_view.item_record_property ip
ON
t.item_record_id = ip.item_record_id

WHERE
t.itype_code_num IN ('245','246','250') AND t.item_location_code ~ '^dea'
AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 1,2
ORDER BY 1