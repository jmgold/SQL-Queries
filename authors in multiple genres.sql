--Finds authors for who a library has classified their works in multiple genres (based on Scat code)
--Currently broken but can use the logic to get two lists that can be duplicate checked in excel.
select bp.best_author_norm
from
sierra_view.bib_record_property bp
WHERE EXISTS (
   SELECT l.id   
   FROM  
      sierra_view.bib_record_item_record_link l
      JOIN   sierra_view.item_view i ON l.item_record_id = i.id
   WHERE  bp.bib_record_id = l.bib_record_id AND i.icode1 = '1' AND location_code LIKE 'lin%'
   )
   and EXISTS (
   SELECT l.id   
   FROM  
      sierra_view.bib_record_item_record_link l
      JOIN   sierra_view.item_view i ON l.item_record_id = i.id
   WHERE  bp.bib_record_id = l.bib_record_id AND i.icode1 = '2' AND location_code LIKE 'lin%'
   )
/*join
sierra_view.bib_record_item_record_link bi
on
bp.bib_record_id=bi.bib_record_id
right join
sierra_view.item_view i1
on
bi.bib_record_id=i1.id and i1.location_code like 'lin%' and i1.icode1 ='1'
right join
sierra_view.item_view i2
on
bi.bib_record_id=i2.id and i2.location_code like 'lin%' and i2.icode1 ='21'
group by 1
having count(i1.id) > '0' or count(i2.id) > '0'*/
