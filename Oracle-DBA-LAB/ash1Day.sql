set verify off
set lines 400
set echo off

PROMPT LAST 15 MIN
PROMPT #######################################################################################################

@ashtop session_state,event,sql_id "session_type='FOREGROUND' "  sysdate-1/24/4 sysdate
@ashtop event2 "session_type='FOREGROUND' " sysdate-1/24/4 sysdate
@ashtop sql_id "session_type='FOREGROUND' "  sysdate-1/24/4 sysdate
@ashtop module "session_type='FOREGROUND' "  sysdate-1/24/4 sysdate
@ashtop module,sql_id "session_type='FOREGROUND' " sysdate-1/24/4 sysdate
@ashtop program,sql_id "session_type='FOREGROUND' "  sysdate-1/24/4 sysdate


PROMPT LAST 1 Hour
PROMPT #######################################################################################################

@ashtop session_state,event,sql_id "session_type='FOREGROUND' "  sysdate-1/24 sysdate
@ashtop event2 "session_type='FOREGROUND' " sysdate-1/24 sysdate
@ashtop sql_id "session_type='FOREGROUND' "  sysdate-1/24 sysdate
@ashtop module "session_type='FOREGROUND' "  sysdate-1/24 sysdate
@ashtop module,sql_id "session_type='FOREGROUND' " sysdate-1/24 sysdate
@ashtop program,sql_id "session_type='FOREGROUND' "  sysdate-1/24 sysdate

PROMPT LAST 4 HOURS
PROMPT #######################################################################################################

@ashtop session_state,event,sql_id "session_type='FOREGROUND' "  sysdate-1/6 sysdate
@ashtop event2 "session_type='FOREGROUND' " sysdate-1/6 sysdate
@ashtop sql_id "session_type='FOREGROUND' "  sysdate-1/6 sysdate
@ashtop module "session_type='FOREGROUND' "  sysdate-1/6 sysdate
@ashtop module,sql_id "session_type='FOREGROUND' " sysdate-1/6 sysdate
@ashtop program,sql_id "session_type='FOREGROUND' "  sysdate-1/6 sysdate

PROMPT LAST 1 Day
PROMPT #######################################################################################################

@ashtop session_state,event,sql_id "session_type='FOREGROUND' "  sysdate-1 sysdate
@ashtop event2 "session_type='FOREGROUND' " sysdate-1 sysdate
@ashtop sql_id "session_type='FOREGROUND' "  sysdate-1 sysdate
@ashtop module "session_type='FOREGROUND' "  sysdate-1 sysdate
@ashtop module,sql_id "session_type='FOREGROUND' " sysdate-1 sysdate
@ashtop program,sql_id "session_type='FOREGROUND' "  sysdate-1 sysdate

