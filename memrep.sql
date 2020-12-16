PROMPT memrep v1 2017

set lines 400


PROMPT ************************************************
PROMPT Display v$sga_dynamic_components -- displays information about the dynamic SGA components
PROMPT ************************************************

select
   component,
   current_size/1024/1024        "CURRENT_SIZE_MB",
   min_size/1024/1024            "MIN_SIZE_MB",
MAX_SIZE/1024/1024  		"MAX_SIZE_MB",
   user_specified_size/1024/1024 "USER_SPECIFIED_SIZE_MB",
   last_oper_type                 "TYPE",
LAST_OPER_MODE,
LAST_OPER_TIME,
GRANULE_SIZE
from
   v$sga_dynamic_components	;

PROMPT ************************************************
PROMPT Display v$sgastat -- displays detailed information on the system global area
PROMPT ************************************************
select POOL, sum(BYTES)/1024/1024 "IN_MB" from v$sgastat group by pool;


select name, BYTES/1024/1024 "IN_MB", RESIZEABLE from v$sgainfo;


PROMPT ************************************************
PROMPT Display BUFFER pool advice
PROMPT ************************************************



COLUMN size_for_estimate FORMAT 999,999,999,999 HEADING 'Cache Size (MB)'
COLUMN buffers_for_estimate FORMAT 999,999,999 HEADING 'Buffers'
COLUMN estd_physical_read_factor FORMAT 999.90 HEADING 'Estd Phys|Read Factor'
COLUMN estd_physical_reads FORMAT 999,999,999 HEADING 'Estd Phys| Reads'

SELECT size_for_estimate, buffers_for_estimate,
       estd_physical_read_factor, estd_physical_reads
  FROM v$db_cache_advice
  WHERE name          = 'DEFAULT'
  AND block_size    = (SELECT value FROM v$parameter 
  WHERE name = 'db_block_size')
  AND advice_status = 'ON';



PROMPT ************************************************
PROMPT Display shared pool advice
PROMPT ************************************************
 
set lines  100
set pages  999
 
column        c1     heading 'Pool |Size(M)'
column        c2     heading 'Size|Factor'
column        c3     heading 'Est|LC(M)  '
column        c4     heading 'Est LC|Mem. Obj.'
column        c5     heading 'Est|Time|Saved|(sec)'
column        c6     heading 'Est|Parse|Saved|Factor'
column c7     heading 'Est|Object Hits'   format 999,999,999
 
 
SELECT
   shared_pool_size_for_estimate  c1,
   shared_pool_size_factor        c2,
   estd_lc_size                   c3,
   estd_lc_memory_objects         c4,
   estd_lc_time_saved                    c5,
   estd_lc_time_saved_factor             c6,
   estd_lc_memory_object_hits            c7
FROM
   v$shared_pool_advice;



set lines 400

select * from v$pga_target_advice;
select * from v$sga_target_advice;
SELECT ROUND(SUM(pga_used_mem)/(1024*1024),2) PGA_USED_MB FROM v$process;	
