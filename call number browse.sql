/*call # browse / shelf list generator
Built by Sam Cook and shared over Sierra-ILS Slack workspace 5/10/19

Enter location, call #, limit and offset values
in rows 38,39,44,46,93,94,99,101
*/

SELECT
	*
FROM (
SELECT
	id2reckey(bib_number) AS bib_number,
	call_number,
	best_title,
	best_author,
	publish_year,
	barcode,
	name,
	string_agg(CASE WHEN (POSITION('|0' in CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END)>0) THEN substring(CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END,1,POSITION('|0' in CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END)-1) ELSE CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END END,'<br />') AS subjects
FROM
	(
	SELECT
		bil.bib_record_id AS bib_number,
		UPPER(call_number_norm) AS call_number,
		barcode,
		name,
		publish_year,
		left(best_title,50) AS best_title,
		left(best_author,50) AS best_author
	FROM
		sierra_view.item_record_property irp
		JOIN sierra_view.item_record i ON irp.item_record_id=i.id
		JOIN sierra_view.location_myuser l ON i.location_code=l.code
		JOIN sierra_view.bib_record_item_record_link bil ON i.id=bil.item_record_id
		JOIN sierra_view.bib_record_property brp ON bil.bib_record_id=brp.bib_record_id
		
	WHERE
		location_code LIKE 'fpl%'
		AND call_number_norm<LOWER('641.5')

	ORDER BY
		call_number_norm DESC
	LIMIT
		25
	OFFSET
		0
) b
	LEFT JOIN sierra_view.varfield v ON b.bib_number=v.record_id AND varfield_type_code='d'
GROUP BY
	bib_number,
	call_number,
	barcode,
	name,
	publish_year,
	best_title,
	best_author
ORDER BY
	call_number ASC
) before

UNION

SELECT
	*
FROM (
SELECT
	id2reckey(bib_number) AS bib_number,
	call_number,
	best_title,
	best_author,
	publish_year,
	barcode,
	name,
	string_agg(CASE WHEN (POSITION('|0' in CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END)>0) THEN substring(CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END,1,POSITION('|0' in CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END)-1) ELSE CASE WHEN (POSITION('|2' in v.field_content)>0) THEN substring(v.field_content,1,POSITION('|2' in v.field_content)-1) ELSE v.field_content END END,'<br />') AS subjects
FROM
	(
	SELECT
		bil.bib_record_id AS bib_number,
		UPPER(call_number_norm) AS call_number,
		barcode,
		name,
		publish_year,
		left(best_title,50) AS best_title,
		left(best_author,50) AS best_author
	FROM
		sierra_view.item_record_property irp
		JOIN sierra_view.item_record i ON irp.item_record_id=i.id
		JOIN sierra_view.location_myuser l ON i.location_code=l.code
		JOIN sierra_view.bib_record_item_record_link bil ON i.id=bil.item_record_id
		JOIN sierra_view.bib_record_property brp ON bil.bib_record_id=brp.bib_record_id
		
	WHERE
		location_code LIKE 'fpl%'
		AND call_number_norm>=LOWER('641.5')

	ORDER BY
		call_number_norm ASC
	LIMIT
		25
	OFFSET
		0
) b
	LEFT JOIN sierra_view.varfield v ON b.bib_number=v.record_id AND varfield_type_code='d'
GROUP BY
	bib_number,
	call_number,
	barcode,
	name,
	publish_year,
	best_title,
	best_author
ORDER BY
	call_number ASC
) after
ORDER BY
	call_number ASC