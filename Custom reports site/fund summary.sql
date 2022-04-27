/*
Jeremy Goldstein
Minuteman Library Network

Reproduces fund view from the fund function in acquisitions for a specified accounting unit 
*/

SELECT
DISTINCT f.fund_code AS "Fund Code",
fn.name AS "Fund Name",
ROUND(CAST(f.appropriation AS NUMERIC (12,2))/100,2)::MONEY AS Appropriation,
ROUND(CAST(f.expenditure AS NUMERIC (12,2))/100,2)::MONEY AS Expenditure,
ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY AS Encumbrance,
ROUND(CAST((f.appropriation - f.expenditure- f.encumbrance) AS NUMERIC (12,2))/100,2)::MONEY AS "Free Balance",
ROUND(CAST((f.appropriation - f.expenditure) AS NUMERIC (12,2))/100,2)::MONEY AS "Cash Balance",
--percentage calculations from Eric McCarthy
COALESCE(CASE
  WHEN f.appropriation > 0 THEN CONCAT(((f.expenditure + f.encumbrance)*100)/f.appropriation, '%') 
END,'N/A') AS "Percent Spent (Free Balance)",
COALESCE(CASE
  WHEN f.appropriation > 0 THEN CONCAT((f.expenditure*100)/f.appropriation, '%') 
END,'N/A') AS "Percent Spent (Cash Balance)",
--FY assumed to start on July 1st
CONCAT(((CURRENT_DATE - (CASE
	WHEN EXTRACT('month' FROM CURRENT_DATE) < 7 THEN ((EXTRACT('year' FROM CURRENT_DATE)-1)||'-07-01')::DATE
	ELSE (EXTRACT('year' from CURRENT_DATE)||'-07-01')::DATE
END))*100)/365, '%') AS "Percent of FY"


FROM
sierra_view.fund f
JOIN
sierra_view.accounting_unit a
ON
f.acct_unit = a.code_num
JOIN
sierra_view.fund_master fm
ON
f.fund_code = fm.code AND fm.accounting_unit_id = a.id
JOIN
sierra_view.fund_property fp
ON
fm.id = fp.fund_master_id AND fp.fund_type_id = '1'
JOIN
sierra_view.fund_property_name fn
ON
fp.id = fn.fund_property_id

WHERE
f.acct_unit = {{accounting_unit}}
AND f.fund_type = 'fbal'

ORDER BY 1