SELECT  
-- bib fields
  b.title                  AS "bib_title"
FROM  sierra_view.bib_view b
WHERE   b.title LIKE '%Eyewitness%' or b.title LIKE '%eyewitness%';