WITH topic_list AS (
SELECT
record_id,
topic,
is_fiction
FROM(
SELECT
d.record_id,
CASE
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yzen\y)|(dalai lama)|(buddhis)' THEN 'Buddhism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yhindu(?!(stan|\skush)))|(divali)|(\yholi\y)|(bhagavadgita)|(upanishads)' THEN 'Hinduism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(agnosticism)|(atheism)|(secularism)' THEN 'Agnosticism & Atheism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(^\y(?!\w*terrorism)\w*(islam(?!.*(fundamentalism|terrorism))))|(\ysufi(sm)?)|(ramadan)|(id al (fitr\y)|(\yadha\y))|(quran)|(sunnites)|(shiah)|(muslim)|(mosques)|(qawwali)' THEN 'Islam'
	WHEN REPLACE(d.index_entry,'.','') ~ '(working class)|(social ((status)|(mobility)|(class)|(stratification)))|(standard of living)|(poor)|(\ycaste\y)|(classism)' THEN 'Class'
	WHEN REPLACE(d.index_entry,'.','') ~ '(south asia)|(indic\y)|(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))|(\yindia\y)|(bengali)|(afghan(?!\swar))|(bangladesh)|(^\y(?!\w*everest)\w*(nepal(?!.*everest)))|(sri lanka)|(bhutan)|(east indian)' THEN 'South Asian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(east asia)|(asian americans)|(^\y(?!\w*everest)\w*(chin(a(?!\sfictitious)|ese)(?!.*everest)))|(japan)|(korea(?!n war))|(taiwan)|(vietnam(?! war))|(cambodia)|(mongolia)|(lao(s|tian))|(myanmar)|(malay)|(thai)|(philippin)|(indonesia)|(polynesia)|(brunei)|(east timor)|(pacific island)|(tibet autonomous)|(hmong)|(filipino)' THEN 'East Asian & Pacific Islander'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bullying)|(aggressiveness)|((?<!(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin))\sabuse)|(violent crimes)|((?<!non)violence)|(crimes against)|((?<!(su)|(herb)|(pest))icide)|(suicide bomber)|(^\y(?!\w*investigation)\w*(murder(?!.*investigation)))|((human|child) trafficking)|(kidnapping)|(victims of)|(rape)|(police brutality)|(harassment)|(torture)' THEN 'Abuse & Violence'
	WHEN REPLACE(d.index_entry,'.','') ~ '((?<!recordings for people.*)disabilit)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)|(aspergers)|(neurobehavioral)|(neuropsychology)|(neurodiversity)|(brain variation)|(personality disorder)|(autis(m|tic))' THEN 'Disabilities & Neurodiversity'
   WHEN REPLACE(d.index_entry,'.','') ~ '(acceptance)|(anxiety)|(compulsive)|(schizophrenia)|(eating disorders)|(mental(( health)|( illness)|( healing)|(ly ill)))|(resilience personality)|(suicid(?!e bomb))|(self (esteem|confidence|realization|perception|actualization|management|destructive|control))|(emotional problems)|(mindfulness)|(depressi(?!ons))|(stress (psychology|disorder|psychology))|(psychic trauma)|((?<!(homo|islamo|trans|xeno))phobia)' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gamblers)|(drug use)|(drug abuse)|(substance abuse)|(alcoholi(?<!c beverages))|(addiction)|(drug use)|(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin)\sabuse|(alcoholi(?!c beverages))|(binge drinking)|((?<!relationship )addict)' THEN 'Substance Abuse & Addiction'
	WHEN REPLACE(d.index_entry,'.','') ~ '(sexual minorities)|(gender)|(asexual)|(bisexual)|(gay(s|\y(?!(head|john))))|(intersex)|(homosexual)|(lesbian)|(stonewall riots)|(masculinity)|(femininity)|(trans(sex|phobia))|(drag show)|(male impersonator)|(queer)|(lgbtq)' THEN 'LGBTQIA+ & Gender Studies'
	WHEN REPLACE(d.index_entry,'.','') ~ '(indigenous)|(aboriginal)|((?<!east\s)\yindians(?!\sbaseball))|(trail of tears)|(aztecs)|(indian art)|(maya(s|n))|(eskimos)|(inuit)|(\yinca(s|n)\y)|(arctic peoples)|(aleut)|(american indian)' THEN 'Indigenous'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yarab)|(middle east)|(palestin)|(bedouin)|(israel)|(saudi)|(yemen)|(iraq(?!\swar))|(\yiran)|(egypt(?!ologists))|(leban(on|ese))|(qatar)|(syria)|((?<!wild )turk((ish|ey(?!(s| hunting)))?)\y)|(kurdis)|(bahrain)|(cyprus)|(kuwait)|(\yoman)|(?<!(belfort|lacey|romero|peele|kisner|lebowitz|miller|myles|reid|rubin|schnitzer|shakoor|sonnenblick|spieth|john|davis|clara|richard) )jordan(?!\s(ruth|fisher|vernon|michael|barbara|robbie|carol|john|david|grace|family|schnitzer|hal|louis|karl|raisa|dorothy|clarence|bruce|billy|andrew|b\y|wong|will|ted|steve|robert|pete|pat|mattie|marsh|leslie|june|joseph|hamilton|zach|teresa|bella|eben))' THEN 'Arab & Middle Eastern'
	WHEN REPLACE(d.index_entry,'.','') ~ '(hispanic)|(?<!new\s)(mexic)|(latin america)|(cuba(?!n\smissile))|(puerto ric)|(dominican)|(el salvador)|(salvadoran)|(argentin)|(bolivia)|
