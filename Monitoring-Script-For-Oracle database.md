## Monitoring-Script-For-Oracle database

```sh
select * from tab;
```

```sh
select sysdate from dual
```

```sh
set feedback off
set pagesize 70;
set linesize 2000
set head on
COLUMN Tablespace format a25 heading 'Tablespace Name'
COLUMN autoextensible format a11 heading 'AutoExtend'
COLUMN files_in_tablespace format 999 heading 'Files'
COLUMN total_tablespace_space format 99999999 heading 'TotalSpace'
COLUMN total_used_space format 99999999 heading 'UsedSpace'
COLUMN total_tablespace_free_space format 99999999 heading 'FreeSpace'
COLUMN total_used_pct format 9999 heading '%Used'
COLUMN total_free_pct format 9999 heading '%Free'
COLUMN max_size_of_tablespace format 99999999 heading 'ExtendUpto'
COLUM total_auto_used_pct format 999.99 heading 'Max%Used'
COLUMN total_auto_free_pct format 999.99 heading 'Max%Free'
WITH tbs_auto AS
(SELECT DISTINCT tablespace_name, autoextensible
FROM dba_data_files
WHERE autoextensible = 'YES'),
files AS
(SELECT tablespace_name, COUNT (*) tbs_files,
SUM (BYTES/1024/1024) total_tbs_bytes
FROM dba_data_files
GROUP BY tablespace_name),
fragments AS
(SELECT tablespace_name, COUNT (*) tbs_fragments,
SUM (BYTES)/1024/1024 total_tbs_free_bytes,
MAX (BYTES)/1024/1024 max_free_chunk_bytes
FROM dba_free_space
GROUP BY tablespace_name),
AUTOEXTEND AS
(SELECT tablespace_name, SUM (size_to_grow) total_growth_tbs
FROM (SELECT tablespace_name, SUM (maxbytes)/1024/1024 size_to_grow
FROM dba_data_files
WHERE autoextensible = 'YES'
GROUP BY tablespace_name
UNION
SELECT tablespace_name, SUM (BYTES)/1024/1024 size_to_grow
FROM dba_data_files
WHERE autoextensible = 'NO'
GROUP BY tablespace_name)
GROUP BY tablespace_name)
SELECT c.instance_name,a.tablespace_name Tablespace,
CASE tbs_auto.autoextensible
WHEN 'YES'
THEN 'YES'
ELSE 'NO'
END AS autoextensible,
files.tbs_files files_in_tablespace,
files.total_tbs_bytes total_tablespace_space,
(files.total_tbs_bytes - fragments.total_tbs_free_bytes
) total_used_space,
fragments.total_tbs_free_bytes total_tablespace_free_space,
round(( ( (files.total_tbs_bytes - fragments.total_tbs_free_bytes)
/ files.total_tbs_bytes
)
* 100
)) total_used_pct,
round(((fragments.total_tbs_free_bytes / files.total_tbs_bytes) * 100
)) total_free_pct
FROM dba_tablespaces a,v$instance c , files, fragments, AUTOEXTEND, tbs_auto
WHERE a.tablespace_name = files.tablespace_name
AND a.tablespace_name = fragments.tablespace_name
AND a.tablespace_name = AUTOEXTEND.tablespace_name
AND a.tablespace_name = tbs_auto.tablespace_name(+)
order by total_free_pct;
```

