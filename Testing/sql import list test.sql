WITH barcodes as (
	SELECT
		barcode
	FROM
		unnest(ARRAY['9781569474631', '9780374310400', '0061050970', '9781624146893']) AS barcode
)
SELECT
	b.barcode,
	e.*
FROM
	barcodes as b
	LEFT OUTER JOIN sierra_view.phrase_entry as e on e.index_tag || e.index_entry = 'i' || b.barcode