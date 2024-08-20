/*
Jeremy Goldstein
Minuteman Library Network
Created for Millis to determine the average time between when a fine is assessed and when it is paid for their patrons
*/
SELECT
CASE
	WHEN f.charge_type_code = '1' THEN 'manual charge'
	WHEN f.charge_type_code = '2' THEN 'overdue'
	WHEN f.charge_type_code = '3' THEN 'replacement'
	WHEN f.charge_type_code = '4' THEN 'adjustment (overduex)'
	WHEN f.charge_type_code = '5' THEN 'lost book'
	WHEN f.charge_type_code = '6' THEN 'overdue renewed'
	WHEN f.charge_type_code = '7' THEN 'rental'
END AS ChargeType,
COUNT (DISTINCT f.id) AS Count_Fines,
COUNT (DISTINCT f.id) AS Count_Paid_Fines,
--COUNT (DISTINCT f.id) AS Count_Unpaid_Fines,
MIN (f.paid_date_gmt::DATE - f.fine_assessed_date_gmt::DATE) AS Min_time_to_payment,
MAX (f.paid_date_gmt::DATE - f.fine_assessed_date_gmt::DATE) AS Max_time_to_payment,
ROUND(AVG (f.paid_date_gmt::DATE - f.fine_assessed_date_gmt::DATE)) AS Average_time_to_payment

FROM
sierra_view.fines_paid AS f
JOIN
sierra_view.patron_record AS p
ON
p.id=f.patron_record_metadata_id

--Limit to a selected patron type
WHERE p.ptype_code='3'
--limit to fully paid fines
AND f.payment_status_code = '1'

GROUP BY 1