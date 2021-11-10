SELECT
d.index_entry,
COUNT(b.id)
--,string_agg(id2reckey(b.id)||'a',',')

FROM
sierra_view.phrase_entry d
JOIN
sierra_view.bib_record_property b 
ON
d.record_id = b.bib_record_id AND d.index_tag = 'd' AND b.material_code NOT IN ('7','8','b','e','j','k','m','n')
/*JOIN
sierra_view.subfield s
ON
b.id = s.record_id AND s.field_type_code = 'd'*/

WHERE
/*REPLACE(LOWER(s.content),'-',' ')*/
REPLACE(d.index_entry,'.','') ~ '(\yafro)|(blacks(?!mith))|(men black)|(africa)|(black (nationalism|panther party|power|muslim|lives))|(harlem renaissance)|(abolition)|(segregation)|(^\y(?!\w*((rome)|(italy)|(egypt)))\w*(slave(s|(ry)?)(?!((rome)|(egypt)|(italy)))))|(emancipation)|(underground railroad)|(apartheid)|(jamaica)|(haiti)|(nigeria)|(ethiopia)|(congo)|(^\y(?!\w*kilmanjaro)\w*(tanzania(?!.*kilmanjaro)))|(kenya)|(uganda)|(sudan)|(ghana)|(cameroon)|
(madagascar)|(mozambique)|(angola)|(niger)|(ivory coast)|(\ymali\y)|(burkina faso)|(malawi)|(somalia)|(zambia)|(senegal)|(zimbabw)|(rwanda)|
(eritrea)|(guinea (?!pig))|(benin\y)|(burundi)|(sierra leone)|(\ytogo\y)|(liberia)|(mauritania)|(\ygabon)|(namibia)|
(botswana)|(lesotho)|(gambia)|(eswatini)|(djibouti)|(\ytutsi\y)'--'(christian(?!.*\d{4}))'
--'(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|(christian(?!.*\d{4}))|(easter\y)|(christmas)|(shaker)|(noahs ark)|(biblical)|(new testament)'
--'(fiction)|(stories)|(tales)|(graphic novels)|(drama)|(pictorial works)|(stories in rhyme)|(picture books)$'
/*
african nations
*/
--negative lookahead (?!\sbaseball) lookbehind (?<!recordings)
--(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))
GROUP BY 1
--HAVING d.index_entry LIKE 'cleveland%'
ORDER BY 2 DESC