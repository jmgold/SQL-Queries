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
'Patterson, James, 1947-',
'Roth, Philip',
'Updike, John',
'Albee, Edward, 1928-2016',
'Straub, Peter, 1943-',
'Weiner, Jennifer',
'Leckie, Ann',
'Farmer, Fannie Merritt, 1857-1915',
'Poundstone, William',
'Fisher, Vardis, 1895-1968',
'Levinson, Paul',
'Howe, Florence',
'Kurland, Michael',
'Kennedy, Thomas E., 1944-',
'Ibsen, Henrik, 1828-1906',
'Housman, A. E. (Alfred Edward), 1859-1936',
'Sackville-West, V. (Victoria), 1892-1962',
'Kerouac, Jack, 1922-1969',
'Howells, William Dean, 1837-1920',
'Strachey, Lytton, 1880-1932',
'Akutagawa, Ryūnosuke, 1892-1927',
'Ellison, Ralph',
'Sholem Aleichem, 1859-1916',
'Seuss, Dr',
'Wolfe, Tom',
'MacLachlan, Patricia',
'Cyrano de Bergerac, 1619-1655',
'García Márquez, Gabriel, 1927-2014',
'Abe, Kōbō, 1924-1993',
'Ellis, Bret Easton',
'Grahame, Kenneth, 1859-1932',
'Eugenides, Jeffrey',
'Spillane, Mickey, 1918-2006',
'Lindsey, Johanna',
'Adams, Douglas, 1952-2001',
'Hamilton, Virginia, 1934-2002',
'Hubbard, L. Ron (La Fayette Ron), 1911-1986',
'Fleischman, Sid, 1920-2010',
'Hoffman, Alice',
'Greenaway, Kate, 1846-1901',
'Ovid, 43 BC-17 AD or 18 AD',
'Lowry, Lois',
'Sachar, Louis, 1954-',
'L''Amour, Louis, 1908-1988',
'Collins, Billy',
'Groom, Winston, 1944-',
'Morris, William, 1834-1896',
'O''Connor, Flannery.',
'DiCamillo, Kate',
'Bellamy, Edward, 1850-1898',
'Frost, Robert, 1874-1963',
'Campbell, Joseph, 1904-1987',
'Williams, Tennessee, 1911-1983',
'Jong, Erica',
'Süskind, Patrick',
'O''Hara, Frank, 1926-1966',
'Gorky, Maksim, 1868-1936',
'Vargas Llosa, Mario, 1936-',
'Marvell, Andrew, 1621-1678',
'Gogolʹ, Nikolaĭ Vasilʹevich, 1809-1852',
'Jakes, John, 1932-'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;