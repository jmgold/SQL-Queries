SELECT
CASE
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('363102','363103','363104','363105','363106','363201','363202') THEN 'Acton'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('356100','356200','356300','356400','356500','356601','356602','356701','356702','356703','356704') THEN 'Arlington'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('385100','385101','385102','385201','385202','385203','385204') THEN 'Ashland'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('359100','359300','359301','359302','359303') THEN 'Bedford'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('357100','357200','357300','357400','357500','357600','357700','357800') THEN 'Belmont'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('400100','400200','400201','400202','400300','400400','400401','400402','400500','400600','400700','400800','400900','401000','401100','401200','401201','401202') THEN 'Brookline'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('352101','352102','352200','352300','352400','352500','352600','352700','352800','352900','353000','353101','353102','353200','353300','353400','353500','353600','353700','353800','353900','354000','354100','354200','354300','354400','354500','354600','354601','354602','354700','354800','354900','354901','354902','355000') THEN 'Cambridge'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('361100','361200','361300','359301') THEN 'Concord'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('402101','402102','402200','402300','402400','402500') THEN 'Dedham'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('405100') THEN 'Dover'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('383101','383102','383200','383300','383400','383401','383402','383501','383502','383600','383700','383800','383900','383901','383902','383903','383904','384000','384001','384002','384003','384004') THEN 'Framingham Public'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('442101','442102','442103','442104','442105','442201','442202','442203','442204') THEN 'Franklin'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('387100','387201','387202') THEN 'Holliston'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('358100','358200','358300','358400','358500','358600','358700') THEN 'Lexington'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('360100','360200','360300','359302') THEN 'Lincoln'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('364101','364102') THEN 'Maynard'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('406101','406102') THEN 'Medfield'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('339100','339101','339102','339200','339300','339400','339500','339600','339700','339801','339802','339803','339804','339900','340000','340100') THEN 'Medford'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('408101','408102','408103','408104') THEN 'Medway'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('407100','407101','407102') THEN 'Millis'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('382100','382200','382300','382400','382500','382601','382602') THEN 'Natick'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('403100','403300','403400','403500','403501','403502','457200') THEN 'Needham'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('373100','373200','373300','373400','373500','373600','373700','373800','373900','373901','373902','374000','374100','374200','374300','374400','374500','374600','374700','374800') THEN 'Newton'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('413100','413200','413201','413202','413300','413401','413402','413500') THEN 'Norwood'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('386100') THEN 'Sherborn'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('350103','350104','350105','350106','350107','350108','350109','350200','350201','350202','350300','350400','350500','350600','350700','350701','350702','350800','350900','351000','351001','351002','351100','351101','351102','351203','351204','351300','351403','351404','351500') THEN 'Somerville'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('323100','323101','323102','980000') THEN 'Stow'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('365100','365201','365202') THEN 'Sudbury'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('366100','366201','366202') THEN 'Wayland'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('368101','368102','368200','368300','368400','368500','368600','368700','368800','368901','368902','369000','369100') THEN 'Waltham'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('370101','370102','370103','370104','370201','370202','370300','370301','370302','370400','370401','370402','370403') THEN 'Watertown'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('404100','404201','404202','404301','404302','404400') THEN 'Wellesley'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('367100','367200') THEN 'Weston'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('412100','412200','412300') THEN 'Westwood'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('338100','338200','338300','338400','338500') THEN 'Winchester'
	WHEN SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('333100','333200','333300','333400','333501','333502','333600','333601','333602') THEN 'Woburn'
	ELSE 'Other'
