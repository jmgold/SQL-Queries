/*
Jeremy Goldstein
Minuteman Library Network

Extract of link tables along with record numbers from record_metadata
*/

SELECT
  *,
  '' AS "RECORD LINK DATA",
  '' AS "https://sic.minlib.net/reports/76"
FROM (
  SELECT
  DISTINCT l.id,
  l.bib_record_id,
  rb.record_type_code AS bib_record_type_code,
  rb.record_num AS bib_record_num,
  {{record_type}}

  {{#if include_review_file}}
  JOIN sierra_view.bool_set bs
    ON (bs.record_metadata_id = r2.id OR bs.record_metadata_id = l.bib_record_id)
	 AND bs.bool_info_id = {{review_file}}
  {{/if include_review_file}}

  WHERE r.location_code ~ {{location}}
  --location using the form ^act in order to reuse an existing filter

  /*
  --if item selected

    r2.id AS item_record_id,
    r2.record_type_code AS item_record_type_code,
    r2.record_num AS item_record_num,
    l.items_display_order

  FROM sierra_view.item_record r
  JOIN sierra_view.bib_record_item_record_link l
    ON r.id = l.item_record_id
  JOIN sierra_view.record_metadata rb 
    ON l.bib_record_id = rb.id
  JOIN sierra_view.record_metadata r2
    ON l.item_record_id = r2.id
  */
  /*
  --if order selected

    r2.id AS order_record_id,
    r2.record_type_code AS order_record_type_code,
    r2.record_num AS order_record_num,
    l.orders_display_order

  FROM sierra_view.order_record_cmf r
  JOIN sierra_view.bib_record_order_record_link l
    ON r.order_record_id = l.order_record_id
  JOIN sierra_view.record_metadata rb 
    ON l.bib_record_id = rb.id
  JOIN sierra_view.record_metadata r2
    ON l.order_record_id = r2.id
  */
  /*
  --if holding selected

    r2.id AS holding_record_id,
    r2.record_type_code AS holding_record_type_code,
    r2.record_num AS holding_record_num,
    l.holdings_display_order

  FROM sierra_view.holding_record_location r
  JOIN sierra_view.bib_record_holding_record_link l
    ON r.holding_record_id = l.holding_record_id
  JOIN sierra_view.record_metadata rb 
    ON l.bib_record_id = rb.id
  JOIN sierra_view.record_metadata r2
    ON l.holding_record_id = r2.id
  */
