SELECT
count(distinct(patron_record_id))
FROM
sierra_view.circ_trans
where
op_code = 'o'
and
transaction_gmt between '2018-03-28' and '2018-03-30'
and stat_group_code_num in ('330','331')
