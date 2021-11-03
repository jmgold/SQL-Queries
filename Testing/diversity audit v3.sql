WITH topic_list AS (SELECT *
FROM
(SELECT
d.record_id,
CASE
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yzen\y)|(dalai lama)|(buddhis)' THEN 'Buddhism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yhindu(?!(stan|\skush)))|(divali)|(\yholi\y)|(bhagavadgita)|(upanishads)' THEN 'Hinduism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(agnosticism)|(atheism)|(secularism)' THEN 'Agnosticism & Atheism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(^\y(?!\w*terrorism)\w*(islam(?!.*(fundamentalism|terrorism))))|(\ysufi(sm)?)|(ramadan)|(id al (fitr\y)|(\yadha\y))|(quran)|(sunnites)|(shiah)|(muslim)|(mosques)|(qawwali)' THEN 'Islam'
	WHEN REPLACE(d.index_entry,'.','') ~ '(working class)|(social mobility)|(standard of living)|(social classes)|(poor)|(\ycaste\y)|(social stratification)|(classism)' THEN 'Class'
	WHEN REPLACE(d.index_entry,'.','') ~ '(south asia)|(indic)|(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))|(\yindia\y)|(bengali)|(afghan(?!\swar))|(bangladesh)|(^\y(?!\w*everest)\w*(nepal(?!.*everest)))|(sri lanka)|(bhutan)' THEN 'South Asian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(east asia)|(asian americans)|(^\y(?!\w*everest)\w*(chin(a(?!\sfictitious)|ese)(?!.*everest)))|(japan)|(korea)|(taiwan)|(vietnam)|(cambodia)|(mongolia)|(lao(s|tian))|(myanmar)|(malay)|(thai)|(philippin)|(indonesia)|(polynesia)|(brunei)|(east timor)|(pacific island)|(tibet autonomous)|(hmong)' THEN 'East Asian & Pacific Islander'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bullying)|(aggressiveness)|((?<!(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin))\sabuse)|(violent crimes)|((?<!non)violence)|(crimes against(?!\sfiction)$)' THEN 'Abuse & Violence'
	WHEN REPLACE(d.index_entry,'.','') ~ '((?<!recordings for people.*)disabilit)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)|(aspergers)|(neurobehavioral)|(neuropsychology)|(neurodiversity)|(brain variation)|(personality disorder)|(autis(m|tic))' THEN 'Disabilities & Neurodiversity'
   WHEN REPLACE(d.index_entry,'.','') ~ '(acceptance)|(anxiety)|(compulsive disorder)|(schizophrenia)|(eating disorders)|(mental (health)|(illness)|healing)|(resilience personality)|(suicid)|(self (esteem|confidence|realization|perception|actualization|management|destructive|control))|(emotional problems)|(mindfulness)|(depressi)|(stress (psychology|disorder|psychology))|(psychic trauma)' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gamblers)|(drug use)|(drug abuse)|(substance abuse)|(alcoholi(?<!c beverages))|(addiction)''(gamblers)|(drug use)|(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin)\sabuse|(alcoholi(?<!c beverages))|(binge drinking)|(addiction)' THEN 'Substance Abuse & Addiction'
	WHEN REPLACE(d.index_entry,'.','') ~ '(sexual minorities)|(gender)|(asexual)|(bisexual)|(gay(s|\y(?!(head|john))))|(intersex)|(homosexual)|(lesbian)|(stonewall riots)|(masculinity)|(femininity)' THEN 'LGBTQIA+ & Gender Studies'
	WHEN REPLACE(d.index_entry,'.','') ~ '(indigenous)|(aboriginal)|((?<!east\s)\yindians(?!\sbaseball))|(apache)|(cherokee)|(navajo)|(trail of tears)|(aztecs)|(indian art)|(maya(s|n))|(ojibwa)|(iroquois)|(nez perce)|(shoshoni)|(pueblo indian)|(seminole)|(eskimos)|(inuit)|(inca(s|n))|(algonquia?n)|(arctic peoples)|(aleut)' THEN 'Indigenous'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yarab)|(middle east)|(palestin)|(bedouin)|(israel)|(saudi)|(yemen)|(iraq(?!\swar))|(iran)|(egypt(?!ologists))|(leban(on|ese))|(qatar)|(syria)|(turkey\y)' THEN 'Arab & Middle Eastern'
	WHEN REPLACE(d.index_entry,'.','') ~ '(hispanic)|(?<!new\s)(mexic)|(latin america)|(cuba(?!n\smissile))|(puerto ric)|(dominican)|(el salvador)|(salvadoran)|(argentin)|(bolivia)|
