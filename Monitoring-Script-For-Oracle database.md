## Monitoring-Script-For-Oracle database

## Alert Log Path from SQL?
```
SELECT 
    value || '/diag/rdbms/' || LOWER((SELECT value FROM v$parameter WHERE name = 'db_name')) || 
    '/' || (SELECT value FROM v$parameter WHERE name = 'instance_name') || '/trace/alert_' || 
    (SELECT value FROM v$parameter WHERE name = 'instance_name') || '.log' AS ALERT_LOG_PATH
FROM v$parameter
WHERE name = 'diagnostic_dest';
```

## View using SQL Developer:
```
SELECT * FROM v$diag_alert_ext
WHERE originating_timestamp > SYSDATE - 1
ORDER BY originating_timestamp DESC;
```

## Details 
```
echo $ORACLE_BASE
echo $ORACLE_HOME
echo $ORACLE_SID

```

```
The provided SQL script gathers various pieces of information about an Oracle 19c database. Below is a list of the specific information the script is designed to retrieve:

1. **Tablespace Usage**:
   - Instance name
   - Tablespace name
   - Autoextensible status (YES/NO)
   - Number of files in the tablespace
   - Total space in megabytes (MB)
   - Used space in MB
   - Free space in MB
   - Percentage of space used (%Used)
   - Percentage of free space (%Free)
   - Maximum size the tablespace can extend to (Max MB)
   - Maximum percentage used considering autoextend (Max%Used)
   - Maximum percentage free considering autoextend (Max%Free)

2. **Active Sessions**:
   - Session ID (SID)
   - Serial number
   - Username
   - Status
   - Program name
   - SQL ID

3. **Recent Alerts (Last 24 Hours)**:
   - Timestamp of alerts
   - Alert message (ORA- errors)

4. **Blocking Sessions**:
   - Blocking session ID
   - Blocked session ID
   - Username
   - Wait time in seconds
   - Seconds in wait
   - Blocking status

5. **Long-Running Queries (> 1 Minute)**:
   - Session ID (SID)
   - Serial number
   - Username
   - SQL ID
   - Elapsed time in seconds
   - Remaining time in seconds
   - Operation name

6. **Invalid Objects**:
   - Owner
   - Object name
   - Object type
   - Creation timestamp
   - Last DDL timestamp

7. **Tablespace Fragmentation**:
   - Tablespace name
   - Number of fragments
   - Total free space in MB
   - Maximum free chunk in MB
   - Percentage of maximum chunk relative to total free space

8. **Redo Log Status**:
   - Group number
   - Log file member path
   - Status
   - Size in MB
   - Sequence number
   - First change number

9. **Archive Log Status**:
   - Archive mode
   - Destination ID
   - Destination name
   - Status
   - Destination path

10. **Archive Log Error Details**:
    - Destination ID
    - Destination path
    - Status
    - Error message

11. **Top 5 CPU-Consuming Sessions**:
    - Session ID (SID)
    - Serial number
    - Username
    - Program name
    - CPU usage in seconds
    - SQL ID

12. **Database Information**:
    - Database name
    - Database ID
    - Creation date
    - Log mode
    - Open mode
    - Database role
    - Platform name
    - Version
    - Flashback status
    - Force logging status
    - Current SCN

13. **Datafile Locations**:
    - File ID
    - Tablespace name
    - File path
    - Size in gigabytes (GB)
    - Status
    - Autoextensible status

14. **Tempfile Locations**:
    - File ID
    - Tablespace name
    - File path
    - Size in GB
    - Status
    - Autoextensible status

15. **Control File Locations**:
    - Control file path
    - Status
    - Recovery destination file status
    - Block size
    - File size in blocks

16. **Redo Log File Locations**:
    - Group number
    - Thread number
    - Sequence number
    - Group status
    - Log file path
    - File status
    - Size in MB

17. **Archive Log Destinations**:
    - Destination ID
    - Destination path
    - Status
    - Binding
    - Target
    - Archiver
    - Schedule
    - Process

18. **Diagnostic Destination**:
    - Parameter name (diagnostic_dest, background_dump_dest, user_dump_dest, core_dump_dest)
    - Parameter value
    - Description

19. **Flash Recovery Area (FRA) Details**:
    - Parameter name (db_recovery_file_dest, db_recovery_file_dest_size)
    - Parameter value
    - Percentage used
    - Used space in GB
    - Limit in GB
    - Number of files

20. **Directory Objects**:
    - Directory name
    - Directory path
    - Origin container ID

21. **Dump Destinations**:
    - Dump type (background, user, core, diagnostic)
    - Path

22. **Audit File Destination**:
    - Parameter name (audit_file_dest, audit_trail, audit_sys_operations)
    - Parameter value

23. **SPFILE and PFILE Locations**:
    - File type (SPFILE, PFILE)
    - File path

24. **Oracle Home and Base Information**:
    - Parameter name (oracle_home, oracle_base)
    - Parameter value

25. **Network Configuration Information**:
    - Configuration type (TNS_ADMIN, ORACLE_HOME/network/admin)
    - Path

26. **Recent Backup Piece Locations (RMAN)**:
    - Backup piece path
    - Media type
    - Start time
    - Completion time
    - Size in GB
    - Status

27. **Database File Storage Type**:
    - File type (DATAFILES, TEMPFILES)
    - Storage type (ASM, RAW DEVICE, FILESYSTEM)
    - File count

28. **Important Oracle Home Subdirectories**:
    - Base path (ORACLE_HOME, BIN, LIB, RDBMS/ADMIN, NETWORK/ADMIN, DBS)
    - Path

29. **Alert Log Location**:
    - Log type (ALERT_LOG, TRACE_DIRECTORY)
    - Log path

30. **Wallet Location (TDE Configuration)**:
    - Parameter name (wallet_root, tde_configuration)
    - Parameter value
    - TDE status

31. **ASM Diskgroup Information**:
    - ASM usage status
    - Diskgroup name
    - State
    - Redundancy type
    - Total size in GB
    - Free size in GB
    - Used size in GB
    - Used percentage

32. **Additional System Information**:
    - Instance name
    - Database block size
    - Compatible parameter
    - Memory target
    - SGA target
    - PGA aggregate target

33. **Tablespace Usage Summary**:
    - Tablespace name
    - Total size in GB
    - Used size in GB
    - Free size in GB
    - Used percentage
```

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

