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
REGEXP_REPLACE(b.best_author,'\.$','') IN ('Greene, Graham, 1904-1991','Wolfe, Thomas, 1900-1938','Herriot, James','Vidal, Gore, 1925-2012','Runyon, Damon, 1880-1946','Collins, Jackie','Rice, Anne, 1941-','Tyson, Neil deGrasse','Savage, Dan','Keneally, Thomas','Herbert, Frank','Stine, R. L','Pinter, Harold, 1930-2008','Leonard, Elmore, 1925-2013','Cummings, E. E. (Edward Estlin), 1894-1962','Virgil','Wodehouse, P. G. (Pelham Grenville), 1881-1975','Calvino, Italo','Gay, Roxane','Wilde, Oscar, 1854-1900','O''Neill, Eugene, 1888-1953','Grass, Günter, 1927-2015','West, Nathanael, 1903-1940','Miller, Arthur, 1915-2005','Wasserstein, Wendy','McMillan, Terry','Le Carré, John, 1931-','Rimbaud, Arthur, 1854-1891','Buchwald, Art','Pinsky, Robert','Coleridge, Samuel Taylor, 1772-1834','Le Guin, Ursula K., 1929-2018','Fisher, Carrie','Lessing, Doris, 1919-2013','Crichton, Michael, 1942-2008','Anderson, Laurie Halse','Burroughs, Augusten','Tyler, Anne','Smith, Zadie','Thomas, Dylan, 1914-1953','Conroy, Pat','Plath, Sylvia','Waugh, Evelyn, 1903-1966','Child, Lee','Pound, Ezra, 1885-1972','Keats, John, 1795-1821','Francis, Dick','O''Brien, Tim, 1946-','Toffler, Alvin','Finder, Joseph','Pekar, Harvey','Roberts, Nora','Puzo, Mario, 1920-1999','Lewis, Michael (Michael M.)','Jordan, Robert, 1948-2007','Rule, Ann','Donoghue, Emma, 1969-','Butcher, Jim, 1971-','Stephenson, Neal','Orlean, Susan')
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;