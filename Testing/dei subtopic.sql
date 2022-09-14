WITH topic_list AS (
    SELECT
    record_id,
    topic,
    is_fiction
    FROM(
    SELECT
    d.record_id,
    CASE
    WHEN REPLACE(d.index_entry,'.','') ~ '^\y(?!\w((ecology)|(ecotourism)|(ecosystems)|(environmentalism)|(african american)|(african diaspora)|(blues music)|(freedom trail)|(underground railroad)|(women)|(ethnic restaurants)|
(social life and customs)|(older people)|(people with disabilities)|(gay(s|\y(?!(head|john))))|(lesbian)|(bisexual)|(gender)|(sexual minorities)|(indian (art|trails))|(indians of)|(inca(s|n))|
(christian (art|antiquities|saints|shrine|travel))|(pilgrims and pilgrimages)|(jews)|(judaism)|((jewish|islamic) architecture)|(convents)|(sacred space)|(sepulchral monuments)|(spanish mission)|(spiritual retreat)|(temples)|(houses of prayer)|(religious institutions)|(monasteries)|(holocaust)|(church (architecture|buildings|decoration))))\w.*((guidebooks)|(description and travel))' THEN 'None of the Above'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yzen\y)|(dalai lama)|(buddhis)' THEN 'Religion-Buddhism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yhindu(?!(stan|\skush)))|(divali)|(\yholi\y)|(bhagavadgita)|(upanishads)|(\ybrahman(s|ism))' THEN 'Religion-Hinduism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(agnosticism)|(atheism)|(secularism)' THEN 'Religion-Agnosticism & Atheism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(^\y(?!\w*terrorism)\w*(islam(?!.*(fundamentalism|terrorism))))|(\ysufi(sm)?)|(ramadan)|(id al (fitr\y)|(\yadha\y))|(quran)|(sunnites)|(shiah)|(muslim)|(mosques)|(qawwali)' THEN 'Religion-Islam'
	WHEN REPLACE(d.index_entry,'.','') ~ '(working class)|(social ((status)|(mobility)|(class)|(stratification)))|(standard of living)|(poor)|(\ycaste\y)|(classism)' THEN 'Class'
	WHEN REPLACE(d.index_entry,'.','') ~ '(south asia)|(indic\y)|(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))|(\yindia\y)|(bengali)|(afghan(?!(\swar|s coverlets)))|(bangladesh)|(^\y(?!\w*everest)\w*(nepal(?!.*everest)))|(sri lanka)|(bhutan)|(east indian)' THEN 'South Asian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(east asia)|(asian americans)|(^\y(?!\w*everest)\w*(chin(a(?!\sfictitious)|ese)(?!.*everest)))|(japan(?!ese beetle))|(korea(?!n war))|(taiwan)|(vietnam(?! war))|(cambodia)|(mongolia)|(lao(s|tian))|(myanmar)|(\ymalay)|((?<!muay )\ythai)|(philippin)|(indonesia)|(polynesia)|(brunei)|(east timor)|(pacific island)|(tibet autonomous)|(hmong)|(filipino)|(burm(a|ese(?! (python|cat))))' THEN 'East Asian & Pacific Islander'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bullying)|(aggressiveness)|((?<!(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin))\sabuse(?!\sof administrative))|(violent crimes)|((?<!non)violence)|(crimes against)|((?<!(su)|(herb)|(pest))icide)|(suicide bomber)|(^\y(?!\w*investigation)\w*(murder(?!.*investigation)))|((human|child) trafficking)|(kidnapping)|(victims of)|(rape)|(police brutality)|(harassment)|(torture)' THEN 'Abuse & Violence'
	WHEN REPLACE(d.index_entry,'.','') ~ '((?<!recordings for people.*)disabilit)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)|(aspergers)|(neurobehavioral)|(neuropsychology)|(neurodiversity)|(brain variation)|(personality disorder)|(autis(m|tic))|(barrier free design)' THEN 'Disabilities & Neurodiversity'
   WHEN REPLACE(d.index_entry,'.','') ~ '(acceptance)|(anxiety)|(compulsive)|(schizophrenia)|(eating disorders)|(mental(( health)|( illness)|( healing)|(ly ill)))|(resilience personality)|(suicid(?!e bomb))|(self (esteem|confidence|realization|perception|actualization|management|destructive|control))|(emotional problems)|(mindfulness)|(depressi(?!ons))|(stress (psychology|disorder))|(psychic trauma)|((?<!(homo|islamo|trans|xeno))phobia)' THEN 'Mental & Emotional Health'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gamblers)|(drug use)|(alcoholi(?<!c beverages))|(addiction)|(drug use)|(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin)\sabuse|(binge drinking)|((?<!relationship )addict)' THEN 'Substance Abuse & Addiction'
	--testing
	WHEN REPLACE(d.index_entry,'.','') ~ '(trans(sex|phobia))' THEN 'LGBTQIA-trans'
	WHEN REPLACE(d.index_entry,'.','') ~ '(intersex)' THEN 'LGBTQIA-intersex'
	WHEN REPLACE(d.index_entry,'.','') ~ '(asexual)' THEN 'LGBTQIA-aesexual'
	WHEN REPLACE(d.index_entry,'.','') ~ '(bisexual)' THEN 'LGBTQIA-bisexual'
	WHEN REPLACE(d.index_entry,'.','') ~ '(drag show)|(male impersonator)' THEN 'LGBTQIA-drag'
	WHEN REPLACE(d.index_entry,'.','') ~ '(lesbian)' THEN 'LGBTQIA-lesbian'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gay(s|\y(?!(head|john))))' THEN 'LGBTQIA-gay'
	WHEN REPLACE(d.index_entry,'.','') ~ '(gender)(masculinity)|(femininity)' THEN 'LGBTQIA-gender'
	WHEN REPLACE(d.index_entry,'.','') ~ '(sexual minorities)|(homosexual)|(stonewall riots)|(queer)|(lgbtq)' THEN 'LGBTQIA-other'
	---
	WHEN REPLACE(d.index_entry,'.','') ~ '(indigenous)|(aboriginal)|((?<!east\s)\yindians(?!\sbaseball))|(trail of tears)|(aztecs)|(indian art)|(maya(s|n))|(eskimos)|(inuit)|(\yinca(s|n)\y)|(arctic peoples)|(aleut)|(american indian)|(indian reservations)|(maori)|(((abenaki)|(algonquian)|(apache)|(cherokee)|(chickasaw)|(chocktaw)|(cree)|(dakota)|(hopi)|(iroquois)|(kiowa)|(munduruku)|(navajo)|(ojibwa)|(oneida)|(osage)|(powhatan)|(pueblo)|(quiche)|(shoshoni)|(siksika)|(taino)|(tlingit)|(tuscarora)|(tzotzil)|(winnebago)|(yankton))\s((women)|(language)|(mythology)|(dance)|(silverwork)|(textile)|(nation)|(literature)|(long walk)))' THEN 'Indigenous'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yarab)|(middle east)|(palestin)|(bedouin)|((?<!(king of|putnam|potter|loring) )\yisrael(?!\slee))|(saudi)|(yemen)|(iraq(?!\swar))|(\yiran)|(\yegypt(?!ologists))|(leban(on|ese))|(qatar)|(syria)|((?<!wild )turk((ish|ey(?!(s| hunting)))?)\y)|(kurdis)|(bahrain)|(cyprus)|(kuwait)|(\yoman)|(?<!(belfort|lacey|romero|peele|kisner|lebowitz|miller|myles|reid|rubin|schnitzer|shakoor|sonnenblick|spieth|john|davis|clara|richard) )jordan(?!\s(ruth|fisher|vernon|michael|barbara|robbie|carol|john|david|grace|family|schnitzer|hal|louis|karl|raisa|dorothy|clarence|bruce|billy|andrew|b\y|wong|will|ted|steve|robert|pete|pat|mattie|marsh|leslie|june|joseph|hamilton|zach|teresa|bella|eben))' THEN 'Arab & Middle Eastern'
	WHEN REPLACE(d.index_entry,'.','') ~ '(hispanic)|((?<!new\s)(mexic))|(latin america)|(\ycuba(?!n\smissile))|(puerto ric)|(dominican)|(el salvador)|(salvadoran)|(argentin)|(bolivia)|
