/*
Jeremy Goldstein
Minuteman Library Network
use to gather bibs where a library owns multiple circulating copies of a title.
And recent circ suggests that some copies could be weeded
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
AND item.item_status_code NOT IN ('o','w') 
AND item.location_code ~ '^ntn'



group by 1, 2
having count(item.id) > 1
AND (SUM(item.year_to_date_checkout_total) + sum(item.last_year_to_date_checkout_total))::NUMERIC/count(item.id) < 2
order BY 6,3 DESC
;