```
set feedback off
set pagesize 70
set linesize 2000
set head on
set termout on
set trimspool on

-- 1. Tablespace Usage (Improved formatting)
prompt
prompt === Tablespace Usage ===
COLUMN instance_name format a15 heading 'Instance'
COLUMN Tablespace format a25 heading 'Tablespace Name'
COLUMN autoextensible format a11 heading 'AutoExtend'
COLUMN files_in_tablespace format 999 heading 'Files'
COLUMN total_tablespace_space format 999999 heading 'Total(MB)'
COLUMN total_used_space format 999999 heading 'Used(MB)'
COLUMN total_tablespace_free_space format 999999 heading 'Free(MB)'
COLUMN total_used_pct format 999 heading '%Used'
COLUMN total_free_pct format 999 heading '%Free'
COLUMN max_size_of_tablespace format 999999 heading 'Max(MB)'
COLUMN total_auto_used_pct format 999.99 heading 'Max%Used'
COLUMN total_auto_free_pct format 999.99 heading 'Max%Free'

WITH tbs_auto AS (
    SELECT DISTINCT tablespace_name, autoextensible
    FROM dba_data_files
    WHERE autoextensible = 'YES'
),
files AS (
    SELECT tablespace_name, COUNT(*) tbs_files,
           SUM(BYTES/1024/1024) total_tbs_bytes
    FROM dba_data_files
    GROUP BY tablespace_name
),
fragments AS (
    SELECT tablespace_name, COUNT(*) tbs_fragments,
           SUM(BYTES/1024/1024) total_tbs_free_bytes,
           MAX(BYTES/1024/1024) max_free_chunk_bytes
    FROM dba_free_space
    GROUP BY tablespace_name
),
AUTOEXTEND AS (
    SELECT tablespace_name, SUM(size_to_grow) total_growth_tbs
    FROM (
        SELECT tablespace_name, SUM(maxbytes)/1024/1024 size_to_grow
        FROM dba_data_files
        WHERE autoextensible = 'YES'
        GROUP BY tablespace_name
        UNION
        SELECT tablespace_name, SUM(BYTES/1024/1024) size_to_grow
        FROM dba_data_files
        WHERE autoextensible = 'NO'
        GROUP BY tablespace_name
    )
    GROUP BY tablespace_name
)
SELECT c.instance_name, a.tablespace_name Tablespace,
       NVL(tbs_auto.autoextensible, 'NO') AS autoextensible,
       files.tbs_files files_in_tablespace,
       files.total_tbs_bytes total_tablespace_space,
       (files.total_tbs_bytes - fragments.total_tbs_free_bytes) total_used_space,
       fragments.total_tbs_free_bytes total_tablespace_free_space,
       ROUND(((files.total_tbs_bytes - fragments.total_tbs_free_bytes) / files.total_tbs_bytes * 100)) total_used_pct,
       ROUND((fragments.total_tbs_free_bytes / files.total_tbs_bytes * 100)) total_free_pct,
       AUTOEXTEND.total_growth_tbs max_size_of_tablespace,
       ROUND(((files.total_tbs_bytes - fragments.total_tbs_free_bytes) / NULLIF(AUTOEXTEND.total_growth_tbs, 0) * 100, 2) total_auto_used_pct,
       ROUND((1 - (files.total_tbs_bytes - fragments.total_tbs_free_bytes) / NULLIF(AUTOEXTEND.total_growth_tbs, 0)) * 100, 2) total_auto_free_pct
FROM dba_tablespaces a
JOIN v$instance c ON 1=1
JOIN files ON a.tablespace_name = files.tablespace_name
JOIN fragments ON a.tablespace_name = fragments.tablespace_name
JOIN AUTOEXTEND ON a.tablespace_name = AUTOEXTEND.tablespace_name
LEFT JOIN tbs_auto ON a.tablespace_name = tbs_auto.tablespace_name
ORDER BY total_free_pct;

-- 2. Active Sessions (Improved formatting)
prompt
prompt === Active Sessions ===
COLUMN sid format 9999 heading 'SID'
COLUMN serial# format 99999 heading 'Serial#'
COLUMN username format a20 heading 'Username'
COLUMN status format a10 heading 'Status'
COLUMN program format a40 heading 'Program' trunc
COLUMN sql_id format a13 heading 'SQL_ID'
SELECT sid, serial#, username, status, program, sql_id
FROM v$session
WHERE status = 'ACTIVE' AND type = 'USER'
ORDER BY sid;

-- 3. Recent Alerts (Improved error handling and formatting)
prompt
prompt === Recent Alerts (Last 24 Hours) ===
COLUMN time format a20 heading 'Time'
COLUMN message format a80 heading 'Alert Message' trunc
DECLARE
    v_count NUMBER;
    v_alerts NUMBER;
BEGIN
    -- Check if view exists
    SELECT COUNT(*) INTO v_count
    FROM v$fixed_table
    WHERE name = 'V$DIAG_ALERT_EXT';
    
    IF v_count > 0 THEN
        -- Check if alerts exist
        SELECT COUNT(*) INTO v_alerts
        FROM v$diag_alert_ext
        WHERE originating_timestamp > SYSDATE - 1
        AND message_text LIKE 'ORA-%';
        
        IF v_alerts > 0 THEN
            EXECUTE IMMEDIATE '
                SELECT TO_CHAR(originating_timestamp, ''YYYY-MM-DD HH24:MI:SS'') time, 
                       SUBSTR(message_text, 1, 80) message
                FROM v$diag_alert_ext
                WHERE originating_timestamp > SYSDATE - 1
                AND message_text LIKE ''ORA-%''
                ORDER BY originating_timestamp DESC
                FETCH FIRST 10 ROWS ONLY';
        ELSE
            DBMS_OUTPUT.PUT_LINE('No ORA- errors found in the last 24 hours.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No access to v$diag_alert_ext. Requires SELECT_CATALOG_ROLE.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking alerts: ' || SQLERRM);
END;
/

-- 4. Blocking Sessions (Improved formatting)
prompt
prompt === Blocking Sessions ===
COLUMN blocking_session format 9999 heading 'Block SID'
COLUMN blocked_session format 9999 heading 'Blocked SID'
COLUMN username format a20 heading 'Username'
COLUMN wait_time format 999999 heading 'Wait(s)'
COLUMN seconds_in_wait format 999999 heading 'Seconds Wait'
COLUMN blocking_status format a15 heading 'Blocking Status'
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM v$session
    WHERE blocking_session IS NOT NULL;
    
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE '
            SELECT blocking_session, 
                   sid AS blocked_session, 
                   username, 
                   wait_time,
                   seconds_in_wait,
                   CASE WHEN blocking_session_status = ''VALID'' THEN ''ACTIVE''
                        ELSE blocking_session_status
                   END AS blocking_status
            FROM v$session
            WHERE blocking_session IS NOT NULL
            ORDER BY blocking_session';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No blocking sessions found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking blocking sessions: ' || SQLERRM);
END;
/

-- 5. Long-Running Queries (Improved formatting)
prompt
prompt === Long-Running Queries (> 1 minute) ===
COLUMN sid format 9999 heading 'SID'
COLUMN serial# format 99999 heading 'Serial#'
COLUMN username format a20 heading 'Username'
COLUMN sql_id format a13 heading 'SQL_ID'
COLUMN elapsed_seconds format 999999 heading 'Elapsed(s)'
COLUMN time_remaining format 999999 heading 'Remaining(s)'
COLUMN opname format a30 heading 'Operation' trunc
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM v$session s
    JOIN v$session_longops l ON s.sid = l.sid AND s.serial# = l.serial#
    WHERE l.elapsed_seconds > 60
    AND s.type = 'USER';
    
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE '
            SELECT s.sid, 
                   s.serial#,
                   s.username,
                   s.sql_id, 
                   l.elapsed_seconds,
                   l.time_remaining,
                   SUBSTR(l.opname, 1, 30) opname
            FROM v$session s
            JOIN v$session_longops l ON s.sid = l.sid AND s.serial# = l.serial#
            WHERE l.elapsed_seconds > 60
            AND s.type = ''USER''
            ORDER BY l.elapsed_seconds DESC';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No queries running longer than 1 minute found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking long-running queries: ' || SQLERRM);
END;
/

-- 6. Invalid Objects (Improved formatting)
prompt
prompt === Invalid Objects ===
COLUMN owner format a20 heading 'Owner'
COLUMN object_name format a30 heading 'Object Name'
COLUMN object_type format a20 heading 'Object Type'
COLUMN created format a20 heading 'Created'
COLUMN last_ddl_time format a20 heading 'Last DDL'
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM dba_objects
    WHERE status = 'INVALID';
    
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE '
            SELECT owner, 
                   object_name, 
                   object_type,
                   TO_CHAR(created, ''YYYY-MM-DD HH24:MI:SS'') created,
                   TO_CHAR(last_ddl_time, ''YYYY-MM-DD HH24:MI:SS'') last_ddl_time
            FROM dba_objects
            WHERE status = ''INVALID''
            ORDER BY owner, object_type, object_name';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No invalid objects found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking invalid objects: ' || SQLERRM);
END;
/

-- 7. Tablespace Fragmentation (Improved formatting)
prompt
prompt === Tablespace Fragmentation ===
COLUMN tablespace_name format a25 heading 'Tablespace'
COLUMN fragment_count format 9999 heading 'Fragments'
COLUMN total_free_mb format 999999 heading 'Total Free(MB)'
COLUMN max_free_chunk_mb format 999999 heading 'Max Chunk(MB)'
COLUMN pct_max_chunk format 999 heading '%Max'
SELECT tablespace_name, 
       COUNT(*) fragment_count, 
       SUM(bytes)/1024/1024 total_free_mb,
       MAX(bytes)/1024/1024 max_free_chunk_mb,
       ROUND(MAX(bytes)/SUM(bytes)*100) pct_max_chunk
FROM dba_free_space
GROUP BY tablespace_name
HAVING COUNT(*) > 5
ORDER BY fragment_count DESC;

-- 8. Redo Log Status (Improved formatting)
prompt
prompt === Redo Log Status ===
COLUMN group# format 999 heading 'Group#'
COLUMN member format a50 heading 'Member' trunc
COLUMN status format a10 heading 'Status'
COLUMN bytes_mb format 9999 heading 'Size(MB)'
COLUMN sequence# format 999999 heading 'Seq#'
COLUMN first_change# format 99999999999 heading 'First Change#'
SELECT lf.group#, 
       lf.member, 
       l.status, 
       l.bytes/1024/1024 bytes_mb,
       l.sequence#,
       l.first_change#
FROM v$logfile lf
JOIN v$log l ON lf.group# = l.group#
ORDER BY lf.group#;

-- 9. Archive Log Status (Improved formatting)
prompt
prompt === Archive Log Status ===
COLUMN archive_mode format a15 heading 'Archive Mode'
COLUMN dest_id format 999 heading 'DestID'
COLUMN dest_name format a30 heading 'Destination' trunc
COLUMN status format a10 heading 'Status'
COLUMN destination format a50 heading 'Path' trunc
SELECT d.log_mode archive_mode,
       ad.dest_id,
       ad.name dest_name,
       ad.status,
       ad.destination
FROM v$database d, v$archive_dest ad
WHERE ad.status != 'INACTIVE'
ORDER BY ad.dest_id;

-- 10. Archive Log Error Details (Improved formatting)
prompt
prompt === Archive Log Error Details ===
COLUMN dest_id format 999 heading 'DestID'
COLUMN destination format a50 heading 'Destination' trunc
COLUMN status format a10 heading 'Status'
COLUMN error format a50 heading 'Error Message' trunc
SELECT dest_id, 
       destination, 
       status, 
       error
FROM v$archive_dest
WHERE status = 'ERROR'
ORDER BY dest_id;

-- 11. Top 5 CPU-Consuming Sessions (Improved formatting)
prompt
prompt === Top 5 CPU-Consuming Sessions ===
COLUMN sid format 9999 heading 'SID'
COLUMN serial# format 99999 heading 'Serial#'
COLUMN username format a20 heading 'Username'
COLUMN program format a40 heading 'Program' trunc
COLUMN cpu_usage format 999999 heading 'CPU(s)'
COLUMN sql_id format a13 heading 'SQL_ID'
SELECT s.sid, 
       s.serial#,
       s.username, 
       s.program,
       st.value/100 cpu_usage,
       s.sql_id
FROM v$session s
JOIN v$sesstat st ON s.sid = st.sid
JOIN v$statname sn ON st.statistic# = sn.statistic#
WHERE sn.name = 'CPU used by this session'
AND s.type = 'USER'
ORDER BY st.value DESC
FETCH FIRST 5 ROWS ONLY;

set feedback on
```

