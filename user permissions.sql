--query from Bee Bornheimer
--Shared over Sierra_ILS slack group 3/21/19

SELECT DISTINCT
 iii_user.name,
 iii_user.full_name,
 iii_user.is_suspended,
 iii_user.account_unit,
 iii_user_permission_myuser.permission_num,
 iii_user_permission_myuser.permission_code,
 iii_user_permission_myuser.permission_name
FROM
 sierra_view.iii_user_permission_myuser,
 sierra_view.iii_user
WHERE
 iii_user.name = iii_user_permission_myuser.user_name
 order by name;