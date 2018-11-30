--Lazy way to generate staff picks booklist
SELECT
--link to Encore, removed in favor of default keyword search on title
--'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author as field_booklist_entry_author,
CASE
WHEN b.material_code = 'a'
THEN 'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(isbn.content) FROM '[0-9]+')||'/SC.gif&client=minuteman'
WHEN b.material_code != 'a'
THEN 'https://syndetics.com/index.aspx?upc='||SUBSTRING(MAX(upc.content) FROM '[0-9]+')||'/SC.gif&client=minuteman'
END AS field_booklist_entry_cover

FROM
sierra_view.bib_record_property b
LEFT JOIN sierra_view.subfield isbn
ON
b.bib_record_id = isbn.record_id AND isbn.marc_tag = '020' AND isbn.tag = 'a'
LEFT JOIN sierra_view.subfield upc
ON
b.bib_record_id = upc.record_id AND upc.marc_tag = '024' AND upc.tag = 'a'
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
--an unkindness of ghosts
'3661398',
--moonshine
'3613569',
--vacationland
'3652176',
--how to invent everything
'3769049',
--Snagglepuss Chronicles
'3783294',
--Old Woman Laura
'3770952',
--Hawkeye kate bishop
'3718917',
--Spinning Silver
'3755652',
--Isola
'3769849',
--Batman White Knight
'3768360',
--Infidel
'3766670',
--Mae
'3613565',
--Thor
'3755259',
--Metal
'3742087',
--Rock Candy Mountain
'3716159',
--Lost Light
'3754936',
--Doctor Aphra
'3673175',
--Giant Days
'3429620',
--Head Lopper
'3721269',
--Wicked + Divine
'3748062',
--Fall of the batmen
'3784606',
--Space Opera
'3725134',
--Freeze Frame Revolution
'3748734',
--Calculating Stars
'3754471',
--Paper Girls
'3458750',
--girl in the green silk gown
'3762860',
--merry spinster
'3715047',
--assassination of brangwain spurge
'3772435',
--PS I Miss You
'3724833',
--comfort in an instant
'3769700',
--Wild Dead
'3738205',
--summer of jordi perez
'3723824',
--a treacherous curse
'3654505',
--girl in the tower
'3654507',
--Here to stay
'3769588',
--check please
'3775527',
--I'll be gone in the dark
'3684052',
--it devours
'3660083',
--kiss quotient
'3737982',
--Wedding Date
'3715874',
--prince and the dressmaker
'3718546',
--European travel for the monstrous gentlewoman
'3760948',
--the proposal
'3768424',
--sustainable home
'3770861',
--milk street tuesday nights
'3763196',
--map of salt and stars
'3743296',
--What She ate
'3643292',
--Amateur
'3770409',
--Barracoon
'3719554',
--Bunk
'3660585',
--Eight flavors
'3526888',
--stone sky
'3649410',
--salt fat acid heat
'3613920',
--American war
'3596082',
--I'll Be Your Girl
'3730441',
--Dirty Computer
'3738649',
--I Like Fun
'3722761',
--Thor Ragnarok
'3710822',
--Sorry to bother you
'3790875',
--get out
'3636435',
--incredibles 2
'3793628',
--black panther
'3736550',
--won't you be my neighbor
'3767463'
)
GROUP BY b.bib_record_id,1,2,b.material_code 
ORDER BY 1
--LIMIT 25
;