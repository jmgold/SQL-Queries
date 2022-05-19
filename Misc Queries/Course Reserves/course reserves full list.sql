-- =============================================================================
-- Course Reserves List
-- B.Searle. Langara College. 2017-05-23
-- =============================================================================
(
  -- Select item records on Course Reserve
  SELECT
    -- Build course record number with wildcard check digit
    concat(
      rmr.record_type_code,
      rmr.record_num,
      'a'
    )                                                      AS "Course Number",
    vfrr.field_content                                     As "Course Name",
    vfrp.field_content                                     As "Instructor",
    rlocnam.name                                           AS "Course Location",
    DATE(r.begin_date)                                     AS "Start Date",
    DATE(r.end_date)                                       AS "End Date",
    rilink.items_display_order                             AS "Display Order",
    bprop.best_title                                       AS "Title",
    bprop.best_author                                      AS "Author",
    mtnam.name                                             AS "Material Type",
    -- use item call number if it exists.
    -- otherwise use bib call number
    CASE
      WHEN iprop.call_number IS NULL
      THEN TRIM(regexp_replace(vfbc.field_content,'\|.',' ','g'))
      ELSE TRIM(regexp_replace(iprop.call_number,'\|.',' ','g'))
    END                                                    AS "Call Number",
    concat(
      'c.',
      i.copy_num
    )                                                      AS "Copy Num",
    iprop.barcode                                          AS "Barcode",
    CASE
      WHEN rilink.status_code = 'a' THEN 'Active'
      WHEN rilink.status_code = 'i' THEN 'Inactive'
      ELSE 'unexpected code '||rilink.status_code
    END                                                    AS "Status",
    DATE(rilink.status_change_date)                        AS "Until",
    ilocnam.name                                           AS "Location",
    i.checkout_total                                       AS "Total CKO",
    i.renewal_total                                        As "Total Renewal",
    i.year_to_date_checkout_total                          AS "YTD CKO",
    i.last_year_to_date_checkout_total                     AS "LYR CKO"
  FROM
    sierra_view.course_record                              AS r
  JOIN
    sierra_view.record_metadata                            AS rmr
    ON
    rmr.id = r.record_id
  JOIN
    sierra_view.location_myuser                            AS rlocnam
    ON
    rlocnam.code = r.location_code
  LEFT JOIN
    sierra_view.varfield                                   AS vfrr
    ON
    vfrr.record_id = r.record_id
    AND
    vfrr.varfield_type_code = 'r'
    AND
    vfrr.occ_num = 0
  LEFT JOIN
    sierra_view.varfield                                   AS vfrp
    ON
    vfrp.record_id = r.record_id
    AND
    vfrp.varfield_type_code = 'p'
    AND
    vfrp.occ_num = 0
  JOIN
    sierra_view.course_record_item_record_link             AS rilink
    ON
    rilink.course_record_id = r.record_id
  JOIN
    sierra_view.item_record                                AS i
    ON
    i.record_id = rilink.item_record_id
  JOIN
    sierra_view.item_record_property                       As iprop
    ON
    iprop.item_record_id = rilink.item_record_id
  JOIN
    sierra_view.location_myuser                            AS ilocnam
    ON
    ilocnam.code = i.location_code
  JOIN
    sierra_view.bib_record_item_record_link                AS bilink
    ON
    bilink.item_record_id = rilink.item_record_id
  JOIN
    sierra_view.bib_record_property                        AS bprop
    ON
    bprop.bib_record_id = bilink.bib_record_id
  LEFT JOIN
    sierra_view.varfield                                   AS vfbc
    ON
    vfbc.record_id = bilink.bib_record_id
    AND
    vfbc.varfield_type_code = 'c'
    AND
    vfbc.marc_tag = '090'
    AND
    vfbc.occ_num = 0
  JOIN
    sierra_view.material_property_myuser                   AS mtnam
    ON
    mtnam.code = bprop.material_code
  WHERE
    r.is_suppressed IS FALSE
    AND
    rmr.deletion_date_gmt IS NULL
)

