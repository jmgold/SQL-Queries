
--Reproduces fund view from the fund function in acquisitions for a specified accounting unit 

SELECT
fund.fund_code AS "FUND CODE",
round(cast (fund.appropriation as numeric (12,2))/100, 2) AS "APPROPRIATION",
round(cast (fund.expenditure as numeric (12,2))/100, 2) AS "EXPENDITURE",
round(cast (fund.encumbrance as numeric (12,2))/100, 2) AS "ENCUMBRANCE",
round(cast (fund.appropriation-fund.expenditure-fund.encumbrance as numeric (12,2))/100, 2) AS "FREE BALANCE",
round(cast (fund.appropriation-fund.expenditure as numeric (12,2))/100, 2) AS "CASH BALANCE"
 
FROM
  sierra_view.fund
    
 
WHERE
fund.acct_unit = '3'
;
