/*
Jeremy Goldstein
Minuteman Library Network

Staff interface for easily pulling data from circ_trans table
*/

SELECT
  *,
  '' AS "CIRC TRANSACTION LOOKUP",
  '' AS "https://sic.minlib.net/reports/49"
FROM (
  SELECT 
    c.transaction_gmt AS transaction_time,
    c.application_name,
    CASE
      WHEN c.op_code = 'o' THEN 'checkout'
      WHEN c.op_code = 'i' THEN 'checkin'
      WHEN c.op_code = 'n' THEN 'hold'
      WHEN c.op_code = 'nb' THEN 'bib hold'
      WHEN c.op_code = 'ni' THEN 'item hold'
      WHEN c.op_code = 'h' THEN 'hold with recall'
      WHEN c.op_code = 'hb' THEN 'hold recall bib'
      WHEN c.op_code = 'hi' THEN 'hold recall item'
      WHEN c.op_code = 'f' THEN 'filled hold'
      WHEN c.op_code = 'r' THEN 'renewal'
      WHEN c.op_code = 'u' THEN 'use count'
    END AS transaction_type,
    p.record_type_code||p.record_num||'a' AS patron_recoord,
    p.barcode AS patron_barcode,
    im.record_type_code||im.record_num||'a' AS item_record,
    bm.record_type_code||bm.record_num||'a' AS bib_record,
    c.stat_group_code_num AS stat_group,
    c.due_date_gmt AS due_date,
    c.count_type_code_num AS count_type,
    c.itype_code_num AS itype,
    c.icode1 AS scat,
    c.item_location_code,
    c.ptype_code,
    c.patron_home_library_code AS patron_home_library,
    c.loanrule_code_num AS loanrule,
    i.call_number_norm AS call_number,
    i.barcode AS item_barcode,
    b.best_title_norm AS title,
    b.material_code AS mat_type

  FROM sierra_view.circ_trans c
  JOIN sierra_view.bib_record_property b
    ON c.bib_record_id = b.bib_record_id
  JOIN sierra_view.record_metadata bm
    ON c.bib_record_id = bm.id
  JOIN sierra_view.patron_view p
    ON c.patron_record_id = p.id
  LEFT JOIN sierra_view.item_record_property i
    ON c.item_record_id = i.item_record_id
  LEFT JOIN sierra_view.record_metadata im
    ON c.item_record_id = im.id

WHERE c.transaction_gmt BETWEEN {{start_time}} AND {{end_time}}
  --if filters include/exclude row based on boolean checkbox
  {{#if include_op}}AND c.op_code IN ({{op_code}}){{/if include_op}}
  {{#if include_stat}}AND c.stat_group_code_num IN ({{stat_group}}){{/if include_stat}}
  {{#if include_location}}AND SUBSTRING(c.item_location_code,1,3) ~ {{location}} {{/if include_location}}
  {{#if include_title}}AND b.best_title_norm LIKE LOWER('%{{title}}%') {{/if include_title}}
  {{#if include_patron_barcode}}AND p.barcode = {{patron_barcode}}{{/if include_patron_barcode}}
  {{#if include_item_barcode}}AND i.barcode = {{barcode}}{{/if include_item_barcode}}
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.

ORDER BY 1
)a