UNION -- merge preceding and following queries, removing duplicate rows

(
  -- Select Bib records on Course Reserve
  SELECT
    -- Build course record number with wildcard check digit
    concat(
      rmr.record_type_code,
      rmr.record_num,
      'a'
    )                                                      AS "Course Number",
    vfrr.field_content                                     As "Course Name",
    vfrp.field_content                                     As "Instructor",
    rlocnam.name                                           AS "Course Location",
    DATE(r.begin_date)                                     AS "Start Date",
    DATE(r.end_date)                                       AS "End Date",
    rblink.bibs_display_order                              AS "Display Order",
    bprop.best_title                                       AS "Title",
    bprop.best_author                                      AS "Author",
    mtnam.name                                             AS "Material Type",
    TRIM(regexp_replace(vfbc.field_content,'\|.',' ','g')) AS "Call Number",
    ' '                                                    AS "Copy Num",
    ' '                                                    AS "Barcode",
    CASE
      WHEN rblink.status_code = 'a' THEN 'Active/Bib'
      WHEN rblink.status_code = 'i' THEN 'Inactive/Bib'
      ELSE 'unexpected code '||rblink.status_code
    END                                                    AS "Status",
    DATE(rblink.status_change_date)                        AS "Until",
    blocnam.name                                           AS "Location",
    SUM(i.checkout_total)                                  AS "Total CKO",
    SUM(i.renewal_total)                                   As "Total Renewal",
    SUM(i.year_to_date_checkout_total)                     AS "YTD CKO",
    SUM(i.last_year_to_date_checkout_total)                AS "LYR CKO"
  FROM
    sierra_view.course_record                              AS r
  JOIN
    sierra_view.record_metadata                            AS rmr
    ON
    rmr.id = r.record_id
  JOIN
    sierra_view.location_myuser                            AS rlocnam
    ON
    rlocnam.code = r.location_code
  LEFT JOIN
    sierra_view.varfield                                   AS vfrr
    ON
    vfrr.record_id = r.record_id
    AND
    vfrr.varfield_type_code = 'r'
    AND
    vfrr.occ_num = 0
  LEFT JOIN
    sierra_view.varfield                                   AS vfrp
    ON
    vfrp.record_id = r.record_id
    AND
    vfrp.varfield_type_code = 'p'
    AND
    vfrp.occ_num = 0
  JOIN
    sierra_view.course_record_bib_record_link              AS rblink
    ON
    rblink.course_record_id = r.record_id
  JOIN
    sierra_view.bib_record_property                        AS bprop
    ON
    bprop.bib_record_id = rblink.bib_record_id
  JOIN
    sierra_view.material_property_myuser                   AS mtnam
    ON
    mtnam.code = bprop.material_code
  LEFT JOIN
    sierra_view.varfield                                   AS vfbc
    ON
    vfbc.record_id = rblink.bib_record_id
    AND
    vfbc.varfield_type_code = 'c'
    AND
    vfbc.marc_tag = '090'
    AND
    vfbc.occ_num = 0
  LEFT JOIN
    sierra_view.bib_record_item_record_link                AS bilink
    ON
    bilink.bib_record_id = rblink.bib_record_id
  LEFT JOIN
    sierra_view.item_record                                AS i
    ON
    i.record_id = bilink.item_record_id
  LEFT JOIN
    sierra_view.location_myuser                            AS blocnam
    ON
    bilink.items_display_order = 0
    AND
    blocnam.code = i.location_code
  LEFT JOIN
    sierra_view.item_record_property                       As iprop
    ON
    iprop.item_record_id = bilink.item_record_id
  WHERE
    r.is_suppressed IS FALSE
    AND
    rmr.deletion_date_gmt IS NULL
  -- GROUP and total checkouts/renewals for all attached items
  GROUP BY -- columns to group totals by
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
)
-- sort all by specified columns
ORDER BY
  2,3,7
;