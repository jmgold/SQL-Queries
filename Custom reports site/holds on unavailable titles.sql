SELECT
  CASE
    WHEN rmbi.record_num IS NULL
    THEN rmbb.record_type_code||rmbb.record_num||'a'
    ELSE rmbi.record_type_code||rmbi.record_num||'a'
  END                                                        AS bib_number,
  CASE
    WHEN bpropb.best_title IS NULL
    THEN bpropi.best_title
    ELSE bpropb.best_title
  END                                                        AS title,
  CASE
    WHEN mattypb.name IS NULL
    THEN mattypi.name
    ELSE mattypb.name
  END                                                        AS mat_type,
  concat(
    rmp.record_type_code,
    rmp.record_num,
    'a'
  )                                                          AS patron_number,
  CASE
    WHEN bpropb.bib_record_id IS NULL
    THEN 'Item'
    ELSE 'Bib'
  END                                                        AS hold_type,
  DATE(hld.placed_gmt)                                       AS date_placed,
  CASE
    WHEN hld.is_frozen IS FALSE THEN 'No'
    WHEN hld.is_frozen IS TRUE THEN 'Yes'
    ELSE ''
  END                                                        AS is_frozen,
  DATE(hld.expires_gmt)                                      AS expiration_date
FROM
  sierra_view.hold                                           AS hld
JOIN
  sierra_view.record_metadata                                AS rmp
  ON
  rmp.id = hld.patron_record_id
JOIN
  sierra_view.location_myuser                                As locnam
  ON
  locnam.code = hld.pickup_location_code
LEFT JOIN
  sierra_view.bib_record_property                            AS bpropb
  ON
  bpropb.bib_record_id = hld.record_id
LEFT JOIN
  sierra_view.record_metadata                                AS rmbb
  ON
  rmbb.id = bpropb.bib_record_id
LEFT JOIN
  sierra_view.material_property_myuser                       AS mattypb
  ON
  mattypb.code = bpropb.material_code
LEFT JOIN
  sierra_view.bib_record_item_record_link                    As bil
  ON
  bil.item_record_id = hld.record_id
LEFT JOIN
  sierra_view.bib_record_property                            AS bpropi
  ON
  bpropi.bib_record_id = bil.bib_record_id
LEFT JOIN
  sierra_view.record_metadata                                AS rmbi
  ON
  rmbi.id = bpropi.bib_record_id
LEFT JOIN
  sierra_view.material_property_myuser                       AS mattypi
  ON
  mattypi.code = bpropi.material_code
WHERE
  hld.pickup_location_code ~ {{location}}
  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
  AND (hld.record_id IN (

    -- Here we select BIB Holds where no attached 
    -- record are available
    SELECT
      s1_hld.record_id
    FROM
      sierra_view.hold                                       AS s1_hld
    JOIN
      sierra_view.bib_record_item_record_link                AS s1_bilb
      ON
      s1_bilb.bib_record_id = s1_hld.record_id
    JOIN
      sierra_view.item_record                                AS s1_i
      ON
      s1_i.record_id = s1_bilb.item_record_id
    GROUP BY
      s1_hld.record_id
    HAVING
      SUM(
        -- Item status codes that are considered unavailable
        -- for holds get '0'. All other item statuses are 
        -- considered available and get '1'
        -- UPDATE THIS LIST TO MATCH YOUR CODES AND NEEDS
        CASE
          WHEN s1_i.item_status_code = '$' THEN 0 -- Lost and Paid
          WHEN s1_i.item_status_code = 'e' THEN 0 -- E-Resource
          WHEN s1_i.item_status_code = 'm' THEN 0 -- Missing
          WHEN s1_i.item_status_code = 'n' THEN 0 -- Billed
          WHEN s1_i.item_status_code = 'o' THEN 0 -- Library Use Only
          WHEN s1_i.item_status_code = 'w' THEN 0 -- Withdrawn
          WHEN s1_i.item_status_code = 'z' THEN 0 -- Claims Returned
          ELSE 1
        END
      ) = 0 -- The number of available items is 0

  )
  OR
  hld.record_id IN (

    -- Here we select Item level holds where 
    -- no item records attached to parent bib
    -- record are available
    SELECT
      s2_hld.record_id
    FROM
      sierra_view.hold                                     As s2_hld
    JOIN
      sierra_view.bib_record_item_record_link              AS s2_bili
      ON
      s2_bili.item_record_id = s2_hld.record_id
    JOIN
      sierra_view.bib_record_item_record_link              AS s2_bilb
      ON
      s2_bilb.bib_record_id = s2_bili.bib_record_id
    JOIN
      sierra_view.item_record                              AS s2_i
      ON
      s2_i.record_id = s2_bilb.item_record_id
    GROUP BY
      s2_hld.record_id
    HAVING
      SUM(
        -- Item status codes that are considered unavailable
        -- for holds get '0'. All other item statuses are 
        -- considered available and get '1'
        -- UPDATE THIS LIST TO MATCH YOUR CODES AND NEEDS
        CASE
          WHEN s2_i.item_status_code = '$' THEN 0 -- Lost and Paid
          WHEN s2_i.item_status_code = 'e' THEN 0 -- E-Resource
          WHEN s2_i.item_status_code = 'm' THEN 0 -- Missing
          WHEN s2_i.item_status_code = 'n' THEN 0 -- Billed
          WHEN s2_i.item_status_code = 'o' THEN 0 -- Library Use Only
          WHEN s2_i.item_status_code = 'w' THEN 0 -- Withdrawn
          WHEN s2_i.item_status_code = 'z' THEN 0 -- Claims Returned
          ELSE 1
        END
      ) = 0 -- The number of available items is 0

  ))
ORDER BY
  CASE
    WHEN bpropb.best_title_norm IS NULL
    THEN bpropi.best_title_norm
    ELSE bpropb.best_title_norm
  END
;
