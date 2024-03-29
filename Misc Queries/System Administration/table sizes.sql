/*
Shared by Ray Voelker over slack 12/9/20

provides size of each view in SierraDNA
*/

SELECT
   relname AS "Table",
   pg_size_pretty(pg_total_relation_size(relid)) AS "Size",
   pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS "External Size"

FROM pg_catalog.pg_statio_user_tables 

ORDER BY pg_total_relation_size(relid) DESC