SELECT 
f.paid_date_gmt::DATE AS DATE,
COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code IN ('2','6'))::MONEY,0.00::MONEY) AS overdue,
COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '5')::MONEY,0.00::MONEY) AS lost_book,
COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '3')::MONEY,0.00::MONEY) AS replacement,
COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '1')::MONEY,0.00::MONEY) AS manual_charge,
COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '4')::MONEY,0.00::MONEY) AS adjustment,
COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code BETWEEN '1' AND '6')::MONEY,0.00::MONEY) AS total

FROM
sierra_view.fines_paid f

WHERE
f.tty_num::VARCHAR ~ '^50'
AND f.payment_status_code NOT IN ('0','3')
AND f.paid_now_amt > 0
AND f.paid_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 week'

GROUP BY 1
ORDER BY 1