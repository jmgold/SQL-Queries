/*
Jeremy Goldstein
Minuteman Library Network

Lists out macros used by each user in the system
*/

WITH macros AS (
SELECT
  DISTINCT o.desktop_option_id,
  CASE
    WHEN o.desktop_option_id = '661' THEN 'ALT+F1'
    WHEN o.desktop_option_id = '75' THEN 'ALT+F2'
    WHEN o.desktop_option_id = '382' THEN 'ALT+F3'
    WHEN o.desktop_option_id = '135' THEN 'ALT+F5'
    WHEN o.desktop_option_id = '771' THEN 'ALT+F7'
    WHEN o.desktop_option_id = '198' THEN 'ALT+F8'
    WHEN o.desktop_option_id = '513' THEN 'ALT+F9'
    WHEN o.desktop_option_id = '742' THEN 'ALT+F10'
    WHEN o.desktop_option_id = '160' THEN 'ALT+F11'
    WHEN o.desktop_option_id = '477' THEN 'ALT+F12'
    WHEN o.desktop_option_id = '809' THEN 'CTRL+F1'
    WHEN o.desktop_option_id = '233' THEN 'CTRL+F2'
    WHEN o.desktop_option_id = '563' THEN 'CTRL+F3'
    WHEN o.desktop_option_id = '301' THEN 'CTRL+F5'
    WHEN o.desktop_option_id = '630' THEN 'CTRL+F6'
    WHEN o.desktop_option_id = '50' THEN 'CTRL+F7'
    WHEN o.desktop_option_id = '365' THEN 'CTRL+F8'
    WHEN o.desktop_option_id = '702' THEN 'CTRL+F9'
    WHEN o.desktop_option_id = '23' THEN 'CTRL+F10'
    WHEN o.desktop_option_id = '345' THEN 'CTRL+F11'
    WHEN o.desktop_option_id = '677' THEN 'CTRL+F12'
    WHEN o.desktop_option_id = '427' THEN 'F1'
    WHEN o.desktop_option_id = '761' THEN 'F2'
    WHEN o.desktop_option_id = '188' THEN 'F3'
    WHEN o.desktop_option_id = '504' THEN 'F4'
    WHEN o.desktop_option_id = '818' THEN 'F5'
    WHEN o.desktop_option_id = '249' THEN 'F6'
    WHEN o.desktop_option_id = '578' THEN 'F7'
    WHEN o.desktop_option_id = '316' THEN 'F9'
    WHEN o.desktop_option_id = '357' THEN 'F11'
    WHEN o.desktop_option_id = '690' THEN 'F12'
    WHEN o.desktop_option_id = '360' THEN 'SHIFT+F1'
    WHEN o.desktop_option_id = '700' THEN 'SHIFT+F2'
    WHEN o.desktop_option_id = '113' THEN 'SHIFT+F3'
    WHEN o.desktop_option_id = '414' THEN 'SHIFT+F4'
    WHEN o.desktop_option_id = '752' THEN 'SHIFT+F5'
    WHEN o.desktop_option_id = '172' THEN 'SHIFT+F6'
    WHEN o.desktop_option_id = '492' THEN 'SHIFT+F7'
    WHEN o.desktop_option_id = '811' THEN 'SHIFT+F8'
    WHEN o.desktop_option_id = '236' THEN 'SHIFT+F9'
    WHEN o.desktop_option_id = '377' THEN 'SHIFT+F10'
    WHEN o.desktop_option_id = '711' THEN 'SHIFT+F11'
    WHEN o.desktop_option_id = '125' THEN 'SHIFT+F12'
  END AS macro
    
FROM
sierra_view.iii_user_desktop_option o
WHERE o.desktop_option_id IN
('661','75','382','135','771','198','513','742','160','477','809','233','563','301','630','50','365','702','23','345','677','427','761','188','504','818','249','578','316','357','690','360','700','113','414','752','172','492','811','236','377','711','125')
ORDER BY 2
)

SELECT
  u.name,
  m.macro AS hotkey,
  o.value AS macro
FROM macros m
JOIN sierra_view.iii_user_desktop_option o
  ON m.desktop_option_id = o.desktop_option_id
  AND o.value != ''
JOIN sierra_view.iii_user u
  ON o.iii_user_id = u.id
ORDER BY 1,2