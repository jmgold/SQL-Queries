/*
Jeremy Goldstein
Minuteman Library Network

Aris holdings by mat type and location code
Turn into pivot table in Excel
*/

SELECT
CASE
	WHEN i.itype_code_num = '46' AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'H9_Adult_Microform'
	WHEN i.itype_code_num = '248' THEN 'H5_Adult_E-Books'
	WHEN b.material_code IN ('a', '2', '9', 'c') AND ((SUBSTRING(i.location_code,4,1) = 'y') OR i.itype_code_num IN ('100','101','102','103','104','105','106','109')) THEN 'H12_YA_Books'
	WHEN b.material_code IN ('5', 'g', 'u', 'x') AND ((SUBSTRING(i.location_code,4,1) = 'y') OR i.itype_code_num IN ('113','114','115','116','117','118','119','120','132','133'))THEN 'H15_YA_Videos'
	WHEN b.material_code IN ('4', '7', '8', 'i', 'j', 'z') AND ((SUBSTRING(i.location_code,4,1) = 'y') OR i.itype_code_num IN ('123','124','125','126','130')) THEN 'H14_YA_Audio'
	WHEN b.material_code IN ('e', '6', 'k', 'o', 'p', 'q', 'r', 't', 'v') AND (SUBSTRING(i.location_code,4,1) = 'y') THEN 'H21_YA_Misc'
	WHEN b.material_code IN ('m', 'n') AND (SUBSTRING(i.location_code,4,1) = 'y') THEN 'H19_YA_Electronic'
	WHEN b.material_code IN ('3', 'b') AND (SUBSTRING(i.location_code,4,1) = 'y') THEN 'N/A_YA_Periodicals'
	WHEN b.material_code IN ('a', '2', '9', 'c') AND ((SUBSTRING(i.location_code,4,1) = 'j') OR i.itype_code_num IN ('150','151','152','153','154','155','156','157','160'))THEN 'H23_Childrens_Books'
	WHEN b.material_code IN ('5', 'g', 'u', 'x') AND ((SUBSTRING(i.location_code,4,1) = 'j') OR i.itype_code_num IN ('163','164','165','166','167','168','182','183')) THEN 'H26_Childrens_Videos'
	WHEN b.material_code IN ('4', '7', '8', 'i', 'j', 'z') AND ((SUBSTRING(i.location_code,4,1) = 'j') OR i.itype_code_num IN ('171','172','173','174','175','180')) THEN 'H25_Childrens_Audio'
	WHEN b.material_code IN ('e', '6', 'k', 'o', 'p', 'q', 'r', 't', 'v') AND (SUBSTRING(i.location_code,4,1) = 'j') THEN 'H32_Childrens_Misc'
	WHEN b.material_code IN ('m', 'n') AND (SUBSTRING(i.location_code,4,1) = 'j') THEN 'H30_Childrens_Electronic'
	WHEN b.material_code IN ('3', 'b') AND (SUBSTRING(i.location_code,4,1) = 'j') THEN 'N/A_Childrens_Periodicals'
	WHEN b.material_code IN ('a', '2', '9', 'c') AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'H1_Adult_Books'
	WHEN b.material_code IN ('5', 'g', 'u', 'x') AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'H4_Adult_Videos'
	WHEN b.material_code IN ('4', '7', '8', 'i', 'j', 'z') AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'H3_Adult_Audio'
	WHEN b.material_code IN ('e', '6', 'k', 'o', 'p', 'q', 'r', 't', 'v') AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'H10_Adult_Misc'
	WHEN b.material_code IN ('m', 'n') AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'H8_Adult_Electronic'
	WHEN b.material_code IN ('3', 'b') AND (SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) THEN 'N/A_Adult_Periodicals'
	ELSE 'OTHER'
END AS ARIS_Category,
m.name AS Mat_type,
i.location_code AS Location,
COUNT(i.id) AS Item_Total,
SUM(i.year_to_date_checkout_total) AS YTD_Checkout_total

	
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.material_property_myuser m
ON
b.material_code = m.code
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
WHERE
i.itype_code_num NOT IN ('239','240','241', '242', '244', '249')
GROUP BY 1,2,3
ORDER BY 1