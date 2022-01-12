SELECT 
t.transaction_gmt::DATE AS checkout_date,
t.loanrule_code_num,
t.ptype_code,
l.code AS ptype_location_code

FROM
sierra_view.circ_trans t
JOIN
sierra_view.ptype_property_myuser p
ON
t.ptype_code = p.value::VARCHAR
JOIN
sierra_view.location_myuser l
ON
SPLIT_PART(REPLACE(UPPER(p.name),'.',''),' ',1) = SPLIT_PART(REPLACE(l.name,'FRAMINGHAM STATE','FRAM'),' ',1)
AND LENGTH(l.code) = 3

WHERE t.op_code = 'o'
ORDER BY 1,3