## 
```
PROMPT
PROMPT  -- 1. Tablespace Usage
PROMPT =====================================================

set feedback off
set pagesize 70
set linesize 2000
set head on
set termout on
set trimspool on

-- 1. Tablespace Usage (Improved formatting)
prompt
prompt -- 1. Tablespace Usage (Improved formatting)
PROMPT =====================================================
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
    SELECT tablespace_name, 
           COUNT(*) AS tbs_files,
           SUM(bytes/1024/1024) AS total_tbs_mb
    FROM dba_data_files
    GROUP BY tablespace_name
),
fragments AS (
    SELECT tablespace_name, 
           COUNT(*) AS tbs_fragments,
           SUM(bytes/1024/1024) AS total_free_mb,
           MAX(bytes/1024/1024) AS max_free_chunk_mb
    FROM dba_free_space
    GROUP BY tablespace_name
),
autoextend_calc AS (
    SELECT tablespace_name, 
           SUM(size_to_grow_mb) AS total_growth_mb
    FROM (
        SELECT tablespace_name, 
               SUM(maxbytes)/1024/1024 AS size_to_grow_mb
        FROM dba_data_files
        WHERE autoextensible = 'YES'
        GROUP BY tablespace_name
        
        UNION ALL
        
        SELECT tablespace_name, 
               SUM(bytes)/1024/1024 AS size_to_grow_mb
        FROM dba_data_files
        WHERE autoextensible = 'NO'
        GROUP BY tablespace_name
    )
    GROUP BY tablespace_name
)
SELECT 
    i.instance_name,
    t.tablespace_name AS "Tablespace",
    NVL(a.autoextensible, 'NO') AS "Autoextensible",
    f.tbs_files AS "Files",
    ROUND(f.total_tbs_mb/1024, 2) AS "Current Size (GB)",
    ROUND(ac.total_growth_mb/1024, 2) AS "Max Size (GB)",
    ROUND((f.total_tbs_mb - fr.total_free_mb)/1024, 2) AS "Used Space (GB)",
    ROUND(fr.total_free_mb/1024, 2) AS "Free Space (GB)",
    ROUND(((f.total_tbs_mb - fr.total_free_mb) / f.total_tbs_mb) * 100) AS "Used %",
    ROUND((fr.total_free_mb / f.total_tbs_mb) * 100) AS "Free %",
    ROUND(fr.max_free_chunk_mb/1024, 2) AS "Largest Free Chunk (GB)",
    fr.tbs_fragments AS "Fragments",
    ROUND(((f.total_tbs_mb - fr.total_free_mb) / NULLIF(ac.total_growth_mb, 0)) * 100, 2) AS "Used of Max %",
    ROUND((1 - ((f.total_tbs_mb - fr.total_free_mb) / NULLIF(ac.total_growth_mb, 0))) * 100, 2) AS "Free of Max %"
FROM 
    dba_tablespaces t
JOIN 
    v$instance i ON 1=1
JOIN 
    files f ON t.tablespace_name = f.tablespace_name
JOIN 
    fragments fr ON t.tablespace_name = fr.tablespace_name
JOIN 
    autoextend_calc ac ON t.tablespace_name = ac.tablespace_name
LEFT JOIN 
    tbs_auto a ON t.tablespace_name = a.tablespace_name
ORDER BY 
    "Free %" DESC;

-- 2. Active Sessions (Improved formatting)
PROMPT
PROMPT  -- 2. Active Sessions
PROMPT =====================================================
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
PROMPT
PROMPT  -- 3. Recent Alerts
PROMPT =====================================================
prompt
prompt === Recent Alerts (Last 24 Hours) ===
COLUMN time FORMAT a20 HEADING 'Time'
COLUMN message FORMAT a80 HEADING 'Alert Message' TRUNC
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
                SELECT TO_CHAR(originating_timestamp, ''YYYY-MM-DD HH24:MI:SS'') AS time, 
                       SUBSTR(message_text, 1, 80) AS message
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
PROMPT
PROMPT  -- 4. Blocking Sessions
PROMPT =====================================================
prompt
prompt === Blocking Sessions ===
COLUMN blocking_session FORMAT 9999 HEADING 'Block SID'
COLUMN blocked_session FORMAT 9999 HEADING 'Blocked SID'
COLUMN username FORMAT a20 HEADING 'Username'
COLUMN wait_time FORMAT 999999 HEADING 'Wait(s)'
COLUMN seconds_in_wait FORMAT 999999 HEADING 'Seconds Wait'
COLUMN blocking_status FORMAT a15 HEADING 'Blocking Status'
COLUMN sql_id FORMAT a15 HEADING 'SQL ID'
COLUMN event FORMAT a30 HEADING 'Wait Event' TRUNC

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM v$session
    WHERE blocking_session IS NOT NULL;
    
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE '
            SELECT s.blocking_session, 
                   s.sid AS blocked_session, 
                   s.username, 
                   s.wait_time/100 AS wait_time,
                   s.seconds_in_wait,
                   CASE WHEN s.blocking_session_status = ''VALID'' THEN ''ACTIVE''
                        ELSE s.blocking_session_status
                   END AS blocking_status,
                   s.sql_id,
                   s.event
            FROM v$session s
            WHERE s.blocking_session IS NOT NULL
            ORDER BY s.blocking_session, s.sid';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No blocking sessions found.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking blocking sessions: ' || SQLERRM);
END;
/

-- 5. Long-Running Queries (Improved formatting)
PROMPT
PROMPT  -- 5. Long-Running Queries
PROMPT =====================================================
prompt
prompt === Long-Running Queries (> 1 minute) ===
COLUMN sid FORMAT 9999 HEADING 'SID'
COLUMN serial# FORMAT 99999 HEADING 'Serial#'
COLUMN username FORMAT a20 HEADING 'Username'
COLUMN sql_id FORMAT a13 HEADING 'SQL ID'
COLUMN elapsed_seconds FORMAT 999,999 HEADING 'Elapsed(s)'
COLUMN time_remaining FORMAT 999,999 HEADING 'Remaining(s)'
COLUMN opname FORMAT a30 HEADING 'Operation' TRUNC
COLUMN pct_complete FORMAT 999.99 HEADING '% Complete'
COLUMN start_time FORMAT a20 HEADING 'Start Time'
COLUMN target FORMAT a30 HEADING 'Target' TRUNC

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
            SELECT 
                s.sid, 
                s.serial#,
                s.username,
                s.sql_id, 
                l.elapsed_seconds,
                l.time_remaining,
                ROUND(l.sofar/DECODE(l.totalwork,0,1,l.totalwork)*100, 2) pct_complete,
                SUBSTR(l.opname, 1, 30) opname,
                TO_CHAR(l.start_time, ''YYYY-MM-DD HH24:MI:SS'') start_time,
                SUBSTR(l.target, 1, 30) target
            FROM v$session s
            JOIN v$session_longops l ON s.sid = l.sid AND s.serial# = l.serial#
            WHERE l.elapsed_seconds > 60
            AND s.type = ''USER''
            ORDER BY l.elapsed_seconds DESC';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No long-running operations (>60s) found for user sessions.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking long-running operations: ' || SQLERRM);
END;
/

-- 6. Invalid Objects (Improved formatting)
PROMPT
PROMPT  -- 6. Invalid Objects
PROMPT =====================================================
prompt
prompt === Invalid Objects ===
COLUMN owner FORMAT a20 HEADING 'Owner'
COLUMN object_name FORMAT a30 HEADING 'Object Name'
COLUMN object_type FORMAT a15 HEADING 'Object Type'
COLUMN created FORMAT a20 HEADING 'Created'
COLUMN last_ddl_time FORMAT a20 HEADING 'Last DDL'
COLUMN status FORMAT a10 HEADING 'Status'
COLUMN dependency_count FORMAT 999 HEADING 'Dep Count'
COLUMN compile_errors FORMAT a50 HEADING 'Compile Errors' TRUNC

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM dba_objects
    WHERE status = 'INVALID';
    
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE '
            SELECT 
                o.owner, 
                o.object_name, 
                o.object_type,
                TO_CHAR(o.created, ''YYYY-MM-DD HH24:MI:SS'') created,
                TO_CHAR(o.last_ddl_time, ''YYYY-MM-DD HH24:MI:SS'') last_ddl_time,
                o.status,
                (SELECT COUNT(*) FROM dba_dependencies d 
                 WHERE d.referenced_owner = o.owner 
                 AND d.referenced_name = o.object_name) dependency_count,
                (SELECT LISTAGG(e.text, '' '') WITHIN GROUP (ORDER BY e.line)
                FROM dba_errors e
                WHERE e.owner = o.owner
                AND e.name = o.object_name
                AND e.type = o.object_type) compile_errors
            FROM dba_objects o
            WHERE o.status = ''INVALID''
            ORDER BY o.owner, o.object_type, o.object_name';
    ELSE
        DBMS_OUTPUT.PUT_LINE('No invalid objects found in the database.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error checking invalid objects: ' || SQLERRM ||
                             CHR(10) || 'Ensure you have access to DBA_ views.');
END;
/

-- 7. Tablespace Fragmentation (Improved formatting)
PROMPT
PROMPT  -- 7. Tablespace Fragmentation
PROMPT =====================================================
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
PROMPT
PROMPT  -- 8. Redo Log Status
PROMPT =====================================================
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
PROMPT
PROMPT  -- 9. Archive Log Status
PROMPT =====================================================
prompt
prompt === Archive Log Status ===
COLUMN archive_mode FORMAT a15 HEADING 'Archive Mode'
COLUMN dest_id FORMAT 999 HEADING 'Dest|ID'
COLUMN dest_name FORMAT a20 HEADING 'Destination|Name' TRUNC
COLUMN status FORMAT a12 HEADING 'Status'
COLUMN destination FORMAT a50 HEADING 'Path' TRUNC
COLUMN target FORMAT a10 HEADING 'Target'
COLUMN protection_mode FORMAT a20 HEADING 'Protection|Mode'
COLUMN error FORMAT a30 HEADING 'Last Error' TRUNC
COLUMN fail_sequence FORMAT 999999 HEADING 'Fail|Seq#'
COLUMN fail_date FORMAT a20 HEADING 'Fail Date'

SET LINESIZE 200
SET PAGESIZE 100

SELECT 
    d.log_mode AS archive_mode,
    d.protection_mode,
    ad.dest_id,
    ad.destination,
    ad.target,
    ad.status,
    ad.destination AS dest_name,  -- Changed from ad.name to ad.destination
    ad.error,
    ad.fail_sequence,
    TO_CHAR(ad.fail_date, 'YYYY-MM-DD HH24:MI:SS') AS fail_date
FROM 
    v$database d, 
    v$archive_dest ad
WHERE 
    ad.status != 'INACTIVE'
ORDER BY 
    ad.dest_id;

-- 10. Archive Log Error Details (Improved formatting)
PROMPT
PROMPT  -- 10. Archive Log Error Details
PROMPT =====================================================
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
PROMPT
PROMPT  -- 11. Top 5 CPU-Consuming Sessions
PROMPT =====================================================
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

> # dba_daily_check
```
-- =====================================================
-- Oracle DBA Daily Health Check Script
-- Author: ChatGPT
-- Purpose: Run before every shift handover
-- =====================================================

