--Jeremy Goldstein
--Minuteman Library Network

--Gathers payments on standing order records made within a specified time period
--Special request from ARL

select *
FROM
sierra_view.order_record_paid as p
JOIN
sierra_view.order_record as o
ON p.order_record_id=o.id
JOIN
sierra_view.order_record_cmf as f
ON o.id=f.order_record_id
where date(p.paid_date_gmt) BETWEEN '2016-07-01' and '2017-06-30'
AND o.accounting_unit_code_num = '2'
AND o.order_type_code = 'o';
