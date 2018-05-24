PROMPT eventserach.sql

set lines 400
col DISPLAY_NAME for a40
col EVENT_NAME for a40
col PARAMETER1 for a10
col PARAMETER2 for a30
col PARAMETER3 for a30
col WAIT_CLASS for a15

col NAME for 30
select WAIT_CLASS,DISPLAY_NAME,NAME EVENT_NAME,PARAMETER1,PARAMETER2,PARAMETER3 from v$event_name where NAME like '%&1%' ;


