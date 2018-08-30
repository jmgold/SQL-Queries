--Jeremy Goldstein
--Value calculator for circ transactions from prior week

SELECT
CAST(SUM(i.price) AS MONEY) AS data
--uncomment to check calculation
--,c.id,
--i.price
FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
WHERE
c.op_code IN ('o', 'r')
AND
c.transaction_gmt >= (localtimestamp - interval '7 days')