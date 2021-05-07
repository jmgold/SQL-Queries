/*
Jeremy Goldstein
Minuteman Library Network
Gathers various patron record statistics grouped on a choice of geography
Census block geoids are stored in patron census fields and can be used to
join results to census data
*/

WITH overdue AS(
SELECT
f.patron_record_id,
SUM(f.item_charge_amt) AS owed_amt

FROM sierra_view.fine f

WHERE
f.charge_code IN ('2','4','6')
GROUP BY 1
)

SELECT
SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12) AS geoid,
--Possible options are zip, county, tract, block group
COUNT(DISTINCT p.id) AS total_patrons,
SUM(p.checkout_total) AS total_checkouts,
SUM(p.renewal_total) AS total_renewals,
SUM(p.checkout_total + p.renewal_total) AS total_circ,
SUM(p.checkout_count) AS total_checkouts_current,
COUNT(DISTINCT h.id) AS total_holds_current,
ROUND(AVG(DATE_PART('year',AGE(CURRENT_DATE,p.birth_date_gmt::DATE)))) AS avg_age,
COUNT(DISTINCT p.id) FILTER(WHERE rm.creation_date_gmt::DATE >= '2020-05-06') AS total_new_patrons,
--set date you wish to use for determining if a patron is considered to be new
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= '2020-05-06') AS total_active_patrons,
--set date you wish to use to determine if a patron is considered to be active
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt::DATE >= '2020-05-06') AS NUMERIC (12,2))) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2)), 4) ||'%' AS pct_active,
--COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) as total_blocked_patrons,
COUNT(DISTINCT p.id) FILTER(WHERE (o.owed_amt >= 10)) as total_blocked_patrons,
--ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE ((p.mblock_code != '-') OR (p.owed_amt >= 10))) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked,
ROUND(100.0 * (CAST(COUNT(DISTINCT p.id) FILTER(WHERE o.owed_amt >= 10) AS NUMERIC (12,2)) / CAST(COUNT(DISTINCT p.id) AS NUMERIC (12,2))),4) ||'%' AS pct_blocked,
ROUND((100.0 * SUM(p.checkout_total))/(100.0 *COUNT(DISTINCT p.id)),2) AS checkouts_per_patron,
'https://censusreporter.org/profiles/15000US'||SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),1,12) AS census_reporter_url
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
LEFT JOIN
overdue o
ON
p.id = o.patron_record_id


WHERE SUBSTRING(REGEXP_REPLACE(v.field_content,'\|(s|c|t|b)','','g'),6,6) IN ('363102','363103','363104','363201','363202',
'356100','356200','356300','356400','356500','356601','356602','356701','356702','356703','356704',
'385100','385201','385202',
'359100','359300',
'357100','357200','357300','357400','357500','357600','357700','357800',
'400100','400200','400201','400300','400400','400500','400600','400700','400800','400900','401000','401100','401200',
'352101','352102','352200','352300','352400','352500','352600','352700','352800','352900','353000','353101','353102','353200','353300','353400','353500','353600','353700','353800','353900','354000','354100','354200','354300','354400','354500','354600','354700','354800','354900','355000',
'361100','361200','361300',
'402101','402102','402200','402300','402400','402500',
'405100',
'383101','383102','383200','383300','383400','383501','383502','383600','383700','383800','383901','383902','384001','384002',
'442101','442102','442103','442201','442202',
'387100','387201','387202',
'358100','358200','358300','358400','358500','358600','358700',
'360100','360200','360300',
'364101','364102',
'406101','406102',
'339100','339200','339300','339400','339500','339600','339700','339801','339802','339900','340000','340100',
'408101','408102',
'407100',
'382100','382200','382300','382400','382500','382601','382602',
'403100','403300','403400','403500','457200',
'373100','373200','373300','373400','373500','373600','373700','373800','373900','374000','374100','374200','374300','374400','374500','374600','374700','374800',
'413100','413200','413300','413401','413402','413500',
'386100',
'350103','350104','350200','350300','350400','350500','350600','350700','350800','350900','351000','351100','351203','351204','351300','351403','351404','351500',
'323100','980000',
'365100','365201','365202',
'366100','366201','366202',
'368101','368102','368200','368300','368400','368500','368600','368700','368800','368901','368902','369000','369100',
'370101','370102','370104','370201','370202','370300','370301','370400','370401',
'404100','404201','404202','404301','404302','404400',
'367100','367200',
'412100','412200','412300',
'338100','338200','338300','338400','338500',
'333100','333200','333300','333400','333501','333502','333600')
--p.ptype_code IN ({{ptype}})

GROUP BY 1,15
ORDER BY 2 DESC