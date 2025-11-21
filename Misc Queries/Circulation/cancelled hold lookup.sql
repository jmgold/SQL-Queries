/*
Jeremy Goldstein
Minuteman Library Network

Search for any cancelled holds on a given item, and their associated patron
when you have an item barcode and cancelled date
*/

SELECT
  p.barcode AS patron_barcode,
  p.record_type_code||p.record_num||
  COALESCE(
    CAST(
      NULLIF(
        (
           ( p.record_num % 10 ) * 2 +
           ( p.record_num / 10 % 10 ) * 3 +
           ( p.record_num / 100 % 10 ) * 4 +
           ( p.record_num / 1000 % 10 ) * 5 +
           ( p.record_num / 10000 % 10 ) * 6 +
           ( p.record_num / 100000 % 10 ) * 7 +
           ( p.record_num / 1000000 % 10  ) * 8 +
           ( p.record_num / 10000000 ) * 9
         ) % 11,
         10
      )
    AS CHAR(1))
  ,'x') AS pnumber,
  h.pickup_location_code,
  h.placed_gmt::DATE AS hold_placed,
  h.expires_gmt::DATE AS hold_expires,
  h.is_frozen,
  CASE
	 WHEN h.status = '0' THEN 'on hold'
	 WHEN h.status = 't' THEN 'in transit'
	 ELSE 'on holdshelf'
  END AS hold_status,
  COALESCE(TO_CHAR(h.on_holdshelf_gmt,'YYYY-mm-dd'),'N/A') AS on_holdshelf,
  COALESCE(TO_CHAR(h.expire_holdshelf_gmt,'YYYY-mm-dd'),'N/A') AS expire_holdshelf,
  CASE
	 WHEN h.holdshelf_status = 'c' THEN 'cancelled'
	 WHEN h.holdshelf_status = 'p' THEN 'picked up'
	 ELSE 'N/A'
  END AS holdshelf_status,
  h.removed_gmt AS removed,
  COALESCE(SPLIT_PART(h.removed_by_user,'/',1),'N/A') AS login,
  TRIM(SPLIT_PART(h.removed_by_program,' ',1)) AS program

FROM sierra_view.hold_removed h
JOIN sierra_view.record_metadata rm
  ON h.record_id = rm.id
JOIN sierra_view.bib_record_item_record_link l
  ON rm.id = l.item_record_id
  OR rm.id = l.bib_record_id
JOIN sierra_view.item_record_property ip
  ON l.item_record_id = ip.item_record_id
JOIN sierra_view.patron_view p
  ON h.patron_record_id = p.id

WHERE ip.barcode = '34863008575707'
  AND h.removed_gmt::DATE = '2025-10-21'