SET PAGESIZE 1000
SET LINESIZE 200
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING ON
SET ECHO OFF
SET WRAP ON

SPOOL dba_daily_health_check.txt

-- 1. Date and Time
PROMPT =====================================================
PROMPT DAILY DBA HEALTH CHECK REPORT
PROMPT Date: 
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS CURRENT_DATE FROM DUAL;
PROMPT =====================================================


-- 2. ALERT LOG (Last 24 hours)
PROMPT
PROMPT 1. RECENT ALERT LOG (Last 24 Hours with ORA Errors)
PROMPT =====================================================
COLUMN ALERT_TIME FORMAT A25
COLUMN ALERT_MESSAGE FORMAT A150 WORD_WRAPPED

SELECT 
    TO_CHAR(originating_timestamp, 'DD-MON-YYYY HH24:MI:SS') AS ALERT_TIME,
    message_text AS ALERT_MESSAGE
FROM v$diag_alert_ext
WHERE originating_timestamp >= SYSDATE - 1
  AND message_text LIKE 'ORA-%'
ORDER BY originating_timestamp DESC;

-- 3. RMAN BACKUP STATUS (Last 24 Hours)
PROMPT
PROMPT 2. RMAN BACKUP STATUS (Last 24 Hours)
PROMPT =====================================================
COLUMN START_TIME FORMAT A20
COLUMN END_TIME FORMAT A20
COLUMN STATUS FORMAT A12
COLUMN INPUT_TYPE FORMAT A15
COLUMN SIZE_MB FORMAT 999999.99

