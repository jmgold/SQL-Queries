--code taken from example on Sierra mailing list

( SELECT 'bib' as hold_type, bib_num, max(title) as title, bool_or(is_available) as is_available, null as
   max_holds_any_item, hold_count_bib as total_holds_all_items, hold_latest_bib, count(birl.item_record_id) as 
   items_on_bib,
CASE WHEN count(birl.item_record_id)>0 THEN (hold_count_bib::float / count(birl.item_record_id)) ELSE
   hold_count_bib::float END as hold_queue_index
FROM (
SELECT b.id as bib_id, b.record_num as bib_num, max(b.title) as title, bool_or(b.is_available_at_library) as
     is_available, count(h.id) as hold_count_bib, date(max(h.placed_gmt)) as hold_latest_bib
FROM sierra_view.bib_view b
JOIN sierra_view.hold h ON h.record_id = b.id and b.bcode3!='n'
GROUP BY b.id, b.record_num
HAVING count(h.id)>=3
) bibholds
LEFT JOIN sierra_view.bib_record_item_record_link birl ON bibholds.bib_id = birl.item_record_id
GROUP BY bib_id, bib_num, hold_latest_bib, hold_count_bib
)

UNION SELECT
'item' as hold_type, bhc.bib_num, title, is_available, bhc.max_holds_any_item, bhc.total_holds_all_items,
   bhc. hold_latest_bib, bhc.items_on_bib, bhc. hold_queue_index
FROM (
SELECT bib_id, bib_num, max(title) as title, bool_or(is_available) as is_available, max(max_holds_any_item)
     max_holds_any_item, max(total_holds_all_items) total_holds_all_items, max( hold_latest_bib) hold_latest_bib, 
     count(birl2.id) as items_on_bib, ( max(max_holds_any_item)::float + ( max(total_holds_all_items)::float / 
     count(birl2.id)) ) / 2 as hold_queue_index
FROM (
SELECT bib_id, bib_num, max(title) as title, bool_or(is_available) as is_available, max(hold_count_item)
     max_holds_any_item, sum(hold_count_item) total_holds_all_items, date(max(hold_latest_item)) 
     hold_latest_bib
FROM (SELECT b.id as bib_id, b.record_num as bib_num, max(b.title) as title, bool_or(b.is_available_at_library) as
     is_available, i.id as item_id, count(h.id) as hold_count_item, max(h.placed_gmt) as hold_latest_item
FROM sierra_view.item_view i
JOIN sierra_view.hold h ON h.record_id = i.id and i.item_status_code!='m'
JOIN sierra_view.bib_record_item_record_link birl
ON i.id = birl.item_record_id
JOIN sierra_view.bib_view b
ON b.id = birl.bib_record_id and b.bcode3!='n'
GROUP BY b.id, b.record_num, i.id
) bih
GROUP BY bib_id, bib_num
) bh
JOIN sierra_view.bib_record_item_record_link birl2 ON bib_id = birl2.bib_record_id
GROUP BY bib_id, bib_num, max_holds_any_item
HAVING max_holds_any_item>=3
) bhc
ORDER BY hold_queue_index desc, hold_latest_bib asc