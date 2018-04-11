--Jeremy Goldstein
--Minuteman Library Network

--Created for Millis to determine the average time between when a fine is assessed and when it is paid for their patrons

SELECT
count (distinct f.id) AS "Count_Fines",
count (distinct CASE WHEN f.paid_gmt is not null then f.id END) AS "Count_Paid_Fines",
count (distinct CASE when f.paid_gmt is null then f.id END) AS "Count_Unpaid_Fines",
MIN (paid_gmt-assessed_gmt) AS "Min_time_to_payment",
MAX (paid_gmt-assessed_gmt) AS "Max_time_to_payment",
AVG (paid_gmt-assessed_gmt) AS "Average_time_to_payment"
FROM
sierra_view.fine as f
JOIN
sierra_view.patron_record as p
ON
--Limit to a selected patron type
p.id=f.patron_record_id and p.ptype_code='24'
