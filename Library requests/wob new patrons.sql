SELECT 
rm.record_type_code||rm.record_num||'a' AS pnumber,
b.index_entry AS barcode,
rm.creation_date_gmt::DATE AS creation_date,
n.first_name,
n.middle_name,
n.last_name,
a.addr1,
a.city,
a.region AS "state",
a.postal_code,
p.home_library_code,
p.expiration_date_gmt::DATE AS expiration_date,
p.pcode1,
p.pcode2,
p.pcode3,
p.pcode4,
p.birth_date_gmt AS birth_date,
p.mblock_code,
p.patron_agency_code_num,
p.checkout_total,
p.renewal_total,
p.checkout_count,
p.claims_returned_total,
p.owed_amt::MONEY AS owed_amt,
p.activity_gmt::DATE AS active_date

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND rm.creation_date_gmt >= '2020-03-01'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
JOIN
sierra_view.phrase_entry b
ON
p.id = b.record_id AND b.varfield_type_code = 'b'

WHERE
p.ptype_code = '41'

ORDER BY 3