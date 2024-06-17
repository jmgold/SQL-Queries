/*
Jeremy Goldstein
Minuteman Library NETWORK

Generates patron file for uploading to OrangeBoy's Savanah platform
*/

SELECT
rm.record_num AS PatronId,
b.index_entry AS barcode,
f.first_name AS FIRSTNAME,
f.last_name AS LASTNAME,
p.birth_date_gmt AS BIRTHDATE,
p.home_library_code AS HOMELIBR,
a.addr1 AS ADDRESS1,
a.addr2 AS ADDRESS2,
a.city AS CITY,
a.region AS STATE,
a.postal_code AS ZIP,
rm.creation_date_gmt AS CreationDate,
p.expiration_date_gmt AS ExpirationDate,
p.activity_gmt AS CIRCACTIVE,
p.ptype_code AS PTYPE,
e.field_content AS Email,
p.owed_amt AS MONEYOWED,
rm.record_type_code||rm.record_num AS PNUM,
DATE_PART('year', p.birth_date_gmt) AS BIRTHYEAR

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id AND p.ptype_code IN ('29','129')
JOIN
sierra_view.phrase_entry b
ON
p.id = b.record_id AND b.varfield_type_code = 'b' AND b.occurrence = 0
JOIN
sierra_view.patron_record_fullname f
ON
p.id = f.patron_record_id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
JOIN
sierra_view.varfield e
ON
p.id = e.record_id AND e.varfield_type_code = 'z' AND e.occ_num = 0