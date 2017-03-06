SELECT
b.bcode2 AS mat_type,
COUNT(i.id),
SUM(i.checkout_total) AS total_checkout,
SUM(i.renewal_total) AS total_renewal,
(SUM(i.checkout_total)+ SUM(i.renewal_total)) AS total_circ
from
sierra_view.bib_view as b
JOIN sierra_view.bib_record_item_record_link as bi
ON
b.id=bi.bib_record_id
JOIN sierra_view.item_view as i
ON
bi.item_record_id=i.id
--limit to one agency code, should match accounting unit entered in collection dev order report
AND
i.agency_code_num = '2'
WHERE
i.record_creation_date_gmt > '06-30-2014'
group by 1
order by 1
;