SELECT 
    TO_CHAR(start_time, 'DD-MON HH24:MI') AS START_TIME,
    TO_CHAR(end_time, 'DD-MON HH24:MI') AS END_TIME,
    status, input_type, ROUND(output_bytes/1024/1024,2) AS SIZE_MB
FROM v$rman_backup_job_details
WHERE start_time >= SYSDATE - 1
ORDER BY start_time DESC;


-- 4. TABLESPACE USAGE
PROMPT
PROMPT 3. TABLESPACE USAGE DETAILS
PROMPT =====================================================
SELECT 
    df.tablespace_name,
    ROUND(df.total_space_mb - fs.free_space_mb, 2) AS USED_MB,
    ROUND(fs.free_space_mb, 2) AS FREE_MB,
    ROUND((fs.free_space_mb / df.total_space_mb) * 100, 2) AS FREE_PCT
FROM 
    (SELECT tablespace_name, SUM(bytes)/1024/1024 AS total_space_mb FROM dba_data_files GROUP BY tablespace_name) df
JOIN 
    (SELECT tablespace_name, SUM(bytes)/1024/1024 AS free_space_mb FROM dba_free_space GROUP BY tablespace_name) fs
ON df.tablespace_name = fs.tablespace_name
ORDER BY FREE_PCT;


