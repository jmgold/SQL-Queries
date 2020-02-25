--Booklist generator for Newton's website
SELECT
id2reckey(bi.bib_record_id)||'a' AS Record_num,
'https://syndetics.com/index.php?isbn='||substring(MAX(isbn.content),'([^\s]+)')||'/mc.gif&client=minuteman\"width=\"74\"height=\"97\"alt=\"Image of book cover\' AS Cover,
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(bi.bib_record_id)AS Encore,
i.location_code,
c.call_number AS Call_num,
bp.best_author AS Author,
bp.best_title AS Title,
regexp_replace(regexp_replace(regexp_replace(description.field_content,'\|a',''),'\|b',''),'\|c',' ') AS Description,
--MAX(note.content) AS Note,
'http://www.syndetics.com/index.aspx?isbn='||substring(MAX(isbn.content),'([^\s]+)')||'/summary.html&client=minuteman&type=rn12' AS More_info
FROM
sierra_view.item_view i
JOIN
sierra_view.bib_record_item_record_link bi
ON
i.id = bi.item_record_id
JOIN
sierra_view.bib_record_property bp
ON
bi.bib_record_id = bp.bib_record_id
JOIN sierra_view.item_record_property c
ON
i.id = c.item_record_id
LEFT OUTER JOIN sierra_view.varfield AS description
ON
bi.bib_record_id = description.record_id AND description.marc_tag = '300'
--LEFT OUTER JOIN sierra_view.subfield AS note
--ON
--bi.bib_record_id = description.record_id AND note.marc_tag = '500' AND note.tag = 'a'
LEFT OUTER JOIN sierra_view.subfield AS isbn
ON
bi.bib_record_id = isbn.record_id AND isbn.marc_tag = '020' AND isbn.tag = 'a'
WHERE
i.agency_code_num = '8'
AND
i.record_creation_date_gmt > (now()::date - 7) 
AND
((CAST(COALESCE(i.icode1, 0) AS integer) BETWEEN 1  AND 99) OR i.icode1 IN ('116','131','150'))
GROUP BY 1,3,4,5,6,7,8;