> # All imp path

```
-- =====================================================
-- Oracle 19c Database Paths and Configuration Check
-- Corrected version for @script.sql usage
-- =====================================================

SET PAGESIZE 1000
SET LINESIZE 300
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING ON
SET ECHO OFF
SET TRIMSPOOL ON
SET TERMOUT ON

-- Column formatting (for clean output)
COLUMN DATABASE_NAME FORMAT A15
COLUMN DATABASE_ID FORMAT 9999999999
COLUMN CREATED_DATE FORMAT A20
COLUMN LOG_MODE FORMAT A15
COLUMN OPEN_MODE FORMAT A20
COLUMN DATABASE_ROLE FORMAT A20
COLUMN PLATFORM FORMAT A30
COLUMN VERSION FORMAT A10

COLUMN FILE_ID FORMAT 9999
COLUMN TABLESPACE_NAME FORMAT A20
COLUMN FILE_PATH FORMAT A80 WORD_WRAPPED
COLUMN SIZE_GB FORMAT 999.99
COLUMN STATUS FORMAT A10
COLUMN AUTOEXTEND FORMAT A10

COLUMN CONTROL_FILE_PATH FORMAT A80
COLUMN BLOCK_SIZE FORMAT 99999
COLUMN FILE_SIZE_BLOCKS FORMAT 99999999
COLUMN RECOVERY_DEST_FILE FORMAT A10

COLUMN GROUP_NUMBER FORMAT 99
COLUMN THREAD_NUMBER FORMAT 9
COLUMN SEQUENCE_NUMBER FORMAT 99999
COLUMN GROUP_STATUS FORMAT A12
COLUMN LOG_FILE_PATH FORMAT A80
COLUMN FILE_STATUS FORMAT A10

COLUMN DEST_ID FORMAT 99
COLUMN DESTINATION_PATH FORMAT A80 WORD_WRAPPED
COLUMN BINDING FORMAT A10
COLUMN TARGET FORMAT A10
COLUMN ARCHIVER FORMAT A10
COLUMN SCHEDULE FORMAT A20
COLUMN PROCESS FORMAT A10

COLUMN PARAMETER_NAME FORMAT A30
COLUMN PARAMETER_VALUE FORMAT A80 WORD_WRAPPED
COLUMN DESCRIPTION FORMAT A80 WORD_WRAPPED

COLUMN DIRECTORY_NAME FORMAT A30
COLUMN DIRECTORY_PATH FORMAT A80 WORD_WRAPPED
COLUMN ORIGIN_CONTAINER_ID FORMAT 9999

COLUMN DUMP_TYPE FORMAT A25
COLUMN PATH FORMAT A100 WORD_WRAPPED

COLUMN FILE_TYPE FORMAT A12
COLUMN STORAGE_TYPE FORMAT A12
COLUMN FILE_COUNT FORMAT 9999

COLUMN BASE_PATH FORMAT A30
COLUMN LOG_TYPE FORMAT A15
COLUMN LOG_PATH FORMAT A100 WORD_WRAPPED

COLUMN DISKGROUP_NAME FORMAT A30
COLUMN STATE FORMAT A10
COLUMN REDUNDANCY_TYPE FORMAT A15
COLUMN TOTAL_GB FORMAT 9999.99
COLUMN FREE_GB FORMAT 9999.99
COLUMN USED_GB FORMAT 9999.99
COLUMN USED_PERCENT FORMAT 999.99

COLUMN INFO_TYPE FORMAT A30
COLUMN VALUE FORMAT A60 WORD_WRAPPED

COLUMN BACKUP_PIECE_PATH FORMAT A100 WORD_WRAPPED
COLUMN MEDIA_TYPE FORMAT A10
COLUMN START_TIME FORMAT A25
COLUMN COMPLETION_TIME FORMAT A25
COLUMN SIZE_GB FORMAT 999.99

COLUMN TABLESPACE_NAME FORMAT A25
COLUMN TOTAL_SIZE_GB FORMAT 999.99
COLUMN USED_SIZE_GB FORMAT 999.99
COLUMN FREE_SIZE_GB FORMAT 999.99
COLUMN USED_PERCENT FORMAT 999.99

COLUMN CHECK_TYPE FORMAT A25
COLUMN STATUS FORMAT A20

-- Timestamp of Report Generation
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS REPORT_TIME FROM DUAL;

-- 1. DATABASE INFORMATION
SELECT 
    d.name AS database_name,
    d.dbid AS database_id,
    d.created AS created_date,
    d.log_mode,
    d.open_mode,
    d.database_role,
    d.platform_name AS platform,
    i.version AS version,
    d.flashback_on,
    d.force_logging,
    d.current_scn
FROM v$database d, v$instance i;

-- 2. DATAFILE LOCATIONS
SELECT 
    file_id AS FILE_ID,
    tablespace_name AS TABLESPACE_NAME,
    file_name AS FILE_PATH,
    ROUND(bytes/1024/1024/1024,2) AS SIZE_GB,
    status AS STATUS,
    autoextensible AS AUTOEXTEND
FROM dba_data_files
ORDER BY tablespace_name, file_id;

-- 3. TEMPFILE LOCATIONS
SELECT 
    file_id AS FILE_ID,
    tablespace_name AS TABLESPACE_NAME,
    file_name AS FILE_PATH,
    ROUND(bytes/1024/1024/1024,2) AS SIZE_GB,
    status AS STATUS,
    autoextensible AS AUTOEXTEND
FROM dba_temp_files
ORDER BY tablespace_name, file_id;

-- 4. CONTROL FILE LOCATIONS
SELECT 
    name AS CONTROL_FILE_PATH,
    status AS STATUS,
    is_recovery_dest_file AS RECOVERY_DEST_FILE,
    block_size AS BLOCK_SIZE,
    file_size_blks AS FILE_SIZE_BLOCKS
FROM v$controlfile;

-- 5. REDO LOG FILE LOCATIONS
SELECT 
    l.group# AS GROUP_NUMBER,
    l.thread# AS THREAD_NUMBER,
    l.sequence# AS SEQUENCE_NUMBER,
    l.status AS GROUP_STATUS,
    lf.member AS LOG_FILE_PATH,
    lf.status AS FILE_STATUS,
    ROUND(l.bytes/1024/1024,2) AS SIZE_MB
FROM v$log l, v$logfile lf
WHERE l.group# = lf.group#
ORDER BY l.group#, lf.member;

-- 6. ARCHIVE LOG DESTINATIONS
SELECT 
    dest_id AS DEST_ID,
    destination AS DESTINATION_PATH,
    status AS STATUS,
    binding AS BINDING,
    target AS TARGET,
    archiver AS ARCHIVER,
    schedule AS SCHEDULE,
    process AS PROCESS
FROM v$archive_dest
WHERE status != 'INACTIVE' OR destination IS NOT NULL;

-- 7. DIAGNOSTIC DESTINATION
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE,
    description AS DESCRIPTION
FROM v$parameter 
WHERE name IN ('diagnostic_dest', 'background_dump_dest', 'user_dump_dest', 'core_dump_dest');

-- 8. FLASH RECOVERY AREA (FRA) DETAILS
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE
FROM v$parameter 
WHERE name IN ('db_recovery_file_dest', 'db_recovery_file_dest_size');

SELECT 
    'FRA' AS FILE_TYPE,
    ROUND((space_used / space_limit) * 100, 2) AS PERCENT_USED,
    ROUND(space_used / 1024 / 1024 / 1024, 2) AS USED_GB,
    ROUND(space_limit / 1024 / 1024 / 1024, 2) AS LIMIT_GB,
    number_of_files AS NUMBER_OF_FILES
FROM v$recovery_file_dest
WHERE space_used > 0;

-- 9. DIRECTORY OBJECTS
SELECT 
    directory_name AS DIRECTORY_NAME,
    directory_path AS DIRECTORY_PATH,
    origin_con_id AS ORIGIN_CONTAINER_ID
FROM dba_directories
ORDER BY directory_name;

-- 10. DUMP DESTINATIONS
SELECT 
    'BACKGROUND_DUMP_DEST' AS DUMP_TYPE,
    value AS PATH
FROM v$parameter WHERE name = 'background_dump_dest'
UNION ALL
SELECT 
    'USER_DUMP_DEST' AS DUMP_TYPE,
    value AS PATH
FROM v$parameter WHERE name = 'user_dump_dest'
UNION ALL
SELECT 
    'CORE_DUMP_DEST' AS DUMP_TYPE,
    value AS PATH
FROM v$parameter WHERE name = 'core_dump_dest'
UNION ALL
SELECT 
    'DIAGNOSTIC_DEST' AS DUMP_TYPE,
    value AS PATH
FROM v$parameter WHERE name = 'diagnostic_dest';

-- 11. AUDIT FILE DESTINATION
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE
FROM v$parameter 
WHERE name IN ('audit_file_dest', 'audit_trail', 'audit_sys_operations');

-- 12. SPFILE AND PFILE LOCATIONS
SELECT 
    'SPFILE' AS FILE_TYPE,
    value AS FILE_PATH
FROM v$parameter 
WHERE name = 'spfile'
UNION ALL
SELECT 
    'PFILE' AS FILE_TYPE,
    value || '/dbs/init' || (SELECT value FROM v$parameter WHERE name = 'db_name') || '.ora' AS FILE_PATH
FROM v$parameter 
WHERE name = 'oracle_home';

-- 13. ORACLE HOME AND BASE INFORMATION
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE
FROM v$parameter 
WHERE name IN ('oracle_home', 'oracle_base');

-- 14. NETWORK CONFIGURATION INFORMATION
SELECT 
    'TNS_ADMIN' AS CONFIG_TYPE,
    value AS PATH
FROM v$parameter WHERE name = 'tns_admin'
UNION ALL
SELECT 
    'ORACLE_HOME/network/admin' AS CONFIG_TYPE,
    value || '/network/admin' AS PATH
FROM v$parameter WHERE name = 'oracle_home';

-- 15. RECENT BACKUP PIECE LOCATIONS (RMAN)
SELECT 
    bp.handle AS BACKUP_PIECE_PATH,
    bp.media AS MEDIA_TYPE,
    TO_CHAR(bp.start_time, 'DD-MON-YYYY HH24:MI:SS') AS START_TIME,
    TO_CHAR(bp.completion_time, 'DD-MON-YYYY HH24:MI:SS') AS COMPLETION_TIME,
    ROUND(bp.bytes/1024/1024/1024,2) AS SIZE_GB,
    bp.status AS STATUS
FROM v$backup_piece bp
WHERE bp.start_time > SYSDATE - 7
ORDER BY bp.start_time DESC;

-- 16. DATABASE FILE STORAGE TYPE
SELECT 
    'DATAFILES' AS FILE_TYPE,
    CASE 
        WHEN file_name LIKE '+%' THEN 'ASM'
        WHEN file_name LIKE '/dev/%' THEN 'RAW DEVICE'
        ELSE 'FILESYSTEM'
    END AS STORAGE_TYPE,
    COUNT(*) AS FILE_COUNT
FROM dba_data_files
GROUP BY CASE 
    WHEN file_name LIKE '+%' THEN 'ASM'
    WHEN file_name LIKE '/dev/%' THEN 'RAW DEVICE'
    ELSE 'FILESYSTEM'
END
UNION ALL
SELECT 
    'TEMPFILES' AS FILE_TYPE,
    CASE 
        WHEN file_name LIKE '+%' THEN 'ASM'
        WHEN file_name LIKE '/dev/%' THEN 'RAW DEVICE'
        ELSE 'FILESYSTEM'
    END AS STORAGE_TYPE,
    COUNT(*) AS FILE_COUNT
FROM dba_temp_files
GROUP BY CASE 
    WHEN file_name LIKE '+%' THEN 'ASM'
    WHEN file_name LIKE '/dev/%' THEN 'RAW DEVICE'
    ELSE 'FILESYSTEM'
END;

-- 17. IMPORTANT ORACLE HOME SUBDIRECTORIES
SELECT 
    'ORACLE_HOME' AS BASE_PATH,
    value AS PATH
FROM v$parameter WHERE name = 'oracle_home'
UNION ALL
SELECT 
    'BIN Directory' AS BASE_PATH,
    value || '/bin' AS PATH
FROM v$parameter WHERE name = 'oracle_home'
UNION ALL
SELECT 
    'LIB Directory' AS BASE_PATH,
    value || '/lib' AS PATH
FROM v$parameter WHERE name = 'oracle_home'
UNION ALL
SELECT 
    'RDBMS/ADMIN Directory' AS BASE_PATH,
    value || '/rdbms/admin' AS PATH
FROM v$parameter WHERE name = 'oracle_home'
UNION ALL
SELECT 
    'NETWORK/ADMIN Directory' AS BASE_PATH,
    value || '/network/admin' AS PATH
FROM v$parameter WHERE name = 'oracle_home'
UNION ALL
SELECT 
    'DBS Directory' AS BASE_PATH,
    value || '/dbs' AS PATH
FROM v$parameter WHERE name = 'oracle_home';

-- 18. ALERT LOG LOCATION
SELECT 
    'ALERT_LOG' AS LOG_TYPE,
    value || '/diag/rdbms/' || LOWER((SELECT value FROM v$parameter WHERE name = 'db_name')) || 
    '/' || (SELECT value FROM v$parameter WHERE name = 'instance_name') || '/trace/alert_' || 
    (SELECT value FROM v$parameter WHERE name = 'instance_name') || '.log' AS LOG_PATH
FROM v$parameter WHERE name = 'diagnostic_dest'
UNION ALL
SELECT 
    'TRACE_DIRECTORY' AS LOG_TYPE,
    value || '/diag/rdbms/' || LOWER((SELECT value FROM v$parameter WHERE name = 'db_name')) || 
    '/' || (SELECT value FROM v$parameter WHERE name = 'instance_name') || '/trace' AS LOG_PATH
FROM v$parameter WHERE name = 'diagnostic_dest';

-- 19. WALLET LOCATION (TDE CONFIGURATION)
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE
FROM v$parameter 
WHERE name IN ('wallet_root', 'tde_configuration');

SELECT 
    'TDE_STATUS' AS CHECK_TYPE,
    CASE 
        WHEN COUNT(*) > 0 THEN 'TDE CONFIGURED'
        ELSE 'TDE NOT CONFIGURED'
    END AS STATUS
FROM v$encryption_wallet;

-- 20. ASM DISKGROUP INFORMATION
SELECT 
    'ASM_USAGE_CHECK' AS CHECK_TYPE,
    CASE 
        WHEN COUNT(*) > 0 THEN 'ASM IS USED'
        ELSE 'ASM NOT USED'
    END AS STATUS
FROM dba_data_files 
WHERE file_name LIKE '+%';

SELECT 
    name AS DISKGROUP_NAME,
    state AS STATE,
    type AS REDUNDANCY_TYPE,
    ROUND(total_mb/1024,2) AS TOTAL_GB,
    ROUND(free_mb/1024,2) AS FREE_GB,
    ROUND((total_mb-free_mb)/1024,2) AS USED_GB,
    ROUND(((total_mb-free_mb)/total_mb)*100,2) AS USED_PERCENT
FROM v$asm_diskgroup;

-- 21. ADDITIONAL SYSTEM INFORMATION
SELECT 
    'INSTANCE_NAME' AS INFO_TYPE,
    value AS VALUE
FROM v$parameter WHERE name = 'instance_name'
UNION ALL
SELECT 
    'DB_BLOCK_SIZE' AS INFO_TYPE,
    value AS VALUE
FROM v$parameter WHERE name = 'db_block_size'
UNION ALL
SELECT 
    'COMPATIBLE' AS INFO_TYPE,
    value AS VALUE
FROM v$parameter WHERE name = 'compatible'
UNION ALL
SELECT 
    'MEMORY_TARGET' AS INFO_TYPE,
    value AS VALUE
FROM v$parameter WHERE name = 'memory_target'
UNION ALL
SELECT 
    'SGA_TARGET' AS INFO_TYPE,
    value AS VALUE
FROM v$parameter WHERE name = 'sga_target'
UNION ALL
SELECT 
    'PGA_AGGREGATE_TARGET' AS INFO_TYPE,
    value AS VALUE
FROM v$parameter WHERE name = 'pga_aggregate_target';

-- 22. TABLESPACE USAGE SUMMARY
SELECT 
    df.tablespace_name AS TABLESPACE_NAME,
    ROUND(df.total_size_gb,2) AS TOTAL_SIZE_GB,
    ROUND(df.total_size_gb - NVL(fs.free_size_gb,0),2) AS USED_SIZE_GB,
    ROUND(NVL(fs.free_size_gb,0),2) AS FREE_SIZE_GB,
    ROUND(((df.total_size_gb - NVL(fs.free_size_gb,0))/df.total_size_gb)*100,2) AS USED_PERCENT
FROM 
    (SELECT tablespace_name, SUM(bytes)/1024/1024/1024 AS total_size_gb
     FROM dba_data_files GROUP BY tablespace_name) df
LEFT JOIN 
    (SELECT tablespace_name, SUM(bytes)/1024/1024/1024 AS free_size_gb
     FROM dba_free_space GROUP BY tablespace_name) fs
ON df.tablespace_name = fs.tablespace_name;

-- END OF SCRIPT
```
