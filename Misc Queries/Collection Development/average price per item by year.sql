/*
Jeremy Goldstein
Minuteman Library Network
finds the average price for an item by year
limited here to a single itype
*/
SELECT
  DATE_PART('year', rm.creation_date_gmt) AS "year",
  AVG(i.price)::MONEY AS avg_price,
  MODE() WITHIN GROUP(ORDER BY i.price)::MONEY AS mode_price
  
FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id

--Limit to an itype, adult book in this case
WHERE i.itype_code_num = '0'

GROUP BY 1
ORDER BY 1
