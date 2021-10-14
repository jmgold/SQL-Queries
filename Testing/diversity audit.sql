WITH is_fiction AS(
SELECT
subjects.record_id,
CASE 
	WHEN subjects.subject ~ '(fiction)|(stories)' THEN true
	ELSE false
END AS is_fiction

FROM
(SELECT
d.record_id,
STRING_AGG(d.index_entry,',') AS subject

FROM
sierra_view.phrase_entry d
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
	WHEN REPLACE(d.index_entry,'.','') ~ '(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|(racism)|(suffrag)|(sex role)|(social (change)|(justice)|(movements)|(problems)|(reformers)|(responsibilit))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(poor)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(with disabilities)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)' THEN 'Disabilities & Special Needs'
   WHEN REPLACE(d.index_entry,'.','') ~ '(autis(m|tic))|(eating disorders)|(learning disabilit)|(mental (health)|(disabilit)|(illness))|(resilience personality)|(suicid)|(self (esteem|confidence|acceptance))|(emotional problems)|(depressi)|(stress (psychology|disorder|psychology))' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(african american)|(africans)|(harlem renaissance)|(abolition)|(segregation)|(slavery)|(underground railroad)' THEN 'Black'
	--jewish?  religion?
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
d.record_id = fic.record_id

WHERE
i.location_code ~ '^wsn'
GROUP BY 1)a

ORDER BY CASE
	WHEN topic = 'None of the Above' THEN 2
	ELSE 1
END,topic