-- 5. LISTENER STATUS (Manual Step)
PROMPT
PROMPT 4. LISTENER STATUS
PROMPT =====================================================
PROMPT Please run: lsnrctl status

-- 6. RAC HEALTH (Manual Step)
PROMPT
PROMPT 5. RAC STATUS CHECK (If RAC is Configured)
PROMPT =====================================================
PROMPT Please run: crsctl stat res -t

-- 7. DATA GUARD SYNC STATUS
PROMPT
PROMPT 6. DATA GUARD SYNC STATUS (Standby Side)
PROMPT =====================================================
SELECT 
    thread#, MAX(sequence#) AS LAST_RECEIVED
FROM v$archived_log
WHERE applied = 'NO'
GROUP BY thread#;

SELECT sequence#, applied FROM v$archived_log
ORDER BY sequence# DESC FETCH FIRST 10 ROWS ONLY;


-- 8. ARCHIVE GAP
PROMPT
PROMPT 7. ARCHIVE LOG GAP CHECK
PROMPT =====================================================
SELECT * FROM v$archive_gap;

-- 9. SCHEDULER JOBS STATUS
PROMPT
PROMPT 8. DBMS_SCHEDULER JOBS STATUS
PROMPT =====================================================
SELECT 
    job_name, state, 
    TO_CHAR(last_start_date, 'DD-MON HH24:MI') AS LAST_RUN,
    TO_CHAR(next_run_date, 'DD-MON HH24:MI') AS NEXT_RUN
FROM dba_scheduler_jobs
WHERE enabled = 'TRUE';

