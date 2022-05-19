/*
Jeremy Goldstein
Minuteman Library Network
extracts checkin box data from serial holding records
*/

SELECT
b.best_title,
cb.enum_level_a,
cb.enum_level_b,
-- parses chronology level fields to format cover date in a more readable form
CASE
	WHEN cb.chron_level_i ~ '^\d{4}$' AND cb.chron_level_j ~ '^\d{2}$'AND cb.chron_level_k ~ '^\d{2}$' THEN cb.chron_level_j||'-'||cb.chron_level_k||'-'||cb.chron_level_i
	WHEN cb.chron_level_i ~ '^\d{4}$' AND cb.chron_level_j ~ '^\d{2}$'AND cb.chron_level_k IS NULL THEN cb.chron_level_j||'-'||cb.chron_level_i
	WHEN (cb.chron_level_k IS NULL OR cb.chron_level_k = '0-') AND cb.chron_level_i ~ '^\d{4}$' AND cb.chron_level_j ~ '^\d{2}(\/|\-)\d{2}$'
		THEN LEFT(cb.chron_level_j,2)||'-'||cb.chron_level_i||' / '||RIGHT(cb.chron_level_j,2)||'-'||cb.chron_level_i
	WHEN (cb.chron_level_k IS NULL OR cb.chron_level_k = '0-') AND cb.chron_level_i ~ '^\d{4}(\/|\-)\d{4}$' AND  cb.chron_level_j ~ '^\d{2}(\/|\-)\d{2}$'
		THEN LEFT(cb.chron_level_j,2)||'-'||LEFT(cb.chron_level_i,4)||' / '||RIGHT(cb.chron_level_j,2)||'-'||RIGHT(cb.chron_level_i,4)
	WHEN cb.chron_level_i ~ '^\d{4}$' AND cb.chron_level_j ~ '^\d{2}(\/|\-)\d{2}$' AND cb.chron_level_k ~ '^\d{1,2}(\/|\-)\d{1,2}$'
		THEN LEFT(cb.chron_level_j,2)||'-'||SUBSTRING(cb.chron_level_k,'^[0-9]{1,2}')||'-'||cb.chron_level_i||' / '||RIGHT(cb.chron_level_j,2)||'-'||SUBSTRING(cb.chron_level_k,'\d{1,2}$')||'-'||cb.chron_level_i
	WHEN cb.chron_level_i ~ '^\d{4}$' AND cb.chron_level_j ~ '^\d{2}$' AND cb.chron_level_k ~ '^\d{1,2}(\/|\-)\d{1,2}$'
		THEN cb.chron_level_j||'-'||SUBSTRING(cb.chron_level_k,'^\d{1,2}')||'-'||cb.chron_level_i||' / '||cb.chron_level_j||'-'||SUBSTRING(cb.chron_level_k,'\d{1,2}$')||'-'||cb.chron_level_i
	WHEN cb.chron_level_i ~ '^\d{4}(\/|\-)\d{4}$' AND cb.chron_level_j ~ '^\d{2}(\/|\-)\d{2}$' AND cb.chron_level_k ~ '^\d{1,2}(\/|\-)\d{1,2}$'
		THEN LEFT(cb.chron_level_j,2)||'-'||SUBSTRING(cb.chron_level_k,'^\d{1,2}')||'-'||LEFT(cb.chron_level_i,4)||' / '||RIGHT(cb.chron_level_j,2)||'-'||SUBSTRING(cb.chron_level_k,'\d{1,2}$')||'-'||RIGHT(cb.chron_level_i,4)
	ELSE cb.chron_level_i||' '||cb.chron_level_j||' '||cb.chron_level_k
END AS cover_date,
cb.chron_level_i_trans_date||'-'||cb.chron_level_j_trans_date||'-'||cb.chron_level_k_trans_date AS transaction_date

FROM
sierra_view.bib_record_property b
JOIN
sierra_view.bib_record_holding_record_link l
ON 
b.bib_record_id = l.bib_record_id
JOIN
sierra_view.holding_record h
ON
--limit to a given accounting unit
l.holding_record_id = h.id AND h.accounting_unit_code_num = '29'
JOIN
sierra_view.holding_record_card c
ON 
h.id = c.holding_record_id
JOIN
sierra_view.holding_record_cardlink cl
ON
c.id = cl.holding_record_card_id
JOIN
sierra_view.holding_record_box cb
ON
cl.id = cb.holding_record_cardlink_id

--Limited to expected titles, change status code to search for different boxes
WHERE
cb.box_status_code = 'E'
ORDER BY 1,2
