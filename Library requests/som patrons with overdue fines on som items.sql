SELECT
DISTINCT ID2RECKEY(f.patron_record_id)||'a'
FROM
sierra_view.fine f
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id
AND i.location_code ~ '^so'
AND f.charge_code IN ('2','4','6')