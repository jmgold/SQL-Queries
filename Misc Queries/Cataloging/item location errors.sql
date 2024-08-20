/*
Jeremy Goldstein
Minuteman Library Network
Identifies items that may have fallen out of a libraries scope due to an incorrect location code
Doubles as means to spot items with data errors from inncorectly using a withdrawal macro
*/

SELECT
*
FROM
(
SELECT
ip.barcode,
REPLACE(REPLACE(SPLIT_PART(INITCAP(l.name),'/',1),' University',''),' College','') AS library,
i.location_code,
REPLACE(a.name,' College','') AS agency,
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
	WHEN ip.barcode LIKE '31213%' THEN 'Framingham'
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
END AS barcode_prefix,
--status, icode2 and itype can help to indicate withdrawal errors
i.item_status_code,
i.icode2,
i.itype_code_num,
rm.record_last_updated_gmt::DATE AS last_updated
FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id
JOIN
sierra_view.agency_property_myuser a
ON
i.agency_code_num = a.code AND a.name != 'Other'
JOIN
sierra_view.location_myuser l
ON
SUBSTRING(i.location_code,1,3) = l.code
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
)inner_query

--match cases where the shelf location doesn't match the item's agency or the barcode prefix used by a given library
WHERE library != agency OR (library != barcode_prefix AND barcode_prefix != 'Unknown')