--Jeremy Goldstein
--Minuteman Library Network

--Gathers totals and subtotals (after running through Excel) of internal use counts for a week long project
--Requested by Diana Fendler at CAM

SELECT
CASE
WHEN i.itype_code_num = '10' THEN 'Adult'
WHEN i.itype_code_num = '107' THEN 'YA'
WHEN i.itype_code_num = '158' THEN 'Juvenile'
END AS age_level,
b.best_title,
v.field_content AS volume,
ip.barcode,
SUM(i.internal_use_count) AS total_use

FROM
sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON c.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property ip
ON
c.item_record_id = ip.item_record_id
JOIN
sierra_view.item_record i
ON c.item_record_id = i.id AND i.itype_code_num IN ('10','107','158')
LEFT JOIN
sierra_view.varfield v
ON c.item_record_id = v.record_id AND varfield_type_code = 'v'

WHERE
c.op_code = 'u' 
AND SUBSTRING(c.item_location_code FROM 1 FOR 3) = 'cam'
AND c.transaction_gmt BETWEEN '2019-05-13' AND '2019-05-18'
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4
;