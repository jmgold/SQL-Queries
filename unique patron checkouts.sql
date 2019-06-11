/*
Jeremy Goldstein
Minuteman Library Network

Monthly checkouts with unique patron count
*/

SELECT
COUNT(*) AS total_checkouts,
COUNT(DISTINCT(patron_record_id)) AS total_unique_patrons,
ROUND(COUNT(*)::NUMERIC/COUNT(DISTINCT(patron_record_id)),2) AS avg_checkouts_per_patron
FROM
sierra_view.circ_trans
where
op_code = 'o'
and
transaction_gmt > NOW()::DATE - INTERVAL '1 month'
and stat_group_code_num in ('330','331')