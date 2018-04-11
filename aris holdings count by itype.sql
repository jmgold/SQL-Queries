--Jeremy Goldstein
--Minuteman Library Network

--Gathers current holdings by ARIS category for a specified library determined by Agency code

SELECT
	CASE 
	WHEN (i.itype_code_num Between '0' AND '9') OR i.itype_code_num='12' OR (i.itype_code_num BETWEEN '100' AND '106') OR i.itype_code_num='109'
		OR (i.itype_code_num BETWEEN '150' AND '157') OR i.itype_code_num='160' OR (i.itype_code_num BETWEEN '221' AND '241') THEN 'Books'
	WHEN i.itype_code_num='10' OR i.itype_code_num='107' OR i.itype_code_num='158' THEN 'Periodicals'
	WHEN (i.itype_code_num BETWEEN '33' AND '41') OR i.itype_code_num='50' OR (i.itype_code_num BETWEEN '123' AND '126') OR i.itype_code_num='130'
		OR (i.itype_code_num BETWEEN '171' AND '175') OR i.itype_code_num='180' THEN 'Audio'
	WHEN (i.itype_code_num BETWEEN '19' AND '30') OR i.itype_code_num='52' OR (i.itype_code_num BETWEEN '112' AND '120') OR i.itype_code_num='132' 
		OR i.itype_code_num='133' OR (i.itype_code_num BETWEEN '163' AND '168') OR i.itype_code_num='182' OR i.itype_code_num='183' THEN 'Video'
	WHEN i.itype_code_num='248' OR i.itype_code_num='249' THEN 'E-book'
	--We lack itypes to specify the following two categories
	--WHEN  THEN 'Downloadable audio'
	--WHEN  THEN 'Downloadable video'
	WHEN  i.itype_code_num='31' OR i.itype_code_num='32' OR i.itype_code_num='42' OR i.itype_code_num='43' OR i.itype_code_num='121' OR i.itype_code_num='122'
		OR i.itype_code_num='129' OR i.itype_code_num='169' OR i.itype_code_num='170' OR i.itype_code_num='178' THEN 'Materials in Electronic Format'
	WHEN i.itype_code_num='46' THEN 'Microforms'
	WHEN  i.itype_code_num='11' OR i.itype_code_num='13' OR i.itype_code_num='44' OR i.itype_code_num='45' OR i.itype_code_num='47' OR i.itype_code_num='51' 
		OR i.itype_code_num='108' OR i.itype_code_num='127' OR i.itype_code_num='128' OR i.itype_code_num='131' OR i.itype_code_num='159' OR i.itype_code_num='176'
		OR i.itype_code_num='177' OR i.itype_code_num='179' OR i.itype_code_num='181' OR i.itype_code_num='243' OR (i.itype_code_num BETWEEN '245' AND '247') THEN 'Miscellaneous'
	WHEN i.itype_code_num='244' THEN 'Electronic collections' 
	ELSE 'Unknown'
	END AS "ARIS CATEGORY",
	CASE
	WHEN SUBSTRING(i.location_code,4,1)='j' THEN 'Juv'
	WHEN SUBSTRING(i.location_code,4,1)='y' THEN 'YA'
	Else 'Adult'
	END AS "Age level",
	count (*)
FROM
	sierra_view.item_record				AS i
WHERE
--Limit to a location
	i.agency_code_num='1'
	GROUP BY 1,2
	ORDER BY 1
;
