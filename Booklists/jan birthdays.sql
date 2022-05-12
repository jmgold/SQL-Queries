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
'Poe, Edgar Allan, 1809-1849',
'Franklin, Benjamin, 1706-1790',
'Graham, Heather',
'Miller, Frank, 1957-',
'Salinger, J. D. (Jerome David), 1919-2010',
'Gibran, Kahlil, 1883-1931',
'Silver, Nate, 1978-',
'Mailer, Norman',
'Wharton, Edith, 1862-1937',
'Sontag, Susan, 1933-2004',
'Zakaria, Fareed',
'Wilson, Robert Anton, 1932-2007',
'Salvatore, R. A., 1959-',
'Rooney, Andrew A',
'Hurston, Zora Neale',
'oward, Robert E. (Robert Ervin), 1906-1936',
'Abbey, Edward, 1927-1989',
'Gabaldon, Diana',
'Sandburg, Carl, 1878-1967',
'Brooks, Terry',
'Coben, Harlan, 1962-',
'Slaughter, Karin, 1971-',
'Doctorow, E. L., 1931-2015',
'Highsmith, Patricia, 1921-1995',
'Johns, Geoff, 1973-',
'Dowd, Maureen',
'Loeb, Jeph',
'Goodwin, Doris Kearns',
'Ambrose, Stephen E',
'Lucado, Max',
'Woods, Stuart',
'Blatty, William Peter',
'Grahame-Smith, Seth',
'Junger, Sebastian',
'Alexander, Lloyd',
'Farmer, Philip José',
'McInerney, Jay',
'Mosley, Walter',
'Silverberg, Robert',
'Wambaugh, Joseph',
'Benford, Gregory, 1941-',
'Krantz, Judith',
'Lippman, Laura, 1959-',
'Alger, Horatio, Jr., 1832-1899',
'Kieth, Sam',
'Feiffer, Jules',
'McGuire, Seanan',
'Gerrold, David, 1944-',
'Barry, Lynda, 1956-',
'Nocenti, Ann',
'Aaron, Jason',
'Steele, Allen M',
'Lescroart, John T',
'Bellairs, John',
'Naylor, Gloria',
'Martinez, A. Lee',
'Grippando, James, 1958-',
'Kress, Nancy',
'Philbrick, Nathaniel',
'Goldsmith, Olivia',
'Conroy, Frank, 1936-2005',
'Siddons, Anne Rivers',
'Pearl, Nancy',
'Due, Tananarive, 1966-'
)
--AND b.publish_year >= '2010'

GROUP BY 1,2,3
HAVING COUNT(i.id) > 3
) a
ORDER BY 3, RANDOM()
;