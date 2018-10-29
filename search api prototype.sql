DROP TABLE IF EXISTS search_api;
CREATE TEMP TABLE search_api AS
SELECT
DISTINCT b.bib_record_id
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.phrase_entry p
ON
b.bib_record_id = p.record_id AND p.index_tag = 't' AND p.index_entry LIKE '%dogs%'
WHERE b.material_code = 'a'
LIMIT 10
;

DROP TABLE IF EXISTS get_isbn;
CREATE TEMP TABLE get_isbn AS
SELECT
t.bib_record_id,
SUBSTRING(MAX(i.content) FROM '[0-9]+') AS isbn
FROM 
search_api as t
JOIN
sierra_view.subfield i
ON
t.bib_record_id = i.record_id AND i.marc_tag = '020' AND i.tag = 'a'
GROUP BY 1
;


SELECT
b.best_title AS title,
id2reckey(b.bib_record_id) AS recordID,
b.best_author AS author,
m.name AS material,
v.field_content AS publisher,
t2.isbn AS isbn,
'https://syndetics.com/index.aspx?isbn='||t2.isbn||'/SC.gif&client=minuteman' AS coverImage

FROM
search_api as t
JOIN
sierra_view.bib_record_property b
ON
t.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser m
ON
b.material_code = m.code
JOIN
sierra_view.varfield v
ON
b.bib_record_id = v.record_id AND v.marc_tag = '260'
JOIN
get_isbn AS t2
ON
b.bib_record_id = t2.bib_record_id
;