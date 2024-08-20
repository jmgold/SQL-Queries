/*
Jeremy Goldstein
Minuteman Library Newtork
Used to generate booklist at www.minlib.net
*/
SELECT DISTINCT ON (field_booklist_entry_author)
*
FROM(
SELECT
--link to Encore
DISTINCT 'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title AS title,
REPLACE(SPLIT_PART(SPLIT_PART(b.best_author,' (',1),', ',2),'.','')||' '||SPLIT_PART(b.best_author,', ',1) AS field_booklist_entry_author,
--Generate cover image from Syndetics
'https://syndetics.com/index.aspx?isbn='||SUBSTRING(MAX(s.content) FROM '[0-9]+')||'/SC.gif&client=minuteman' AS field_booklist_entry_cover
FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_item_record_link l
ON
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id
AND
i.is_available_at_library = 'TRUE'
AND i.item_status_code NOT IN ('m', 'n', 'z', 't', 'o', '$', '!', 'w', 'd', 'p', 'r', 'e', 'j', 'u', 'q', 'x', 'y', 'v')
--Limit to adult collections
AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
--Limit to English
JOIN
sierra_view.bib_record r
ON b.bib_record_id = r.id AND r.language_code = 'eng'
JOIN sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '020' AND s.tag = 'a'
WHERE
b.material_code = 'a' 
AND
REGEXP_REPLACE(b.best_author,'\.$','') IN (
'Chomsky, Noam',
'Meyer, Stephenie, 1973-',
'Miller, Henry, 1891-1980',
'Sedaris, David',
'Sanderson, Brandon',
'Didion, Joan',
'Clark, Mary Higgins',
'Cather, Willa, 1873-1947',
'Vowell, Sarah, 1969-',
'Thurber, James, 1894-1961',
'Pierce, Tamora',
'Toole, John Kennedy, 1937-1969',
'Willis, Connie',
'Roberts, Cokie',
'Cisneros, Sandra',
'Patchett, Ann',
'Harrison, Jim, 1937-2016',
'Saunders, George, 1958-',
'Fraction, Matt',
'Brinkley, Douglas',
'Waldman, Ayelet',
'Macaulay, David',
'Portis, Charles',
'Kurlansky, Mark',
'Mitchard, Jacquelyn',
'Berg, Elizabeth',
'Moriarty, Laura, 1970-',
'Deutermann, Peter T, 1941-',
'Lee, Stan, 1922-',
'Boyle, T.C',
'Conrad, Joseph, 1857-1924',
'Rilke, Rainer Maria, 1875-1926',
'Butler, Samuel, 1835-1902',
'Bryson, Bill',
'Milton, John, 1608-1674',
'Dickinson, Emily, 1830-1886',
'Flaubert, Gustave, 1821-1880',
'Jackson, Shirley, 1916-1965',
'Austen, Jane, 1775-1817',
'Clarke, Arthur C. (Arthur Charles), 1917-2008',
'Dick, Philip K',
'Ford, Ford Madox, 1873-1939',
'Tartt, Donna',
'Sparks, Nicholas'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;