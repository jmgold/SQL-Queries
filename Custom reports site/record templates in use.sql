/*
Jeremy Goldstein
Minuteman Library Network

Query identifies which records templates are currently in use
and how many logins have each one set as a preferred template
*/

SELECT 
--u.name,
'bib' AS "type",
UNNEST(STRING_TO_ARRAY(bib.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option bib
ON
u.id= bib.iii_user_id AND bib.desktop_option_id = '524'
GROUP BY 1,2

UNION
SELECT 
--u.name,
'item' AS "type",
UNNEST(STRING_TO_ARRAY(item.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option item
ON
u.id= item.iii_user_id AND item.desktop_option_id = '344'
GROUP BY 1,2

UNION
SELECT 
--u.name,
'order' AS "type",
UNNEST(STRING_TO_ARRAY(orec.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option orec
ON
u.id= orec.iii_user_id AND orec.desktop_option_id = '176'
GROUP BY 1,2

UNION
SELECT 
--u.name,
'authority' AS "type",
UNNEST(STRING_TO_ARRAY(auth.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option auth
ON
u.id= auth.iii_user_id AND auth.desktop_option_id = '699'
GROUP BY 1,2

UNION
SELECT 
--u.name,
'patron' AS "type",
UNNEST(STRING_TO_ARRAY(patron.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option patron
ON
u.id= patron.iii_user_id AND patron.desktop_option_id = '21'
GROUP BY 1,2

UNION
SELECT 
--u.name,
'course' AS "type",
UNNEST(STRING_TO_ARRAY(course.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option course
ON
u.id= course.iii_user_id AND course.desktop_option_id = '344'
GROUP BY 1,2

UNION
SELECT 
--u.name,
'vendor' AS "type",
UNNEST(STRING_TO_ARRAY(vendor.value, ',')) AS "template",
COUNT(DISTINCT u.name)

FROM
sierra_view.iii_user u
JOIN
sierra_view.iii_user_desktop_option vendor
ON
u.id= vendor.iii_user_id AND vendor.desktop_option_id = '880'
GROUP BY 1,2

ORDER BY 1,2