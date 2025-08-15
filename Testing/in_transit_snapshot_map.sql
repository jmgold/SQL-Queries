WITH transit AS (
  SELECT
    v.id AS id,
    SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) AS origin_loc,
    SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) AS destination_loc,
    CASE
      WHEN h.id IS NOT NULL THEN 'Hold'
      ELSE 'Home'
    END AS destination_purpose

  FROM sierra_view.item_record i
  JOIN sierra_view.varfield v
    ON i.id = v.record_id
	 AND v.varfield_type_code = 'm'
	 AND v.field_content LIKE '%IN TRANSIT%'
  LEFT JOIN sierra_view.hold h
    ON i.id = h.record_id
	 
	 
  WHERE i.item_status_code = 't'
)

SELECT
  lo.name AS origin,
  REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(bo.address,'[\$#]\(?[0-9]{3}\)?\.?(\s|\-)[0-9].*',''),'$',' '),'\s(http|www|hollistonlibrary.org).*','') AS origin_address,
  ld.name AS destination,
  REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(bd.address,'[\$#]\(?[0-9]{3}\)?\.?(\s|\-)[0-9].*',''),'$',' '),'\s(http|www|hollistonlibrary.org).*','') AS destination_address,
  t.destination_purpose,
  COUNT(t.*) AS total

FROM transit t
JOIN sierra_view.location_myuser lo
  ON t.origin_loc = lo.code
JOIN sierra_view.branch bo
  ON lo.branch_code_num = bo.code_num
JOIN sierra_view.location_myuser ld
  ON t.destination_loc = ld.code
JOIN sierra_view.branch bd
  ON ld.branch_code_num = bd.code_num
  
GROUP BY 1,2,3,4,5
ORDER BY 1,3