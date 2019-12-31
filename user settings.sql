/*
Jeremy Goldstein
Minuteman Library Network

Identifies which optional settings are used by each login for selected settings
*/

select distinct(u.user_name),
--true if sierra web is enabled
CASE WHEN web.id IS NULL THEN 'true'
  ELSE web.value
  END AS sierra_web,
--true if e-mailed due slips are enabled
CASE WHEN due_slip.value LIKE 'Email%' THEN 'true'
  ELSE 'false'
  END AS email_due_slip,
--true if using compact browse
COALESCE(compact.value,'false') AS compact_browse,
--true if using spine label templates
COALESCE(spine.value,'false') AS spine_labels
from
sierra_view.iii_user_application_myuser u
left join
sierra_view.iii_user_desktop_option web
on 
u.iii_user_id=web.iii_user_id  and web.desktop_option_id='899'
LEFT JOIN
sierra_view.iii_user_desktop_option due_slip
ON
u.iii_user_id=due_slip.iii_user_id  and due_slip.desktop_option_id='905'
LEFT JOIN
sierra_view.iii_user_desktop_option compact
ON
u.iii_user_id=compact.iii_user_id  and compact.desktop_option_id='833'
LEFT JOIN
sierra_view.iii_user_desktop_option spine
ON
u.iii_user_id=spine.iii_user_id  and spine.desktop_option_id='386'
order by 1