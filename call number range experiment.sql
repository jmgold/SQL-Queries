SELECT
CASE
	WHEN i.call_number_norm IS NULL THEN 'No Call number'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^00[0-9]' THEN '000'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^01[0-9]' THEN '010'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^02[0-9]' THEN '020'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^03[0-9]' THEN '030'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^04[0-9]' THEN '040'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^05[0-9]' THEN '050'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^06[0-9]' THEN '060'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^07[0-9]' THEN '070'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^08[0-9]' THEN '080'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^09[0-9]' THEN '090'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^10[0-9]' THEN '100'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^11[0-9]' THEN '110'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^12[0-9]' THEN '120'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^13[0-9]' THEN '130'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^14[0-9]' THEN '140'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^15[0-9]' THEN '150'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^16[0-9]' THEN '160'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^17[0-9]' THEN '170'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^18[0-9]' THEN '180'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^19[0-9]' THEN '190'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^20[0-9]' THEN '200'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^21[0-9]' THEN '210'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^22[0-9]' THEN '220'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^23[0-9]' THEN '230'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^24[0-9]' THEN '240'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^25[0-9]' THEN '250'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^26[0-9]' THEN '260'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^27[0-9]' THEN '270'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^28[0-9]' THEN '280'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^29[0-9]' THEN '290'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^30[0-9]' THEN '300'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^31[0-9]' THEN '310'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^32[0-9]' THEN '320'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^33[0-9]' THEN '330'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^34[0-9]' THEN '340'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^35[0-9]' THEN '350'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^36[0-9]' THEN '360'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^37[0-9]' THEN '370'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^38[0-9]' THEN '380'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^39[0-9]' THEN '390'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^40[0-9]' THEN '400'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^41[0-9]' THEN '410'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^42[0-9]' THEN '420'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^43[0-9]' THEN '430'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^44[0-9]' THEN '440'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^45[0-9]' THEN '450'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^46[0-9]' THEN '460'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^47[0-9]' THEN '470'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^48[0-9]' THEN '480'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^49[0-9]' THEN '490'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^50[0-9]' THEN '500'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^51[0-9]' THEN '510'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^52[0-9]' THEN '520'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^53[0-9]' THEN '530'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^54[0-9]' THEN '540'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^55[0-9]' THEN '550'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^56[0-9]' THEN '560'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^57[0-9]' THEN '570'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^58[0-9]' THEN '580'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^59[0-9]' THEN '590'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^60[0-9]' THEN '600'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^61[0-9]' THEN '610'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^62[0-9]' THEN '620'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^63[0-9]' THEN '630'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^64[0-9]' THEN '640'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^65[0-9]' THEN '650'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^66[0-9]' THEN '660'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^67[0-9]' THEN '670'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^68[0-9]' THEN '680'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^69[0-9]' THEN '690'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^70[0-9]' THEN '700'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^71[0-9]' THEN '710'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^72[0-9]' THEN '720'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^73[0-9]' THEN '730'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^74[0-9]' THEN '740'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^75[0-9]' THEN '750'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^76[0-9]' THEN '760'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^77[0-9]' THEN '770'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^78[0-9]' THEN '780'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^79[0-9]' THEN '790'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^80[0-9]' THEN '800'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^81[0-9]' THEN '810'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^82[0-9]' THEN '820'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^83[0-9]' THEN '830'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^84[0-9]' THEN '840'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^85[0-9]' THEN '850'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^86[0-9]' THEN '860'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^87[0-9]' THEN '870'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^88[0-9]' THEN '880'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^89[0-9]' THEN '890'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^90[0-9]' THEN '900'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^91[0-9]' THEN '910'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^92[0-9]' THEN '920'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^93[0-9]' THEN '930'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^94[0-9]' THEN '940'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^95[0-9]' THEN '950'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^96[0-9]' THEN '960'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^97[0-9]' THEN '970'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^98[0-9]' THEN '980'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^99[0-9]' THEN '990'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(fic)' THEN 'Fiction'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(mys|fiction mys)' THEN 'Fiction - Mystery'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(fictionsscifi|fictionscience|fictionsf|sciencefiction|sf|scific)' THEN 'Fiction - Sci Fi'	
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(ficrom|fictionrom|rom)' THEN 'Fiction - Romance'	
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(ficwes|fictionwes|western)' THEN 'Fiction - Western'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(ficthriller|fictionthriller|thriller)' THEN 'Fiction - Thriller'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(speed|readit|quick|express)' THEN 'Speed Read/quick pick/read it now/express'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(comic|graphic)' THEN 'comic/graphic'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(largeprintfic|largetypefic|lgprintfic|lpfic|ltfic|ltpfic)' THEN 'large type fic'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(largeprint|largetype|lgprint|lp|lt|ltp)' THEN 'large type'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)0[0-9][0-9]' THEN 'J 000'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)1[0-9][0-9]' THEN 'J 100'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)2[0-9][0-9]' THEN 'J 200'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)3[0-9][0-9]' THEN 'J 300'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)4[0-9][0-9]' THEN 'J 400'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)5[0-9][0-9]' THEN 'J 500'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)6[0-9][0-9]' THEN 'J 600'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)7[0-9][0-9]' THEN 'J 700'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)8[0-9][0-9]' THEN 'J 800'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)9[0-9][0-9]' THEN 'J 900'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(j|juv|juvenile)' THEN 'J other'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)0[0-9][0-9]' THEN 'YA 000'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)1[0-9][0-9]' THEN 'YA 100'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)2[0-9][0-9]' THEN 'YA 200'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)3[0-9][0-9]' THEN 'YA 300'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)4[0-9][0-9]' THEN 'YA 400'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)5[0-9][0-9]' THEN 'YA 500'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)6[0-9][0-9]' THEN 'YA 600'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)7[0-9][0-9]' THEN 'YA 700'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)8[0-9][0-9]' THEN 'YA 800'
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen)9[0-9][0-9]' THEN 'YA 900'	
	WHEN REPLACE(i.call_number_norm,' ','') ~ '^(y|ya|teen|young)' THEN 'YA other'
	ELSE 'other'
