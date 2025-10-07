# **1) Create Monitoring DB User (Read‑Only Catalog Access)**

This user is created for **day-to-day monitoring**. It has **limited system privileges** and **catalog read access**.

**File:** `create_monitor_user.sql`

```sql
-- Run as SYS (or another user with privileges)
-- Change password before use
CREATE USER monitor_user IDENTIFIED BY Monitor@123
 DEFAULT TABLESPACE USERS
 TEMPORARY TABLESPACE TEMP
 ACCOUNT UNLOCK;

-- Grant minimal privileges for monitoring
GRANT CREATE SESSION TO monitor_user;
GRANT SELECT_CATALOG_ROLE TO monitor_user;   -- Access to many V$ / DBA_ views

-- Optional: grant SELECT on specific objects
GRANT SELECT ON v_$session TO monitor_user;
GRANT SELECT ON v_$sql TO monitor_user;
GRANT SELECT ON v_$process TO monitor_user;
GRANT SELECT ON dba_users TO monitor_user;
GRANT SELECT ON dba_data_files TO monitor_user;
GRANT SELECT ON dba_free_space TO monitor_user;

COMMIT;
```

---

# **2) Monitoring SQL Script — Collects Day‑to‑Day Info**

**File:** `daily_monitor.sql`
Run as `monitor_user` (or `sysdba` for some views). Spools results to a timestamped file.

```sql
SET PAGESIZE 200
SET LINESIZE 200
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING ON

-- Generate timestamped spool file
COLUMN now_col NEW_VALUE NOWVAL
SELECT TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS') now_col FROM DUAL;
SPOOL /tmp/monitor_${NOWVAL}.txt

PROMPT ==== Database / Instance Info ====
SELECT instance_name, host_name, status, version FROM v$instance;

PROMPT ==== Current Date/Time ====
SELECT SYSDATE FROM DUAL;

PROMPT ==== Sessions Summary ====
SELECT status, COUNT(*) cnt FROM v$session GROUP BY status ORDER BY status;

PROMPT ==== Active Sessions (Top 20 by CPU / Elapsed) ====
SELECT s.sid, s.serial#, s.username, s.program, s.machine, s.status, s.last_call_et, q.sql_text
FROM v$session s LEFT JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.username IS NOT NULL AND s.status='ACTIVE'
ORDER BY s.last_call_et DESC FETCH FIRST 20 ROWS ONLY;

PROMPT ==== Long Running SQL (by Elapsed) ====
SELECT sql_id, sql_text, elapsed_time/1000000 elapsed_seconds, executions
FROM v$sql
ORDER BY elapsed_time DESC FETCH FIRST 10 ROWS ONLY;

PROMPT ==== Long Running Sessions (> 300s) ====
SELECT sid, serial#, username, status, last_call_et, machine
FROM v$session
WHERE last_call_et > 300
ORDER BY last_call_et DESC;

PROMPT ==== Tablespace Usage (MB) ====
SELECT df.tablespace_name, 
       ROUND(SUM(df.bytes)/1024/1024,2) total_mb,
       ROUND(SUM(fs.bytes)/1024/1024,2) free_mb,
       ROUND((SUM(df.bytes)-NVL(SUM(fs.bytes),0))/SUM(df.bytes)*100,2) pct_used
FROM dba_data_files df
LEFT JOIN dba_free_space fs ON df.tablespace_name = fs.tablespace_name
GROUP BY df.tablespace_name
ORDER BY pct_used DESC;

PROMPT ==== Datafile Sizes ====
SELECT file_name, tablespace_name, bytes/1024/1024 size_mb, autoextensible
FROM dba_data_files;

PROMPT ==== User Accounts Status / Expiry / Locked ====
SELECT username, account_status, lock_date, expiry_date
FROM dba_users
ORDER BY username;

PROMPT ==== User Roles (Important List) ====
SELECT grantee, granted_role, admin_option
FROM dba_role_privs
ORDER BY grantee;

PROMPT ==== System Privileges (Granted to Users) ====
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee NOT LIKE 'SYS'
ORDER BY grantee;

PROMPT ==== Object Privileges (Top Few) ====
SELECT owner, table_name, grantee, privilege
FROM dba_tab_privs
WHERE ROWNUM < 50;

PROMPT ==== Blocking Sessions (Who Waits on Whom) ====
SELECT /*+RULE*/ blocking_session, sid, serial#, username, event, seconds_in_wait
FROM v$session
WHERE blocking_session IS NOT NULL;

PROMPT ==== Recent Errors from Alert Log (Last 200 Lines) ====
-- Requires server access; cannot query directly from SQL
-- Use: tail -n 200 $ADR_BASE/.../alert_<SID>.log  (run from OS)

SPOOL OFF
```

