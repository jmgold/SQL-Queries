/*
Jeremy Goldstein
Minuteman Library Network

Monthly checkouts with unique patron count
*/
/*
Jeremy Goldstein
Minuteman Library network

Counts patrons who checkout items on multiple days within a month
*/

SELECT
md5(patron_record_id::VARCHAR) AS patron,
COUNT(DISTINCT(transaction_gmt::DATE)) AS total_visits,
string_agg(DISTINCT(to_char(transaction_gmt, 'dd-Mon-yyyy')), ', ') AS visit_dates,
COUNT(item_record_id) AS item_total
FROM
sierra_view.circ_trans
where
op_code = 'o'
and
transaction_gmt > NOW()::DATE - INTERVAL '1 month'
and stat_group_code_num in ('330','331')
GROUP BY 1
HAVING COUNT(DISTINCT(transaction_gmt::DATE)) > 1
ORDER BY 2 DESC