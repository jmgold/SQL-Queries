/*
Jeremy Goldstein
Minuteman Library Network

Parse out dewey 10's from call numbers
*/

SELECT 
  *,
  TRUNC(inner_query.call_rounded,-1) AS Dewey_10s,
  TRUNC(inner_query.call_rounded,-2) AS Dewey_100s
FROM(
  SELECT
    ip.call_number,
    SUBSTRING(REPLACE(ip.call_number,'|a','') FROM '\d{3}\.?\d*')::NUMERIC AS number_isolated,
    TRUNC(SUBSTRING(REPLACE(ip.call_number,'|a','') FROM '\d{3}\.?\d*')::NUMERIC) AS call_rounded
  FROM sierra_view.item_record_property ip
) inner_query

WHERE call_rounded < 1000

LIMIT 500