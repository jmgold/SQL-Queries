/*
Jeremy Goldstein
Minuteman Library Network
Using the reading history table query finds the titles that have been checked out the most
by patrons who have checked out a specified title
Plug in the record number of the title you want results for in both where clauses
*/

--Finds all patron ids who have the specified title in their reading history, for use in the main query
WITH patron_list AS(
SELECT
r.patron_record_metadata_id

FROM
sierra_view.reading_history r 
JOIN
sierra_view.record_metadata rm
ON
r.bib_record_metadata_id = rm.id 

--Using the Fifth Season as an example
WHERE rm.record_num = '3272328'
)

SELECT
rm.record_type_code||rm.record_num||'a' AS bnumber
,bp.best_title
,bp.best_author
,COUNT(DISTINCT r.patron_record_metadata_id)

FROM
sierra_view.reading_history r
JOIN
sierra_view.bib_record b
ON
r.bib_record_metadata_id = b.id
JOIN
sierra_view.record_metadata rm
ON
b.id = rm.id
JOIN
sierra_view.bib_record_property bp
ON
b.id = bp.bib_record_id
JOIN
patron_list p
ON
r.patron_record_metadata_id = p.patron_record_metadata_id
--filter out the title you want read alikes for
WHERE rm.record_num != '3272328'

GROUP BY 1,2,3

ORDER BY 4 DESC
LIMIT 100