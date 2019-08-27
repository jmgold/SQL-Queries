/*
Jeremy Goldstein
Minuteman Library Newtork
Used to generate booklist at www.minlib.net
*/
SELECT *
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
b.best_author IN ('Burroughs, Edgar Rice, 1875-1950.','Wright, Richard, 1908-1960.','Tolstoy, Leo, graf, 1828-1910.','Oliver, Mary, 1935-','Henry, O., 1862-1910.','Lawrence, D. H. (David Herbert), 1885-1930.','Ondaatje, Michael, 1943-','Mencken, H. L. (Henry Louis), 1880-1956.','Dahl, Roald.','Cooper, James Fenimore, 1789-1851.','Christie, Agatha, 1890-1976.','Knowles, John, 1926-2001','Gates Jr, Henry Louis.','Williams, William Carlos, 1883-1963.','Kesey, Ken.','Golding, William, 1911-1993.','Sinclair, Upton, 1878-1968.','Wells, H. G. (Herbert George), 1866-1946.','King, Stephen, 1947-','Fitzgerald, F. Scott (Francis Scott), 1896-1940.','Faulkner, William, 1897-1962.','Eliot, T. S. (Thomas Stearns), 1888-1965.','Smiley, Jane.','Capote, Truman, 1924-1984.','Cervantes Saavedra, Miguel de, 1547-1616,','Martin, George R. R.','Wiesel, Elie, 1928-2016.','Parker, Robert B., 1932-2010.','Egan, Jennifer.','Sebold, Alice.','Thompson, Jim, 1906-1977.','David, Peter (Peter Allen)','Deveraux, Jude.','Brooks, Geraldine.','Goodwin, Archie.','Busiek, Kurt.','Stern, Roger.')
--AND b.publish_year >= '2010'
GROUP BY 1,2,3
) a
ORDER BY RANDOM()
LIMIT 50;