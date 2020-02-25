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
'Whitman, Walt, 1819-1892',
'Heller, Joseph',
'Grimes, Martha',
'Machiavelli, Niccolò, 1469-1527',
'Smith, Dodie, 1896-1990',
'Kinsella, Thomas',
'Oz, Amos',
'Guterson, David',
'Kierkegaard, Søren, 1813-1855',
'Marx, Karl, 1818-1883',
'Hume, David, 1711-1776',
'Browning, Robert, 1812-1889',
'MacLeish, Archibald, 1892-1982',
'Wilson, Edmund, 1895-1972',
'Meriwether, Louise',
'Pynchon, Thomas',
'Benchley, Peter',
'Barrie, J. M. (James Matthew), 1860-1937',
'Adams, Richard, 1920-2016',
'Bennett, Alan, 1934-',
'Kaufman, Bel',
'Cooney, Caroline B',
'Lear, Edward, 1812-1888',
'Du Maurier, Daphne, 1907-1989',
'Pascal, Francine',
'Chatwin, Bruce, 1940-1989',
'Maupin, Armistead',
'Baum, L. Frank (Lyman Frank), 1856-1919',
'Bulgakov, Mikhail, 1891-1940',
'Zindel, Paul',
'Hillenbrand, Laura',
'Terkel, Studs, 1912-2008',
'Coville, Bruce',
'Reyes, Alfonso, 1889-1959',
'Paulsen, Gary',
'Høeg, Peter, 1957-',
'Russell, Bertrand, 1872-1970',
'Duane, Diane',
'Erdman, Paul, 1932-2007',
'Ephron, Nora',
'Balzac, Honoré de, 1799-1850',
'Ogilvie, Elisabeth, 1917-2006',
'Dante Alighieri, 1265-1321',
'Pope, Alexander, 1688-1744',
'Robbins, Harold, 1916-1997',
'Creeley, Robert, 1926-2005',
'Doyle, Arthur Conan, 1859-1930',
'Fuller, Margaret, 1810-1850',
'O''Dell, Scott, 1898-1989',
'Brown, Margaret Wise, 1910-1952',
'Chabon, Michael',
'Emerson, Ralph Waldo, 1803-1882',
'Roethke, Theodore, 1908-1963',
'Ludlum, Robert, 1927-2001',
'Kinsella, W. P',
'Carver, Raymond, 1938-1988',
'Kincaid, Jamaica',
'Hammett, Dashiell, 1894-1961',
'Carson, Rachel, 1907-1964',
'Cheever, John',
'Wouk, Herman, 1915-2019',
'Hillerman, Tony',
'Barth, John, 1930-',
'Morris, Edmund',
'Fleming, Ian, 1908-1964',
'Binchy, Maeve, 1940-2012',
'Chesterton, G. K. (Gilbert Keith), 1874-1936',
'White, T. H. (Terence Hanbury), 1906-1964'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;
