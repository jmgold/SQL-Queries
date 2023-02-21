/*
Jeremy Goldstein
Minuteman Library Network
See logins currently running SQL queries 
*/

SELECT 
*
FROM 
pg_stat_activity a

WHERE
a.state IS NOT NULL