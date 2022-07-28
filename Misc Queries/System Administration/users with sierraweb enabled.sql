/*
Jeremy Goldstein
Minuteman Library Network
Identifies user accounts with the permission to access Sierra Web
*/

SELECT DISTINCT u.user_name

FROM 
sierra_view.iii_user_application_myuser u
LEFT JOIN
sierra_view.iii_user_desktop_option o
ON 
u.iii_user_id = o.iii_user_id  AND o.desktop_option_id='899'

WHERE 
CASE 
	WHEN o.id IS NULL THEN 'true'
  	ELSE o.value
END = 'true'

ORDER BY 1