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
'McCullough, Colleen, 1937-2015',
'Hardy, Thomas, 1840-1928',
'Ginsberg, Allen, 1926-1997',
'McMurtry, Larry',
'Hill, Joe',
'Ryan, Cornelius',
'Brown, Christy, 1932-1981',
'Follett, Ken',
'Pushkin, Aleksandr Sergeevich, 1799-1837',
'Mann, Thomas, 1875-1955',
'Rylant, Cynthia',
'Brooks, Gwendolyn, 1917-2000',
'Pamuk, Orhan, 1952-',
'Erdrich, Louise',
'Paretsky, Sara',
'Cornwell, Patricia Daniels',
'Bellow, Saul',
'Sendak, Maurice',
'Beaton, M C',
'Jonson, Ben, 1573?-1637',
'Yeats, W B ‪(William Butler)‬, 1865-1939',
'Buck, Pearl S ‪(Pearl Sydenstricker)‬, 1892-1973',
'Sayers, Dorothy L ‪(Dorothy Leigh)‬, 1893-1957',
'Giovanni, Nikki',
'Stowe, Harriet Beecher, 1811-1896',
'Bartlett, John, 1820-1905',
'Wideman, John Edgar',
'Jacques, Brian',
'Boccaccio, Giovanni, 1313-1375',
'Segal, Erich, 1937-2010',
'Oates, Joyce Carol, 1938-',
'Godwin, Gail',
'Van Allsburg, Chris',
'Pascal, Blaise, 1623-1662',
'Rushdie, Salman',
'Hellman, Lillian, 1905-1984',
'Muldoon, Paul',
'Sartre, Jean-Paul, 1905-1980',
'McEwan, Ian',
'Haggard, H Rider ‪(Henry Rider)‬, 1856-1925',
'Butler, Octavia E',
'Brown, Dan, 1964-',
'Bierce, Ambrose, 1842-1914?',
'Orwell, George, 1903-1950',
'Martel, Yann',
'Keller, Helen, 1880-1968',
'Helprin, Mark',
'Saint-Exupéry, Antoine de, 1900-1944'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;
