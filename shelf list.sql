SELECT  
-- bib fields
  b.record_num             AS "bib_record",
  b.title                  AS "bib_title",
  bc.field_content         AS "bib_record_call_number",
  -- item fields
  i.record_num             AS "item_record",
  i.item_status_code,  i.location_code    AS "item_location_code",
  i.barcode                AS "item_record_barcode",
  ic.field_content         AS "item_record_call_number",
  TRIM(REGEXP_REPLACE(ic.field_content,'\|.',' ','g'))
    AS "item_record_call_number_subfield_tags_removed",
  iv.marc_tag              AS "item_record_varfield_v_marc_tag",
  iv.field_content         AS "item_record_volume",
  i.last_checkin_gmt,
  --checkout fields
  c.due_gmt
FROM  sierra_view.item_view i
    JOIN sierra_view.bib_record_item_record_link birl
      ON i.id = birl.item_record_id
    JOIN sierra_view.bib_view b
      ON b.id = birl.bib_record_id
    JOIN sierra_view.checkout c
      ON c.item_record_id = i.id
    -- Join for item record varfield type code 'c'
    LEFT OUTER JOIN sierra_view.varfield ic
      ON i.id = ic.record_id AND ic.varfield_type_code = 'c'
    -- Join for item record varfield type code 'v'
    LEFT OUTER JOIN sierra_view.varfield iv
      ON i.id = iv.record_id AND iv.varfield_type_code = 'v'
    -- Join for bib record varfield type code  'c'
    LEFT OUTER JOIN sierra_view.varfield bc
      ON b.id = bc.record_id AND bc.varfield_type_code = 'c'
WHERE   i.agency_code_num = '8';