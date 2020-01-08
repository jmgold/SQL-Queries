SELECT *
FROM(
SELECT
--link to Encore, removed in favor of default keyword search on title
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
CASE
WHEN b.material_code = 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
WHEN b.material_code != 'a'
THEN (SELECT
'https://syndetics.com/index.aspx?upc='||SUBSTRING(s.content FROM '[0-9]+')||'/SC.gif&client=minuteman'
FROM
sierra_view.subfield s
WHERE
b.bib_record_id = s.record_id AND s.marc_tag = '024' AND s.tag = 'a'
ORDER BY s.occ_num
LIMIT 1)
END AS field_booklist_entry_cover

FROM
sierra_view.bib_record_property b
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
--comfort in an instant
'3769700',
--milk street tuesday nights
'3763196',
--Eight flavors
'3526888',
--salt fat acid heat
'3613920',
--Budget Bytes
'3152225',
--smitten kitchen
'3012273',
--homesick texan
'2928837',
--Pioneer woman cooks
'2948625',
--Plenty
'2881280',
--great big pressure cooker cookbook
'3215963',
--homemade life
'3001638',
--my berlin kitchen
'3013442',
--Julie & Julia
'2431945',
--blood bones & butter
'2955861',
--kitchen confidential
'2448798',
--food lab
'3274600',
--food anatomy
'3592950',
--everlasting meal
'2947984',
--how to cook everything
'1843627',
--omnivore's dilemma
'2377339',
--making of a chef
'1800807',
--On food and cooking
'2284927',
--art of fermentation
'2988559',
--simply keto
'3724950',
--flavor bible
'2614912',
--from crook to cook
'3784227',
--flour
'2853303',
--deep run roots
'3568451',
--a year of pies
'3013748',
--a year of picnics
'3649917',
--Joy the baker
'2965748',
--how to instant pot
'3664994',
--the perfect scoop
'3725515',
--bakewise
'2613831',
--classic german baking
'3540186',
--baked explorations
'2855647',
--keys to the kitchen
'3043895',
--martha's american food
'2962201',
--josey baker bread
'3150888',
--batch
'3645178',
--love and lemons
'3455828',
--vegetable love
'2355002',
--vegetables every day
'1989894',
--homemade pantry
'2967197',
--homemade kitchen
'3284811',
--food52
'2941160',
--art of simple food
'2499695',
--cooking in the moment
'2877763',
--veganomicon
'3660306',
--breakfast for dinner
'3055168',
--whole grain mornings
'3130620',
--americas test kichen
'2061059',
--Indian ish
'3815760',
--Pastry Love
'3855512',
--salt and straw
'3829680'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
) a
ORDER BY RANDOM()
LIMIT 50;
;