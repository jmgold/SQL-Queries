SELECT
CASE
WHEN p.barcode LIKE '22211%' THEN 'Acton'
WHEN p.barcode LIKE '24860%' THEN 'Arlington'
WHEN p.barcode LIKE '20308%' THEN 'Ashland'
WHEN p.barcode LIKE '24861%' THEN 'Bedford'
WHEN p.barcode LIKE '24862%' THEN 'Belmont'
WHEN p.barcode LIKE '21712%' THEN 'Brookline'
WHEN p.barcode LIKE '21189%' THEN 'Cambridge'
WHEN p.barcode LIKE '24863%' THEN 'Concord'
WHEN p.barcode LIKE '20423%' THEN 'Dean'
WHEN p.barcode LIKE '26504%' THEN 'Dedham'
WHEN p.barcode LIKE '26304%' THEN 'Dover'
WHEN p.barcode LIKE '21213%' THEN 'Framingham Public'
WHEN p.barcode LIKE '23014%' THEN 'Framingham State'
WHEN p.barcode LIKE '26998%' THEN 'Franklin'
WHEN p.barcode LIKE '26287%' THEN 'Holliston'
WHEN p.barcode LIKE '23015%' THEN 'Lasell'
WHEN p.barcode LIKE '21619%' THEN 'Lexington'
WHEN p.barcode LIKE '24864%' THEN 'Lincoln'
WHEN p.barcode LIKE '26294%' THEN 'Mass Bay'
WHEN p.barcode LIKE '25957%' THEN 'Maynard'
WHEN p.barcode LIKE '21848%' THEN 'Medfield'
WHEN p.barcode LIKE '24865%' THEN 'Medford'
WHEN p.barcode LIKE '21852%' THEN 'Medway'
WHEN p.barcode LIKE '26216%' THEN 'Millis'
WHEN p.barcode LIKE '20022%' THEN 'Mount Ida'
WHEN p.barcode LIKE '23016%' THEN 'Natick'
WHEN p.barcode LIKE '23017%' THEN 'Needham'
WHEN p.barcode LIKE '21323%' THEN 'Newton'
WHEN p.barcode LIKE '22405%' THEN 'Norwood'
WHEN p.barcode LIKE '22101%' THEN 'Olin'
WHEN p.barcode LIKE '21911%' THEN 'Pine Manor'
WHEN p.barcode LIKE '21927%' THEN 'Regis'
WHEN p.barcode LIKE '28106%' THEN 'Sherborn'
WHEN p.barcode LIKE '21155%' THEN 'Somerville'
WHEN p.barcode LIKE '22051%' THEN 'Stow'
WHEN p.barcode LIKE '24866%' THEN 'Sudbury'
WHEN p.barcode LIKE '24867%' THEN 'Waltham'
WHEN p.barcode LIKE '24868%' THEN 'Watertown'
WHEN p.barcode LIKE '24869%' THEN 'Wayland'
WHEN p.barcode LIKE '24870%' THEN 'Wellesley'
WHEN p.barcode LIKE '24871%' THEN 'Weston'
WHEN p.barcode LIKE '23018%' THEN 'Westwood'
WHEN p.barcode LIKE '24872%' THEN 'Winchester'
WHEN p.barcode LIKE '21906%' THEN 'Woburn'
ELSE 'Unknown'
END AS Library,
COUNT(p.id) AS Total_Patrons,
COUNT(p.id) FILTER(WHERE p.activity_gmt > (localtimestamp - INTERVAL '1 year')) AS Active_Patrons,
COUNT(p.id) FILTER(WHERE m.creation_date_gmt > (localtimestamp - INTERVAL '1 year')) AS New_Patrons
FROM
sierra_view.patron_view p
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num and m.record_type_code = 'p'
GROUP BY 1
ORDER BY 1
