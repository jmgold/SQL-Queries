SELECT
id2reckey(a.patron_record_id)||'a' AS pnumber,
p.*,
a.addr1,
a.city,
a.region,
a.postal_code

FROM sierra_view.patron_record_address a
JOIN sierra_view.patron_record p
ON a.patron_record_id = p.id
WHERE LOWER(a.city) ~ 'stoneham'
OR LOWER(a.region) ~ 'stoneham' 
OR LOWER(a.addr1) ~ 'stoneham\s?ma'
OR LOWER(a.addr2) ~ 'stoneham\s?ma'
OR LOWER(a.addr3) ~ 'stoneham\s?ma'