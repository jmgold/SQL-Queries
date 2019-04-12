--Jeremy Goldstein
--Minuteman Library Network

--Gathers totals and subtotals (after running through Excel) of internal use counts for a week long project
--Requested by Diana Fendler at CAM

SELECT
b.best_title,
--REPLACE(ip.call_number,'|a',''),
v.field_content AS volume,
ip.barcode,
--use count field being used tbd
i.internal_use_count,
copy_use_count,
use3_count

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
ON c.item_record_id = i.id
LEFT JOIN
sierra_view.varfield v
ON c.item_record_id = v.record_id AND varfield_type_code = 'u'

WHERE
c.op_code = 'o' 
AND SUBSTRING(c.item_location_code FROM 1 FOR 3) = 'cam'
AND c.transaction_gmt BETWEEN '2019-04-10' AND '2019-04-12'

ORDER BY 1,2,3,4
;