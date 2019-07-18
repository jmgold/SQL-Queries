SELECT
CAST(SUM(i.price) AS MONEY) AS value,
COUNT(c.id) AS circ_count,
(CAST(SUM(i.price) AS MONEY) / COUNT(c.id)) as value_per_circ
FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
WHERE
c.op_code IN ('o', 'r')
AND
c.transaction_gmt::DATE {{relative_date}}
AND
i.location_code ~ {{location}}