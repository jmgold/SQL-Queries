--http://librarybooklists.org/literarybirths/bmay.htm

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
'Lovecraft, H. P. (Howard Phillips), 1890-1937',
'Parker, Dorothy, 1893-1967',
'Aiken, Conrad, 1889-1973',
'Borges, Jorge Luis, 1899-1986',
'Bradbury, Ray, 1920-2012',
'Melville, Herman, 1819-1891',
'Baldwin, James, 1924-1987',
'Allende, Isabel, 1942-',
'James, P. D',
'Uris, Leon, 1924-2003',
'Shelley, Percy Bysshe, 1792-1822',
'Maupassant, Guy de, 1850-1893',
'Berry, Wendell, 1934-',
'Tennyson, Alfred Tennyson, Baron, 1809-1892',
'Anthony, Piers',
'Keillor, Garrison',
'Beattie, Ann',
'Teasdale, Sara, 1884-1933',
'Keyes, Daniel',
'Kellerman, Jonathan',
'Blyton, Enid',
'Haley, Alex',
'Dubus, Andre, 1936-1999',
'Hamilton, Edith, 1867-1963',
'Goldman, William, 1931-2018',
'Myers, Walter Dean, 1937-2014',
'Scott, Walter, 1771-1832',
'De Quincey, Thomas, 1785-1859',
'Ferber, Edna, 1887-1968',
'Lawrence, T. E. ‪(Thomas Edward)‬, 1888-1935',
'Larsson, Stieg, 1954-2004',
'Heyer, Georgette, 1902-1974',
'Bukowski, Charles',
'Garvey, Marcus, 1887-1940',
'Hawkes, John, 1925-1998',
'Hughes, Ted, 1930-1998',
'Naipaul, V. S. ‪(Vidiadhar Surajprasad)‬, 1932-2018',
'Dryden, John, 1631-1700',
'Nash, Ogden, 1902-1971',
'Kennedy, X. J',
'Stone, Robert, 1937-2015',
'Shepard, Lucius',
'Proulx, Annie',
'Byatt, A. S. (Antonia Susan), 1936-',
'Wright, Charles, 1935-',
'Ehrenreich, Barbara',
'Confucius',
'Dreiser, Theodore, 1871-1945',
'Forester, C. S. ‪(Cecil Scott)‬, 1899-1966',
'Levin, Ira, 1929-2007',
'Goethe, Johann Wolfgang von, 1749-1832',
'Tolstoy, Leo, graf, 1828-1910',
'McIntyre, Vonda N',
'Holmes, Oliver Wendell, 1809-1894',
'Shelley, Mary Wollstonecraft, 1797-1851',
'Lee, Jim, 1964-',
'Larson, Gary',
'Bendis, Brian Michael',
'Dini, Paul',
'Yang, Gene Luen',
'Herriman, George, 1880-1944',
'Azzarello, Brian',
'Kelly, Walt',
'Robbins, Trina',
'Bushmiller, Ernie',
'Clugston-Flores, Chynna'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;