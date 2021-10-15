/*
Jeremy Goldstein
Minuteman Library Network

In development query to serve as rough starting point for a collection diversity audit
Identifies diverse subject areas based on keywords in LC subjects
*/

--subquery to create a binary is_fiction field
WITH is_fiction AS(
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
	WHEN REPLACE(d.index_entry,'.','') ~ '(sexual minorities)|(gender)|(aesexual)|(bisexual)|(gay)|(intersex)|(homosexual)|(lesbian)|(stonewall riots)' THEN 'LGBTQIA+ & Gender Studies'
	WHEN REPLACE(d.index_entry,'.','') ~ '(south asia)|(indic)|(pakistan)|(\bindia\b)|(bengali)|(afghan[^ war])' THEN 'South Asian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(east asia)|(asian americans)|(chinese)|(japanese)|(korean)|(taiwanese)|(vietnamese)|(cambodian)|(pacific island)|(tibet autonomous)' THEN 'East Asian & Pacific Islander'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gamblers)|(drug use)|(drug abuse)|(substance abuse)|(alcoholi)|(addiction)' THEN 'Substance Abuse & Addiction'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bullying)|(aggressiveness)|(abuse)|(violent crimes)|(violence)|(violence against)' THEN 'Abuse & Violence'
	WHEN REPLACE(d.index_entry,'.','') ~ '(indigenous)|(aboriginal)|(indians of)|(apache)|(cherokee)|(navajo)|(trail of tears)|(aztecs)|(indian art)|(maya(s|n))|(ojibwa)|(iroquois)|(nez perce)|(shoshoni)|(pueblo indian)|(seminole)|(eskimos)|(inuit)|(inca(s|n))' THEN 'Indigenous'
	WHEN REPLACE(d.index_entry,'.','') ~ '(hispanic)|(mexican)|(latin american)|(cuban[^ missile])|(puerto rican)|(dominican)|(salvadoran)' THEN 'Hispanic & Latino'
	WHEN REPLACE(d.index_entry,'.','') ~ '(multicultural)|(diasporas)|(minorities)|(ethnic identity)|((race|ethnic) relations)|(racially mixed)|(bilingual)' THEN 'Multicultural'
	WHEN REPLACE(d.index_entry,'.','') ~ '(arab)|(middle east)|(palestin)|(bedouin)' THEN 'Arab & Middle Eastern'
	WHEN REPLACE(d.index_entry,'.','') ~ '(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|(racism)|(suffrag)|(sex role)|(social (change)|(justice)|(movements)|(problems)|(reformers)|(responsibilit))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)|(refugee)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(with disabilities)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)' THEN 'Disabilities & Special Needs'
   WHEN REPLACE(d.index_entry,'.','') ~ '(autis(m|tic))|(eating disorders)|(learning disabilit)|(mental (health)|(disabilit)|(illness))|(resilience personality)|(suicid)|(self (esteem|confidence|acceptance))|(emotional problems)|(depressi)|(stress (psychology|disorder|psychology))' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(african american)|(africans)|(harlem renaissance)|(abolition)|(segregation)|(slavery)|(underground railroad)' THEN 'Black'
	WHEN REPLACE(d.index_entry,'.','') ~ '(working class)|(social mobility)|(standard of living)|(social classes)|(poor)' THEN 'Class'
	--still unsure how to handle religion as a category and exploring options...Christianity is not particularly a diverse category but its also a nice basis for comparison
	--investigat buddhism, hinduism, agnosticism?
	WHEN REPLACE(d.index_entry,'.','') ~ '(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|(christianity)|(easter)|(christmas)' THEN 'Christianity'
	WHEN REPLACE(d.index_entry,'.','') ~ '(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionism)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)' THEN 'Judaism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(islam[^ic fundamentalism])|(ramadan)|(id al fitr)|(quran)|(sufism)|(sunnites)|(shiah)|(muslim)|(mosques)' THEN 'Islam'
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
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.phrase_entry d
ON
l.bib_record_id = d.record_id AND d.index_tag = 'd'
JOIN
is_fiction fic
ON
l.bib_record_id = fic.record_id

WHERE i.location_code ~ '^ntn'

GROUP BY 1)a

ORDER BY CASE
	WHEN topic = 'None of the Above' THEN 2
	ELSE 1
END,topic
