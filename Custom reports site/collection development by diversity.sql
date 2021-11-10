/*
Jeremy Goldstein
Minuteman Lirary Network
Gathers together various performance metrics for portions of a library's collection
grouped by diverse topical areas that were developed for the diversity analysis report found in this directory
Is passed variables for owning location, item status to exclude from the report, age level and item created date
*/

WITH topic_list AS (SELECT *
FROM
(SELECT
d.record_id,
i.checkout_total,
i.renewal_total,
i.price,
i.last_checkin_gmt,
CASE
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yzen\y)|(dalai lama)|(buddhis)' THEN 'Buddhism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yhindu(?!(stan|\skush)))|(divali)|(\yholi\y)|(bhagavadgita)|(upanishads)' THEN 'Hinduism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(agnosticism)|(atheism)|(secularism)' THEN 'Agnosticism & Atheism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(^\y(?!\w*terrorism)\w*(islam(?!.*(fundamentalism|terrorism))))|(\ysufi(sm)?)|(ramadan)|(id al (fitr\y)|(\yadha\y))|(quran)|(sunnites)|(shiah)|(muslim)|(mosques)|(qawwali)' THEN 'Islam'
	WHEN REPLACE(d.index_entry,'.','') ~ '(working class)|(social ((status)|(mobility)|(class)|(stratification)))|(standard of living)|(poor)|(\ycaste\y)|(classism)' THEN 'Class'
	WHEN REPLACE(d.index_entry,'.','') ~ '(south asia)|(indic)|(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))|(\yindia\y)|(bengali)|(afghan(?!\swar))|(bangladesh)|(^\y(?!\w*everest)\w*(nepal(?!.*everest)))|(sri lanka)|(bhutan)|(east indian)' THEN 'South Asian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(east asia)|(asian americans)|(^\y(?!\w*everest)\w*(chin(a(?!\sfictitious)|ese)(?!.*everest)))|(japan)|(korea)|(taiwan)|(vietnam)|(cambodia)|(mongolia)|(lao(s|tian))|(myanmar)|(malay)|(thai)|(philippin)|(indonesia)|(polynesia)|(brunei)|(east timor)|(pacific island)|(tibet autonomous)|(hmong)|(filipino)' THEN 'East Asian & Pacific Islander'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bullying)|(aggressiveness)|((?<!(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin))\sabuse)|(violent crimes)|((?<!non)violence)|(crimes against)|((?<!(su)|(herb)|(pest))icide)|(suicide bomber)|(^\y(?!\w*investigation)\w*(murder(?!.*investigation)))|((human|child) trafficking)|(kidnapping)|(victims of)|(rape)|(police brutality)|(harassment)|(torture)' THEN 'Abuse & Violence'
	WHEN REPLACE(d.index_entry,'.','') ~ '((?<!recordings for people.*)disabilit)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)|(aspergers)|(neurobehavioral)|(neuropsychology)|(neurodiversity)|(brain variation)|(personality disorder)|(autis(m|tic))' THEN 'Disabilities & Neurodiversity'
   WHEN REPLACE(d.index_entry,'.','') ~ '(acceptance)|(anxiety)|(compulsive)|(schizophrenia)|(eating disorders)|(mental(( health)|( illness)|( healing)|(ly ill)))|(resilience personality)|(suicid(?!e bomb))|(self (esteem|confidence|realization|perception|actualization|management|destructive|control))|(emotional problems)|(mindfulness)|(depressi(?!ons))|(stress (psychology|disorder|psychology))|(psychic trauma)|((?<!(homo|islamo|trans|xeno))phobia)' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gamblers)|(drug use)|(drug abuse)|(substance abuse)|(alcoholi(?<!c beverages))|(addiction)''(gamblers)|(drug use)|(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin)\sabuse|(alcoholi(?!c beverages))|(binge drinking)|((?<!relationship )addict)' THEN 'Substance Abuse & Addiction'
	WHEN REPLACE(d.index_entry,'.','') ~ '(sexual minorities)|(gender)|(asexual)|(bisexual)|(gay(s|\y(?!(head|john))))|(intersex)|(homosexual)|(lesbian)|(stonewall riots)|(masculinity)|(femininity)|(trans(sex|phobia))|(drag show)|(male impersonator)|(queer)|(lgbtq)' THEN 'LGBTQIA+ & Gender Studies'
	WHEN REPLACE(d.index_entry,'.','') ~ '(indigenous)|(aboriginal)|((?<!east\s)\yindians(?!\sbaseball))|(trail of tears)|(aztecs)|(indian art)|(maya(s|n))|(eskimos)|(inuit)|(\yinca(s|n)\y)|(arctic peoples)|(aleut)|(american indian)' THEN 'Indigenous'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yarab)|(middle east)|(palestin)|(bedouin)|(israel)|(saudi)|(yemen)|(iraq(?!\swar))|(\yiran)|(egypt(?!ologists))|(leban(on|ese))|(qatar)|(syria)|(turkey\y)' THEN 'Arab & Middle Eastern'
	WHEN REPLACE(d.index_entry,'.','') ~ '(hispanic)|((?<!new\s)(mexic))|(latin america)|(cuba(?!n\smissile))|(puerto ric)|(dominican)|(el salvador)|(salvadoran)|(argentin)|(bolivia)|
