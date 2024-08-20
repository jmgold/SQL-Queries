/*
Jeremy Goldstein
Minuteman Library Network

Takes the contents of a review file and produces a list with one ISBN/UPC per title, removing any excess data from the ISBN/UPC fields. 
Designed for importing lists into other sites such as when creating lists within Aspen or autopopulating a cart when ordering through a vendor.
*/

SELECT
*,
'' AS "REVIEW FILE TO ISBNS/UPCS",
'' AS "https://sic.minlib.net/reports/116"
FROM
(SELECT
CASE
  WHEN b.material_code = 'a'
    THEN (SELECT
    SUBSTRING(s.content FROM '[0-9]+')
    FROM
    sierra_view.subfield s
    WHERE
    b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
    ORDER BY s.occ_num
    LIMIT 1)
  WHEN b.material_code != 'a'
    THEN (SELECT
    SUBSTRING(s.content FROM '[0-9]+')
    FROM
    sierra_view.subfield s
    WHERE
    b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
    ORDER BY s.occ_num
    LIMIT 1)
END AS isbn_upc

FROM
sierra_view.bool_info bo
JOIN
sierra_view.bool_set sb
ON
bo.id = sb.bool_info_id
LEFT JOIN
sierra_view.bib_record_item_record_link bi 
ON
sb.record_metadata_id = bi.item_record_id AND bo.record_type_code = 'i'
LEFT JOIN
sierra_view.bib_record_order_record_link bol
ON sb.record_metadata_id = bol.order_record_id AND bo.record_type_code = 'o'
JOIN
sierra_view.bib_record_property b
ON
(sb.record_metadata_id = b.bib_record_id AND bo.record_type_code ='b') OR bi.bib_record_id = b.bib_record_id OR bol.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.item_record_property i
ON
sb.record_metadata_id = i.item_record_id

WHERE sb.bool_info_id = {{review_file}}
)a

WHERE isbn_upc IS NOT NULL