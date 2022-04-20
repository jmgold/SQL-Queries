select 
rm.record_type_code ||rm.record_num ||'a' as bnumber,
b.best_title as title,
b.best_author as author,
COALESCE(s.content,'') AS edition,
STRING_AGG(DISTINCT REPLACE(ip.call_number,'|a',''),'; ') AS call_numbers,
COUNT(i.id) AS total_copies,
SUM(i.checkout_total) as total_checkouts,
SUM(i.year_to_date_checkout_total) AS total_checkouts_ytd,
SUM(i.renewal_total) AS total_renewals

from 
sierra_view.bib_record_property b
join
sierra_view.record_metadata rm 
on
b.bib_record_id = rm.id
join
sierra_view.bib_record_item_record_link l 
on
b.bib_record_id = l.bib_record_id 
join 
sierra_view.item_record i
on
l.item_record_id  = i.id and i.icode1 = '119' and i.location_code ~ '^ntn'
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
LEFT JOIN
sierra_view.subfield s
ON
b.bib_record_id = s.record_id AND s.marc_tag = '250' AND s.tag = 'a'

group by 1,2,3,4