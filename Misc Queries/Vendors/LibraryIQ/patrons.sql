SELECT
rmp.record_type_code||rmp.record_num AS "UserID",
p.expiration_date_gmt::DATE AS "ExpirationDate",
p.ptype_code AS "Patron Branch",
--missing YTDYearCount and PreviousYearCount
p.checkout_total + p.renewal_total AS "LifetimeCount",
p.activity_gmt::DATE AS "LastActivityDate",
--missing LastCheckoutDate,
rmp.creation_date_gmt::DATE AS "RegistrationDate",
--clean up address data
a.addr1 AS "StreetOne",
a.addr2 AS "AddressLn2",
a.city AS "AddressCity",
a.region AS "AddressState",
a.postal_code AS "AddressZip"

FROM
sierra_view.patron_record p
JOIN
sierra_view.record_metadata rmp
ON
p.id = rmp.id
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id AND a.patron_record_address_type_id = 1

--use filter for delta file
WHERE rmp.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'