--Jeremy Goldstein
--Minuteman Library Network

--Identifies user accounts with the permission to access Sierra Web

select distinct(u.user_name)
from
sierra_view.iii_user_application_myuser u
left join
sierra_view.iii_user_desktop_option o
on 
u.iii_user_id=o.iii_user_id  and o.desktop_option_id='899'
where o.id is null
order by 1
