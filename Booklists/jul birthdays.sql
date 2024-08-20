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
'Thoreau, Henry David, 1817-1862',
'Novak, B. J., 1979-',
'Thompson, Hunter S',
'Hawthorne, Nathaniel, 1804-1864',
'Williamson, Marianne, 1952-',
'Gilbert, Elizabeth, 1969-',
'Heinlein, Robert A. ‪(Robert Anson)‬, 1907-1988',
'Ferriss, Timothy',
'Sacks, Oliver, 1933-2015',
'Huffington, Arianna Stassinopoulos, 1950-',
'Wells-Barnett, Ida B., 1862-1931',
'Connelly, Michael, 1956-',
'Chandler, Raymond, 1888-1959',
'Lahiri, Jhumpa',
'Hinton, S. E',
'Gygax, Gary',
'Cussler, Clive',
'White, E. B. ‪(Elwyn Brooks)‬, 1899-1985',
'Koontz, Dean R. ‪(Dean Ray)‬, 1945-',
'Reichs, Kathy',
'Bloom, Harold',
'McCullough, David G',
'Clare, Cassandra',
'Godin, Seth',
'Straczynski, J. Michael, 1954-',
'Kushner, Tony',
'Barry, Dave',
'VanderMeer, Jeff',
'Lazarus, Emma, 1849-1887',
'Gardner, Erle Stanley, 1889-1970',
'Miller, Madeline',
'Robbins, Tom, 1932-',
'Eddings, David',
'Schwab, Victoria',
'Chandra, Vikram',
'Russo, Richard, 1949-',
'Palacio, R. J',
'Hilderbrand, Elin',
'Machado, Carmen Maria',
'Selby, Hubert, Jr., 1928-2004',
'Lu, Marie, 1984-',
'Quindlen, Anna',
'Cook, Glen',
'Sutherland, Tui, 1978-',
'Kornfield, Jack, 1945-',
'Westlake, Donald E',
'Morgenstern, Erin',
'Lindsay, Jeffry P',
'Gardner, John, 1933-1982',
'Cain, James M. (James Mallahan), 1892-1977',
'Fisher, M. F. K. (Mary Frances Kennedy), 1908-1992',
'Coonts, Stephen, 1946-',
'Russell, Karen, 1981-',
'Himes, Chester B., 1909-1984',
'Scottoline, Lisa',
'Kellerman, Faye',
'Lawhead, Stephen R., 1950-',
'Woods, Sherryl',
'Hocking, Amanda',
'DeConnick, Kelly Sue',
'Link, Kelly',
'Clark, Carol Higgins',
'May, Julian',
'Elliott, Kate, 1958-',
'Dickey, Eric Jerome',
'Lafferty, Mur',
'Coleman, Loren',
'Langan, John (John Paul)'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;