(chile)|(colombia)|(costa rica)|(ecuador)|(equatorial guinea)|(guatemala)|(hondura)|(nicaragua)|(panama)|(paragua)|(peru(?!gia))|(spain)|(spaniard)|(spanish)|(urugua)|(venezuela)|
((?<!jiu jitsu )brazil)|(guiana)|(guadeloup)|(martinique)|(saint barthelemy)|(saint martin)' THEN 'Hispanic & Latino'
	WHEN REPLACE(d.index_entry,'.','') ~ '(\yafro)|(blacks(?!mith))|(men black)|((?<!game reserve south )africa(?!(nized|nus|n (literature french|elephant|gray|black rhino|buffalo|wild dog|python|pygmy|violets))))|(black (nationalism|panther party|power|muslim|lives))|(harlem renaissance)|(abolition)|(segregation)|(^\y(?!\w*((rome)|(italy)|(egypt)))\w*(slave(s|(ry)?)(?!((rome)|(egypt)|(italy)))))|(emancipation)|(underground railroad)|(apartheid)|((?<!kincaid )jamaica)|(haiti)|(nigeria)|((?<!cepheus king of )ethiopia)|(^\y(?!\w*(bonobo|wildlife))\w*congo)|(^\y(?!\w*kilmanjaro)\w*(tanzania(?!.*kilmanjaro)))|((?<!(mammals|elephants|leopard|cows|lion|animals|zoology|conservation|behavior) )kenya)|(uganda)|(sudan)|(ghana)|(cameroon)|
