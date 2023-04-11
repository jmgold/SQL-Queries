/*
Jeremy Goldstein
Minuteman Library Network

Identifies locations with print collections in key languagues
provides item counts as a crosstab report
*/

SELECT
l.name AS Location,
COUNT(i.id) FILTER(WHERE b.language_code = 'chi') AS Chinese,
COUNT(i.id) FILTER(WHERE b.language_code = 'spa') AS Spanish,
COUNT(i.id) FILTER(WHERE b.language_code = 'rus') AS Russian,
COUNT(i.id) FILTER(WHERE b.language_code = 'fre') AS French,
COUNT(i.id) FILTER(WHERE b.language_code = 'ger') AS German,
COUNT(i.id) FILTER(WHERE b.language_code = 'ita') AS Italian,
COUNT(i.id) FILTER(WHERE b.language_code = 'heb') AS Hebrew,
COUNT(i.id) FILTER(WHERE b.language_code = 'por') AS Portuguese,
COUNT(i.id) FILTER(WHERE b.language_code = 'jpn') AS Japanese,
COUNT(i.id) FILTER(WHERE b.language_code = 'kor') AS Korean,
COUNT(i.id) FILTER(WHERE b.language_code = 'hin') AS Hindi,
COUNT(i.id) FILTER(WHERE b.language_code = 'ara') AS Arabic,
COUNT(i.id) FILTER(WHERE b.language_code = 'per') AS Persian,
COUNT(i.id) FILTER(WHERE b.language_code = 'pol') AS Polish,
COUNT(i.id) FILTER(WHERE b.language_code = 'guj') AS Gujarati,
COUNT(i.id) FILTER(WHERE b.language_code = 'tur') AS Turkish,
COUNT(i.id) FILTER(WHERE b.language_code = 'arm') AS Armenian,
COUNT(i.id) FILTER(WHERE b.language_code = 'yid') AS Yiddish,
COUNT(i.id) FILTER(WHERE b.language_code = 'ben') AS Bengali,
COUNT(i.id) FILTER(WHERE b.language_code = 'tam') AS Tamil,
COUNT(i.id) FILTER(WHERE b.language_code = 'hat') AS Hatian_Creole,
COUNT(i.id) FILTER(WHERE b.language_code = 'mar') AS Marathi,
COUNT(i.id) FILTER(WHERE b.language_code = 'tel') AS Telugu

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(i.location_code,1,3) = l.code AND l.code NOT IN ('int', 'hpl', 'knp', 'mls', 'trn', 'cmc')

WHERE b.bcode2 IN ('a','2','3')
GROUP BY 1
ORDER BY 1