---

# **3) Useful Day‑to‑Day Monitoring Queries**

```sql
-- Account Status
SELECT username, account_status, lock_date, expiry_date
FROM dba_users
ORDER BY username;

-- Password Expiry Soon (Next 7 Days)
SELECT username, expiry_date
FROM dba_users
WHERE expiry_date <= SYSDATE + 7
ORDER BY expiry_date;

-- Roles Granted to User
SELECT * FROM dba_role_privs WHERE grantee='MONITOR_USER';

-- System Privileges Granted
SELECT * FROM dba_sys_privs WHERE grantee='MONITOR_USER';
```

---

# **4) Sessions / Active SQL Queries**

```sql
-- Active Sessions
SELECT sid, serial#, username, status, osuser, machine, program, last_call_et
FROM v$session
WHERE username IS NOT NULL
ORDER BY last_call_et DESC;

-- Top SQL by Buffer Gets or Elapsed
SELECT sql_id, executions, buffer_gets, elapsed_time/1000000 elapsed_sec
FROM v$sql
ORDER BY buffer_gets DESC
FETCH FIRST 10 ROWS ONLY;
```

---

# **5) Tablespace & Datafile Queries**

```sql
-- Free Space per Tablespace
SELECT tablespace_name, SUM(bytes)/1024/1024 free_mb
FROM dba_free_space
GROUP BY tablespace_name;

-- Datafile Details
SELECT file_name, tablespace_name, bytes/1024/1024 size_mb, autoextensible
FROM dba_data_files;
```

---

# **6) Long Running / Blocking Sessions Queries**

```sql
-- Blocking Sessions
SELECT s.username blocker, s.sid blocker_sid, w.username waiter, w.sid waiter_sid, w.event, w.seconds_in_wait
FROM v$session s
JOIN v$session w ON s.sid = w.blocking_session;

-- Long Running SQL (Active > 300s)
SELECT s.sid, s.username, q.sql_id, q.sql_text, s.last_call_et
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.last_call_et > 300 AND s.status='ACTIVE';
```

---

# **7) Runner: Windows .BAT to SSH and Run the Monitor Script**

**File:** `ConnectAndRun.bat`

```bat
@echo off
REM --------------------------
REM Change these variables
REM --------------------------
SET HOST=192.168.1.124
SET SSH_USER=oracle
SET KEY=%USERPROFILE%\.ssh\id_rsa_oracle
SET REMOTE_SQL=/home/oracle/monitor/daily_monitor.sql
SET REMOTE_SPOOL_DIR=/tmp

REM Run remote sqlplus as monitor_user (uses TNS connect to local listener)
ssh -i "%KEY%" -t %SSH_USER%@%HOST% "sqlplus -s monitor_user/Monitor@123@//localhost:1521/oradb.localdomain @%REMOTE_SQL%"

REM Note: If monitor_user has no passwordless auth, run as OS user with 'sqlplus / as sysdba' if needed.
pause
```

---

✅ **This organized version includes:**

1. User creation SQL
2. Daily monitoring script
3. Quick monitoring queries
4. Sessions / SQL monitoring queries
5. Tablespace / Datafile queries
6. Blocking / Long-running SQL queries
7. Windows `.bat` runner for automation

---
