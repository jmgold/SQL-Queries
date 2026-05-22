SELECT
  i.icode1 AS scat_code,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^camnn') AS camnn,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^ca4nn') AS ca4nn,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^ca5nn') AS ca5nn,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^ca6nn') AS ca6nn,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^ca7nn') AS ca7nn,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^ca8nn') AS ca8nn,
  COUNT(i.id) FILTER (WHERE i.location_code ~ '^ca9nn') AS ca9nn
FROM sierra_view.item_record i

WHERE i.location_code ~ '^ca(m|4|5|6|7|8|9)nn'
  AND i.icode1 IN ('165','166','167','168','170','171','172','180','185','186')

GROUP BY 1
ORDER BY 1