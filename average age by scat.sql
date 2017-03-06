----average age of all items by scat
Select
i.icode1 as SCAT,
round(AVG(bp.publish_year), 0) as avg_age
from
sierra_view.item_view as i
JOIN sierra_view.bib_record_item_record_link as bi
ON
i.id=bi.item_record_id
JOIN sierra_view.bib_view as b
ON
bi.bib_record_id=b.id
JOIN sierra_view.bib_record_property as bp
ON
b.id=bp.bib_record_id
Where
i.agency_code_num = '11'
group by 1
order by 1;