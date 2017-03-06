-- ========================================================================
-- Select HOLDS where bib has only one attached item 
-- and the item is missing
-- Brent Searle. Langara College. 2016-10-14
-- ========================================================================
SELECT
  concat(
    rmb.record_type_code,
    rmb.record_num,
    'a'
  )                                                     AS "Bib Number",
  bprop.best_title                                      As "Title",
  CASE
    WHEN rmp1.record_num IS NULL
    THEN concat(
      rmp2.record_type_code,
      rmp2.record_num,
      'a'
    )
    ELSE concat(
      rmp1.record_type_code,
      rmp2.record_num,
      'a'
    )
  END                                                   AS "Patron Number",
  CASE
    WHEN TRIM(pnam1.last_name) IS NULL
    THEN TRIM(pnam2.first_name||' '||pnam2.last_name)
    ELSE TRIM(pnam1.first_name||' '||pnam1.last_name)
  END                                                   AS "Patron Name",
  CASE
    WHEN hld1.placed_gmt IS NULL 
    THEN DATE(hld2.placed_gmt)
    ELSE DATE(hld1.placed_gmt)
  END                                                   AS "Hold Placed",
  CASE
    WHEN hld1.expires_gmt IS NULL
    THEN DATE(hld2.expires_gmt)
    ELSE DATE(hld1.expires_gmt)
  END                                                   AS "Hold Expires",
  CASE
    WHEN hld1.is_frozen IS NULL 
    AND hld2.is_frozen IS TRUE THEN 'Yes'
    WHEN hld1.is_frozen IS NULL 
    AND hld2.is_frozen IS FALSE THEN 'No'
    WHEN hld2.is_frozen IS NULL
    AND hld1.is_frozen IS TRUE THEN 'Yes'
    WHEN hld2.is_frozen IS NULL
    AND hld1.is_frozen IS FALSE THEN 'No'
    ELSE 'error'
  END                                                   AS "Frozen",
  CASE
    WHEN pulnam1.name IS NULL
    THEN pulnam2.name
    ELSE pulnam1.name
  END                                                   AS "Pickup Location",
  concat(
    rmi.record_type_code,
    rmi.record_num,
    'a'
  )                                                     AS "Item Number",
  lnam.name                                             AS "Item Location",
  isnam.name                                            AS "Item Status"
FROM
  sierra_view.bib_record_item_record_link               AS bil
JOIN
  sierra_view.bib_record_property                       AS bprop
  ON
  bprop.bib_record_id = bil.bib_record_id
JOIN
  sierra_view.record_metadata                           AS rmb
  ON
  rmb.id = bil.bib_record_id
JOIN
  sierra_view.record_metadata                           As rmi
  ON
  rmi.id = bil.item_record_id
JOIN
  sierra_view.item_record                               AS i
  ON
  i.record_id = bil.item_record_id
JOIN
  sierra_view.location_myuser                           AS lnam
  ON
  lnam.code = i.location_code
JOIN
  sierra_view.item_status_property_myuser               AS isnam
  ON
  isnam.code = i.item_status_code
LEFT JOIN
  sierra_view.hold                                      AS hld1
  ON
  hld1.record_id = bil.bib_record_id
LEFT JOIN
  sierra_view.hold                                      AS hld2
  ON
  hld2.record_id = bil.item_record_id
LEFT JOIN
  sierra_view.patron_record_fullname                    AS pnam1
  ON
  pnam1.patron_record_id = hld1.patron_record_id
LEFT JOIN
  sierra_view.patron_record_fullname                    As pnam2
  ON
  pnam2.patron_record_id = hld2.patron_record_id
LEFT JOIN
  sierra_view.record_metadata                           AS rmp1
  ON
  rmp1.id = hld1.patron_record_id
LEFT JOIN
  sierra_view.record_metadata                           AS rmp2
  ON
  rmp2.id = hld2.patron_record_id
LEFT JOIN
  sierra_view.location_myuser                           AS pulnam1
  ON
  pulnam1.code = hld1.pickup_location_code
LEFT JOIN
  sierra_view.location_myuser                           AS pulnam2
  ON
  pulnam2.code = hld2.pickup_location_code
WHERE
  bil.bib_record_id IN (

    -- Here we select BIB RECORD IDs from internal
    -- select that have only one attached item record
    SELECT
      s2_bil.bib_record_id
    FROM
      sierra_view.bib_record_item_record_link           AS s2_bil
    WHERE
      s2_bil.bib_record_id IN (

        -- Here we select the PARENT BIB RECORD IDs 
        -- for ITEM RECORD HOLDS where item is missing 
        SELECT
          s1_bil.bib_record_id
        FROM
          sierra_view.hold                              As s1_hld
        JOIN
          sierra_view.item_record                       AS s1_i
          ON
          s1_i.record_id = s1_hld.record_id
          AND
          -- Change this code if it's not your
          -- MISSING code
          s1_i.item_status_code = 'm'
        JOIN
          sierra_view.bib_record_item_record_link       AS s1_bil
          ON
          s1_bil.item_record_id = s1_hld.record_id

      )
    GROUP BY
      s2_bil.bib_record_id
    HAVING
      -- Only one item record is attached
      COUNT(s2_bil.item_record_id) = 1

  )
  OR
  bil.bib_record_id IN (

    -- Here we select BIB RECORD IDs from internal
    -- select where where attached item is missing
    SELECT
      s4_bil.bib_record_id
    FROM
      sierra_view.bib_record_item_record_link           AS s4_bil
    JOIN
      sierra_view.item_record                           AS s4_i
      ON
      s4_i.record_id = s4_bil.item_record_id
    WHERE
      s4_bil.bib_record_id IN (

        -- Here we select BIB RECORD IDs from 
        -- BIB RECORD HOLDS where the bib has 
        -- only one attached item record
        SELECT
          s3_bil.bib_record_id
        FROM
          sierra_view.hold                              AS s3_hld
        JOIN
          sierra_view.bib_record_item_record_link       AS s3_bil
          ON
          s3_bil.bib_record_id = s3_hld.record_id
        GROUP By
          s3_bil.bib_record_id
        HAVING
          -- Only one item record is attached
          COUNT(s3_bil.item_record_id) = 1

      )
      AND
      -- Change this code if it's not your
      -- MISSING code
      s4_i.item_status_code = 'm'

  )
;