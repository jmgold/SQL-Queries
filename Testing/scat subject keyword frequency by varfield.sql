--try regex_replace for subfield...maybe subfield table instead and weed out some subfields like dates
--https://dba.stackexchange.com/questions/145016/finding-the-most-commonly-used-non-stop-words-in-a-column

WITH subject_list AS(
SELECT DISTINCT ON (i.icode1, d.field_content)
i.icode1 AS scat,
REPLACE(d.field_content,'|a','') AS subject
FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.varfield d
ON
l.bib_record_id = d.record_id AND d.varfield_type_code = 'd'


WHERE
i.location_code ~ '^cam'
AND i.icode1 <= 100
), 

found_lower_words AS
(
SELECT 
	scat,
	LOWER(unnest(string_to_array(subject, '|'))) AS word
	
FROM
subject_list
)

SELECT scat, word, count(*) AS word_count
FROM
    found_lower_words
    
GROUP BY
    scat, word
ORDER BY
    scat, word_count DESC, word ASC
;

/*SELECT * 
FROM ts_stat('SELECT to_tsvector(''hello dere hello hello ridiculous'')');
*/