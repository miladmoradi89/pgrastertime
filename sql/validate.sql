SELECT 'Space disk use ' ||  pg_size_pretty(pg_total_relation_size(C.oid)) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE relname='pgrastertime';

select 'The pgrastertime table containe ' || count(*) || ' rows' as nb_rows from wis.pgrastertime;
select 'The pgrastertime table containe ' || count(distinct(objnam)) || ' objnam(xml files) in it.' from wis.pgrastertime_metadata;
WITH
  o as (SELECT distinct(objnam) as objnam FROM wis.pgrastertime_metadata),
  s as (
SELECT 7 as res, count(o.objnam) || ' rows deploy in soundings_16m' as cnt FROM o, soundings_16m s WHERE s.metadata_id = o.objnam
union
SELECT 6 as res, count(o.objnam) || ' rows deploy in soundings_8m' as cnt FROM o, soundings_8m s WHERE s.metadata_id = o.objnam
union
SELECT 5 as res,count(o.objnam) || ' rows deploy in soundings_4m' as cnt FROM o, soundings_4m s WHERE s.metadata_id = o.objnam
union
SELECT 4 as res,count(o.objnam) || ' rows deploy in soundings_2m' as cnt FROM o, soundings_2m s WHERE s.metadata_id = o.objnam
union
SELECT 3 as res,count(o.objnam) || ' rows deploy in soundings_1m' as cnt FROM o, soundings_1m s WHERE s.metadata_id = o.objnam
ORDER by res)
SELECT s.cnt from s;
WITH
i as (
	select 7 as res, count(*) || ' rows invalidate in soundings_16m' as cnt from soundings_16m s where metadata_id IN (SELECT distinct(objnam) as objnam FROM pgrastertime_metadata) and upper (sys_period) is not null
	union
	select 6 as res, count(*) || ' rows invalidate in soundings_8m' as cnt from soundings_8m s where metadata_id IN (SELECT distinct(objnam) as objnam FROM pgrastertime_metadata) and upper (sys_period) is not null
	union
	select 5 as res, count(*) || ' rows invalidate in soundings_4m' as cnt from soundings_4m s where metadata_id IN (SELECT distinct(objnam) as objnam FROM pgrastertime_metadata) and upper (sys_period) is not null
	union
	select 4 as res, count(*) || ' rows invalidate in soundings_2m' as cnt from soundings_2m s where metadata_id IN (SELECT distinct(objnam) as objnam FROM pgrastertime_metadata) and upper (sys_period) is not null
	union
	select 3 as res, count(*) || ' rows invalidate in soundings_1m' as cnt from soundings_1m s where metadata_id IN (SELECT distinct(objnam) as objnam FROM pgrastertime_metadata) and upper (sys_period) is not null
)SELECT cnt from i order by res;
