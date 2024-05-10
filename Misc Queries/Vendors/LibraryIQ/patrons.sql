/*
Jeremy Goldstein
Minuteman Library Network
*/

SELECT
  rmp.record_type_code||rmp.record_num AS PatronNum,
  TO_CHAR(p.expiration_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "ExpireDate",
  p.ptype_code AS "PatronType",
  pt.name AS "PatronTypeName",
  l.code AS "PatronBranch",
  --missing YTDYearCount and PreviousYearCount
  p.checkout_total + p.renewal_total AS "TotalCheckout",
  TO_CHAR(p.activity_gmt,'YYYY-MM-DD HH24:MI:SS') AS "ActivityDate",
  TO_CHAR(
    (SELECT
    MAX(rh.checkout_gmt)
	 FROM sierra_view.reading_history rh 
	 WHERE rh.patron_record_metadata_id=rmp.id)
  ,'YYYY-MM-DD HH24:MI:SS') AS "LastCheckout",
  TO_CHAR(rmp.creation_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CreateDate",
  a.addr1 AS "AddressLn1",
  a.addr2 AS "AddressLn2",
  COALESCE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(a.city),'\d','','g'),'\s(ma|MA)$','','i'),'') AS "AddressCity",
  COALESCE(CASE
    WHEN a.region = '' AND (LOWER(a.city) ~ '\sma$' OR p.pcode3 BETWEEN '1' AND '200') THEN 'MA'
	 ELSE a.region
  END,'') AS "AddressState",
  a.postal_code AS "AddressZip"

FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser pt
ON
p.ptype_code = pt.value
LEFT JOIN
sierra_view.location_myuser l
ON
UPPER(REGEXP_REPLACE(REGEXP_REPLACE(pt.name,'Fram State|Fram. State','Framingham STATE'),' (eCard|Exempt|Faculty|Student|Teacher|Homebound|CrossReg Student)','')) = REGEXP_REPLACE(l.name,' (COLLEGE|UNIVERSITY)','')
JOIN
sierra_view.record_metadata rmp
ON
p.id = rmp.id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id AND a.patron_record_address_type_id = 1

--use filter for delta file
WHERE 
CASE
  WHEN EXTRACT(DAY FROM CURRENT_DATE) = 1 THEN rmp.record_last_updated_gmt::DATE < CURRENT_DATE
  ELSE rmp.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'
END