SELECT
ip.name as itype,
s.location_code as transaction_loc,
c.loanrule_code_num as loanrule_num,
AGE(mode() WITHIN GROUP (ORDER BY due_date_gmt::date),mode() WITHIN GROUP (ORDER BY transaction_gmt::date)) AS loan_period
FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser ip
ON
i.itype_code_num = ip.code
JOIN
sierra_view.statistic_group_myuser s
ON
c.stat_group_code_num = s.code
WHERE
c.op_code = 'o'
GROUP BY 1,2,3
ORDER BY 1,2,3