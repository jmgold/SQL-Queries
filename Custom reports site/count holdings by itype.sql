/*
Jeremy Goldstein
Minuteman Library Network

Holdings Profile gathered for annual reports
location code by itype

Passed variables for owning location and item statuses to exclude
*/

SELECT
  *,
  '' AS "COUNT HOLDINGS BY ITYPE",
  '' AS "https://sic.minlib.net/reports/22"
FROM (
  SELECT
    {{grouping}},
    /*Options are
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
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 19) AS "19",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 20) AS "20",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 21) AS "21",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 22) AS "22",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 23) AS "23",
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
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 40) AS "40",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 41) AS "41",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 42) AS "42",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 43) AS "43",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 44) AS "44",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 45) AS "45",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 46) AS "46",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 47) AS "47",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 48) AS "48",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 50) AS "50",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 51) AS "51",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 52) AS "52",
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
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 113) AS "113",
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
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 186) AS "186",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 187) AS "187",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 188) AS "188",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 189) AS "189",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 221) AS "221",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 222) AS "222",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 223) AS "223",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 224) AS "224",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 239) AS "239",
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
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 255) AS "255",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 256) AS "256",
    COUNT({{bib_or_item}}) FILTER(WHERE i.itype_code_num = 257) AS "257"

  FROM sierra_view.item_record i
  JOIN sierra_view.bib_record_item_record_link l
    ON i.id = l.item_record_id
  JOIN sierra_view.bib_record b 
    ON l.bib_record_id = b.id
  JOIN sierra_view.language_property_myuser ln
    ON b.language_code = ln.code
  JOIN sierra_view.material_property_myuser m
    ON b.bcode2 = m.code
  JOIN sierra_view.itype_property_myuser it
    ON i.itype_code_num = it.code

  WHERE i.location_code ~ {{location}}
    --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
    AND i.item_status_code NOT IN ({{item_Status_Codes}})

GROUP BY 1
ORDER BY 1
)a