((?<!(conservation|animals|jungles|species|lemurs|dinosaurs|fossil|zoology|wildlife watching) )madagascar)|(mozambique)|(angola)|(cote divoire)|(\ymali\y)|(burkina faso)|(malawi)|(somalia)|(zambia)|(senegal)|(zimbabw)|((?<!gorilla )rwanda)|
(eritrea)|(guinea (?!pig))|(benin\y)|(burundi)|(sierra leone)|(\ytogo\y(?! dog))|(liberia)|(mauritania)|(\ygabon)|(namibia)|
(botswana)|(lesotho)|(gambia)|(eswatini)|(djibouti)|(\ytutsi\y)|((?<!(daybell|johnson|foster|gardenier|gibbs|hurley|jenkins|kerley|kister|rje) )\ychad\y)' THEN 'Black'
	WHEN REPLACE(d.index_entry,'.','') ~ '(jewish)|(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionis)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)|(hebrew)|(yiddish)|(seder)|(cabala)' THEN 'Religion-Judaism'
	WHEN REPLACE(d.index_entry,'.','') ~ '(genocide)|(equality)|(immigra)|(feminis)|(womens rights)|(sexism)|((?<!(fugitives from |young |jones ))justice(?!(s of the peace)|(\s(league|society|donald|benjamin|victoria))))|(racism)|(suffrag)|(sex role)|(social ((change)|(movements)|(problems)|(reformers)|(responsibilit)|(conditions)))|(sustainable development)|(environmental)|(poverty)|(abortion)|((human|civil) rights)|(prejudice)|(protest movements)|(homeless)|(public (health|welfare))|(discrimination)|(refugee)|((anti nazi|pro choice|labor) movement)|(race awareness)|(political prisoner)|(ku klux klan)|(colorism)|(activis)|(persecution)|(xenophobia)|(((privilege)|(belonging)|(alienation)|(stigma)|(stereotypes)) social)|(noncitizen)|(stateless person)|(deportation)|(abuse of power)|(boat people)' THEN 'Equity & Social Issues'
	WHEN REPLACE(d.index_entry,'.','') ~ '(multicultural)|(cross cultural)|(diasporas)|((?<!sexual )minorities)|(interracial)|(ethnic identity)|((race|ethnic) relations)|(racially mixed)|(bilingual)|(passing identity)' THEN 'Multicultural'
	WHEN REPLACE(d.index_entry,'.','') ~ '(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|((?<!(christ|mary\s|ezra\s))church(?!(ill|\sbenjamin|\sr w richard|\sfrederic|\sf forrester)))|(evangelicalism)|((?<!(siriano|amanpour|dior) )christian(?!(sen|son| dior))(?!.*\d{4}))|(easter\y)|(christmas)|(shaker)|(noahs ark)|(biblical)|(new testament)' THEN 'Religion-Christianity'
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

    WHERE bl.location_code ~ '^fpl'
    )inner_query

    GROUP BY 1,2,3
    )

    SELECT *

    FROM
    (SELECT 'fpl'
     AS library,
    mat.name AS format,
    CASE
	 	WHEN t.topic ~ '^LGBTQIA' THEN 'LTBTQIA+ & Gender Studies'
	 	WHEN t.topic ~ '^Religion' THEN 'Religion'
		ELSE t.topic
	 END AS topic,
    CASE
      WHEN t.topic ~ '^LGBTQIA' THEN REPLACE(t.topic,'LGBTQIA-','')
      WHEN t.topic ~ '^Religion' THEN REPLACE(t.topic,'Religion-','')
      ELSE 'NA'
   END AS subtopic,
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
    i.id = l.item_record_id AND i.location_code ~ '^fpl'
    JOIN
    topic_list t
    ON
    l.bib_record_id= t.record_id AND t.topic != 'None of the Above'
    JOIN
    sierra_view.bib_record_property b
    ON
    t.record_id = b.bib_record_id
    JOIN
    sierra_view.material_property_myuser mat
    ON
    b.material_code = mat.code

    GROUP BY 1,2,3,4

    UNION

    SELECT 'Framingham'
     AS library,
    mat.name AS format,
    'Unique Diverse Items' AS topic,
    'NA' AS subtopic,
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
    i.id = l.item_record_id  AND i.location_code ~ '^fpl'
    JOIN
    topic_list t
    ON
    l.bib_record_id= t.record_id AND t.topic != 'None of the Above'
    JOIN
    sierra_view.bib_record_property b
    ON
    t.record_id = b.bib_record_id
    JOIN
    sierra_view.material_property_myuser mat
    ON
    b.material_code = mat.code

    GROUP BY 1,2,3,4

    UNION

    SELECT 'Framingham'
     AS library,
    mat.name AS format,
    'None of the Above' AS topic,
    'NA' AS subtopic,
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
    i.id = l.item_record_id AND i.location_code ~ '^fpl'
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
    JOIN
    sierra_view.bib_record_property b
    ON
    t.record_id = b.bib_record_id
    JOIN
    sierra_view.material_property_myuser mat
    ON
    b.material_code = mat.code

    GROUP BY 1,2,3,4
    )a

    ORDER BY 1,2,
    CASE
    WHEN topic = 'Unique Diverse Items' THEN 2
    WHEN topic = 'None of the Above' THEN 3
    ELSE 1
    END,topic