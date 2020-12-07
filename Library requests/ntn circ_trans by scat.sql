SELECT
CASE
	WHEN i.location_code IN ('ntnan','ntnnn','ntnjn','ntnyn') THEN i.location_code
	ELSE i.icode1::VARCHAR
END AS "scat/loc",
COUNT(t.id) FILTER (WHERE t.op_code = 'o') AS checkout_total,
COUNT(t.id) FILTER (WHERE t.op_code = 'r') AS renewal_total,
COUNT(t.id) FILTER (WHERE t.op_code IN ('o','r')) AS circ_total

FROM
sierra_view.circ_trans t
JOIN
sierra_view.item_record i
ON
t.item_record_id = i.id AND i.location_code ~ '^ntn'

GROUP BY 1
ORDER BY 1