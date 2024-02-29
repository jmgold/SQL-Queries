/*
Jeremy Goldstein
Minuteman Library Network

Find all funds in the network with an encumbrance originated in a prior fiscal year
*/

WITH open_orders AS (
	SELECT
	a.code_num AS accounting_unit,
	fm.code,
	cmf.copies - COALESCE(op.copies,0) AS copies,
	ROUND(SUM(o.estimated_price * (cmf.copies - COALESCE(op.copies,0))),2)::MONEY AS total_encumbered

	FROM sierra_view.order_record o
	JOIN sierra_view.record_metadata rm
	  ON o.id = rm.id
	JOIN sierra_view.order_record_cmf cmf
	  ON o.id = cmf.order_record_id  AND cmf.location_code != 'multi'
	JOIN sierra_view.accounting_unit a
	  ON o.accounting_unit_code_num = a.code_num
	JOIN sierra_view.fund_master fm
	  ON cmf.fund_code::INT = fm.code_num AND a.id = fm.accounting_unit_id
	LEFT JOIN sierra_view.order_record_paid op
	  ON o.id = op.order_record_id AND o.order_status_code = 'q'

	WHERE rm.creation_date_gmt::DATE <= '2023-07-01'
		AND o.order_status_code IN ('o','q','g','d')

	GROUP BY 1,2,3
)

SELECT
oo.accounting_unit,
oo.code,
SUM(oo.total_encumbered) AS total_encumbered,
SUM(copies) AS copies_on_order

FROM open_orders oo

GROUP BY 1,2
ORDER BY 1,2