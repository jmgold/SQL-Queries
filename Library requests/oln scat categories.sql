SELECT
i.call_number_norm AS original,
CASE
  WHEN i.call_number_norm ~ '^cable' THEN 'CABLE'
  WHEN i.call_number_norm ~ '^dvd nf' THEN 'DVD NF'
  WHEN i.call_number_norm ~ '^dvd' THEN 'DVD'
  WHEN i.call_number_norm ~ '^fiction \(?graphic novel' THEN 'FICTION GRAPHIC NOVEL'
  WHEN i.call_number_norm ~ '^fiction \(?poetry' THEN 'FICTION POETRY'
  WHEN i.call_number_norm ~ '^fiction \(?story col' THEN 'FICTION STORY COLLECTION'
  WHEN i.call_number_norm ~ '^fiction \(?theater' THEN 'FICTION THEATRE'
  WHEN i.call_number_norm ~ '^fiction' THEN 'FICTION'
  WHEN i.call_number_norm ~ '^game' THEN 'GAME'
  WHEN i.call_number_norm ~ '^media' THEN 'MEDIA'
  WHEN i.call_number_norm ~ '^tool' THEN 'TOOL'
  WHEN i.call_number_norm ~ '^zine' THEN 'ZINE'
  --contains an LC number in the 1000-9999 range
  WHEN i.call_number_norm ~ '^[a-z]{1,3}\s?[0-9]{4}' THEN BTRIM(SUBSTRING(REPLACE(i.call_number_norm,' ',''),'^[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(i.call_number_norm,'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999')
  --contains an LC number in the 001-999 range
  WHEN i.call_number_norm ~ '^[a-z]{1,3}\s?[0-9]{1,3}' THEN BTRIM(SUBSTRING(REPLACE(i.call_number_norm,' ',''),'^[a-z]{1,2}')||'001-999')
   
  ELSE 'UNKNOWN'
END AS collection,
rm.record_type_code||rm.record_num||'a' AS record_num

FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
--avoid comcat items
AND
ir.location_code ~ '^oln'
JOIN
sierra_view.record_metadata rm
ON
i.item_record_id = rm.id AND rm.campus_code = ''

ORDER BY 2,1