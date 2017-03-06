-- finds order records that predate a specified year across accounting units
SELECT
  'o'||record_num||'a'               AS "ord_record",
  date(order_date_gmt) AS "ord_cataloged_date",
  order_status_code         AS "status",
  accounting_unit_code_num AS "Accounting_Unit"
FROM sierra_view.order_view
WHERE date_part('year', order_date_gmt) < 2014 and date_part ('month', order_date_gmt) < 07
Order by 4,3,2;