(chile)|(colombia)|(costa rica)|(ecuador)|(equatorial guinea)|(guatemala)|(hondura)|(nicaragua)|(panama)|(paragua)|(peru)|(spain)|(spaniard)|(spanish)|(urugua)|(venezuela)|
(brazil)|(guiana)|(guadaloup)|(martinique)|(saint barthelemy)|(saint martin)' THEN 'Hispanic & Latino'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yafro)|(blacks(?!mith))|(men black)|(africa)|(black (nationalism|panther party|power|muslim|lives))|(harlem renaissance)|(abolition)|(segregation)|(^\y(?!\w*((rome)|(italy)|(egypt)))\w*(slave(s|(ry)?)(?!((rome)|(egypt)|(italy)))))|(emancipation)|(underground railroad)|(apartheid)|(jamaica)|(haiti)|(nigeria)|(ethiopia)|(congo)|(^\y(?!\w*kilmanjaro)\w*(tanzania(?!.*kilmanjaro)))|(kenya)|(uganda)|(sudan)|(ghana)|(cameroon)|
(madagascar)|(mozambique)|(angola)|(niger)|(ivory coast)|(\ymali\y)|(burkina faso)|(malawi)|(somalia)|(zambia)|(senegal)|(zimbabw)|(rwanda)|
(eritrea)|(guinea (?!pig))|(benin\y)|(burundi)|(sierra leone)|(\ytogo\y)|(liberia)|(mauritania)|(\ygabon)|(namibia)|
(botswana)|(lesotho)|(gambia)|(eswatini)|(djibouti)|(\ytutsi\y)|((?<!(johnson|foster|gardenier|gibbs|hurley|jenkins|kerley|kister|rje) )\ychad\y)' THEN 'Black'
	WHEN REPLACE(d.index_entry,'.','') ~ '(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionis)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)' THEN 'Judaism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|((?<!fugitives from )justice(?!(s of the peace)|(\s(league|society|donald))))|(racism)|(suffrag)|(sex role)|(social (change)|(movements)|(problems)|(reformers)|(responsibilit)|(conditions))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)|(refugee)|((anti nazi|pro choice|labor) movement)|(race awareness)|(political prisoner)|(ku klux klan)|(colorism)|(activis)|(persecution)|(xenophobia)|(((privilege)|(belonging)|(alienation)|(stigma)|(stereotypes)) social)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(multicultural)|(cross cultural)|(diasporas)|((?<!sexual )minorities)|(interracial)|(ethnic identity)|((race|ethnic) relations)|(racially mixed)|(bilingual)|(passing identity)' THEN 'Multicultural'
	WHEN REPLACE(d.index_entry,'.','') ~ '(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|((?<!(siriano|amanpour|dior) )christian(?!(sen|son| dior))(?!.*\d{4}))|(easter\y)|(christmas)|(shaker)|(noahs ark)|(biblical)|(new testament)' THEN 'Christianity'
