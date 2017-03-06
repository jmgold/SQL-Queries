-- =========================================================================================
-- Paid Orders Detail (SERIAL NO ENC) for specified Accounting Unit
-- Brent Searle. Langara College Library. 2014-12-17
-- Check digit calculation, Jim Nicholls, University of Sydney
-- =========================================================================================
SELECT DISTINCT
  o.record_type_code||o.record_num||
  COALESCE(                                                    -- Check digit calculation
    CAST(
      NULLIF(
        (
          ( o.record_num % 10 ) * 2 +
          ( o.record_num / 10 % 10 ) * 3 +
          ( o.record_num / 100 % 10 ) * 4 +
          ( o.record_num / 1000 % 10 ) * 5 +
          ( o.record_num / 10000 % 10 ) * 6 +
          ( o.record_num / 100000 % 10 ) * 7 +
          ( o.record_num / 1000000 ) * 8
        ) % 11,
        10
      )
      AS CHAR(1)
    ),
    'x'
  )                                                          AS "Order Number",
  vf.field_content                                           AS "Vendor",
  paid.note                                                  AS "Note",
  ostat.name                                                 AS "Order Status",
  DATE(paid.paid_date_gmt)                                   AS "Paid Date",
  paid.display_order                                         AS "Display Order",
  paid.voucher_num                                           AS "Voucher #",
  paid.invoice_code                                          AS "Invoice #",
  DATE(paid.invoice_date_gmt)                                AS "Invoice Date",
  bprop.best_title                                           AS "Title",
  cmf.copies                                                 AS "Copies Ordered",
  paid.copies                                                AS "Copies Paid",
  to_char(paid.paid_amount,'99,990D00')                      AS "Amount Paid",
  cmf.fund_code                                              AS "Fund Number",
  CASE
    WHEN fundm.code IS NULL THEN 'multi'
    ELSE fundm.code
  END                                                        AS "Fund Code",
  CASE
    WHEN fund.name IS NULL THEN 'multi'
    ELSE fund.name
  END                                                        AS "Fund Name",
  cmf.location_code                                          AS "Location"
FROM
  sierra_view.order_record_paid AS paid
JOIN
  sierra_view.order_view AS o
  ON
  o.record_id = paid.order_record_id
  AND
  o.accounting_unit_code_num = '2'                           -- Join only to orders for Acct Unit 2
  AND
  o.order_status_code = 'f'                                  -- Join only when order status 'f' (SERIAL NO ENC)
JOIN
  sierra_view.order_status_property_myuser        AS ostat
  ON
  ostat.code = o.order_status_code
JOIN
  sierra_view.order_record_cmf AS cmf
  ON
  cmf.order_record_id = paid.order_record_id
  AND
  cmf.display_order = 0                                      -- Join only to top level cmf rows
                                                             -- Ignore sub funds of split orders
LEFT JOIN
  sierra_view.fund_master                         AS fundm
  ON
  fundm.code_num = CAST(cmf.fund_code AS INTEGER)
  AND
  fundm.accounting_unit_id = '2'                             -- Join only to funds for Acct Unit 2
LEFT JOIN
  sierra_view.fund_myuser                         AS fund
  ON
  fund.fund_code = fundm.code
  AND
  fund.acct_unit = '2'                                       -- Join only to funds for Acct Unit 2
  AND
  fund.fund_type = 'fbal'                                    -- Join only to current funds
LEFT JOIN
  sierra_view.bib_record_order_record_link        AS bolink
  ON
  bolink.order_record_id = paid.order_record_id
LEFT JOIN
  sierra_view.bib_record_property                 AS bprop
  ON
  bprop.bib_record_id = bolink.bib_record_id
LEFT JOIN
  sierra_view.vendor_record                       AS v
  ON
  v.code = o.vendor_record_code
  AND
  v.accounting_unit_code_num = '2'                           -- Join only to vendor records for Acct Unit 2
LEFT JOIN
  sierra_view.varfield                            AS vf
  ON
  vf.record_id = v.record_id
  AND
  vf.varfield_type_code = 't'                                -- 't' tagged vendor field for vendor name
  AND
  vf.occ_num = '0'                                           -- Ignore all but 1st occurence of 't' tag
ORDER BY
  1,                                                         -- Order Record Number
  5,                                                         -- Paid Date
  6,                                                         -- paid.display_order
  7                                                          -- Voucher Number
;