SELECT
'949' AS marcTag,
'.'||rm.record_type_code||rm.record_num||COALESCE(
    CAST(
        NULLIF(
        (
            ( rm.record_num % 10 ) * 2 +
            ( rm.record_num / 10 % 10 ) * 3 +
            ( rm.record_num / 100 % 10 ) * 4 +
            ( rm.record_num / 1000 % 10 ) * 5 +
            ( rm.record_num / 10000 % 10 ) * 6 +
            ( rm.record_num / 100000 % 10 ) * 7 +
            ( rm.record_num / 1000000 ) * 8
         ) % 11,
         10
         )
  AS CHAR(1)
  ),
  'x'
 ) AS itemNumber,
ip.barcode,
i.location_code AS location,
i.item_status_code AS statusCode,
COALESCE(TO_CHAR(o.due_gmt,'mm-dd-yyyy'),'') AS dueDate,
i.checkout_total AS totalCheckouts,
i.last_year_to_date_checkout_total AS lastYearCheckouts,
i.year_to_date_checkout_total AS yearToDateCirc,
i.renewal_total AS renewals,
i.itype_code_num AS iType,
TO_CHAR(rm.creation_date_gmt,'mm-dd-yyyy') AS createdDate,
i.icode2 AS iCode2,
TRIM(REPLACE(ip.call_number,'|a','')) AS callNumber

FROM
sierra_view.item_record i
LEFT JOIN
sierra_view.checkout o
ON
i.id = o.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON i.id = l.item_record_id
JOIN
sierra_view.record_metadata rm
ON
l.item_record_id = rm.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE rm.record_num = '7214982'