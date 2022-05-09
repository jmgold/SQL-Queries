/*
Jeremy Goldstein
Minuteman Library Network
Identifies bib records that contain multiples of non-repeating MARC fields
*/
SELECT 
r.record_type_code||r.record_num||'a' as bib_record_num,
v.marc_tag,
COUNT(*) AS count

FROM
sierra_view.record_metadata r
JOIN
sierra_view.varfield	v
ON
v.record_id = r.id AND r.record_type_code = 'b' 
AND ( 
	-- 00X: Control Fields (NR)
   v.marc_tag IN ('001','003','005','008')
	-- 01X-09X: Numbers and Code Fields (NR)
	OR v.marc_tag IN ('010','018','036','038','040','042','043','044','045','066')
	-- 1XX - Main Entries-General Information
	OR v.marc_tag IN ('100','110','111','130')
	-- 20X-24X - Title and Title-Related Fields - General Information (NR)
	OR v.marc_tag IN ('240','243','245')
	-- 25X-28X - Edition, Imprint, Etc. Fields-General Information (NR)
	OR v.marc_tag IN ('254','256','263')
	-- 3XX - Physical Description, Etc. Fields - General Information (NR)
	OR v.marc_tag IN ('306','310','357','384')

	-- 5XX - Note Fields - General Information (NR)
	OR v.marc_tag IN ('507','514')
	-- 841-88X - Holdings, Alternate Graphics, Etc.-General Information (NR)
	OR v.marc_tag IN ('841','842','844','882')
  )

GROUP BY
v.marc_tag,
r.record_type_code,
r.record_num
HAVING
COUNT(*) > 1