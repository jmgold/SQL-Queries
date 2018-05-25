SELECT
min(n.first_name),
min(n.last_name),
min(v.field_content) as email,
p.barcode,
CASE
WHEN p.ptype_code = 5 THEN 'the Belmont Public Library'
WHEN p.ptype_code = 6 THEN 'the Public Library of Brookline'
WHEN p.ptype_code = 7 THEN 'the Cambridge Public Library'
WHEN p.ptype_code = 8 THEN 'the Concord Free Public Library'
WHEN p.ptype_code IN ('10','110') THEN 'the Dedham Public Library'
WHEN p.ptype_code IN ('17', '117') THEN 'the Cary Memorial Library'
WHEN p.ptype_code IN ('29', '129') THEN 'the Newton Free Library'
WHEN p.ptype_code = 31 THEN 'the Somerville Public Library'
WHEN p.ptype_code = 35 THEN 'the Watertown Free Public Library'
WHEN p.ptype_code IN ('37', '137') THEN 'the Wellesley Free Library'
WHEN p.ptype_code = 1 THEN 'the Acton Public Library'
WHEN p.ptype_code = 2 THEN 'the Robbins Library'
WHEN p.ptype_code = 3 THEN 'the Ashland Public Library'
WHEN p.ptype_code = 4 THEN 'the Bedford Free Public Library'
WHEN p.ptype_code = 11 THEN 'the Dover Town Library'
WHEN p.ptype_code = 12 THEN 'the Framingham Public Library'
WHEN p.ptype_code = 14 THEN 'the Franklin Public Library'
WHEN p.ptype_code IN ('15', '115') THEN 'the Holliston Public Library'
WHEN p.ptype_code = 18 THEN 'the Lincoln Public Library'
WHEN p.ptype_code IN ('20', '120') THEN 'the Maynard Public Library'
WHEN p.ptype_code IN ('21', '121') THEN 'the Medfield Public Library'
WHEN p.ptype_code IN ('22', '122') THEN 'the Medford Public Library'
WHEN p.ptype_code = 23 THEN 'the Medway Public Library'
WHEN p.ptype_code = 24 THEN 'the Millis Public Library'
WHEN (p.ptype_code = 26 AND p.home_library_code != 'na2z') THEN 'the Morse Institute Library'
WHEN (p.ptype_code = 26 AND p.home_library_code = 'na2z') THEN 'the Bacon Free Library'
WHEN p.ptype_code = 27 THEN 'the Needham Free Public Library'
WHEN p.ptype_code IN ('30', '130') THEN 'the Morrill Memorial Library'
WHEN p.ptype_code = 32 THEN 'the Randall Library'
WHEN p.ptype_code IN ('33', '133') THEN 'the Goodnow Library'
WHEN p.ptype_code = 34 THEN 'the Waltham Public Library'
WHEN p.ptype_code = 36 THEN 'the Wayland Free Library'
WHEN p.ptype_code = 38 THEN 'the Weston Public Library'
WHEN p.ptype_code = 39 THEN 'the Westwood Public Library'
WHEN p.ptype_code = 40 THEN 'the Winchester Public Library'
WHEN p.ptype_code = 41 THEN 'the Woburn Public Library'
WHEN p.ptype_code = 46 THEN 'the Sherborn Public Library'
Else 'the Minuteman Library Network'
END AS library,
CASE
WHEN p.ptype_code = 5 THEN 'the Belmont Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 6 THEN 'the Public Library of Brookline</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 7 THEN 'the Cambridge Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 8 THEN 'the Concord Free Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('10','110') THEN 'the Dedham Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('17', '117') THEN 'the Cary Memorial Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('29', '129') THEN 'the Newton Free Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 31 THEN 'the Somerville Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 35 THEN 'the Watertown Free Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('37', '137') THEN 'the Wellesley Free Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 1 THEN 'the Acton Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 2 THEN 'the Robbins Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 3 THEN 'the Ashland Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 4 THEN 'the Bedford Free Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 11 THEN 'the Dover Town Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 12 THEN 'the Framingham Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 14 THEN 'the Franklin Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('15', '115') THEN 'the Holliston Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 18 THEN 'the Lincoln Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('20', '120') THEN 'the Maynard Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('21', '121') THEN 'the Medfield Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('22', '122') THEN 'the Medford Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 23 THEN 'the Medway Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 24 THEN 'the Millis Public Library</a>, a member of the Minuteman Library Network'
WHEN (p.ptype_code = 26 AND p.home_library_code != 'na2z') THEN 'the Morse Institute Library</a>, a member of the Minuteman Library Network'
WHEN (p.ptype_code = 26 AND p.home_library_code = 'na2z') THEN 'the Bacon Free Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 27 THEN 'the Needham Free Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('30', '130') THEN 'the Morrill Memorial Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 32 THEN 'the Randall Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code IN ('33', '133') THEN 'the Goodnow Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 34 THEN 'the Waltham Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 36 THEN 'the Wayland Free Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 38 THEN 'the Weston Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 39 THEN 'the Westwood Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 40 THEN 'the Winchester Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 41 THEN 'the Woburn Public Library</a>, a member of the Minuteman Library Network'
WHEN p.ptype_code = 46 THEN 'the Sherborn Public Library</a>, a member of the Minuteman Library Network'
Else 'the Minuteman Library Network</a>'
END AS library_2,
CASE
WHEN p.ptype_code = 5 THEN 'https://belmontpubliclibrary.net/'
WHEN p.ptype_code = 6 THEN 'https://www.brooklinelibrary.org/'
WHEN p.ptype_code = 7 THEN 'https://www.cambridgema.gov/cpl'
WHEN p.ptype_code = 8 THEN 'https://concordlibrary.org/'
WHEN p.ptype_code IN ('10','110') THEN 'http://library.dedham-ma.gov/'
WHEN p.ptype_code IN ('17', '117') THEN 'https://www.carylibrary.org/'
WHEN p.ptype_code IN ('29', '129') THEN 'http://newtonfreelibrary.net/'
WHEN p.ptype_code = 31 THEN 'http://www.somervillepubliclibrary.org/'
WHEN p.ptype_code = 35 THEN 'http://www.watertownlib.org/'
WHEN p.ptype_code IN ('37', '137') THEN 'https://www.wellesleyfreelibrary.org/'
WHEN p.ptype_code = 1 THEN 'http://www.actonmemoriallibrary.org/'
WHEN p.ptype_code = 2 THEN 'https://www.robbinslibrary.org/'
WHEN p.ptype_code = 3 THEN 'http://www.ashlandmass.com/184/Ashland-Public-Library'
WHEN p.ptype_code = 4 THEN 'http://www.bedfordlibrary.net/'
WHEN p.ptype_code = 11 THEN 'http://dovertownlibrary.org/'
WHEN p.ptype_code = 12 THEN 'https://framinghamlibrary.org/'
WHEN p.ptype_code = 14 THEN 'http://www.franklinma.gov/franklin-public-library'
WHEN p.ptype_code IN ('15', '115') THEN 'http://www.hollistonlibrary.org/'
WHEN p.ptype_code = 18 THEN 'http://www.lincolnpl.org/'
WHEN p.ptype_code IN ('20', '120') THEN 'http://www.maynardpubliclibrary.org/'
WHEN p.ptype_code IN ('21', '121') THEN 'http://www.medfieldpubliclibrary.org/'
WHEN p.ptype_code IN ('22', '122') THEN 'http://www.medfordlibrary.org/'
WHEN p.ptype_code = 23 THEN 'http://medwaylib.org/'
WHEN p.ptype_code = 24 THEN 'http://www.millislibrary.org/'
WHEN (p.ptype_code = 26 AND p.home_library_code != 'na2z') THEN 'https://morseinstitute.org/'
WHEN (p.ptype_code = 26 AND p.home_library_code = 'na2z') THEN 'http://baconfreelibrary.org/'
WHEN p.ptype_code = 27 THEN 'http://www.needhamma.gov/index.aspx?nid=3031'
WHEN p.ptype_code IN ('30', '130') THEN 'http://www.norwoodlibrary.org/'
WHEN p.ptype_code = 32 THEN 'http://www.randalllibrarystow.org/'
WHEN p.ptype_code IN ('33', '133') THEN 'https://goodnowlibrary.org/'
WHEN p.ptype_code = 34 THEN 'http://waltham.lib.ma.us/'
WHEN p.ptype_code = 36 THEN 'https://waylandlibrary.org/'
WHEN p.ptype_code = 38 THEN 'http://www.westonlibrary.org/'
WHEN p.ptype_code = 39 THEN 'http://www.westwoodlibrary.org/'
WHEN p.ptype_code = 40 THEN 'http://www.winpublib.org/'
WHEN p.ptype_code = 41 THEN 'https://woburnpubliclibrary.org/'
WHEN p.ptype_code = 46 THEN 'https://sherbornlibrary.org/'
ELSE 'http://www.mln.lib.ma.us/info/index.htm/'
END AS url
FROM
sierra_view.patron_view as p
JOIN		
sierra_view.varfield v		
ON		
p.id = v.record_id and v.varfield_type_code = 'z'
JOIN
sierra_view.patron_record_fullname n
ON
p.id = n.patron_record_id
JOIN
sierra_view.record_metadata m
ON
p.record_num = m.record_num AND m.record_type_code = 'p'
WHERE
m.creation_date_gmt > (localtimestamp - interval '1 day')

--Opt out list, libraries and ptypes
AND p.ptype_code NOT IN('7', '29', '129', '9', '159', '13', '163', '204', '200', '16', '116', '166', '19', '169', '25', '175', '201', '206', '199', '207', '44', '194', '45', '195', '202', '203', '255', '254', '205', '28', '178')
group by 4, 5, 6, 7
