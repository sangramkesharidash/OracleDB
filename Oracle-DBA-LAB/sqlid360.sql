PROMPT #####################################################################
PROMPT # https://github.com/sangramkesharidash/OracleDB/blob/master/Oracle-DBA-LAB/
PROMPT # sqlid360 SQL_ID Performance Details
PROMPT # @sqlid360 <sqlid>
PROMPT # 
PROMPT # By : Sangram Keshari Dash
PROMPT #####################################################################



alter session set nls_date_format = 'DD-MON-YYYY hh24:mi:ss';
set verify OFF
set lines 400

col SEGMENT_NAME for a25
col OBJECT_OWNER for a20
col OBJECT_TYPE for a15
col CREATED for a20
col OBJECT_NAME for a25
col TABLE_NAME for a25
col OWNER for a10
col INDEX_NAME for a25
col STALE_STATS for a10
col PARTITIONED for a10
col sql_sql_text head SQL_TEXT format a150 word_wrap
col sql_child_number head CH# for 9999


col cpu_sec_exec   FOR 999999.999
col ela_sec_exec   FOR 999999.999
col lios_per_exec  FOR 9999999999
col pios_per_exec  FOR 9999999999

prompt Show SQL text, child cursors and execution stats for SQLID &1 All child cursor




SELECT module
	,sql_id,child_number
	,plan_hash_value
--	,action
	,trunc(last_active_time) last_active_time
	,sum(rows_processed) rows_processed
	,sum(executions) executions
	,sum(elapsed_time) elapsed_time
	,round(((sum(elapsed_time) / sum(executions)) / 1000000), 2) elapased_total_by_execution
FROM gv$sql
WHERE executions > 0
--	AND module LIKE 'BIPublisher_NOC Requirement_report.xdo'
--	AND sql_text LIKE '%optimizer_features_enable%_optimizer_use_feedback%GATHER_PLAN_STATISTICS%'
--and sql_text like '%NOC_Data_Data_Model_NOC_Requirement%' and sql_text like '%10NOV2020_f6nsgd6g5p0v7%'
and sql_id='&1'
--and module='BIPSR'
GROUP BY module
	,sql_id,child_number
	,trunc(last_active_time)
	,plan_hash_value
	,action
--ORDER BY trunc(last_active_time) DESC;
order by ELAPASED_TOTAL_BY_EXECUTION;

select 
	hash_value,
	plan_hash_value,
	child_number	sql_child_number,
	sql_text sql_sql_text
from 
	v$sql 
where 
	sql_id = ('&1')
order by
	sql_id,
	hash_value,
	child_number
/

alter session set nls_date_format = 'DD-MON-YYYY hh24:mi:ss';

col FIRST_LOAD_TIME for a25
col LAST_ACTIVE_TIME for a25
select 
	child_number	sql_child_number,
	plan_hash_value plan_hash,
	parse_calls parses,
	loads h_parses,
	executions,
	rows_processed,
  rows_processed/nullif(fetches,0) rows_per_fetch,
	ROUND(cpu_time/NULLIF(executions,0)/1000000,3)     cpu_sec_PerExec,
	ROUND(elapsed_time/NULLIF(executions,0)/1000000,3) ela_sec_PerExec,
	ROUND(buffer_gets/NULLIF(executions,0),3)  lios_per_exec,
	ROUND(disk_reads/NULLIF(executions,0),3)   pios_per_exec,
	ROUND(cpu_time/1000000,3) total_cpu_sec,
	ROUND(elapsed_time/1000000,3) total_ela_sec,
  user_io_wait_time/1000000 total_iowait_sec,
	buffer_gets total_LIOS,
	disk_reads total_pios,sorts,DIRECT_READS
--	address,
--	sharable_mem,
--	persistent_mem,
--	runtime_mem,
--   , PHYSICAL_READ_REQUESTS         
--   , PHYSICAL_READ_BYTES            
--   , PHYSICAL_WRITE_REQUESTS        
--   , PHYSICAL_WRITE_BYTES           
--   , IO_CELL_OFFLOAD_ELIGIBLE_BYTES 
--   , IO_INTERCONNECT_BYTES          
--   , IO_CELL_UNCOMPRESSED_BYTES     
--   , IO_CELL_OFFLOAD_RETURNED_BYTES 
--	, address		parent_handle
--	, child_address   object_handle
from v$sql
where sql_id = ('&1')
order by
	sql_id,
	hash_value,
	child_number