PROMPT
PROMPT 9. FAILED JOBS IN LAST 24 HOURS
PROMPT =====================================================
SELECT 
    job_name, status, additional_info, 
    TO_CHAR(log_date, 'DD-MON HH24:MI') AS LOG_TIME
FROM dba_scheduler_job_run_details
WHERE status != 'SUCCEEDED'
  AND log_date >= SYSDATE - 1
ORDER BY log_date DESC;

-- 10. FRA (Flash Recovery Area) Usage
PROMPT
PROMPT 10. FRA (Flash Recovery Area) USAGE
PROMPT =====================================================
SELECT 
    ROUND(space_used * 100 / space_limit, 2) AS PERCENT_USED,
    ROUND(space_used / 1024 / 1024, 2) AS USED_MB,
    ROUND(space_limit / 1024 / 1024, 2) AS LIMIT_MB,
    number_of_files
FROM v$recovery_file_dest
WHERE space_used > 0;

-- 11. INVALID OBJECTS
PROMPT
PROMPT 11. INVALID OBJECTS (If Any)
PROMPT =====================================================
SELECT object_name, object_type, status FROM dba_objects WHERE status = 'INVALID';

-- 12. BLOCKING SESSIONS
PROMPT
PROMPT 12. BLOCKING SESSIONS (If Any)
PROMPT =====================================================
SELECT 
    sid, serial#, blocking_session, wait_class, seconds_in_wait
FROM v$session
WHERE blocking_session IS NOT NULL;

-- End of Report
PROMPT =====================================================
PROMPT REPORT COMPLETE
PROMPT =====================================================

SPOOL OFF
```

> # All imp path

```
-- =====================================================
-- Oracle 19c Database Paths and Configuration Check
-- Cleaned and corrected version for @script.sql usage
-- =====================================================

SET PAGESIZE 1000
SET LINESIZE 300
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING ON
SET ECHO OFF
SET TRIMSPOOL ON
SET TERMOUT ON

SPOOL Path_details.txt

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

COLUMN ERROR_TIME FORMAT A20
COLUMN ERROR_MESSAGE FORMAT A100 WORD_WRAPPED

-- Timestamp of Report Generation
PROMPT
PROMPT Timestamp of Report Generation
PROMPT =====================================================
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS REPORT_TIME FROM DUAL;

-- 1. DATABASE INFORMATION
PROMPT
PROMPT 1. DATABASE INFORMATION
PROMPT =====================================================
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
PROMPT
PROMPT 2. DATAFILE LOCATIONS
PROMPT =====================================================
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
PROMPT
PROMPT 3. TEMPFILE LOCATIONS
PROMPT =====================================================
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
PROMPT
PROMPT 4. CONTROL FILE LOCATIONS
PROMPT =====================================================
SELECT 
    name AS CONTROL_FILE_PATH,
    status AS STATUS,
    is_recovery_dest_file AS RECOVERY_DEST_FILE,
    block_size AS BLOCK_SIZE,
    file_size_blks AS FILE_SIZE_BLOCKS
FROM v$controlfile;

-- 5. REDO LOG FILE LOCATIONS
PROMPT
PROMPT 5. REDO LOG FILE LOCATIONS
PROMPT =====================================================
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
PROMPT
PROMPT 6. ARCHIVE LOG DESTINATIONS
PROMPT =====================================================
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
PROMPT
PROMPT 7. DIAGNOSTIC DESTINATION
PROMPT =====================================================
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE,
    description AS DESCRIPTION
FROM v$parameter 
WHERE name IN ('diagnostic_dest', 'background_dump_dest', 'user_dump_dest', 'core_dump_dest');

-- 8. FLASH RECOVERY AREA (FRA) DETAILS
PROMPT
PROMPT 8. FLASH RECOVERY AREA (FRA) DETAILS
PROMPT =====================================================
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
PROMPT
PROMPT 9. DIRECTORY OBJECTS
PROMPT =====================================================
SELECT 
    directory_name AS DIRECTORY_NAME,
    directory_path AS DIRECTORY_PATH,
    origin_con_id AS ORIGIN_CONTAINER_ID
FROM dba_directories
ORDER BY directory_name;

-- 10. DUMP DESTINATIONS
PROMPT
PROMPT 10. DUMP DESTINATIONS
PROMPT =====================================================
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
PROMPT
PROMPT 11. AUDIT FILE DESTINATION
PROMPT =====================================================
SELECT 
    name AS PARAMETER_NAME,
    value AS PARAMETER_VALUE
