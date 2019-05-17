/*Call # title look up
Shared by Ray Voelker over Sierra-ILS Slack on 5/17/19
*/

SELECT
r.record_type_code || r.record_num || 'a' as bib_record_num,
i.location_code,
i.item_status_code,
i.is_suppressed,
i.checkout_total,
(
    SELECT
    c.due_gmt
    FROM
    sierra_view.checkout as c
    WHERE
    c.item_record_id = p.item_record_id
    
) as due_gmt,
p.call_number_norm,
pb.best_author,
pb.best_title,
p.barcode,
p.*,
pb.*


FROM
sierra_view.item_record_property as p

JOIN
sierra_view.bib_record_item_record_link as l
ON
  l.item_record_id = p.item_record_id

JOIN
sierra_view.item_record as i
ON
  i.record_id = p.item_record_id


JOIN
sierra_view.record_metadata as r
ON
  r.id = l.bib_record_id

JOIN
sierra_view.bib_record_property as pb
ON
  pb.bib_record_id = l.bib_record_id

WHERE
p.call_number_norm ~* '^306.76.*'

ORDER BY
i.location_code,
p.call_number_norm,
pb.best_author_norm,
pb.best_title_norm