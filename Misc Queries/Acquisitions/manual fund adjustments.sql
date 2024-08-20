/*
Jeremy Goldstein
Minuteman Library Network

Searches the payment history file for manual fund adjustments within an accounting unit
*/

SELECT 
t.posted_date::DATE AS posted_date,
t.source_name AS transaction_type, 
fm.code,
t.amt::MONEY AS amt


FROM
sierra_view.accounting_transaction t
JOIN
sierra_view.fund_master fm
ON
t.fund_master_id = fm.id AND fm.accounting_unit_id = '37'
WHERE
t.accounting_unit_id = 37
AND t.source_name ~ 'Manual'
ORDER BY t.posted_date