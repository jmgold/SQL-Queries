SELECT
rc .code AS permission_category,
r .code AS permissions,
u .name AS user_name,
u .full_name AS user_full_name
FROM
sierra_view.iii_user u
LEFT JOIN sierra_view.iii_user_location u_loc ON u_loc.iii_user_id = u.id
JOIN sierra_view.iii_user_iii_role ur ON ur.iii_user_id = u.id
JOIN sierra_view.iii_role r ON r.id = ur.iii_role_id
JOIN sierra_view.iii_role_category rc ON rc.id = r.iii_role_category_id;
--WHERE u.name = ‘winjcirc';
--LIMIT 100;