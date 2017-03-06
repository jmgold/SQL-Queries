-- count of order status usage...count command example
SELECT
  accounting_unit_code_num,
  order_status_code,
  count (*)         
FROM sierra_view.order_view
group by 1, 2
order by 1, 2;