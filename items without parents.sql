SELECT
  'i'||item_view.record_num||'a'
FROM
  sierra_view.item_view
LEFT JOIN
  sierra_view.bib_record_item_record_link ON
  item_view.id = bib_record_item_record_link.item_record_id
WHERE
  bib_record_item_record_link.item_record_id is NULL
  