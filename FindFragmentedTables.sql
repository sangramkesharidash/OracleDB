-- To check Fragmented Tables and Indexes
-- version 1 27-1-2021 -- From OPERA SCHEMA Tables and Indexes included
--REF
-- https://asktom.oracle.com/pls/apex/f?p=100:11:::::P11_QUESTION_ID:9542632500346189789



-- Basic details
set lines 400
set verify off

PROMPT select count(*) from dba_tables;
select count(*) from dba_tables;

PROMPT DB SIZE From dba_data_files
select sum(bytes)/1024/1024/1024 "GB" from dba_data_files;

PROMPT DB SIZE From dba_segements
select sum(bytes)/1024/1024/1024 "GB" from dba_segments ;



PROMPT FOR TOP 50 TABLES By SIZE


PROMPT METHOD-1

set lines 400
set verify OFF

col OWNER for a30
col TABLE_NAME for a40

select * from (
select owner,table_name,round((blocks*8),2) "SIZE_KB" ,
round((num_rows*avg_row_len/1024),2) "ACTUAL_DATA_KB",
(round((blocks*8),2) - round((num_rows*avg_row_len/1024),2)) "WASTED_SPACE_KB",
((round((blocks * 8), 2) - round((num_rows * avg_row_len / 1024), 2)) /round((blocks * 8), 2)) * 100 - 10 "RECLAIMABLE_SPACE_PCT"
from dba_tables
--where owner in ('&SCHEMA_NAME' ) and (round((blocks*8),2) > round((num_rows*avg_row_len/1024),2))
where owner in ('OPERA' ) and (round((blocks*8),2) > round((num_rows*avg_row_len/1024),2))
order by 5 desc ) where rownum < 51 order by 6 DESC;


===========================================================

PROMPT METHOD-2

select 
TBLSEGTOP100.OWNER,
TBLSEGTOP100.TABLE_NAME,
TBLDFRAGTOP100.NUM_ROWS,
TBLSEGTOP100.SEG_SIZE_GB,
TBLDFRAGTOP100.TBLBLK_SIZE_GB,
TBLDFRAGTOP100.AVGRL_ACTUAL_DATA_GB,
TBLDFRAGTOP100.WASTED_SPACE_GB,
TBLDFRAGTOP100.RECLAIMABLE_SPACE_PCT
FROM
(
select OWNER,SEGMENT_NAME "TABLE_NAME",sum(bytes)/1024/1024/1024 "SEG_SIZE_GB"
from dba_segments
where SEGMENT_TYPE='TABLE' and OWNER='OPERA'
group by OWNER,SEGMENT_NAME
order by 3 DESC 
FETCH NEXT 100 ROWS ONLY
) TBLSEGTOP100, 
(
select owner,table_name,NUM_ROWS,TBLBLK_SIZE_GB,AVGRL_ACTUAL_DATA_GB, 
TBLBLK_SIZE_GB-AVGRL_ACTUAL_DATA_GB "WASTED_SPACE_GB",
((TBLBLK_SIZE_GB-AVGRL_ACTUAL_DATA_GB)/TBLBLK_SIZE_GB)* 100 "RECLAIMABLE_SPACE_PCT"
FROM
(
select owner,table_name,
(blocks*8)/1024/1024 "TBLBLK_SIZE_GB" ,
(num_rows*avg_row_len)/1024/1024/1024 "AVGRL_ACTUAL_DATA_GB",
num_rows
from dba_tables
where owner in ('OPERA' ) and num_rows is NOT NULL and blocks is NOT NULL
order by 3 DESC
FETCH NEXT 100 ROWS ONLY
)
) TBLDFRAGTOP100
where 
TBLSEGTOP100.OWNER = TBLDFRAGTOP100.OWNER and
TBLSEGTOP100.TABLE_NAME = TBLDFRAGTOP100.TABLE_NAME
FETCH NEXT 50 ROWS ONLY;











