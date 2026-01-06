/*
Jeremy Goldstein
Minuteman Library Network

Identifies items where the itype doesn't match the bib record the item is attached to
*/

SELECT
  *,
  '' AS "ITYPE/MATTYPE MISMATCHES"
FROM (
  SELECT
    DISTINCT rm.record_type_code||rm.record_num||'a' AS item_number,
    b.best_title AS title,
    m.name AS mat_type,
    it.name AS itype,
    i.location_code AS location

  FROM  sierra_view.item_record i
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN sierra_view.bib_record_property b
    ON l.bib_record_id = b.bib_record_id
  JOIN sierra_view.material_property_myuser m
    ON b.material_code = m.code
  JOIN sierra_view.itype_property_myuser it
    ON i.itype_code_num = it.code
  JOIN sierra_view.record_metadata rm
    ON i.id = rm.id

  WHERE i.itype_code_num NOT IN ('239','240','241','242')
    AND i.location_code ~ {{location}}
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND (
	   (b.material_code IN ('a','c','2','t') AND i.itype_code_num NOT IN ('0','1','2','3','4','5','6','7','8','9','12','100','101','102','103','104','105','106','109','150','151','152','153','154','155','156','157','160','221','222','223','224'))
      OR (b.material_code = 'b' AND i.itype_code_num NOT IN ('244','248','249'))
      OR (b.material_code = 'e' AND i.itype_code_num NOT IN ('3','6','11','103','154'))
      OR (b.material_code = 'g' AND i.itype_code_num NOT IN ('6','22','25','26','112','115','116','165','166'))
      OR (b.material_code = 'h' AND i.itype_code_num NOT IN ('244','248','249'))
      OR (b.material_code = 'i' AND i.itype_code_num NOT IN ('6','38','41','126','174'))
      OR (b.material_code = 'j' AND i.itype_code_num NOT IN ('6','33','34','123','171'))
      OR (b.material_code = 'k' AND i.itype_code_num NOT IN ('6','13','45','46','108','159','247'))
      OR (b.material_code = 'l' AND i.itype_code_num NOT IN ('244','248'))
      OR (b.material_code = 'm' AND i.itype_code_num NOT IN ('6','31','32','42','43','121','122','129','169','170','178','248'))
      OR (b.material_code = 'n' AND i.itype_code_num NOT IN ('6','43','129','178'))
      OR (b.material_code = 'o' AND i.itype_code_num NOT IN ('6','13','47','108','127','159','176','186','187','188','189','245','251','252','253'))
      OR (b.material_code = 'p' AND i.itype_code_num NOT IN ('6','13','47','108','127','159','176','186','187','188','189','245','251','252','253'))
      OR (b.material_code = 'q' AND i.itype_code_num NOT IN ('6','13','47','51','108','127','131','159','176','181','186','187','188','189','245','246','250','251','252','253','256','257'))
      OR (b.material_code = 'r' AND i.itype_code_num NOT IN ('6','13','48','108','128','159','177','186','187','188','189','221','222','223','224','243','245','246','250','251','252','253','256','257'))
      OR (b.material_code = 's' AND i.itype_code_num NOT IN ('244','248','249'))
      OR (b.material_code IN ('u','5') AND i.itype_code_num NOT IN ('6','19','20','21','23','27','28','29','30','113','117','118','119','120','133','163','164','167','168','183'))
      OR (b.material_code = 'v' AND i.itype_code_num NOT IN ('6','51','131','181','186','187','188','189','245','246','251','252','253'))
      OR (b.material_code = 'w' AND i.itype_code_num NOT IN ('244','248','249'))
      OR (b.material_code = 'x' AND i.itype_code_num NOT IN ('6','52','132','182'))
      OR (b.material_code = 'y' AND i.itype_code_num NOT IN ('244','248','249'))
      OR (b.material_code = 'z' AND i.itype_code_num NOT IN ('6','50','130','180'))
      OR (b.material_code = '3' AND i.itype_code_num NOT IN ('6','10','107','158','221','222','223','224'))
      OR (b.material_code = '4' AND i.itype_code_num NOT IN ('6','36','37','41','125','173'))
      OR (b.material_code = '6' AND i.itype_code_num NOT IN ('6','44','45','46','179'))
      OR (b.material_code = '7' AND i.itype_code_num NOT IN ('6','35','124','172'))
      OR (b.material_code = '8' AND i.itype_code_num NOT IN ('6','40'))
      OR (b.material_code = '9' AND i.itype_code_num NOT IN ('6','150','151','152','155','157','160'))
    )
)a