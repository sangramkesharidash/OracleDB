-----------------------------------------------------------------------
-- AWR Generation Through BASH and PLSQL
-- By Sangram Keshari Dash
-- version 2.1 --Last Updated on 26 FEB 2020
-- sangramAWR_v2.sql
-- Need to be checked the reason of *** ORA-20019: 30353 is not a valid snapshot ID for database 986240895.
-- grep podName /var/mcollective/facts.yaml | awk '{print $2}'
-----------------------------------------------------------------------
VARIABLE sql_dbid NUMBER
VARIABLE sql_beginsnapid NUMBER
VARIABLE sql_endsnapid NUMBER
DECLARE
plsql_dbid v$database.dbid%TYPE;
plsql_instance_number  v$instance.instance_number%TYPE;
plsql_max_snap DBA_HIST_SNAPSHOT.SNAP_ID%TYPE;
plsql_max_minus1 DBA_HIST_SNAPSHOT.SNAP_ID%TYPE;
BEGIN
  SELECT dbid INTO plsql_dbid FROM v$database;
  dbms_output.put_line ('plsql_dbid='||plsql_dbid);
  select max(snap_id) INTO plsql_max_snap from dba_hist_snapshot;
  dbms_output.put_line ('plsql_max_snap='||plsql_max_snap);

  :sql_dbid := plsql_dbid;
  :sql_endsnapid := plsql_max_snap;
  :sql_beginsnapid := plsql_max_snap-2;
  dbms_output.put_line ('sql_beginsnapid='|| :sql_beginsnapid);
  dbms_output.put_line ('sql_endsnapid='|| :sql_endsnapid);
END;
/

SET TERMOUT OFF PAGESIZE 0 HEADING OFF LINESIZE 1000 TRIMSPOOL ON TRIMOUT ON TAB OFF

SET TERMOUT ON
PROMPT Genrating AWR_GLOBAL_REPORT_TEXT
SET TERMOUT OFF

SPOOL AWR_GLOBAL_REPORT_TEXT.TXT
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_GLOBAL_REPORT_TEXT(:sql_dbid, CAST(null AS VARCHAR2(10)), :sql_beginsnapid, :sql_endsnapid));
SPOOL OFF

SET TERMOUT ON
PROMPT Genrating AWR_INSTANCE_1_TEXT
SET TERMOUT OFF


SPOOL AWR_INSTANCE_1_TEXT.TXT
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(:sql_dbid, 1, :sql_beginsnapid, :sql_endsnapid));
SPOOL OFF

SET TERMOUT ON
PROMPT Genrating AWR_INSTANCE_2_TEXT
SET TERMOUT OFF


SPOOL AWR_INSTANCE_2_TEXT.TXT
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(:sql_dbid, 2, :sql_beginsnapid, :sql_endsnapid));

SET TERMOUT ON
PROMPT Genrating AWR_INSTANCE_1_HTML
SET TERMOUT OFF

SPOOL AWR_INSTANCE_1_HTML.HTML
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:sql_dbid, 1, :sql_beginsnapid, :sql_endsnapid));
SPOOL OFF

SET TERMOUT ON
PROMPT Genrating AWR_INSTANCE_2_HTML
SET TERMOUT OFF


SPOOL AWR_INSTANCE_2_HTML.HTML
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:sql_dbid, 2, :sql_beginsnapid, :sql_endsnapid));
SPOOL OFF

SET TERMOUT ON
PROMPT Genrating AWR_GLOBAL_REPORT_HTML
SET TERMOUT OFF


SPOOL AWR_GLOBAL_REPORT_HTML.html
SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_GLOBAL_REPORT_HTML(:sql_dbid, CAST(null AS VARCHAR2(10)), :sql_beginsnapid, :sql_endsnapid));
SPOOL OFF


SPOOL OFF

SET TERMOUT ON
PROMPT AWR Report Gneration Completed !!!

PROMPT Please check and report errors to sangram.k.dash@oracle.com if any.


-- SPOOL awr_local_inst_2.html
-- SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:dbid, 2, &bid, &eid));
--
-- SPOOL awr_local_inst_3.html
-- SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:dbid, 3, &bid, &eid));

-- SPOOL awr_global.html
-- SELECT * FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_GLOBAL_REPORT_HTML(:dbid, CAST(null AS VARCHAR2(10)), &bid, &eid));

SPOOL OFF
SET TERMOUT ON PAGESIZE 5000 HEADING ON