FROM v$parameter 
WHERE name IN ('audit_file_dest', 'audit_trail', 'audit_sys_operations');

-- 12. SPFILE AND PFILE LOCATIONS
PROMPT
PROMPT 12. SPFILE AND PFILE LOCATIONS
PROMPT =====================================================
SELECT 
    'SPFILE' AS FILE_TYPE,
    value AS FILE_PATH
FROM v$parameter WHERE name = 'spfile'
UNION ALL
SELECT 
    'ORACLE_HOME' AS FILE_TYPE,
    value || '/dbs/init' || (SELECT value FROM v$parameter WHERE name = 'db_name') || '.ora' AS FILE_PATH
FROM v$parameter WHERE name = 'oracle_home';

-- 13. ORACLE HOME AND BASE INFORMATION
PROMPT
PROMPT 13. ORACLE HOME AND BASE INFORMATION
PROMPT =====================================================
SELECT 
    name AS parameter_name,
    value AS parameter_value,
    display_value AS display_value
FROM v$parameter
WHERE name IN ('spfile', 'memory_target', 'memory_max_target', 'processes', 'nls_language')
ORDER BY name;

-- 14. NETWORK CONFIGURATION INFORMATION
PROMPT
PROMPT 14. NETWORK CONFIGURATION INFORMATION
PROMPT =====================================================
SELECT 
    'TNS_ADMIN' AS config_type,
    value AS path
FROM v$parameter 
WHERE name = 'tns_admin' AND value IS NOT NULL
UNION ALL
SELECT 
    'ORACLE_HOME/network/admin' AS config_type,
    sys_context('USERENV', 'ORACLE_HOME') || '/network/admin' AS path
FROM dual
WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL
UNION ALL
SELECT 
    'DEFAULT_TNS_ADMIN' AS config_type,
    '/etc/oracle' AS path
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM v$parameter 
    WHERE name = 'tns_admin' AND value IS NOT NULL
)
AND sys_context('USERENV', 'ORACLE_HOME') IS NULL;

-- 15. RECENT BACKUP PIECE LOCATIONS (RMAN)
PROMPT
PROMPT 15. RECENT BACKUP PIECE LOCATIONS (RMAN)
PROMPT =====================================================
SELECT 
    bp.handle AS backup_piece_path,
    bp.media AS media_type,
    TO_CHAR(bp.start_time, 'YYYY-MM-DD HH24:MI:SS') AS start_time,
    bp.status AS status
FROM v$backup_piece bp
ORDER BY bp.start_time DESC;

-- 16. DATABASE FILE STORAGE TYPE
PROMPT
PROMPT 16. DATABASE FILE STORAGE TYPE
PROMPT =====================================================
SELECT 
    'DATAFILES' AS FILE_TYPE,
    CASE 
        WHEN file_name LIKE '+%' THEN 'ASM'
        WHEN file_name LIKE '/dev/%' THEN 'RAW DEVICE'
        ELSE 'FILESYSTEM'
    END AS STORAGE_TYPE,
    COUNT(*) AS FILE_COUNT
FROM dba_data_files
GROUP BY 
    CASE 
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
GROUP BY 
    CASE 
        WHEN file_name LIKE '+%' THEN 'ASM'
        WHEN file_name LIKE '/dev/%' THEN 'RAW DEVICE'
        ELSE 'FILESYSTEM'
    END;

-- 17. IMPORTANT ORACLE HOME SUBDIRECTORIES
PROMPT
PROMPT 17. IMPORTANT ORACLE HOME SUBDIRECTORIES
PROMPT =====================================================
SET SQLBLANKLINES ON
SELECT 'ORACLE_HOME' AS BASE_PATH, sys_context('USERENV', 'ORACLE_HOME') AS PATH FROM dual WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL
UNION ALL
SELECT 'BIN Directory' AS BASE_PATH, sys_context('USERENV', 'ORACLE_HOME') || '/bin' AS PATH FROM dual WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL
UNION ALL
SELECT 'LIB Directory' AS BASE_PATH, sys_context('USERENV', 'ORACLE_HOME') || '/lib' AS PATH FROM dual WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL
UNION ALL
SELECT 'RDBMS/ADMIN Directory' AS BASE_PATH, sys_context('USERENV', 'ORACLE_HOME') || '/rdbms/admin' AS PATH FROM dual WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL
UNION ALL
SELECT 'NETWORK/ADMIN Directory' AS BASE_PATH, sys_context('USERENV', 'ORACLE_HOME') || '/network/admin' AS PATH FROM dual WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL
UNION ALL
SELECT 'DBS Directory' AS BASE_PATH, sys_context('USERENV', 'ORACLE_HOME') || '/dbs' AS PATH FROM dual WHERE sys_context('USERENV', 'ORACLE_HOME') IS NOT NULL;

