--limited to one language at a time

SELECT
  bv.bcode2                                                 AS "Format",   
  bv.title                                         	    AS "Title",
  'b'||bv.record_num||'a'                       	    AS "record number",
  SUM(iv.year_to_date_checkout_total)           	    AS "YTD Checkouts",
  count(bilink.id) 			        	    AS "item count",
  round(cast(SUM(iv.year_to_date_checkout_total) as numeric (12,2))/cast(count (bilink.id) as numeric (12,2)), 2) as "turnover",
  string_agg(distinct(loc.location_code), ',')                           AS "location code",
  'http://find.minlib.net/iii/encore/record/C__Rb'||bv.record_num   AS "URL"
FROM
  sierra_view.bib_view                              AS bv
JOIN
  sierra_view.bib_record_location                   AS loc
  ON
  bv.id = loc.bib_record_id  
JOIN
  sierra_view.bib_record_item_record_link           AS bilink
  ON
  bv.id = bilink.bib_record_id
JOIN
  sierra_view.item_view                             AS iv
  ON
  bilink.item_record_id = iv.id  
WHERE 
  bv.language_code = 'chi'
  AND 
  iv.year_to_date_checkout_total > 0
Group By
  3,1,2,8
ORDER BY
  1,4 DESC,2
;