(chile)|(colombia)|(costa rica)|(ecuador)|(equatorial guinea)|(guatemala)|(hondura)|(nicaragua)|(panama)|(paragua)|(peru)|(spain)|(spaniard)|(spanish)|(urugua)|(venezuela)|
(brazil)|(guiana)|(guadaloup)|(martinique)|(saint barthelemy)|(saint martin)' THEN 'Hispanic & Latino'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yafro)|(blacks(?!mith))|(men black)|(africa)|(black (nationalism|panther party|power|muslim|lives))|(harlem renaissance)|(abolition)|(segregation)|(^\y(?!\w*((rome)|(italy)|(egypt)))\w*(slave(s|(ry)?)(?!((rome)|(egypt)|(italy)))))|(emancipation)|(underground railroad)|(apartheid)|(jamaica)|(haiti)|(nigeria)|(ethiopia)|(congo)|(^\y(?!\w*kilmanjaro)\w*(tanzania(?!.*kilmanjaro)))|(kenya)|(uganda)|(sudan)|(ghana)|(cameroon)|
(madagascar)|(mozambique)|(angola)|(niger)|(ivory coast)|(\ymali\y)|(burkina faso)|(malawi)|(somalia)|(zambia)|(senegal)|(zimbabw)|(rwanda)|
(eritrea)|(guinea (?!pig))|(benin\y)|(burundi)|(sierra leone)|(\ytogo\y)|(liberia)|(mauritania)|(\ygabon)|(namibia)|
(botswana)|(lesotho)|(gambia)|(eswatini)|(djibouti)|(\ytutsi\y)' THEN 'Black'
	WHEN REPLACE(d.index_entry,'.','') ~ '(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionis)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)' THEN 'Judaism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|((?<!fugitives from )justice(?!(s of the peace)|(\s(league|society|donald))))|(racism)|(suffrag)|(sex role)|(social (change)|(movements)|(problems)|(reformers)|(responsibilit)|(conditions))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)|(refugee)|((anti nazi|pro choice|labor) movement)|(race awareness)|(political prisoner)|(ku klux klan)|(colorism)|(activis)|(persecution)|(xenophobia)|(((privilege)|(belonging)|(alienation)|(stigma)|(stereotypes)) social)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(multicultural)|(cross cultural)|(diasporas)|((?<!sexual )minorities)|(interracial)|(ethnic identity)|((race|ethnic) relations)|(racially mixed)|(bilingual)|(passing identity)' THEN 'Multicultural'
	WHEN REPLACE(d.index_entry,'.','') ~ '(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|(christian(?!.*\d{4}))|(easter\y)|(christmas)|(shaker)|(noahs ark)|(biblical)|(new testament)' THEN 'Christianity'
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
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}}
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) 

WHERE i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}})
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND {{age_limit}}
/*
(i.itype_code_num NOT BETWEEN '100' AND '183' AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')) -- adult
i.itype_code_num BETWEEN '150' AND '183' OR SUBSTRING(i.location_code,4,1) = 'j')) --juv
i.itype_code_num BETWEEN '100' AND '133' OR SUBSTRING(i.location_code,4,1) = 'y')) --ya
i.location_code ~ '\w' --all ages
*/
GROUP BY 1,2,3,4,5,6
)a
WHERE
a.topic IS NOT NULL)

SELECT *

