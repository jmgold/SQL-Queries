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
'Steinbeck, John, 1902-1968',
'Wallace, David Foster',
'Stein, Gertrude, 1874-1946',
'Auden, W. H. (Wystan Hugh), 1907-1973',
'Auster, Paul, 1947-',
'Kinney, Jeff',
'Willems, Mo',
'Lethem, Jonathan',
'Powers, Tim, 1952-',
'Reed, Ishmael, 1938-',
'Bridwell, Norman',
'Bowles, Jane, 1917-1973',
'Alexander, Meena, 1951-',
'Fowler, Karen Joy',
'Macdonald, James, 1954-',
'Hughes, Langston, 1902-1967',
'Hoban, Russell',
'Wilder, Laura Ingalls, 1867-1957',
'Dickens, Charles, 1812-1870',
'Blume, Judy',
'Voigt, Cynthia',
'Longfellow, Henry Wadsworth, 1807-1882',
'Douglass, Frederick, 1818-1895',
'Morrison, Toni',
'Hughes, Langston, 1902-1967',
'Paine, Thomas, 1737-1809',
'Handler, Chelsea',
'Groening, Matt',
'Grisham, John',
'Burroughs, William S., 1914-1997',
'Walker, Alice, 1944-',
'Palahniuk, Chuck',
'Kurzweil, Ray',
'Garten, Ina',
'Pollan, Michael',
'Flynn, Gillian, 1971-',
'Foer, Jonathan Safran, 1977-',
'Lewis, Sinclair, 1885-1951',
'Chopin, Kate, 1850-1904',
'Sheldon, Sidney',
'Bernstein, Carl, 1944-',
'Handler, Daniel',
'Tan, Amy',
'Matheson, Richard, 1926-2013',
'Michener, James A. (James Albert), 1907-1997',
'Hofstadter, Douglas R., 1945-',
'Sandford, John, 1944 February 23-',
'Truman, Margaret, 1924-2008',
'Rowell, Rainbow',
'Bishop, Elizabeth, 1911-1979',
'Millay, Edna St. Vincent, 1892-1950',
'Gorey, Edward, 1925-2000',
'Bombeck, Erma',
'Sholem Aleichem, 1859-1916',
'See, Lisa',
'Talese, Gay',
'Hamilton, Laurell K',
'Auel, Jean M',
'Cabot, Meg',
'George, Elizabeth, 1949-',
'Pelecanos, George P',
'Woodson, Jacqueline',
'Briggs, Patricia',
'Kowal, Mary Robinette, 1969-',
'Jin, Ha, 1956-',
'Yolen, Jane',
'Russ, Joanna, 1937-2011',
'ohnson, Maureen, 1973-'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;