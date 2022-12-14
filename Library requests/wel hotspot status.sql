SELECT
rm.record_type_code||rm.record_num||
COALESCE(
    CAST(
        NULLIF(
        (
            ( rm.record_num % 10 ) * 2 +
            ( rm.record_num / 10 % 10 ) * 3 +
            ( rm.record_num / 100 % 10 ) * 4 +
            ( rm.record_num / 1000 % 10 ) * 5 +
            ( rm.record_num / 10000 % 10 ) * 6 +
            ( rm.record_num / 100000 % 10 ) * 7 +
            ( rm.record_num / 1000000 % 10  ) * 8 +
            ( rm.record_num / 10000000 ) * 9
         ) % 11,
         10
         )
  AS CHAR(1)
  ),
  'x'
 ) AS record_number,
REGEXP_REPLACE(ip.call_number,'^\|a','') AS call_number,
stat.name AS status,
COALESCE(TO_CHAR(o.due_gmt,'YYYY-MM-DD'),'N/A') AS due_date,
ip.barcode

FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
LEFT JOIN sierra_view.checkout o
ON
i.id = o.item_record_id
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.item_status_property_myuser stat
ON
i.item_status_code = stat.code

WHERE
i.itype_code_num = '252'
AND i.item_status_code != 'a'
AND i.icode2 = '-'
AND i.location_code ~ '^we'
AND ip.call_number_norm LIKE '%hotspot%'

ORDER BY 4,3,2