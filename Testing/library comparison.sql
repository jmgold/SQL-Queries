WITH order_count AS (
SELECT
l.name AS Library
,COUNT(DISTINCT cmf.order_record_id) AS order_count
,COUNT(DISTINCT cmf.order_record_id) FILTER (WHERE rmo.creation_date_gmt::DATE >= CASE
	WHEN EXTRACT('month' FROM CURRENT_DATE) < 7 THEN ((EXTRACT('year' FROM CURRENT_DATE)-1)||'-07-01')::DATE
	ELSE (EXTRACT('year' from CURRENT_DATE)||'-07-01')::DATE END) AS orders_this_fy 

FROM
sierra_view.location_myuser l
LEFT JOIN
sierra_view.order_record_cmf cmf
ON
l.code = SUBSTRING(cmf.location_code,1,3)
LEFT JOIN
sierra_view.record_metadata rmo
ON
cmf.order_record_id = rmo.id

WHERE 
LENGTH(l.code) = 3
AND l.code NOT IN ('cmc','hpl','int','knp','trn')

GROUP BY 1)

,holding_count AS(
SELECT
l.name AS Library
,COUNT(DISTINCT h.holding_record_id) AS checkin_count

FROM
sierra_view.location_myuser l
LEFT JOIN
sierra_view.holding_record_location h
ON 
l.code = SUBSTRING(h.location_code,1,3)


WHERE 
LENGTH(l.code) = 3
AND l.code NOT IN ('cmc','hpl','int','knp','trn')

GROUP BY 1
)

,patron_count AS(
SELECT
pc.Library,
pc.patron_count_by_home_library,
COUNT(DISTINCT p.id) AS patron_count_by_ptype,
COUNT(DISTINCT p.id) FILTER(WHERE p.activity_gmt > (localtimestamp - INTERVAL '1 year')) AS Active_Patrons,
COUNT(DISTINCT p.id) FILTER(WHERE m.creation_date_gmt > (localtimestamp - INTERVAL '1 year')) AS New_Patrons
FROM
sierra_view.patron_record p
JOIN
sierra_view.ptype_property_myuser n
ON
p.ptype_code = n.value
JOIN
(
SELECT
l.name AS Library
,COUNT(DISTINCT p.id) AS patron_count_by_home_library

FROM
sierra_view.location_myuser l
LEFT JOIN
sierra_view.patron_record p
ON 
l.code = SUBSTRING(p.home_library_code,1,3)

WHERE 
LENGTH(l.code) = 3
AND l.code NOT IN ('cmc','hpl','int','knp','trn')

GROUP BY 1

) pc
ON
SUBSTRING(n.name,'^\S+') = SUBSTRING(INITCAP(REPLACE(REPLACE(pc.library,'/',' '),'FRAMINGHAM STATE','Fram')),'^\S+')
JOIN
sierra_view.record_metadata m
ON
p.id = m.id
GROUP BY 1,2
)

,course_count AS(
SELECT
l.name AS Library
,COUNT(DISTINCT c.id) AS course_count

FROM
sierra_view.location_myuser l
LEFT JOIN
sierra_view.course_record c
ON 
l.code = SUBSTRING(c.location_code,1,3)

WHERE 
LENGTH(l.code) = 3
AND l.code NOT IN ('cmc','hpl','int','knp','trn')

GROUP BY 1

)
SELECT
l.name AS Library
,p.patron_count_by_home_library
,p.patron_count_by_ptype
,p.Active_Patrons
,p.New_Patrons
,COUNT(DISTINCT bi.bib_record_id) AS title_count
,COUNT(i.id) AS item_count
,COUNT(i.id) FILTER(WHERE DATE_PART('year',rmi.creation_date_gmt) = DATE_PART('year',CURRENT_DATE)) AS items_added_current_year
,SUM(i.year_to_date_checkout_total) AS ytd_checkout_total
,SUM(i.last_year_to_date_checkout_total) AS last_ytd_checkout_total
--,SUM(i.checkout_total) AS checkout_total
,o.order_count
,o.orders_this_fy
,h.checkin_count
,course.course_count

FROM
sierra_view.location_myuser l
JOIN
sierra_view.item_record i
ON
l.code = SUBSTRING(i.location_code,1,3)
JOIN 
sierra_view.record_metadata rmi
ON
i.id = rmi.id
JOIN
sierra_view.bib_record_item_record_link bi
ON
i.id = bi.item_record_id
JOIN
order_count o
ON
l.name = o.library
JOIN
holding_count h
ON
l.name = h.library
JOIN
patron_count p
ON
l.name = p.library
JOIN
course_count course
ON
l.name = course.library

WHERE 
LENGTH(l.code) = 3
AND l.code NOT IN ('cmc','hpl','int','knp','trn')

GROUP BY l.name,p.patron_count_by_home_library,p.patron_count_by_ptype,
			p.Active_patrons,p.New_patrons,o.order_count,o.orders_this_fy,h.checkin_count,course.course_count
ORDER BY 1