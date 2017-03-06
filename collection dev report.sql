--rough equivalent to collection development report found in web management reports, organized by scat code and only utilizing item record data

Select
icode1 as SCAT,
count (*) as Item_Total,
round(SUM(price),2) as price_total,
SUM(checkout_total) as checkout_total,
SUM(renewal_total) as renewal_total,
(SUM(checkout_total) + SUM(renewal_total)) as circ_total,
round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2))/cast(count (*) as numeric (12,2)), 2) as avg_circ,
round(round(SUM(price),2)/NULLIF((SUM(checkout_total) + SUM(renewal_total)),0),2) as price_per_circ
from
sierra_view.item_view
Where
agency_code_num = '2' and
--comment out date limit if unwanted
cast(record_creation_date_gmt as date) between '2015-07-01' and '2016-06-30'
group by 1
order by 1, 2, 3, 4, 5, 6, 7, 8;
