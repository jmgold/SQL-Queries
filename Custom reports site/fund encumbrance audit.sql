/*
Jeremy Goldstein
Minuteman Library Network

compares current funds to values of open orders and paid invoices 
*/

--Gather total price of open order records for each fund 

WITH partial_payments AS (
  SELECT
    o.id,
    SUM(op.copies) AS copies
    
  FROM sierra_view.order_record o
  JOIN sierra_view.order_record_paid op
    ON o.id = op.order_record_id

  WHERE o.order_status_code = 'q'
    AND o.accounting_unit_code_num = {{accounting_unit}}

  GROUP BY 1
),

order_encumbrance AS (
  SELECT
    fm.code,
    ROUND(o.estimated_price * (SUM(cmf.copies) - COALESCE(p.copies,0)),2)::MONEY AS encumbrance_orders

  FROM sierra_view.order_record o
  JOIN sierra_view.order_record_cmf cmf
    ON o.id = cmf.order_record_id
	 AND cmf.location_code != 'multi'
  JOIN sierra_view.accounting_unit a
    ON o.accounting_unit_code_num = a.code_num
  JOIN sierra_view.fund_master fm
    ON fm.code_num = cmf.fund_code::INT
	 AND fm.accounting_unit_id = a.id
  LEFT JOIN partial_payments p
    ON o.id = p.id

  WHERE o.accounting_unit_code_num = {{accounting_unit}}
    AND o.order_status_code IN ('o','q','g','c')

  GROUP BY 1,o.estimated_price,p.copies
)

SELECT
  *,
  '' AS "FUND ENCUMBRANCE AUDIT",
  '' AS "https://sic.minlib.net/reports/56"
FROM (
  SELECT
    DISTINCT f.fund_code,
    fn.name AS "name",
    ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY AS encumbrance,
    SUM(COALESCE(oe.encumbrance_orders,0::MONEY)) AS order_encumbrance,
    ROUND(CAST(f.encumbrance AS NUMERIC (12,2))/100,2)::MONEY - SUM(COALESCE(oe.encumbrance_orders,0::MONEY)) AS difference

  FROM sierra_view.fund f
  JOIN sierra_view.accounting_unit a
    ON f.acct_unit = a.code_num
  JOIN sierra_view.fund_master fm
    ON f.fund_code = fm.code
	 AND fm.accounting_unit_id = a.id
  JOIN sierra_view.fund_property fp
    ON fm.id = fp.fund_master_id
	 AND fp.fund_type_id = '1'
  JOIN sierra_view.fund_property_name fn
    ON fp.id = fn.fund_property_id
  LEFT JOIN order_encumbrance oe
    ON fm.code = oe.code

  WHERE f.acct_unit = {{accounting_unit}}
    AND f.fund_type = 'fbal'
    AND fp.is_active = true

  GROUP BY 1,2,3
  ORDER BY 1
)a