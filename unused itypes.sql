-- ==================================================================

-- SELECT Item Type Codes that are not being used for any items

-- Brent Searle. Langara College. 2016-07-06

-- ==================================================================

SELECT

  itprop.code_num                        AS "Itype Code",

  itname.name                            AS "Itype Name",

  SUM (

    CASE

      WHEN i.itype_code_num IS NULL THEN 0

      ELSE 1

    END

  )                                      AS "Item Count"

FROM

  sierra_view.itype_property             AS itprop

JOIN

  sierra_view.itype_property_name        AS itname

  ON

  itname.itype_property_id = itprop.id

  AND

  -- Code description is in English.

  -- Change the language code number

  -- for code descriptions in other

  -- languages in your system

  itname.iii_language_id = '1'

LEFT JOIN

  sierra_view.item_record                AS i

  ON

  i.itype_code_num = itprop.code_num

GROUP BY

  -- group by columns 1 and 2

  1,2 

HAVING

  -- limit result to codes that are

  -- not currently in use by item records

  SUM(

    CASE

      WHEN i.itype_code_num IS NULL THEN 0

      ELSE 1

    END

  ) = 0

ORDER BY

  -- sort by itype code

  itprop.code_num

;
