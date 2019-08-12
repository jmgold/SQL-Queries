/*
Jeremy Goldstein
Minuteman Library Network

Reproduces fund view from the fund function in acquisitions for a specified accounting unit 
*/

SELECT
DISTINCT f.fund_code,
fn.name,
ROUND(CAST(f.appropriation AS NUMERIC (12,2))/100,2)::MONEY,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY,
ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY,
ROUND(CAST((f.appropriation - f.expenditure- f.encumbrance) AS NUMERIC (12,2))/100,2)::MONEY AS "free balance",
ROUND(CAST((f.appropriation - f.expenditure) AS NUMERIC (12,2))/100,2)::MONEY AS "cash balance"

FROM
sierra_view.fund f
JOIN
sierra_view.fund_master fm
ON
f.fund_code = fm.code
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id

WHERE
f.acct_unit = '5'
AND f.fund_type = 'fbal'

ORDER BY 1