-- 18. ALERT LOG LOCATION
PROMPT
PROMPT 18. ALERT LOG LOCATION
PROMPT =====================================================
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
PROMPT
PROMPT 19. WALLET LOCATION (TDE CONFIGURATION)
PROMPT =====================================================
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
PROMPT
PROMPT 20. ASM DISKGROUP INFORMATION
PROMPT =====================================================
SELECT 
    'ASM_USAGE_CHECK' AS CHECK_TYPE,
    CASE 
        WHEN COUNT(*) > 0 THEN 'ASM IS USED'
        ELSE 'ASM NOT USED'
    END AS STATUS
FROM dba_data_files 
WHERE file_name LIKE '+%';

-- 21. ADDITIONAL SYSTEM INFORMATION
PROMPT
PROMPT 21. ADDITIONAL SYSTEM INFORMATION
PROMPT =====================================================
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
PROMPT
PROMPT 22. TABLESPACE USAGE SUMMARY
PROMPT =====================================================
WITH ts_metrics AS (
    SELECT
        df.tablespace_name,
        df.total_size_gb,
        NVL(fs.free_size_gb, 0) AS free_size_gb,
        NVL(us.used_size_gb, 0) AS used_size_gb,
        df.max_size_gb,
        df.autoextensible,
        df.status,
        ts.contents,
        ts.block_size,
        ts.extent_management,
        ts.allocation_type,
        ts.segment_space_management
    FROM 
        (SELECT 
            tablespace_name,
            SUM(bytes)/1024/1024/1024 AS total_size_gb,
            SUM(CASE WHEN autoextensible = 'YES' THEN maxbytes ELSE bytes END)/1024/1024/1024 AS max_size_gb,
            MAX(autoextensible) AS autoextensible,
            MAX(status) AS status
         FROM dba_data_files 
         GROUP BY tablespace_name) df
    LEFT JOIN 
        (SELECT tablespace_name, SUM(bytes)/1024/1024/1024 AS free_size_gb
         FROM dba_free_space GROUP BY tablespace_name) fs
    ON df.tablespace_name = fs.tablespace_name
    LEFT JOIN
        (SELECT tablespace_name, SUM(bytes)/1024/1024/1024 AS used_size_gb
         FROM dba_segments GROUP BY tablespace_name) us
    ON df.tablespace_name = us.tablespace_name
    JOIN dba_tablespaces ts ON df.tablespace_name = ts.tablespace_name
)
SELECT
    tablespace_name AS "Tablespace",
    contents AS "Type",
    ROUND(total_size_gb, 2) AS "Current Size (GB)",
    ROUND(max_size_gb, 2) AS "Max Size (GB)",
    ROUND(used_size_gb, 2) AS "Used Space (GB)",
    ROUND(free_size_gb, 2) AS "Free Space (GB)",
    ROUND((used_size_gb/total_size_gb)*100, 2) AS "Used %",
    ROUND((free_size_gb/total_size_gb)*100, 2) AS "Free %",
    ROUND((max_size_gb - total_size_gb)/1024, 2) AS "Growth Available (TB)",
    autoextensible AS "Autoextend",
    status AS "Status",
    block_size/1024 AS "Block Size (KB)",
    extent_management AS "Extent Mgmt",
    allocation_type AS "Allocation Type",
    segment_space_management AS "Segment Mgmt"
FROM ts_metrics
ORDER BY "Used %" DESC, tablespace_name;

-- 23. RECENT ALERT LOG (Last 24 Hours with ORA Errors)
PROMPT
PROMPT 23. RECENT ALERT LOG (Last 24 Hours with ORA Errors)
PROMPT =====================================================
SELECT 
    TO_CHAR(originating_timestamp, 'DD-MON-YYYY HH24:MI:SS') AS ERROR_TIME,
    message_text AS ERROR_MESSAGE
FROM v$diag_alert_ext
WHERE component_id = 'rdbms'
AND message_text LIKE 'ORA-%'
AND originating_timestamp >= SYSDATE - 1
ORDER BY originating_timestamp DESC;

SPOOL OFF
-- END OF SCRIPT
```
