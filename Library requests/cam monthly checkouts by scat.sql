SELECT
t.transaction_gmt::DATE,
i.location_code,
i.icode1 AS scat,
COUNT(t.id) AS checkout_total

FROM
sierra_view.circ_trans t
JOIN
sierra_view.item_record i
ON
t.item_record_id = i.id
AND i.icode1 IN ('165','166','167','168','170','180','185','186')
AND i.location_code IN ('camnn','ca4nn','ca5nn','ca6nn','ca7nn','ca8nn','ca9nn')
WHERE
t.op_code = 'o'
AND
 t.transaction_gmt::DATE BETWEEN CURRENT_DATE - INTERVAL '1 month' AND CURRENT_DATE

GROUP BY 1,2,3
ORDER BY 1,2,3