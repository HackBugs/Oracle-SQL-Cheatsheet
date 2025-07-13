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
