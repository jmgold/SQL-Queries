SELECT 
'b' || r.record_num || 'a' as bib_record_num,
v.marc_tag,
count(*) as count

FROM
sierra_view.record_metadata 	as r

JOIN
sierra_view.varfield		as v
ON
  (v.record_id = r.id) 
  AND (r.record_type_code = 'b') 
  AND ( 
	-- 00X: Control Fields (NR)
	   v.marc_tag = '001' 
	OR v.marc_tag = '003'
	OR v.marc_tag = '005'
	OR v.marc_tag = '008'

	-- 01X-09X: Numbers and Code Fields (NR)
	OR v.marc_tag = '010'
	OR v.marc_tag = '018'
	OR v.marc_tag = '036'
	OR v.marc_tag = '038'
	OR v.marc_tag = '040'
	OR v.marc_tag = '042'
	OR v.marc_tag = '043'
	OR v.marc_tag = '044'
	OR v.marc_tag = '045'
	OR v.marc_tag = '066'

	-- 1XX - Main Entries-General Information
	OR v.marc_tag = '100'
	OR v.marc_tag = '110'
	OR v.marc_tag = '111'
	OR v.marc_tag = '130'

	-- 20X-24X - Title and Title-Related Fields - General Information (NR)
	OR v.marc_tag = '240'
	OR v.marc_tag = '243'
	OR v.marc_tag = '245'

	-- 25X-28X - Edition, Imprint, Etc. Fields-General Information (NR)
	OR v.marc_tag = '254'
	OR v.marc_tag = '256'
	OR v.marc_tag = '263'

	-- 3XX - Physical Description, Etc. Fields - General Information (NR)
	OR v.marc_tag = '306'
	OR v.marc_tag = '310'
	OR v.marc_tag = '357'
	OR v.marc_tag = '384'

	-- 5XX - Note Fields - General Information (NR)
	OR v.marc_tag = '507'
	OR v.marc_tag = '514'

	-- 841-88X - Holdings, Alternate Graphics, Etc.-General Information (NR)
	OR v.marc_tag = '841'
	OR v.marc_tag = '842'
	OR v.marc_tag = '844'
	OR v.marc_tag = '882'
  )

GROUP BY
v.marc_tag,
r.record_num

HAVING
count(*) > 1