FROM
(SELECT
CASE
	WHEN t.topic IS NOT NULL THEN t.topic
	ELSE 'None of the Above'
END AS topic,
COUNT (DISTINCT i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'),2)::MONEY AS "AVG_price",
COUNT(DISTINCT i.id) FILTER(WHERE c.id IS NOT NULL) AS "total_checked_out",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE c.id IS NOT NULL) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_checked_out",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_1_year",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_3_years",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_5_years",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NOT NULL) AS "have_circed_within_5+_years",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NOT NULL) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_5+_years",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NULL) AS "0_circs",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NULL) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_0_circs",
ROUND((COUNT(DISTINCT i.id) *(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2)::MONEY AS "Cost_Per_Circ_By_AVG_price",
ROUND(CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2))/CAST(COUNT (i.id) AS NUMERIC (12,2)), 2) AS turnover,
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) AS NUMERIC (12,2)) / (SELECT CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))FROM sierra_view.item_record i JOIN sierra_view.bib_record_item_record_link l ON i.id = l.item_record_id AND i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}}) AND {{age_limit}} JOIN
	sierra_view.record_metadata rmi ON i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}} JOIN sierra_view.bib_record_property b ON l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) )), 6)||'%' AS relative_item_total,
ROUND(100.0 * (CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2)) / (SELECT CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2)) FROM sierra_view.item_record i JOIN sierra_view.bib_record_item_record_link l ON i.id = l.item_record_id AND i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}}) AND {{age_limit}} JOIN
	sierra_view.record_metadata rmi ON i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}} JOIN sierra_view.bib_record_property b ON l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) )), 6)||'%' AS relative_circ

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}}) AND {{age_limit}}
LEFT JOIN
topic_list t
ON
l.bib_record_id= t.record_id
LEFT JOIN
sierra_view.checkout c
ON
i.id = c.item_record_id
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}}
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) 

GROUP BY 1

UNION

SELECT
'Unique Diverse Items' AS topic,
COUNT (DISTINCT i.id) AS "Item total",
SUM(i.checkout_total) AS "Total_Checkouts",
SUM(i.renewal_total) AS "Total_Renewals",
SUM(i.checkout_total) + SUM(i.renewal_total) AS "Total_Circulation",
ROUND(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'),2)::MONEY AS "AVG_price",
COUNT(DISTINCT i.id) FILTER(WHERE c.id IS NOT NULL) AS "total_checked_out",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE c.id IS NOT NULL) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_checked_out",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_1_year",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_3_years",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_5_years",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NOT NULL) AS "have_circed_within_5+_years",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NOT NULL) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_5+_years",
COUNT (DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NULL) AS "0_circs",
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) FILTER(WHERE i.last_checkout_gmt IS NULL) AS NUMERIC (12,2)) / CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))), 4)||'%' AS "Percentage_0_circs",
ROUND((COUNT(DISTINCT i.id) *(AVG(i.price) FILTER(WHERE i.price>'0' AND i.price <'10000'))/(NULLIF((SUM(i.checkout_total) + SUM(i.renewal_total)),0))),2)::MONEY AS "Cost_Per_Circ_By_AVG_price",
ROUND(CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2))/CAST(COUNT (i.id) AS NUMERIC (12,2)), 2) AS turnover,
ROUND(100.0 * (CAST(COUNT(DISTINCT i.id) AS NUMERIC (12,2)) / (SELECT CAST(COUNT (DISTINCT i.id) AS NUMERIC (12,2))FROM sierra_view.item_record i JOIN sierra_view.bib_record_item_record_link l ON i.id = l.item_record_id AND i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}}) AND {{age_limit}} JOIN
	sierra_view.record_metadata rmi ON i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}} JOIN sierra_view.bib_record_property b ON l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) )), 6)||'%' AS relative_item_total,
ROUND(100.0 * (CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2)) / (SELECT CAST(SUM(i.checkout_total) + SUM(i.renewal_total) AS NUMERIC (12,2)) FROM sierra_view.item_record i JOIN sierra_view.bib_record_item_record_link l ON i.id = l.item_record_id AND i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}}) AND {{age_limit}} JOIN
	sierra_view.record_metadata rmi ON i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}} JOIN sierra_view.bib_record_property b ON l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) )), 6)||'%' AS relative_circ

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ {{location}} AND i.item_status_code NOT IN ({{item_status_codes}}) AND {{age_limit}}
JOIN
(SELECT
DISTINCT record_id
FROM
topic_list) t
ON
l.bib_record_id= t.record_id
LEFT JOIN
sierra_view.checkout c
ON
i.id = c.item_record_id
JOIN
sierra_view.record_metadata rmi
ON
i.id = rmi.id AND rmi.creation_date_gmt::DATE > {{created_date}}
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ({{mat_type}}) 

GROUP BY 1

)a

ORDER BY CASE
	WHEN topic = 'Unique Diverse Items' THEN 2
	WHEN topic = 'None of the Above' THEN 3
	ELSE 1
END,topic
