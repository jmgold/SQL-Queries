/*
Query from Ray Voelker
Shared over Sierra_ils slack 3/18/20
*/

WITH on_holdshelf AS (

SELECT
h.id,
h.patron_record_id,
h.record_id,
(
	select
	r.record_type_code || r.record_num || 'a' as record_num
	from
	sierra_view.record_metadata as r
	where
	r.id = h.record_id
	-- this is a sanity check mostly
	and r.record_type_code = 'i'
	and r.campus_code = ''
	limit 1
) as item_record_num,
h.expires_gmt,
h.pickup_location_code

FROM
sierra_view.hold AS h


WHERE
h.status IN ('i', 'j', 'b')

)

SELECT
hs.patron_record_id,
hs.pickup_location_code,
COUNT(hs.record_id) as count_items,
(
	SELECT
-- 	string_agg(this_hs.record_id::varchar,',')
	string_agg(this_hs.item_record_num::varchar, ',')
	from
	on_holdshelf as this_hs
	where
	this_hs.patron_record_id = hs.patron_record_id
	-- since we're gouping by patron_record_id AND pickup_location_code, we need to filter by both
	and this_hs.pickup_location_code = hs.pickup_location_code
) as item_record_num_list,
(
	select
	r.record_type_code || r.record_num || 'a'
	from
	sierra_view.record_metadata as r
	where
	r.id = hs.patron_record_id
	-- this is a sanity check mostly
	and r.record_type_code = 'p'
	and r.campus_code = ''
	limit 1
) as patron_record_num,
(
	SELECT
	string_agg(v.field_content, ',' order by v.occ_num)
	from
	sierra_view.varfield as v
	where
	v.record_id = hs.patron_record_id
	and v.varfield_type_code = 'z'	
) as patron_emails

FROM
on_holdshelf as hs

GROUP BY
hs.patron_record_id,
hs.pickup_location_code

ORDER BY
hs.pickup_location_code,
count_items DESC,
hs.patron_record_id