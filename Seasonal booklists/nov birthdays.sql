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
'Crane, Stephen, 1871-1900',
'Shepard, Sam, 1943-2017',
'Cunningham, Michael, 1952-',
'Camus, Albert, 1913-1960',
'Stoker, Bram, 1847-1912',
'Mitchell, Margaret, 1900-1949',
'Ishiguro, Kazuo, 1954-',
'Sexton, Anne, 1928-1974',
'Griffin, W. E. B',
'Gaiman, Neil',
'Vonnegut, Kurt',
'Kidder, Tracy',
'Stevenson, Robert Louis, 1850-1894',
'O''Rourke, P. J',
'Achebe, Chinua',
'Atwood, Margaret, 1939-',
'DeLillo, Don',
'Voltaire, 1694-1778',
'Eliot, George, 1819-1880',
'Burnett, Frances Hodgson, 1849-1924',
'Ionesco, Eugène',
'Agee, James, 1909-1955',
'Sheehy, Gail',
'Blake, William, 1757-1827',
'Brown, Rita Mae',
'Alcott, Louisa May, 1832-1888',
'Lewis, C. S. (Clive Staples), 1898-1963',
'L''Engle, Madeleine',
'Swift, Jonathan, 1667-1745',
'Twain, Mark, 1835-1910',
'Mamet, David,',
'Lafferty, R. A',
'Fast, Howard, 1914-2003',
'Shawn, Wallace',
'Lindgren, Astrid, 1907-2002',
'Saramago, José',
'Bunyan, John, 1628-1688',
'Claremont, Chris, 1950-',
'Sagan, Carl, 1934-1996',
'Harris, Charlaine',
'Hoffman, Abbie',
'Ziglar, Zig',
'Ditko, Steve',
'Singer, Isaac Bashevis, 1904-1991',
'Gawande, Atul',
'Anderson, Poul, 1926-2001',
'Friedman, Kinky',
'Bujold, Lois McMaster',
'Brubaker, Ed',
'Pohl, Frederik',
'Brust, Steven, 1955-',
'Black, Holly',
'Beah, Ishmael, 1980-',
'TenNapel, Doug',
'Smith, Martin Cruz, 1942-',
'Hickman, Tracy',
'Rucka, Greg',
'Thomas, Roy, 1940-',
'Frazier, Charles, 1950-',
'McKinley, Robin',
'Giffen, Keith',
'Swanwick, Michael',
'Ford, Jeffrey, 1955-'

)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;
