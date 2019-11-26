/*
script shared by Ray Voelker

Flags the indexes used by each system table
*/
SELECT
*
FROM
pg_indexes
--WHERE
--tablename = 'phrase_entry'
-- tablename NOT LIKE 'pg%'
ORDER BY
schemaname,
tablename,
indexname
;