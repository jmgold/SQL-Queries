/*
Jeremy Goldstein
Minuteman Library Network
Provides stats on how many brief records were fully upgraded in the past week vs marked as a temp record
Temp records are checked again in a few months and originally catalogged if needed at that time
*/
SELECT
	CASE
		WHEN bcode3 = 't' THEN 'TEMP'
		ELSE 'FULL'
	END,
	COUNT(id),
	ROUND(CAST(COUNT(id) AS numeric (12,2)) / (SELECT CAST(COUNT(id) AS numeric (12,2)) FROM sierra_view.bib_record WHERE cataloging_date_gmt IS NOT NULL AND cataloging_date_gmt::DATE > (CURRENT_DATE - INTERVAL '7 days') AND bcode3 IN ('t','-')),2)*100 AS Percentage

FROM
	sierra_view.bib_record
	
WHERE
	cataloging_date_gmt IS NOT NULL 
	AND cataloging_date_gmt::DATE > (CURRENT_DATE - INTERVAL '7 days') 
	AND bcode3 IN ('t','-')
	
GROUP BY 1