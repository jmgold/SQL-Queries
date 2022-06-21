/*
Query shared by Ray Voelker and Josh Klingbeil over Slack 5/20/22
Identifies items that have been renewed by a patron multiple times based on circ_trans data
*/
WITH renewal_data AS (
SELECT
item_record_id
,patron_record_id
,ptype_code
,transaction_gmt,
COUNT(*) OVER(
	PARTITION BY
	item_record_id
	,patron_record_id
) AS renewal_count
	
FROM 
sierra_view.circ_trans t

WHERE
op_code = 'r'
GROUP BY 1,2,3,4
)

SELECT
rmi.record_type_code||rmi.record_num||'a' AS inumber
,rmp.record_type_code||rmp.record_num||'a' AS pnumber
,r.ptype_code
,r.renewal_count
,ARRAY_AGG(r.transaction_gmt ORDER BY r.transaction_gmt DESC) renewal_dates

FROM
renewal_data r
JOIN
sierra_view.record_metadata rmi
ON
r.item_record_id = rmi.id
JOIN
sierra_view.record_metadata rmp
ON
r.patron_record_id = rmp.id

WHERE r.renewal_count > 1
GROUP BY 1,2,3,4
ORDER BY r.renewal_count DESC