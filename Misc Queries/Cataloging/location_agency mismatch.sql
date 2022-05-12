/*
Jeremy Goldstein
Minuteman Library Network

Identifies items where the location and agency do not match and the owning library may not be able to correct the record themselves
This report is specific to Minuteman
*/
SELECT * FROM(
SELECT
rm.record_type_code||rm.record_num||'a' AS item_number,
CASE
WHEN ip.barcode LIKE '32211%' THEN 'Acton'
WHEN ip.barcode LIKE '34860%' THEN 'Arlington'
WHEN ip.barcode LIKE '30308%' THEN 'Ashland'
WHEN ip.barcode LIKE '34861%' THEN 'Bedford'
WHEN ip.barcode LIKE '34862%' THEN 'Belmont'
WHEN ip.barcode LIKE '31712%' THEN 'Brookline'
WHEN ip.barcode LIKE '31189%' THEN 'Cambridge'
WHEN ip.barcode LIKE '34863%' THEN 'Concord'
WHEN ip.barcode LIKE '30423%' THEN 'Dean'
WHEN ip.barcode LIKE '36504%' THEN 'Dedham'
WHEN ip.barcode LIKE '36304%' THEN 'Dover'
WHEN ip.barcode LIKE '31213%' THEN 'Framingham Public'
WHEN ip.barcode LIKE '33014%' THEN 'Framingham State'
WHEN ip.barcode LIKE '36998%' THEN 'Franklin'
WHEN ip.barcode LIKE '36287%' THEN 'Holliston'
WHEN ip.barcode LIKE '33015%' THEN 'Lasell'
WHEN ip.barcode LIKE '31619%' THEN 'Lexington'
WHEN ip.barcode LIKE '34864%' THEN 'Lincoln'
WHEN ip.barcode LIKE '36294%' THEN 'Mass Bay'
WHEN ip.barcode LIKE '35957%' THEN 'Maynard'
WHEN ip.barcode LIKE '31848%' THEN 'Medfield'
WHEN ip.barcode LIKE '34865%' THEN 'Medford'
WHEN ip.barcode LIKE '31852%' THEN 'Medway'
WHEN ip.barcode LIKE '36216%' THEN 'Millis'
WHEN ip.barcode LIKE '30022%' THEN 'Mount Ida'
WHEN ip.barcode LIKE '33016%' THEN 'Natick'
WHEN ip.barcode LIKE '33017%' THEN 'Needham'
WHEN ip.barcode LIKE '31323%' THEN 'Newton'
WHEN ip.barcode LIKE '32405%' THEN 'Norwood'
WHEN ip.barcode LIKE '32101%' THEN 'Olin'
WHEN ip.barcode LIKE '31911%' THEN 'Pine Manor'
WHEN ip.barcode LIKE '31927%' THEN 'Regis'
WHEN ip.barcode LIKE '38106%' THEN 'Sherborn'
WHEN ip.barcode LIKE '31155%' THEN 'Somerville'
WHEN ip.barcode LIKE '32051%' THEN 'Stow'
WHEN ip.barcode LIKE '34866%' THEN 'Sudbury'
WHEN ip.barcode LIKE '34867%' THEN 'Waltham'
WHEN ip.barcode LIKE '34868%' THEN 'Watertown'
WHEN ip.barcode LIKE '34869%' THEN 'Wayland'
WHEN ip.barcode LIKE '34870%' THEN 'Wellesley'
WHEN ip.barcode LIKE '34871%' THEN 'Weston'
WHEN ip.barcode LIKE '33018%' THEN 'Westwood'
WHEN ip.barcode LIKE '34872%' THEN 'Winchester'
WHEN ip.barcode LIKE '31906%' THEN 'Woburn'
ELSE 'Unknown'
END AS barcode,
i.location_code,
a.name AS agency,
rm.creation_date_gmt::DATE AS creation_date,
rm.record_last_updated_gmt::DATE AS last_update

FROM
sierra_view.item_record i
JOIN
sierra_view.agency_property_myuser a
ON
i.agency_code_num = a.code
JOIN
sierra_view.location_myuser l
ON
i.location_code = l.code
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.bib_record_item_record_link bi
ON
i.id = bi.item_record_id
JOIN 
sierra_view.bib_record_property bib
ON
bi.bib_record_id = bib.bib_record_id
--AND bib.best_title_norm !~ '^xample'
WHERE
LOWER(a.name) != 
CASE
	WHEN l.code ~ '^dea' THEN 'dean'
	WHEN l.code ~ '^las' THEN 'lasell'
	WHEN l.code ~ '^pmc' THEN 'pine manor'
	WHEN l.code ~ '^reg' THEN 'regis college'	
	ELSE LOWER(SPLIT_PART(l.name,'/',1))
END
AND SUBSTRING(i.location_code FROM 1 FOR 3) NOT IN ('int','knp','hpl','trn')
) innerquery
ORDER BY barcode, creation_date
