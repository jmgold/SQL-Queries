--limited to one language at a time

SELECT
CASE
    WHEN bv.bcode2 = '2' THEN 'Large Print'
    WHEN bv.bcode2 = '3' THEN 'Periodical'
    WHEN bv.bcode2 = '4' THEN 'Spoken CD'
    WHEN bv.bcode2 = '5' THEN 'DVD'
    WHEN bv.bcode2 = '6' THEN 'Film/Strip'
    WHEN bv.bcode2 = '7' THEN 'Music Cassette'
    WHEN bv.bcode2 = '8' THEN 'LP'
    WHEN bv.bcode2 = '9' THEN 'Juv Book + CD'
    WHEN bv.bcode2 = 'a' THEN 'Book'
    WHEN bv.bcode2 = 'b' THEN 'Archival Material'
    WHEN bv.bcode2 = 'c' THEN 'Music Score'
    WHEN bv.bcode2 = 'e' THEN 'Map'
    WHEN bv.bcode2 = 'g' THEN 'VHS'
    WHEN bv.bcode2 = 'h' THEN 'Downloadable eBook'
    WHEN bv.bcode2 = 'i' THEN 'Spoken Cassette'
    WHEN bv.bcode2 = 'j' THEN 'Music CD'
    WHEN bv.bcode2 = 'k' THEN '2D Visual Material'
    WHEN bv.bcode2 = 'l' THEN 'Downloadable Video'
    WHEN bv.bcode2 = 'm' THEN 'Software'
    WHEN bv.bcode2 = 'n' THEN 'Console Game'
    WHEN bv.bcode2 = 'o' THEN 'Kit'
    WHEN bv.bcode2 = 'p' THEN 'Mixed Material'
    WHEN bv.bcode2 = 'q' THEN 'Equipment'
    WHEN bv.bcode2 = 'r' THEN '3D Object'
    WHEN bv.bcode2 = 's' THEN 'Downloadable Audiobook'
    WHEN bv.bcode2 = 't' THEN 'Manuscript'
    WHEN bv.bcode2 = 'u' THEN 'Blu-ray'
    WHEN bv.bcode2 = 'v' THEN 'eReader/Tablet'
    WHEN bv.bcode2 = 'w' THEN 'Downloadable Music'
    WHEN bv.bcode2 = 'x' THEN 'Playaway Video'
    WHEN bv.bcode2 = 'y' THEN 'Online'
    WHEN bv.bcode2 = 'z' THEN 'Playaway Audio'
    ELSE 'unexpected code '||bv.bcode2
END     AS "MatType",   
  bv.title                                         	    AS "Title",
  'b'||bv.record_num||'a'                       	    AS "record number",
  SUM(iv.last_year_to_date_checkout_total)           	    AS "Last YTD Checkouts",
  count(bilink.id) 			        	    AS "item count",
  round(cast(SUM(iv.last_year_to_date_checkout_total) as numeric (12,2))/cast(count (bilink.id) as numeric (12,2)), 2) as "turnover",
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
  iv.last_year_to_date_checkout_total > 0
Group By
  3,1,2,8
ORDER BY
  1,4 DESC,2
;
