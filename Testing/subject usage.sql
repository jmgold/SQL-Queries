SELECT
d.index_entry,
COUNT(b.id)
--,string_agg(id2reckey(b.id)||'a',',')

FROM
sierra_view.phrase_entry d
JOIN
sierra_view.bib_record b 
ON
d.record_id = b.id AND d.index_tag = 'd'
JOIN
sierra_view.subfield s
ON
b.id = s.record_id AND s.field_type_code = 'd'

WHERE
REPLACE(LOWER(s.content),'-',' ') ~ '((?<!recordings for people.*)disabilit)|(blind)|(deaf)|(terminally ill)|(amputees)|(patients)|(aspergers)|(neurobehavioral)|(neuropsychology)|(neurodiversity)|(brain variation)|(personality disorder)|(autis(m|tic))'
--negative lookahead (?!\sbaseball)
GROUP BY 1
--HAVING d.index_entry LIKE 'cleveland%'
ORDER BY 2 DESC