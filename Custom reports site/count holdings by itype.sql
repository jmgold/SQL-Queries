/*
Jeremy Goldstein
Minuteman Library Network

Holdings Profile gathered for annual reports
location code by itype

Passed variables for owning location and item statuses to exclude
*/

WITH call_number_mod AS(
SELECT
i.item_record_id,
CASE
	WHEN b.best_author_norm != '' AND i.call_number_norm ~ ('^.+'||SPLIT_PART(b.best_author_norm, ' ',1)) THEN SPLIT_PART(TRIM(BOTH FROM i.call_number_norm),SPLIT_PART(b.best_author_norm, ' ',1),1)
	WHEN i.call_number_norm ~ ('^.+'||SPLIT_PART(REGEXP_REPLACE(b.best_title_norm,'\*|\+|\?|\{',''), ' ',1)) THEN SPLIT_PART(TRIM(BOTH FROM i.call_number_norm),SPLIT_PART(b.best_title_norm, ' ',1),1)
	--only digits are a year at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{3}[12]', '') !~ '\d' THEN TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\s?\d{4}$',''))
   --only digits are a volume,copy,series, etc number at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM i.call_number_norm)), '^[0-9]{1,3}\s?\.?(v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob)', '') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM REGEXP_REPLACE(i.call_number_norm,'\(|\)|\[|\]','','gi'))),'^[0-9]{1,3}\s?\.?(v|lov|c|#|s|nosaes|aes|tes|res|seires|p|tp|trap|loc|noitcelloc|b|kb|koob)',''))
	ELSE TRIM(BOTH FROM i.call_number_norm)
	END AS call_number_norm

FROM
sierra_view.item_record_property i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
)

SELECT
{{Grouping}},
/*Options are
TRIM(BOTH FROM COALESCE(CASE
   --call number does not exist
	WHEN ic.call_number_norm = '' OR ic.call_number_norm IS NULL THEN 'no call number'
	--biographies
   WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '^(.*biography|.*biog|.*bio)' THEN SUBSTRING(REGEXP_REPLACE(ic.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*biography|.*biog|.*bio)')
	--graphic novels & manga
   WHEN ic.call_number_norm ~ '^(.*graphic|.*manga)' AND ic.call_number_norm !~ '\d' THEN SUBSTRING(REGEXP_REPLACE(ic.call_number_norm,'\(|\)|\[|\]','','gi')FROM '^(.*graphic|.*manga)')
	--call number contains no numbers and a 1 or 2 words
	WHEN ic.call_number_norm !~ '\d' AND (ic.call_number_norm !~ '\s' OR ic.call_number_norm ~ '^([\w\-\.]+\s)[\w\-\.]+$') THEN REGEXP_REPLACE(ic.call_number_norm,'\(|\)|\[|\]','','gi')
	--call number contains no numbers and 3-4 words
	WHEN TRIM(BOTH FROM ic.call_number_norm) !~ '\d' AND TRIM(BOTH FROM ic.call_number_norm) ~ '^([\w\-\.]+\s)([\w\-\.]+\s){0,2}[\w\-\.]+$' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/'']*\s', ''))
	--call number contains no numbers and > 4 words
   WHEN TRIM(BOTH FROM ic.call_number_norm) !~ '\d' THEN SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),' ','1')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),' ','2')||' '||SPLIT_PART(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),' ','3')
   --only digits are a cutter at the end
	WHEN REGEXP_REPLACE(REVERSE(TRIM(BOTH FROM ic.call_number_norm)), '^[a-z]*[0-9]{2,3}[a-z]\s?','') !~ '\d' THEN REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[a-z]*[0-9]{2}[a-z]\s?', ''),'^[\w\-\.'']*\s', ''))
   --contains an LC number in the 1000-9999 range
   WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{4}(\.\d{1,3})?\s?\.?[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]',''),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'000-'||SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}\s?[0-9]')||'999'
	--contains an LC number in the 001-999 range
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '(^|\s)[a-z]{1,3}\s?[0-9]{1,3}(\.\d{1,3})?\s?\.[a-z][0-9]' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[a-z]{1,2}')||'001-999'
   --contains a dewey number
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '[0-9]{3}\.?[0-9]*' THEN SUBSTRING(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'^[a-z\s\[\]\&\-\.\,\(\)]*[0-9]{2}')||'0'
   --PS4
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ 'ps4' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/'']*\s', ''))
	--mp3
	WHEN TRIM(BOTH FROM ic.call_number_norm) ~ 'mp3' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi')),'^[\w\-\.\/'']*\s', ''))
	--leftover number suffixes
   WHEN TRIM(BOTH FROM ic.call_number_norm) ~ '\d' THEN REVERSE(REGEXP_REPLACE(REVERSE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(BOTH FROM ic.call_number_norm),'\(|\)|\[|\]','','gi'),'\d\w*','')),'^[\w\-\.\/'']*\s', ''))
	ELSE 'unknown'
   END, 'unknown')) AS call_number_range
it.name AS itype
ln.name AS language
m.name AS mat_type
i.icode1 AS scat_code
i.location_code AS location
*/

COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 0) AS "0",
--DISTINCT b.id or i.id
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 1) AS "1",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 2) AS "2",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 3) AS "3",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 4) AS "4",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 5) AS "5",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 6) AS "6",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 7) AS "7",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 8) AS "8",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 9) AS "9",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 10) AS "10",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 11) AS "11",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 12) AS "12",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 13) AS "13",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 14) AS "14",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 15) AS "15",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 16) AS "16",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 17) AS "17",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 18) AS "18",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 19) AS "19",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 20) AS "20",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 21) AS "21",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 22) AS "22",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 23) AS "23",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 24) AS "24",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 25) AS "25",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 26) AS "26",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 27) AS "27",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 28) AS "28",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 29) AS "29",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 30) AS "30",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 31) AS "31",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 32) AS "32",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 33) AS "33",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 34) AS "34",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 35) AS "35",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 36) AS "36",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 37) AS "37",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 38) AS "38",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 39) AS "39",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 40) AS "40",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 41) AS "41",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 42) AS "42",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 43) AS "43",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 44) AS "44",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 45) AS "45",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 46) AS "46",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 47) AS "47",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 48) AS "48",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 49) AS "49",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 50) AS "50",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 51) AS "51",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 52) AS "52",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 53) AS "53",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 54) AS "54",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 55) AS "55",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 56) AS "56",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 57) AS "57",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 58) AS "58",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 59) AS "59",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 60) AS "60",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 61) AS "61",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 62) AS "62",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 63) AS "63",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 64) AS "64",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 65) AS "65",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 66) AS "66",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 67) AS "67",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 68) AS "68",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 69) AS "69",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 70) AS "70",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 71) AS "71",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 72) AS "72",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 73) AS "73",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 74) AS "74",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 75) AS "75",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 76) AS "76",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 77) AS "77",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 78) AS "78",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 79) AS "79",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 80) AS "80",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 81) AS "81",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 82) AS "82",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 83) AS "83",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 84) AS "84",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 85) AS "85",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 86) AS "86",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 87) AS "87",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 88) AS "88",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 89) AS "89",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 90) AS "90",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 91) AS "91",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 92) AS "92",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 93) AS "93",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 94) AS "94",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 95) AS "95",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 96) AS "96",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 97) AS "97",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 98) AS "98",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 99) AS "99",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 100) AS "100",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 101) AS "101",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 102) AS "102",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 103) AS "103",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 104) AS "104",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 105) AS "105",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 106) AS "106",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 107) AS "107",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 108) AS "108",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 109) AS "109",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 110) AS "110",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 111) AS "111",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 112) AS "112",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 113) AS "113",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 114) AS "114",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 115) AS "115",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 116) AS "116",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 117) AS "117",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 118) AS "118",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 119) AS "119",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 120) AS "120",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 121) AS "121",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 122) AS "122",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 123) AS "123",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 124) AS "124",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 125) AS "125",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 126) AS "126",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 127) AS "127",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 128) AS "128",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 129) AS "129",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 130) AS "130",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 131) AS "131",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 132) AS "132",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 133) AS "133",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 134) AS "134",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 135) AS "135",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 136) AS "136",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 137) AS "137",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 138) AS "138",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 139) AS "139",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 140) AS "140",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 141) AS "141",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 142) AS "142",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 143) AS "143",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 144) AS "144",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 145) AS "145",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 146) AS "146",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 147) AS "147",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 148) AS "148",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 149) AS "149",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 150) AS "150",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 151) AS "151",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 152) AS "152",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 153) AS "153",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 154) AS "154",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 155) AS "155",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 156) AS "156",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 157) AS "157",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 158) AS "158",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 159) AS "159",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 160) AS "160",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 161) AS "161",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 162) AS "162",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 163) AS "163",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 164) AS "164",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 165) AS "165",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 166) AS "166",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 167) AS "167",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 168) AS "168",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 169) AS "169",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 170) AS "170",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 171) AS "171",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 172) AS "172",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 173) AS "173",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 174) AS "174",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 175) AS "175",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 176) AS "176",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 177) AS "177",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 178) AS "178",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 179) AS "179",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 180) AS "180",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 181) AS "181",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 182) AS "182",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 183) AS "183",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 184) AS "184",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 185) AS "185",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 186) AS "186",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 187) AS "187",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 188) AS "188",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 189) AS "189",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 190) AS "190",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 191) AS "191",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 192) AS "192",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 193) AS "193",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 194) AS "194",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 195) AS "195",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 196) AS "196",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 197) AS "197",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 198) AS "198",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 199) AS "199",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 200) AS "200",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 201) AS "201",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 202) AS "202",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 203) AS "203",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 204) AS "204",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 205) AS "205",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 206) AS "206",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 207) AS "207",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 208) AS "208",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 209) AS "209",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 210) AS "210",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 211) AS "211",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 212) AS "212",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 213) AS "213",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 214) AS "214",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 215) AS "215",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 216) AS "216",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 217) AS "217",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 218) AS "218",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 219) AS "219",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 220) AS "220",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 221) AS "221",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 222) AS "222",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 223) AS "223",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 224) AS "224",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 225) AS "225",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 226) AS "226",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 227) AS "227",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 228) AS "228",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 229) AS "229",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 230) AS "230",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 231) AS "231",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 232) AS "232",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 233) AS "233",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 234) AS "234",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 235) AS "235",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 236) AS "236",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 237) AS "237",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 238) AS "238",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 239) AS "239",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 240) AS "240",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 241) AS "241",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 242) AS "242",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 243) AS "243",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 244) AS "244",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 245) AS "245",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 246) AS "246",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 247) AS "247",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 248) AS "248",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 249) AS "249",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 250) AS "250",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 251) AS "251",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 252) AS "252",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 253) AS "253",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 254) AS "254",
COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 255) AS "255"

FROM
sierra_view.bib_record b
JOIN
sierra_view.bib_record_item_record_link bi
ON
b.id = bi.bib_record_id
JOIN
sierra_view.item_record i
ON
bi.item_record_id = i.id
JOIN
sierra_view.language_property_myuser ln
ON
b.language_code = ln.code
JOIN
sierra_view.material_property_myuser m
ON
b.bcode2 = m.code
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code
JOIN
call_number_mod ic
ON
i.id = ic.item_record_id

WHERE
i.location_code ~ {{location}}
--location will take the form ^oln, which in this example looks for all locations starting with the string oln.
AND i.item_status_code NOT IN ({{Item_Status_Codes}})

GROUP BY
1
ORDER BY
1