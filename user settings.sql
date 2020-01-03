/*
Jeremy Goldstein
Minuteman Library Network

Identifies which optional settings are used by each login for selected settings
*/

select distinct(u.user_name),
--true if sierra web is enabled (option 899)
CASE WHEN web.id IS NULL THEN 'true'
  ELSE web.value
  END AS sierra_web,
--true if e-mailed due slips are enabled (option 905)
CASE WHEN due_slip.value LIKE 'Email%' THEN 'true'
  ELSE 'false'
  END AS email_due_slip,
--true if using compact browse (option 833)
COALESCE(compact.value,'false') AS compact_browse,
--true if show book jacket is selected (option 536)
COALESCE(show_book_jacket.value,'false') AS show_book_jacket,
--true if using spine label templates (option 386)
COALESCE(spine.value,'false') AS spine_labels,
--hold slip template (option 12)
COALESCE(hold_slip_template.value,'none') AS hold_slip_template
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
LEFT JOIN
sierra_view.iii_user_desktop_option hold_slip_template 
ON
u.iii_user_id=hold_slip_template.iii_user_id and hold_slip_template.desktop_option_id='12'
LEFT JOIN
sierra_view.iii_user_desktop_option show_book_jacket
ON
u.iii_user_id=show_book_jacket.iii_user_id and show_book_jacket.desktop_option_id='536'
order by 1