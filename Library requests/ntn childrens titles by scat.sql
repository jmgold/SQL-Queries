SELECT
i.icode1 AS scat,
rm.record_type_code||rm.record_num||'a' AS bibnumber,
b.best_title,
b.best_author,
SUM(i.checkout_total) AS checkout_total,
COUNT(i.id) AS copies,
ROUND(SUM(i.checkout_total) / (COUNT(i.id) * 1.0),2) AS turnover

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^ntn(j|y)'
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id

WHERE i.icode1 = '6980'
GROUP BY 1,2,3,4
HAVING SUM(i.checkout_total) / (COUNT(i.id) * 1.0) >= 3
ORDER BY 1,7 DESC
