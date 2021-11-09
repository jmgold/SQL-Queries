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
REPLACE(d.index_entry,'.','') ~ '(^\y(?!\w*((rome)|(italy)|(egypt)))\w*(slave(s|(ry)?)(?!((rome)|(egypt)|(italy)))))'--'(gamblers)|(drug use)|(drug abuse)|(substance abuse)|(alcoholi(?<!c beverages))|(addiction)''(gamblers)|(drug use)|(substance|medication|opioid|oxycodone|cocaine|marijuana|opium|phetamine|drug|morphine|heroin)\sabuse|(alcoholi(?!c beverages))|(binge drinking)|((?<!relationship )addict)'
--'(fiction)|(stories)|(tales)|(graphic novels)|(drama)|(pictorial works)|(stories in rhyme)|(picture books)$'
/*
african nations
*/
--negative lookahead (?!\sbaseball) lookbehind (?<!recordings)
--(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))
GROUP BY 1
--HAVING d.index_entry LIKE 'cleveland%'
ORDER BY 2 DESC