/

col SQL_PROFILE for a10
col SQL_PATCH for a10
col SQL_PLAN_BASELINE for a15
col SERVICE for a35
select 
	child_number	sql_child_number,
	plan_hash_value plan_hash,
	parse_calls parses,
	loads hard_parses,
	executions,INVALIDATIONS
	fetches, FIRST_LOAD_TIME,LAST_LOAD_TIME,last_active_time,SERVICE,IS_BIND_SENSITIVE,IS_BIND_AWARE,IS_SHAREABLE,SQL_PROFILE,SQL_PATCH,SQL_PLAN_BASELINE
from v$sql
where sql_id = ('&1')
order by
	sql_id,
	hash_value,
	child_number
/






PROMPT "ALL OBJECTS USED in SQL"


select p.sql_id,p.OBJECT_OWNER,p.OBJECT_NAME,p.OBJECT_TYPE,p.OBJECT#,o.OBJECT_ID,o.OBJECT_TYPE,o.CREATED,o.STATUS
FROM V$SQL_PLAN p,ALL_OBJECTS o
where p.OBJECT#=o.OBJECT_ID
and p.SQL_ID='&1'
order by o.OBJECT_TYPE;

PROMPT "ALL TABLE USED in SQL"

select distinct s.SEGMENT_NAME "SEGMENT_NAME", s.SIZE_IN_MB "SIZE_MB", t.table_name "table_name", t.GLOBAL_STATS "GLOBAL_STATS",t.USER_STATS "USER_STATS", t.LAST_ANALYZED "LAST_ANALYZED", t.NUM_ROWS, t.PARTITIONED "PARTITIONED", st.STALE_STATS "STALE_STATS",st.owner
from dba_tables t,dba_tab_statistics st,
(
select SEGMENT_NAME,sum(bytes)/1024/1024 "SIZE_IN_MB" from dba_segments where SEGMENT_NAME in
 (
select p.OBJECT_NAME
FROM V$SQL_PLAN p,ALL_OBJECTS o
where p.OBJECT#=o.OBJECT_ID and o.OBJECT_TYPE like '%TABLE%'
and p.SQL_ID='&1'
 ) group by SEGMENT_NAME 
) s
where st.table_name=s.SEGMENT_NAME and t.table_name=s.SEGMENT_NAME 
order by 6 DESC
/

PROMPT "ALL INDEX USED in SQL "

select distinct s.SEGMENT_NAME "SEGMENT_NAME", s.SIZE_IN_MB "SIZE_MB", t.table_name "TABLE_NAME",t.index_name "INDEX_NAME", t.GLOBAL_STATS "GLOBAL_STATS",t.USER_STATS "USER_STATS", t.LAST_ANALYZED "LAST_ANALYZED", t.NUM_ROWS, t.PARTITIONED "PARTITIONED", st.STALE_STATS "STALE_STATS",st.owner
from dba_indexes t,dba_ind_statistics st,
(
select SEGMENT_NAME,sum(bytes)/1024/1024 "SIZE_IN_MB" from dba_segments where SEGMENT_NAME in
 (
select p.OBJECT_NAME
FROM V$SQL_PLAN p,ALL_OBJECTS o
where p.OBJECT#=o.OBJECT_ID and o.OBJECT_TYPE like '%INDEX%'
and p.SQL_ID='&1'
 ) group by SEGMENT_NAME 
) s
where st.index_name=s.SEGMENT_NAME and t.index_name=s.SEGMENT_NAME 
order by 6 DESC
/

PROMPT "HISTORICAL RUN ELAPSED TIME of SQL "

set lines 155
col execs for 999,999,999
col avg_etime for 999,999.999
col avg_lio for 999,999,999.9
col begin_interval_time for a30
col node for 99999
break on plan_hash_value on startup_time skip 1
select ss.snap_id, ss.instance_number node, begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id  ='&1'
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and executions_delta > 0
order by 1, 2, 3
/