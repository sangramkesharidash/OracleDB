set verify off
set pagesize 100

PROMPT #####################################################################
PROMPT #
PROMPT # My ASH 2 DASH Events Report 1.0
PROMPT # This script is using TanelPoder's Script ashtop and dashtop
PROMPT # Download ashtop and dashtop from 
PROMPT # https://blog.tanelpoder.com/files/
PROMPT #
PROMPT # By : Sangram Keshari Dash
PROMPT #####################################################################

PROMPT #####################################################################
PROMPT LAST 1 MIN
@ashtop session_state,event "session_type='FOREGROUND'" sysdate-1/24/60 sysdate
PROMPT #####################################################################
PROMPT LAST 5 MIN
@ashtop session_state,event "session_type='FOREGROUND'" sysdate-1/24/12 sysdate
PROMPT #####################################################################
PROMPT LAST 15 MIN
@ashtop session_state,event "session_type='FOREGROUND'" sysdate-1/24/4 sysdate
PROMPT #####################################################################
PROMPT LAST 30 MIN
@ashtop session_state,event "session_type='FOREGROUND'" sysdate-1/24/2 sysdate
PROMPT #####################################################################
PROMPT LAST 1 Hour
@ashtop session_state,event "session_type='FOREGROUND'" sysdate-1/24 sysdate
PROMPT #####################################################################
PROMPT LAST 1 DAY
@dashtop session_state,event "session_type='FOREGROUND'" sysdate-1 sysdate
PROMPT #####################################################################
PROMPT LAST 7 DAYS
@dashtop session_state,event "session_type='FOREGROUND'" sysdate-7 sysdate
PROMPT #####################################################################