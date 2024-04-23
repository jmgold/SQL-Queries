SELECT 
*
FROM (
SELECT
CASE
	WHEN i.icode1 = '92' THEN 'BIOGRAPHY'
	WHEN i.icode1 BETWEEN '10' AND '100' AND ip.call_number_norm ~ '^(?!express)\w+ \d' THEN '[LANGUAGE] NONFICTION'
	WHEN i.icode1 = '1' AND ip.call_number_norm ~ '^(?!express)\w+ fiction' THEN '[LANGUAGE] FICTION'
	WHEN i.icode1 BETWEEN '195' AND '237' AND ip.call_number_norm ~ '^j world' THEN 'J WORLD/[LANGUAGE]'
	WHEN i.icode1 BETWEEN '10' AND '100' THEN 'NONFICTION'
	WHEN i.icode1 = '117' THEN 'GENEALOGY'
	WHEN i.icode1 = '115' THEN 'REF'
	WHEN i.icode1 = '124' THEN 'ELL'
	WHEN i.icode1 = '1' THEN 'FICTION'
	WHEN i.icode1 = '160' THEN 'GRAPHIC'
	WHEN i.icode1 = '2' THEN 'MYSTERY'
	WHEN i.icode1 = '3' THEN 'SCIENCE FICTION'
	WHEN i.icode1 = '5' THEN 'PAPERBACK'
	WHEN i.icode1 = '6' THEN 'LARGE PRINT FICTION'
	WHEN i.icode1 = '103' THEN 'LARGE PRINT NONFICTION'
	WHEN i.icode1 IN ('130','131') THEN 'AUDIOBOOKS'
	WHEN i.icode1 = '129' THEN 'MUSIC CDs'
	WHEN i.icode1 = '132' THEN 'ELL AUDIOBOOKS/CDs'
	WHEN i.icode1 IN ('134','135') THEN 'PLAYAWAYS'
	WHEN i.icode1 = '136' THEN 'TABLET/eREADER'
	WHEN i.icode1 IN ('141','149','150') THEN 'EQUIP'
	WHEN i.icode1 IN ('140','143','144','146') THEN 'DVDS/BLU-RAYS'
	WHEN i.icode1 = '137' THEN 'VIDEO GAMES'
	WHEN i.icode1 = '161' THEN 'Y FICTION'
	WHEN i.icode1 = '166' THEN 'Y GRAPHIC'
	WHEN i.icode1 = '190' THEN 'Y AUDIOBOOKS'
	WHEN i.icode1 = '192' THEN 'Y PLAYAWAYS'
	WHEN i.icode1 = '201' THEN 'J FICTION'
	WHEN i.icode1 = '205' THEN 'J ILLUSTRATED FICTION'
	WHEN i.icode1 = '196' THEN 'J READ-ALONG'
	WHEN i.icode1 = '198' THEN 'J MYSTERY'
	WHEN i.icode1 = '200' THEN 'J EASY CHAPTER'
	WHEN i.icode1 = '206' THEN 'J PICTURE BOOKS'
	WHEN i.icode1 = '207' THEN 'J BOARD BOOKS'
	WHEN i.icode1 = '208' THEN 'J PAPERBACK PIC'
	WHEN i.icode1 = '209' THEN 'J EASY READER'
	WHEN i.icode1 = '197' THEN 'J GRAPHIC NOVEL'
	WHEN i.icode1 BETWEEN '210' AND '219' THEN 'J NONFICTION'
	WHEN i.icode1 = '220' THEN 'J BIOGRAPHY'
	WHEN i.icode1 = '199' THEN 'J PARENTS SHELF'
	WHEN i.icode1 = '195' THEN 'J PHONICS KIT'
	WHEN i.icode1 = '234' THEN 'J DVD'
	WHEN i.icode1 = '229' THEN 'J COMPACT DISC'
	WHEN i.icode1 = '232' THEN 'J BOOK ON CD'
	WHEN i.icode1 = '235' THEN 'J PLAYAWAY'
	WHEN i.icode1 = '236' THEN 'J PLAYAWAY VIDEO'
	WHEN i.icode1 = '237' THEN 'J TABLET/EREADER'
	ELSE 'UNKNOWN'
END AS "collection",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'asia') AS "Asian",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'black') AS "Black",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(disab)|(neuro)') AS "Disabilities & Neurodiversity",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(equi)|(social)') AS "Equity & Social Issues",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(spani)|(latin)') AS "Hispanic & Latino",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'indig') AS "Indigenous",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(lgbt)|(gender)') AS "LGBTQIA+ & Gender Studies",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(mental)|(emotion)') AS "Mental & Emotional Health",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(middle)|(north africa)') AS "Middle Eastern & North African",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'multicult') AS "Multicultural",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'religio') AS "Religion",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(substance)|(addict)') AS "Substance Abuse & Addiction",
COUNT(i.id) AS total_items_added
FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND i.location_code ~ '^nee'
JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'x' AND v.field_content LIKE 'DEI:%'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'

GROUP BY 1

UNION

SELECT
'TOTAL' AS "Collection",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'asia') AS "Asian",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'black') AS "Black",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(disab)|(neuro)') AS "Disabilities & Neurodiversity",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(equi)|(social)') AS "Equity & Social Issues",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(spani)|(latin)') AS "Hispanic & Latino",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'indig') AS "Indigenous",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(lgbt)|(gender)') AS "LGBTQIA+ & Gender Studies",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(mental)|(emotion)') AS "Mental & Emotional Health",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(middle)|(north africa)') AS "Middle Eastern & North African",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'multicult') AS "Multicultural",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ 'religio') AS "Religion",
COUNT(i.id) FILTER(WHERE LOWER(TRIM(REGEXP_REPLACE(v.field_content,'dei:\s?','','i'))) ~ '(substance)|(addict)') AS "Substance Abuse & Addiction",
COUNT(i.id) AS total_items_added
FROM
sierra_view.item_record i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id AND i.location_code ~ '^nee'
JOIN
sierra_view.varfield v
ON
i.id = v.record_id AND v.varfield_type_code = 'x' AND v.field_content LIKE 'DEI:%'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id

WHERE rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'

GROUP BY 1
)a

ORDER BY CASE WHEN a.Collection = 'TOTAL' THEN 2 ELSE 1 END,1