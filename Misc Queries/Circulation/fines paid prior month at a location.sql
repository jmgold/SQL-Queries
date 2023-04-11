/*
Jeremy Goldstein
Minuteman Library Network

Collects fines paid details at a location from the prior month
*/

SELECT
	f.item_charge_amt::MONEY AS item_charge,
	f.paid_now_amt::MONEY AS amt_paid,
	f.processing_fee_amt::MONEY AS processing_fee,
   f.billing_fee_amt::MONEY AS billing_fee,
   CASE 
		WHEN f.charge_type_code = '1' THEN 'Manual Charge' WHEN charge_type_code = '2' THEN 'Overdue'
   	WHEN f.charge_type_code = '3' THEN 'Replacement' WHEN charge_type_code = '4' THEN 'Adjustment (OverdueX)'
      WHEN f.charge_type_code = '5' THEN 'Lost Book' WHEN charge_type_code = '6' THEN 'Overdue Renewed'
      WHEN f.charge_type_code = '7' THEN 'Rental' WHEN charge_type_code = '8' THEN 'Rental Adjustment'
      WHEN f.charge_type_code = '9' THEN 'Debit' WHEN charge_type_code = 'a' THEN 'Notice'
      WHEN f.charge_type_code = 'b' THEN 'Credit Card' WHEN charge_type_code = 'p' THEN 'Program'
		ELSE 'OTHER'
	END AS charge_type,
   f.charge_location_code,
	f.paid_date_gmt::DATE AS paid_date,
   f.description,
	f.tty_num AS terminal_number

FROM sierra_view.fines_paid f

WHERE f.paid_date_gmt >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
AND f.paid_date_gmt < DATE_TRUNC('month', CURRENT_DATE)
AND (f.tty_num::VARCHAR LIKE '%0' OR tty_num::VARCHAR LIKE '%9' OR tty_num::VARCHAR LIKE '%8')
AND f.payment_status_code != '0'
AND f.payment_status_code != '3'
AND f.charge_location_code ~ '^fp'

ORDER BY 6,7