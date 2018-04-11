--Jeremy Goldstein
--Minuteman Library Network

--Pair with output of collection dev item report to see circ totals along side payment data

SELECT
b.bcode2 AS mat_type,
SUM(p.copies) AS paid_copies,
Round(SUM(p.paid_amount),2) AS total_payment 
from
sierra_view.bib_view as b
JOIN sierra_view.bib_record_order_record_link as bo
ON
b.id=bo.bib_record_id
JOIN sierra_view.order_view as o
ON
bo.order_record_id=o.record_id
--limit to accounting unit, should match agency entered in collection dev item report
AND
o.accounting_unit_code_num = '6'
JOIN sierra_view.order_record_paid as p
ON
o.record_id=p.order_record_id
WHERE
o.record_creation_date_gmt > '06-30-2014'
group by 1
order by 1
;