END AS city,
SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS geoid,
--Possible options are zip, county, tract, block group
COUNT(DISTINCT p.id) AS total_patrons,
SUM(p.checkout_total) AS total_checkouts,
SUM(p.renewal_total) AS total_renewals,
SUM(p.checkout_total + p.renewal_total) AS total_circ,
SUM(p.checkout_count) AS total_checkouts_current,
COUNT(DISTINCT h.id) AS total_holds_current,
ROUND(AVG(DATE_PART('year',AGE(CURRENT_DATE,p.birth_date_gmt::DATE)))) AS avg_age,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') AS total_new_patrons,
--set date you wish to use for determining if a patron is considered to be new
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') AS total_active_patrons,
--set date you wish to use to determine if a patron is considered to be active
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') AS NUMERIC (12,2))) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2)), 4) ||'%' AS pct_active,
COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) as total_blocked_patrons,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 100))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked,
ROUND((100.0 * SUM(p.checkout_total))/(100.0 *COUNT(DISTINCT p.id)),2) AS checkouts_per_patron,
'https://censusreporter.org/profiles/14000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,11) AS census_reporter_url

FROM
sierra_view.patron_record p
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id
AND a.patron_record_address_type_id = '1'
JOIN
sierra_view.record_metadata rm
ON
p.id = rm.id
LEFT JOIN
sierra_view.hold h
ON
p.id = h.patron_record_id
--for census field
LEFT JOIN
sierra_view.varfield v
ON
v.record_id = p.id AND v.varfield_type_code = 'k' AND v.field_content ~ '^\|s25'


WHERE SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('363102','363103','363104','363105','363106','363201','363202',
'356100','356200','356300','356400','356500','356601','356602','356701','356702','356703','356704',
'385100','385101','385102','385201','385202','385203','385204',
'359100','359300','359301','359302','359303',
'357100','357200','357300','357400','357500','357600','357700','357800',
'400100','400200','400201','400202','400300','400400','400401','400402','400500','400600','400700','400800','400900','401000','401100','401200','401201','401202',
'352101','352102','352200','352300','352400','352500','352600','352700','352800','352900','353000','353101','353102','353200','353300','353400','353500','353600','353700','353800','353900','354000','354100','354200','354300','354400','354500','354600','354601','354602','354700','354800','354900','354901','354902','355000',
'361100','361200','361300','359301',
'402101','402102','402200','402300','402400','402500',
'405100',
'383101','383102','383200','383300','383400','383401','383402','383501','383502','383600','383700','383800','383900','383901','383902','383903','383904','384000','384001','384002','384003','384004',
'442101','442102','442103','442104','442105','442201','442202','442203','442204',
'387100','387201','387202',
'358100','358200','358300','358400','358500','358600','358700',
'360100','360200','360300','359302',
'364101','364102',
'406101','406102',
'339100','339101','339102','339200','339300','339400','339500','339600','339700','339801','339802','339803','339804','339900','340000','340100',
'408101','408102','408103','408104',
'407100','407101','407102',
'382100','382200','382300','382400','382500','382601','382602',
'403100','403300','403400','403500','403501','403502','457200',
'373100','373200','373300','373400','373500','373600','373700','373800','373900','373901','373902','374000','374100','374200','374300','374400','374500','374600','374700','374800',
'413100','413200','413201','413202','413300','413401','413402','413500',
'386100',
'350103','350104','350105','350106','350107','350108','350109','350200','350201','350202','350300','350400','350500','350600','350700','350701','350702','350800','350900','351000','351001','351002','351100','351101','351102','351203','351204','351300','351403','351404','351500',
'323100','323101','323102','980000',
'365100','365201','365202',
'366100','366201','366202',
'368101','368102','368200','368300','368400','368500','368600','368700','368800','368901','368902','369000','369100',
'370101','370102','370103','370104','370201','370202','370300','370301','370302','370400','370401','370402','370403',
'404100','404201','404202','404301','404302','404400',
'367100','367200',
'412100','412200','412300',
'338100','338200','338300','338400','338500',
'333100','333200','333300','333400','333501','333502','333600','333601','333602')
--p.ptype_code IN ({{ptype}})

GROUP BY 1,2,16
ORDER BY 1,2