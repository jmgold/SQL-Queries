/*
Jeremy Goldstein
Minuteman Library Network
Gathers permissions used by each user account
adapted from query shared by Bee Bornheimer
over Sierra_ILS slack group 3/21/19
*/

SELECT
u.name
,u.full_name
,u.statistic_group_code_num
,p.permission_num
,p.permission_name

FROM
sierra_view.iii_user_permission_myuser p
JOIN
sierra_view.iii_user u
ON
p.user_name = u.name

ORDER BY u.name, p.permission_num