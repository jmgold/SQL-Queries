select *
from sierra_view.circ_trans
join
sierra_view.patron_view
on
circ_trans.patron_record_id = patron_view.id
where
patron_view.record_num = ''