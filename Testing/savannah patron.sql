SELECT
  pv.record_num AS PatronId,
  pv.barcode,
  f.first_name AS FIRSTNAME,
  f.last_name AS LASTNAME,
  pv.birth_date_gmt AS BIRTHDATE,
  pv.home_library_code AS HOMELIBR,
  a.addr1 AS ADDRESS1,
  a.addr2 AS ADDRESS2,
  a.city AS CITY,
  a.region AS STATE,
  a.postal_code AS ZIP,
  (SELECT m.creation_date_gmt FROM sierra_view.record_metadata m
  WHERE m.id = pv.id) AS CreationDate,
  pv.expiration_date_gmt AS ExpirationDate,
  pv.activity_gmt AS CIRCACTIVE,
  pv.ptype_code AS PTYPE,
  (SELECT e.field_content FROM sierra_view.varfield_view e
  WHERE pv.id = e.record_id
  AND e.occ_num = 0
  AND e.record_type_code = 'p'
  AND e.varfield_type_code = 'z'
) AS Email,
  pv.owed_amt AS MONEYOWED,
  'p' || pv.record_num AS PNUM,
  EXTRACT(YEAR FROM pv.birth_date_gmt) AS BIRTHYEAR
FROM sierra_view.patron_view pv
LEFT OUTER JOIN sierra_view.patron_record_fullname f
  ON pv.id = f.patron_record_id
LEFT OUTER JOIN sierra_view.patron_record_address a
  ON pv.id = a.patron_record_id
  AND a.patron_record_address_type_id = '1'
WHERE pv.ptype_code = '29'