END AS call_number_range,
COUNT (ir.id) AS "Item total",
SUM(ir.checkout_total) AS "Total_Checkouts",
SUM(ir.renewal_total) AS "Total_Renewals",
SUM(ir.checkout_total) + SUM(ir.renewal_total) AS "Total_Circulation",
ROUND(AVG(ir.price) FILTER(WHERE ir.price>'0' and ir.price <'10000'),2) AS "AVG_price",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS "have_circed_within_1_year",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '1 year')) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_1_year",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS "have_circed_within_3_years",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '3 years')) AS NUMERIC (12,2)) / CAST(count (i.id) AS NUMERIC (12,2)), 6) AS "Percentage_3_years",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS "have_circed_within_5_years",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt >= (localtimestamp - interval '5 years')) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_5_years",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt is not null) AS "have_circed_within_5+_years",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt is not null) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_5+_years",
COUNT (ir.id) FILTER(WHERE ir.last_checkout_gmt is null) AS "0_circs",
ROUND(CAST(COUNT(ir.id) FILTER(WHERE ir.last_checkout_gmt is null) AS NUMERIC (12,2)) / CAST(count (ir.id) AS NUMERIC (12,2)), 6) AS "Percentage_0_circs",
ROUND((COUNT(ir.id) *(AVG(ir.price) FILTER(WHERE ir.price>'0' and ir.price <'10000'))/(NULLIF((SUM(ir.checkout_total) + SUM(ir.renewal_total)),0))),2) AS "Cost_Per_Circ_By_AVG_price",
round(cast(SUM(ir.checkout_total) + SUM(ir.renewal_total) as numeric (12,2))/cast(count (ir.id) as numeric (12,2)), 2) as turnover,
round(cast(count(i.id) as numeric (12,2)) / (select cast(count (id) as numeric (12,2))from sierra_view.item_record where location_code LIKE 'arl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')), 6) as relative_item_total,
round(cast(SUM(ir.checkout_total) + SUM(ir.renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'arl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd', 'e')), 6) as relative_circ
FROM
sierra_view.item_record_property i
JOIN
sierra_view.item_record ir
ON
i.item_record_id = ir.id
AND
ir.location_code ~ '^arl'
JOIN
sierra_view.bib_record_item_record_link l
ON
ir.id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id AND b.material_code IN ('a','2')
GROUP BY 1
ORDER BY 1;