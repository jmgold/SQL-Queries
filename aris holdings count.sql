--Gathers current holdings by ARIS category for a specified library determined by Agency code

SELECT
	CASE 
	WHEN b.material_code='2' OR b.material_code='9' OR b.material_code='a' OR b.material_code='c' OR b.material_code='t' THEN 'Books'
	WHEN b.material_code='3' THEN 'Periodicals'
	WHEN b.material_code='4' OR b.material_code='7' OR b.material_code='8' OR b.material_code='i' OR b.material_code='j' OR b.material_code='z' THEN 'Audio'
	WHEN b.material_code='5' OR b.material_code='g' OR b.material_code='u' OR b.material_code='x' THEN 'Video'
	WHEN b.material_code='h' THEN 'E-book'
	WHEN b.material_code='s' or b.material_code='w' THEN 'Downloadable audio'
	WHEN b.material_code='l' THEN 'Downloadable video'
	WHEN b.material_code='m' OR b.material_code='n' THEN 'Materials in Electronic Format'
	WHEN b.material_code='6' OR b.material_code='b' OR b.material_code='e' OR b.material_code='k' OR b.material_code='o' OR b.material_code='p' OR b.material_code='q' or b.material_code='r' OR b.material_code='v' THEN 'Miscellaneous'
	WHEN b.material_code='y' THEN 'Electronic collections' 
	ELSE 'Unknown'
	END AS "ARIS CATEGORY",
	CASE
	WHEN SUBSTRING(i.location_code,4,1)='j' THEN 'Juv'
	WHEN SUBSTRING(i.location_code,4,1)='y' THEN 'YA'
	Else 'Adult'
	END AS "Age level",
	count (distinct(b.id)) AS "title count",
	count (i.id) AS "item count"
FROM
	sierra_view.item_record				AS i
	JOIN
	sierra_view.bib_record_item_record_link		AS bi
	ON
	i.record_id=bi.item_record_id
	JOIN
	sierra_view.bib_record_property			AS b
	ON
	bi.bib_record_id=b.bib_record_id
--WHERE
--	i.agency_code_num='1'
	GROUP BY 1,2
	ORDER BY 1
;
