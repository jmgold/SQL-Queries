SELECT
SUBSTRING(p.home_library_code FROM 1 FOR 3),
ROUND(AVG(checkout_total + renewal_total) FILTER (WHERE owed_amt = '0'),2) AS "0_owed",
ROUND(AVG(checkout_total + renewal_total) FILTER (WHERE owed_amt BETWEEN '0.1' AND '.99'),2) AS "<$1_owed",
ROUND(AVG(checkout_total + renewal_total) FILTER (WHERE owed_amt BETWEEN '1' AND '2.49'),2) AS "<$2.50_owed",
ROUND(AVG(checkout_total + renewal_total) FILTER (WHERE owed_amt BETWEEN '2.5' AND '4.99'),2) AS "<$5_owed",
ROUND(AVG(checkout_total + renewal_total) FILTER (WHERE owed_amt BETWEEN '5' AND '9.99'),2) AS "<$10_owed",
ROUND(AVG(checkout_total + renewal_total) FILTER (WHERE owed_amt >= '10'),2) AS blocked
FROM
sierra_view.patron_record p
GROUP BY 1
ORDER BY 1