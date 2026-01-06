/*
Jeremy Goldstein
Minuteman Library Network

Identifies bib records where a library has attached a paid order record and 0 items
Limited to full monographic records

Is passed an owning location variable
*/

SELECT
  *,
  '' AS "ORPHANED ORDER RECORDS",
  '' AS "https://sic.minlib.net/reports/17"
FROM (
  SELECT
    DISTINCT id2reckey(b.bib_record_id)||'a' AS rec_num,
    b.best_title AS title,
    MAX(o.paid_date_gmt::DATE) AS paid_date
  FROM sierra_view.bib_record br
  JOIN sierra_view.bib_record_order_record_link l
    ON br.id = l.bib_record_id
  JOIN sierra_view.order_record_paid o
    ON l.order_record_id = o.order_record_id
  JOIN sierra_view.order_record_cmf cmf
    ON o.order_record_id = cmf.order_record_id
  JOIN sierra_view.bib_record_property b
    ON br.id = b.bib_record_id

  WHERE br.bcode1 = 'm'
	 AND br.bcode3 NOT IN ('b','g','c','z')
	 AND cmf.location_code ~ {{location}}
	 --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
	 AND NOT EXISTS (
      SELECT
		  1 
      FROM sierra_view.bib_record_item_record_link bl
      JOIN sierra_view.item_record i 
        ON bl.item_record_id = i.id
		  AND i.location_code ~ {{location}}
        --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
      WHERE l.bib_record_id = bl.bib_record_id
    )

  GROUP BY 1,2
  ORDER BY 3
)a