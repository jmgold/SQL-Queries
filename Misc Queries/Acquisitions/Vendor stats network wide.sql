SELECT
  CASE
    WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^(Baker)|(BT)|(B&)|(baker)' THEN 'Baker & Taylor'
    WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^ABDO' THEN 'ABDO'
    WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^ABC\-' THEN 'ABC-CLIO'
    WHEN REGEXP_REPLACE(LOWER(TRIM(vf.field_content)),'\,|\/|\.','','g') ~ '^amazon' THEN 'Amazon'
    WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^J Apple' THEN 'J Appleseed'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ 'JSTOR' THEN 'JSTOR'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Ingram' THEN 'Ingram'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Mid' THEN 'Midwest Tapes'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Overdrive' THEN 'Overdrive'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Thorndike' THEN 'Thorndike'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^World Book' THEN 'World Book'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^WT' THEN 'WT Cox'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^(Findaway)|(Playaway)' THEN 'Playaway'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Blackstone' THEN 'Blackstone'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Buo' THEN 'BuoBooks'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^(Cavendish)|(Marshall)' THEN 'Cavendish Square'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Multicultural' THEN 'Multicultural Books & Video'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^ProQ|q' THEN 'ProQuest'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Rosen' THEN 'Rosen Publishing'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Rowman' THEN 'Rowman & LIttlefield'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Scholastic' THEN 'Scholastic'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Sebco' THEN 'Sebco Books'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Sentrum' THEN 'Sentrum'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Tsai' THEN 'Tsai Fong Books'
	 WHEN REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g') ~ '^Tumbleweed' THEN 'Tumbleweed Press'
	 ELSE REGEXP_REPLACE(TRIM(vf.field_content),'\,|\/|\.','','g')
  END AS vendor,
  COUNT(o.id) AS total_orders,
  COUNT(DISTINCT v.accounting_unit_code_num) AS total_libraries
FROM sierra_view.order_record o
JOIN sierra_view.vendor_record v
  ON o.vendor_record_code = v.code
  AND o.accounting_unit_code_num = v.accounting_unit_code_num
JOIN sierra_view.varfield vf
  ON v.id = vf.record_id AND vf.varfield_type_code = 't'
GROUP BY 1
ORDER BY 1