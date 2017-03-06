--counts number of items using each scat code within a specified agency

Select
icode1 as SCAT,
count (*)
from
sierra_view.item_view
Where
agency_code_num = '1'
group by 1
order by 1;
