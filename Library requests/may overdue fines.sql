SELECT
DISTINCT id2reckey(i.id)||'a'
FROM
sierra_view.fine f
JOIN
sierra_view.item_record i
ON
f.item_record_metadata_id = i.id
--AND i.location_code ~ '^may'
AND f.charge_code IN ('2','4','6')
WHERE
f.loanrule_code_num BETWEEN '200' AND '210' OR f.loanrule_code_num BETWEEN '663' AND '671'