ELSE 'None of the Above'
END AS topic,
CASE
	WHEN d.index_entry ~ '((\yfiction)|(pictorial works)|(tales)|(^\y(?!\w*biography)\w*(comic books strips etc))|(^\y(?!\w*biography)\w*(graphic novels))|(\ydrama)|((?<!hi)stories))(( [a-z]+)?)(( translations into [a-z]+)?)$' AND b.material_code NOT IN ('7','8','b','e','j','k','m','n')
	AND NOT (ml.bib_level_code = 'm' AND ml.record_type_code = 'a' AND f.p33 IN ('0','e','i','p','s')) THEN TRUE
	ELSE FALSE
END AS is_fiction	

FROM
sierra_view.bib_record_location bl
LEFT JOIN
sierra_view.phrase_entry d
ON
bl.bib_record_id = d.record_id AND d.index_tag = 'd' AND d.is_permuted = FALSE
JOIN
sierra_view.bib_record_property b
ON
bl.bib_record_id = b.bib_record_id
LEFT JOIN
sierra_view.control_field f
ON
b.bib_record_id = f.record_id
LEFT JOIN
sierra_view.leader_field ml
ON
b.bib_record_id = ml.record_id

WHERE bl.location_code ~ '^act'
)inner_query
GROUP BY 1,2,3
)

SELECT *

FROM
(SELECT
t.topic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND t.is_fiction IS TRUE) AS juv_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND t.is_fiction IS FALSE) AS juv_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND t.is_fiction IS TRUE) AS ya_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND t.is_fiction IS FALSE) AS ya_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND t.is_fiction IS TRUE) AS adult_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND t.is_fiction IS FALSE) AS adult_nonfic,
COUNT(DISTINCT i.id) AS total_items

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^act'
JOIN
topic_list t
ON
l.bib_record_id= t.record_id AND t.topic != 'None of the Above'

GROUP BY 1

UNION

SELECT
'Unique Diverse Items' AS topic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND t.is_fiction IS TRUE) AS juv_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND t.is_fiction IS FALSE) AS juv_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND t.is_fiction IS TRUE) AS ya_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND t.is_fiction IS FALSE) AS ya_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND t.is_fiction IS TRUE) AS adult_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND t.is_fiction IS FALSE) AS adult_nonfic,
COUNT(DISTINCT i.id) AS total_items

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^act'
JOIN
topic_list t
ON
l.bib_record_id= t.record_id AND t.topic != 'None of the Above'

GROUP BY 1

UNION

SELECT
'None of the Above' AS topic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND t.is_fiction IS TRUE) AS juv_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j' AND t.is_fiction IS FALSE) AS juv_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND t.is_fiction IS TRUE) AS ya_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y' AND t.is_fiction IS FALSE) AS ya_nonfic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND t.is_fiction IS TRUE) AS adult_fic,
COUNT(DISTINCT i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j') AND t.is_fiction IS FALSE) AS adult_nonfic,
COUNT(DISTINCT i.id) AS total_items

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id AND i.location_code ~ '^act'
JOIN
(SELECT
t.record_id,
t.is_fiction
FROM topic_list t
GROUP BY 1,2
HAVING COUNT(DISTINCT t.topic) FILTER (WHERE t.topic != 'None of the Above') = 0
) t
ON
l.bib_record_id= t.record_id

GROUP BY 1
)a

ORDER BY CASE
	WHEN topic = 'Unique Diverse Items' THEN 2
	WHEN topic = 'None of the Above' THEN 3
	ELSE 1
END,topic