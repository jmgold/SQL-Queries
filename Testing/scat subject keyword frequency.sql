--https://dba.stackexchange.com/questions/145016/finding-the-most-commonly-used-non-stop-words-in-a-column

WITH subject_list AS(
SELECT DISTINCT ON (i.icode1, d.index_entry)
i.icode1 AS scat,
d.index_entry AS subject
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


WHERE
i.location_code ~ '^cam'
AND i.icode1 <= 100
)

SELECT 
--*
scat
,lexemes
--,token
,COUNT(*)

FROM subject_list
CROSS JOIN LATERAL ts_debug(subject)
WHERE alias = 'asciiword'
	AND lexemes != '{}'
--        AND array_length(lexemes,1) <> 0
GROUP BY 1,2
ORDER BY 1,3 DESC

/*SELECT * 
FROM ts_stat('SELECT to_tsvector(''hello dere hello hello ridiculous'')');
*/