/*
Jeremy Goldstein
Minuteman Library Network

fine details for patrons owing 100
created for Andy Gardner at Libraries Online, Inc
*/

/*
The temp table might be an excessive approach but makes the two portions of the query a bit easier to follow
and you could cut and paste the query within the temp table to produce it's own report with just the patron details
*/

DROP TABLE IF EXISTS patrons;
CREATE TEMP TABLE patrons AS

SELECT
--id here is just used to allow the join in the main query below
p.id,
n.last_name||', '||n.first_name||' '||n.middle_name AS name,
p.barcode,
--cast as money to make the formatting just a bit nicer
p.owed_amt::MONEY

FROM
sierra_view.patron_view p
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id

--limit to only patrons owing at least 100
WHERE p.owed_amt >= 100
;

SELECT
p.name,
p.barcode,
p.owed_amt,
f.title,
i.call_number_norm AS call_number,
f.item_charge_amt::MONEY,
f.processing_fee_amt::MONEY,
f.billing_fee_amt::MONEY,
--labels for the charge codes in the fine table do not exist so I'm using a case statement to plug them in according to the sierradna documentation
CASE
WHEN f.charge_code = '1' THEN 'manual charge'
WHEN f.charge_code = '2' THEN 'overdue'
WHEN f.charge_code = '3' THEN 'replacement'
WHEN f.charge_code = '4' THEN 'adjustment (overduex)'
WHEN f.charge_code = '5' THEN 'lost book'
WHEN f.charge_code = '6' THEN 'overdue renewed'
WHEN f.charge_code = '7' THEN 'rental'
WHEN f.charge_code = '8' THEN 'rental adjustment (rentalx)'
WHEN f.charge_code = '9' THEN 'debit'
WHEN f.charge_code = 'a' THEN 'notice'
WHEN f.charge_code = 'b' THEN 'credit card'
WHEN f.charge_code = 'p' THEN 'program'
END AS charge_type,
--casting as date to cut off the timestamp portion of the assessed_gmt field
f.assessed_gmt::DATE AS assessed_date


FROM
--pulling from the temp table created above
patrons p
JOIN
sierra_view.fine f
ON
p.id = f.patron_record_id
JOIN
sierra_view.item_record_property i
ON
f.item_record_metadata_id = i.item_record_id