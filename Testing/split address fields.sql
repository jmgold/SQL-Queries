SELECT
id2reckey(a.patron_record_id)||'a' AS pnumber,
a.addr1
FROM
sierra_view.patron_record_address a
WHERE a.addr1 ~ '\s[A-Za-z]{2}\s?\d{5}'