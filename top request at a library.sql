--Jeremy Goldstein
--jgoldstein@minlib.net
--Minuteman Library Network

--Query returns the record with the largest number of holds for each pickup location

SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code = 'actz'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'actz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'arl%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'arl%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ar2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ar2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code = 'ashz'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'ashz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code = 'bedz'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'bedz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code = 'blmz'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code = 'blmz'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE h.pickup_location_code LIKE 'brk'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'brk'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'br2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'br2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'br3%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'br3%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'cam'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'cam'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ca4%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca4%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ca5%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca5%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ca6%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca6%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ca7%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca7%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ca8%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca8%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ca9%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ca9%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'con%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'con%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'co2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'co2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'de%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'de%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ddm%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ddm%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'dd2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'dd2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'do%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'do%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'fpl%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fpl%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'fp2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fp2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'fs%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fs%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'fr%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'fr%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ho%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ho%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'la%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'la%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'le%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'le%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'li%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'li%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ma%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ma%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ml%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ml%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'me%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'me%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'mw%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'mw%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'mi%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'mi%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'nat%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'nat%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'na2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'na2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'na3%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'na3%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ne%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ne%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'nt%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'nt%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'no%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'no%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code = 'pmcz'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'pmcz'
GROUP BY 1,2
LIMIT 1
)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 're%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 're%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'sh%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'sh%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'som%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'som%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'so2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'so2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'so3%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'so3%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'st%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'st%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'su%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'su%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wl%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wl%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wa%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wa%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wy%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wy%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wel%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wel%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'we2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'we2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'we3%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'we3%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ws%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ws%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wwd%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wwd%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'ww2%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'ww2%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wi%'
GROUP BY 1,2,3,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wi%'
GROUP BY 1,2)AS Q)
UNION
SELECT
DISTINCT ON (field_booklist_entry_location)
l.name AS field_booklist_entry_location,
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id) AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author AS field_booklist_entry_author, 
COUNT(h.id),
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM 
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
JOIN
sierra_view.location_myuser l
ON
substring(h.pickup_location_code from 1 for 3) = l.code
WHERE
h.pickup_location_code LIKE 'wo%'
GROUP BY 1,2,3,4,4
HAVING COUNT(h.id) = (SELECT MAX(C) FROM (SELECT h.pickup_location_code,b.bib_record_id,COUNT(h.id) AS C FROM sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
WHERE
h.pickup_location_code LIKE 'wo%'
GROUP BY 1,2)AS Q)
ORDER BY 1