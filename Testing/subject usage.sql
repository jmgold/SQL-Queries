SELECT
d.index_entry,
COUNT(b.id)
--,string_agg(id2reckey(b.id)||'a',',')

FROM
sierra_view.phrase_entry d
JOIN
sierra_view.bib_record_property b 
ON
d.record_id = b.bib_record_id AND d.index_tag = 'd' AND b.material_code NOT IN ('7','8','b','e','j','k','m','n') AND d.is_permuted = FALSE
/*JOIN
sierra_view.subfield s
ON
b.id = s.record_id AND s.field_type_code = 'd'*/

WHERE
/*REPLACE(LOWER(s.content),'-',' ')*/
REPLACE(d.index_entry,'.','') ~ 'spain'
--'(christian (art|antiquities|pilgrims|saints|shrine|travel))|(church (architecture|buildings|decoration)).*guidebooks'
-- pondering for mysteries 'crimes against(?!.*fiction)'

--negative lookahead (?!\sbaseball) lookbehind (?<!recordings)
--(^\y(?!\w*k2)\w*(pakistan(?!.*k2)))
GROUP BY 1
--HAVING d.index_entry LIKE 'cleveland%'
ORDER BY 2 DESC