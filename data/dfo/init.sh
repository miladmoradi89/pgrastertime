cat  ../../sql/dfo_add_conformance_band.sql ../../sql/dfo_add_shoal_geom.sql ../../sql/dfo_calculate_tile_extents.sql ../../sql/dfo_calculate_tile_geoms.sql ../../sql/dfo_delete_empty_tiles.sql ../../sql/dfo_merge_bands.sql ../../sql/dfo_metadata.sql ../../sql/dfo_most_recent.sql ../../sql/dfoTables/parent.sql ../../sql/dfoTables/25cm.sql ../../sql/dfoTables/50cm.sql ../../sql/dfoTables/1m.sql ../../sql/dfoTables/2m.sql ../../sql/dfoTables/4m.sql ../../sql/dfoTables/8m.sql ../../sql/dfoTables/16m.sql ../../sql/init_exta.sql  | psql pgrt -U loader -1 -f -
