select id2reckey(r.bib_record_metadata_id),
b.title,
count (r.bib_record_metadata_id)
from
sierra_view.reading_history r
join
sierra_view.bib_view b
on
r.bib_record_metadata_id = b.id
where
exists (select r.id from sierra_view.reading_history r join sierra_view.bib_view b on r.bib_record_metadata_id = b.id where b.record_num = '3083504')
AND count (r.bib_record_metadata_id) > 400
group by 1, 2
order by 3 desc
;