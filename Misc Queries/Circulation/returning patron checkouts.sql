/*
Jeremy Goldstein
Minuteman Library network

Identifies patrons who checkout items on multiple days within a month
*/

SELECT
--Patron id needed for grouping data in query, anonymizing via MD5 hash
MD5(patron_record_id::VARCHAR) AS patron_anon,
COUNT(DISTINCT(transaction_gmt::DATE)) AS total_visits,
STRING_AGG(DISTINCT(to_char(transaction_gmt, 'Mon-dd-yyyy')), ', ') AS visit_dates,
COUNT(item_record_id) AS item_total

FROM
sierra_view.circ_trans

WHERE
op_code = 'o'
AND
transaction_gmt > NOW()::DATE - INTERVAL '1 month'
AND stat_group_code_num in ('330','331')
GROUP BY 1
HAVING COUNT(DISTINCT(transaction_gmt::DATE)) > 1
ORDER BY 2 DESC