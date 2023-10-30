/*
Jeremy Goldstein
Minuteman Library Network

Pulls vendor records set to be used with edifact ordering
and lists the account and note2 fields for a quick review of the setup across libraries.
*/
SELECT
v.accounting_unit_code_num,
v.code,
vname.field_content AS vendor_name,
note2.field_content AS note2,
acct.field_content AS account

FROM
sierra_view.vendor_record v
JOIN
sierra_view.varfield note2
ON
v.id = note2.record_id AND note2.varfield_type_code = 'm'
JOIN
sierra_view.varfield acct
ON
v.id = acct.record_id AND acct.varfield_type_code = 'l'
JOIN
sierra_view.varfield vname
ON
v.id = vname.record_id AND vname.varfield_type_code = 't'

WHERE v.vcode3 = 'd'
ORDER BY 2,1