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
--AND SUBSTRING(i.location_code,4,1) NOT IN ('j','y')
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
--Acton/Arlington
'Creeley, Robert, 1926-2005',
--Belmont
'Junger, Sebastian',
'Perrotta, Tom, 1961-',
--Brookline
'Barnes, Linda',
'Bellow, Saul',
'Hodgman, John',
'Lowell, Amy, 1874-1925',
'Smith, Sarah, 1947-',
'Wolf, Gary K',
--Cambridge
'Chen, Joyce',
'Child, Julia',
'Cummings, E. E. (Edward Estlin), 1894-1962',
'Glück, Louise, 1943-',
'Hoffman, Alice',
'Longfellow, Henry Wadsworth, 1807-1882',
'Lowry, Lois',
'McCaffrey, Anne',
'Parker, Robert B., 1932-2010',
'Preston, Douglas J',
'Rey, H. A. (Hans Augusto), 1898-1977',
'Skinner, B. F. (Burrhus Frederic), 1904-1990',
'Fuller, Margaret, 1810-1850',
'Liu, Ken, 1976-',
'Du Bois, W. E. B. (William Edward Burghardt), 1868-1963',
--Concord
'Alcott, Louisa May, 1832-1888',
'Alcott, Amos Bronson, 1799-1888',
'Emerson, Ralph Waldo, 1803-1882',
'Cornwell, Patricia Daniels',
'Goodwin, Doris Kearns',
'Hawthorne, Nathaniel, 1804-1864',
'Maguire, Gregory',
'Thoreau, Henry David, 1817-1862',
'Wood, Gordon S',
--Dedham
'Reynolds, Peter H. (Peter Hamilton), 1961-',
'Shreve, Anita',
--Lexington
'Chomsky, Noam',
'Gates, Henry Louis, Jr',
'McCloud, Scott, 1960-',
'Sawyer, Ruth, 1880-1970',
--Lincoln
'Donald, David Herbert, 1920-2009',
--Maynard
'Berry, Julie, 1974-',
--Medford
'Ciardi, John, 1916-1986',
'Theroux, Paul',
--Natick
'Kushner, Harold S',
'Stowe, Harriet Beecher, 1811-1896',
--Needham
'Wyeth, N. C. (Newell Convers), 1882-1945',
--Newton
'Asimov, Isaac, 1920-1992',
'Banks, Russell, 1940-',
'Bulfinch, Thomas, 1796-1867',
'Burr, Ty',
'Diamant, Anita',
'Everett, Bill, 1917-1973',
'Kurzweil, Ray',
'Mamet, David',
'Pinsky, Robert',
'Sexton, Anne, 1928-1974',
--Somerville
'Clement, Hal, 1922-2003',
'Munroe, Randall',
'Moren, Dan',
--Sudbury
'Poundstone, Paula'
--Watertown
--Wellesley
'Bradford, Gamaliel, 1863-1932',
'Chiasson, Dan',
'Kaling, Mindy',
'Plath, Sylvia',
--Winchester
'Reid, Paul, 1949-',
--Waltham
'Brockmann, Suzanne',
'Wright, Franz, 1953-2015',
'Farizan, Sara',
--Woburn
'Bogosian, Eric',
--Weston
--Westwood
'MacMullan, Jackie',
--Wayland
'Child, Lydia Maria, 1802-1880',
'Cooper, Glenn, 1953-'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;