(chile)|(colombia)|(costa rica)|(ecuador)|(equatorial guinea)|(guatemala)|(hondura)|(nicaragua)|(panama)|(paragua)|(peru)|(spain)|(spaniard)|(spanish)|(urugua)|(venezuela)|
(brazil)|(guiana)|(guadaloup)|(martinique)|(saint barthelemy)|(saint martin)' THEN 'Hispanic & Latino'
	WHEN REPLACE(d.index_entry,'.','') ~ '(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|((?<!fugitives from )justice(?!(s of the peace)|(\s(league|society|donald))))|(racism)|(suffrag)|(sex role)|(social (change)|(movements)|(problems)|(reformers)|(responsibilit)|(conditions))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)|(refugee)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yafro)|(blacks(?!mith))|(africa)|(black (nationalism|panther party|power|muslim|lives))|(harlem renaissance)|(abolition)|(segregation)|(^\y(?!\w*(rome)|(italy)|(egypt))\w*(slave(s|(ry))(?!(rome)|(egypt)|(italy))))|(emancipation)|(underground railroad)|(apartheid)' THEN 'Black'
	WHEN REPLACE(d.index_entry,'.','') ~ '(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionis)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)' THEN 'Judaism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(multicultural)|(cross cultural)|(diasporas)|(minorities)|(ethnic identity)|((race|ethnic) relations)|(racially mixed)|(bilingual)|(passing identity)' THEN 'Multicultural'
	WHEN REPLACE(d.index_entry,'.','') ~ '(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|(christianity)|(easter)|(christmas)' THEN 'Christianity'
END AS topic

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.phrase_entry d
ON
l.bib_record_id = d.record_id AND d.index_tag = 'd'

WHERE i.location_code ~ '^lin'
)a
WHERE
a.topic IS NOT NULL),

is_fiction AS(
SELECT
DISTINCT d.record_id

FROM
sierra_view.phrase_entry d
JOIN
sierra_view.bib_record_item_record_link l
ON
d.record_id = l.bib_record_id 
--AND b.material_code NOT IN ('7','8','b','e','j','k','m','n')
AND d.index_tag = 'd'
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id AND i.location_code ~ '^lin'
LEFT JOIN
sierra_view.control_field f
ON
b.bib_record_id = f.record_id
LEFT JOIN
sierra_view.leader_field l
ON
b.bib_record_id = l.record_id

WHERE d.index_entry ~ '(\yfiction)|(stories)|(tales)|(graphic novels)|(\ydrama)$' AND f.p33 != '0'
)


SELECT *

FROM
(SELECT
CASE
	WHEN t.topic IS NOT NULL THEN t.topic
	ELSE 'None of the Above'
END AS topic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND fic.record_id IS NOT NULL) AS juv_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND fic.record_id IS NULL) AS juv_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND fic.record_id IS NOT NULL) AS ya_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND fic.record_id IS NULL) AS ya_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND fic.record_id IS NOT NULL) AS adult_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND fic.record_id IS NULL) AS adult_nonfic,
COUNT(DISTINCT i.id) AS total_items

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^lin'
LEFT JOIN
topic_list t
ON
l.bib_record_id= t.record_id
LEFT JOIN
is_fiction fic
ON
l.bib_record_id = fic.record_id

GROUP BY 1

UNION

SELECT
'Unique Diverse Items' AS topic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND fic.record_id IS NOT NULL) AS juv_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND fic.record_id IS NULL) AS juv_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND fic.record_id IS NOT NULL) AS ya_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND fic.record_id IS NULL) AS ya_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND fic.record_id IS NOT NULL) AS adult_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND fic.record_id IS NULL) AS adult_nonfic,
COUNT(DISTINCT i.id) AS total_items

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^lin'
JOIN
topic_list t
ON
l.bib_record_id= t.record_id
LEFT JOIN
is_fiction fic
ON
l.bib_record_id = fic.record_id

GROUP BY 1

)a

ORDER BY CASE
	WHEN topic = 'Unique Diverse Items' THEN 2
	WHEN topic = 'None of the Above' THEN 3
	ELSE 1
END,topic

