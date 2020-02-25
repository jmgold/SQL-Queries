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
'Shakespeare, William, 1564-1616',
'Warner, Gertrude Chandler, 1890-1979',
'McCaffrey, Anne',
'Delany, Samuel R',
'Andersen, H. C. (Hans Christian), 1805-1875',
'Zola, Émile, 1840-1902',
'Herbert, George, 1593-1633',
'Irving, Washington, 1783-1859',
'Goodall, Jane, 1934-',
'Angelou, Maya',
'Washington, Booker T., 1856-1915',
'Eberhart, Richard, 1904-2005',
'Bloch, Robert, 1917-1994',
'Wordsworth, William, 1770-1850',
'Barthelme, Donald',
'Kingsolver, Barbara',
'Baudelaire, Charles, 1821-1867',
'Halberstam, David',
'Theroux, Paul',
'Cleary, Beverly',
'Ayckbourn, Alan, 1939-',
'Clancy, Tom, 1947-2013',
'Turow, Scott',
'Beckett, Samuel, 1906-1989',
'Welty, Eudora, 1909-2001',
'Heaney, Seamus, 1939-2013',
'James, Henry, 1843-1916',
'France, Anatole, 1844-1924',
'Amis, Kingsley',
'Wilder, Thornton, 1897-1975',
'Brontë, Charlotte, 1816-1855',
'Fielding, Henry, 1707-1754',
'Glück, Louise, 1943-',
'Marsh, Ngaio, 1895-1982',
'Nabokov, Vladimir Vladimirovich, 1899-1977',
'Donleavy, J. P. (James Patrick), 1926-2017',
'Defoe, Daniel, 1661?-1731',
'Trollope, Anthony, 1815-1882',
'Goudge, Elizabeth, 1900-1984',
'Warren, Robert Penn, 1905-1989',
'Grafton, Sue',
'Hume, David, 1711-1776',
'Malamud, Bernard',
'Wilson, August',
'Lee, Harper',
'Duncan, Lois, 1934-2016',
'Pratchett, Terry',
'Toklas, Alice B',
'Dillard, Annie'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;