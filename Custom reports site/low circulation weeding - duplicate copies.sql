/*
Jeremy Goldstein
Minuteman Library Network

use to gather bibs where a library owns multiple circulating copies of a title.
and recent circ suggests that some copies could be weeded

Passed variables for owning location, item statuses to exclude, copies greater than x and turnover less than y
*/

SELECT 
id2reckey(b.bib_record_id)||'a' as "record_num",
b.best_title,
count(item.id) as "item_count",
sum(item.last_year_to_date_checkout_total) as "last_ytd_checkouts",
SUM(item.year_to_date_checkout_total) AS "ytd_checkouts",
ROUND((SUM(item.year_to_date_checkout_total) + sum(item.last_year_to_date_checkout_total))::NUMERIC/count(item.id),2) AS turnover
from 
sierra_view.bib_record_property as b
JOIN
sierra_view.bib_record bib
ON
b.bib_record_id = bib.id
AND bib.bcode1 = 'm'
join
sierra_view.bib_record_item_record_link as link
on
b.bib_record_id = link.bib_record_id
join
sierra_view.item_view as item
on
item.id = link.item_record_id
AND item.item_status_code NOT IN ({{Item_Status_Codes}}) 
AND item.location_code ~ {{Location}}



group by 1, 2
having count(item.id) > {{Item_Count}}
AND (SUM(item.year_to_date_checkout_total) + sum(item.last_year_to_date_checkout_total))::NUMERIC/count(item.id) < {{Turnover}}
order BY 6,3 DESC
;