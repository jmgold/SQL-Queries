WITH topic_list AS (SELECT
i.id,
i.checkout_total,
i.renewal_total,
i.price,
i.last_checkin_gmt,
CASE
	WHEN REPLACE(d.index_entry,'.','') ~ '(sexual minorities)|(gender)|(aesexual)|(bisexual)|(gay)|(intersex)|(homosexual)|(lesbian)|(stonewall riots)|(masculinity)|(femininity)' THEN 'LGBTQIA+ & Gender Studies'
	WHEN REPLACE(d.index_entry,'.','') ~ '(south asia)|(indic)|(pakistan)|(\yindia\y)|(bengali)|(afghan(?!\swar))|(bangladesh)|(nepal)|(sri lanka)|(bhutan)' THEN 'South Asian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(east asia)|(asian americans)|(chin(a|ese))|(japan)|(korea)|(taiwan)|(vietnam)|(cambodia)|(mongolia)|(lao(s|tian))|(myanmar)|(malay)|(thai)|(philippin)|(indonesia)|(polynesia)|(brunei)|(east timor)|(pacific island)|(tibet autonomous)' THEN 'East Asian & Pacific Islander'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gamblers)|(drug use)|(drug abuse)|(substance abuse)|(alcoholi)|(addiction)' THEN 'Substance Abuse & Addiction'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bullying)|(aggressiveness)|(abuse)|(violent crimes)|(violence)|(violence against)' THEN 'Abuse & Violence'
	WHEN REPLACE(d.index_entry,'.','') ~ '(indigenous)|(aboriginal)|((?<!east\s)\yindians(?!\sbaseball))|(apache)|(cherokee)|(navajo)|(trail of tears)|(aztecs)|(indian art)|(maya(s|n))|(ojibwa)|(iroquois)|(nez perce)|(shoshoni)|(pueblo indian)|(seminole)|(eskimos)|(inuit)|(inca(s|n))|(algonquia?n)' THEN 'Indigenous'
	WHEN REPLACE(d.index_entry,'.','') ~ '(hispanic)|(?<!new\s)(mexic)|(latin america)|(cuba(?!n\smissile))|(puerto ric)|(dominican)|(el salvador)|(salvadoran)|(argentin)|(bolivia)|
(chile)|(colombia)|(costa rica)|(ecuador)|(equatorial guinea)|(guatemala)|(hondura)|(nicaragua)|(panama)|(paragua)|(peru)|(spain)|(spaniard)|(spanish)|(urugua)|(venezuela)|
(brazil)|(guiana)|(guadaloup)|(haiti)|(martinique)|(saint bartelemy)|(saint martin)' THEN 'Hispanic & Latino'
	WHEN REPLACE(d.index_entry,'.','') ~ '(multicultural)|(cross cultural)|(diasporas)|(minorities)|(ethnic identity)|((race|ethnic) relations)|(racially mixed)|(bilingual)' THEN 'Multicultural'
	WHEN REPLACE(d.index_entry,'.','') ~ '(arab)|(middle east)|(palestin)|(bedouin)|(israel)|(saudi)|(yemen)|(iraq)|(iran)|(egypt)|(leban(an|ese))|(qatar)|(syria)|(turkey\y)' THEN 'Arab & Middle Eastern'
	WHEN REPLACE(d.index_entry,'.','') ~ '(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|(racism)|(suffrag)|(sex role)|(social (change)|(justice)|(movements)|(problems)|(reformers)|(responsibilit))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)|(refugee)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(disabilit)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)|(aspergers)|(neurobehavioral)|(neuropsychology)|(neurodiversity)|(brain variation)|(personality disorder)|(autis(m|tic))' THEN 'Disabilities & Neurodiversity'
   WHEN REPLACE(d.index_entry,'.','') ~ '(acceptance)|(anxiety)|(compulsive disorder)|(schizophrenia)|(eating disorders)|(mental (health)|(illness))|(resilience personality)|(suicid)|(self (esteem|confidence|acceptance))|(emotional problems)|(mindfulness)|(depressi)|(stress (psychology|disorder|psychology))' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yafro)|(blacks(?!mith))|(africa)|(black (nationalism|panther party|power|muslim|lives))|(harlem renaissance)|(abolition)|(segregation)|(slavery)|(underground railroad)|(apartheid)' THEN 'Black'
	WHEN REPLACE(d.index_entry,'.','') ~ '(working class)|(social mobility)|(standard of living)|(social classes)|(poor)|(\ycaste\y)|(social stratification)|(classism)' THEN 'Class'
	--still unsure how to handle religion as a category and exploring options...Christianity is not particularly a diverse category but its also a nice basis for comparison
	--investigate buddhism, hinduism, agnosticism?
	WHEN REPLACE(d.index_entry,'.','') ~ '(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|(christianity)|(easter)|(christmas)' THEN 'Christianity'
	WHEN REPLACE(d.index_entry,'.','') ~ '(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionism)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)' THEN 'Judaism'
	WHEN REPLACE(d.index_entry,'.','') ~ '((?<!terrorism.*)islam(?!(ic( fundamentalism|\sterrorism))))|(\ysufi(sm)?)|(ramadan)|(id al fitr)|(quran)|(sunnites)|(shiah)|(muslim)|(mosques)|(qawwali)' THEN 'Islam'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yzen\y)|(dalai lama)|(buddhis)' THEN 'Buddhism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yhindu(?!(stan|\skush)))|(divali)|(\yholi\y)|(bhagavadgita)|(upanishads)' THEN 'Hinduism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(agnosticism)|(atheism)|(secularism)' THEN 'Angosticism & Atheism'
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

WHERE i.location_code ~ '^ntn'
GROUP BY 1,2,3,4,5,6),

is_fiction AS(
SELECT
subjects.record_id,
CASE 
	WHEN subjects.subject_count > 0 THEN true
	ELSE false
END AS is_fiction

FROM
(SELECT
d.record_id,
COUNT(d.index_entry) FILTER(WHERE d.index_entry ~ '(fiction)|(stories)$') AS subject_count

FROM
sierra_view.phrase_entry d
JOIN
sierra_view.record_metadata rm
ON
d.record_id = rm.id AND rm.record_type_code = 'b'
WHERE 
d.index_tag = 'd'

GROUP BY 1

)subjects
)


SELECT *

FROM
(SELECT
CASE
	WHEN t.topic IS NOT NULL THEN t.topic
	ELSE 'None of the Above'
END AS topic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND fic.is_fiction IS TRUE) AS juv_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND fic.is_fiction IS FALSE) AS juv_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND fic.is_fiction IS TRUE) AS ya_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND fic.is_fiction IS FALSE) AS ya_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND fic.is_fiction IS TRUE) AS adult_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND fic.is_fiction IS FALSE) AS adult_nonfic,
COUNT(DISTINCT i.id) AS total_items

FROM
topic_list t
LEFT JOIN
sierra_view.item_record i
ON
t.id = i.id AND i.location_code ~ '^ntn'
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
is_fiction fic
ON
l.bib_record_id = fic.record_id

GROUP BY 1)a

ORDER BY CASE
	WHEN topic = 'None of the Above' THEN 2
	ELSE 1
END,topic

