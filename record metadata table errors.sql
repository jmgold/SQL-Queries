--Query shared by Jim Nicholls on Sierra list 3/24/17
--Checks for record_metadata entries that failed to update

SELECT item_record.record_id,
           record_metadata.record_num,
           record_metadata.num_revisions,
           record_metadata.creation_date_gmt,
           record_metadata.record_last_updated_gmt,
           record_metadata.previous_last_updated_gmt
      FROM sierra_view.item_record
           JOIN sierra_view.record_metadata USING ( id )
           LEFT JOIN sierra_view.item_record_property ON ( item_record_id = item_record.id )
     WHERE deletion_date_gmt IS NULL
           AND item_record_property.id IS NULL