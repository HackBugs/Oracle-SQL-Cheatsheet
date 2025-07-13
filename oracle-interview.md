
```
find /$ORACLE_HOME -name 'tnsnames.ora'
//u01/app/oracle/product/19.0.0/db_1/network/admin/samples/tnsnames.ora
//u01/app/oracle/product/19.0.0/db_1/network/admin/tnsnames.ora

find /$ORACLE_HOME -name 'awrrpt.sql'
//u01/app/oracle/product/19.0.0/db_1/rdbms/admin/awrrpt.sql

find /$ORACLE_HOME -name 'listener.ora'
//u01/app/oracle/product/19.0.0/db_1/network/admin/samples/listener.ora
//u01/app/oracle/product/19.0.0/db_1/network/admin/listener.ora
```

बहुत बढ़िया! आपने Oracle Interview के लिए काफी practical बातें और real-life experience share किया है। अब मैं इसे अच्छी तरह **organize** कर देता हूँ ताकि आप इसे इंटरव्यू में confidently और professional तरीके से बता सको।

---

# ✅ **Oracle DBA Interview Preparation Notes (Hinglish Me)**

---

## 🔹 **1. Index Rebuilding & Tuning**

* Jab index rebuild karte hain aur koi issue aata hai (jaise performance down), to problematic SQL ko identify karte hain.
* AWR report ya V\$ views se top SQLs, high CPU consuming processes identify karte hain.
* Hard parsing zyada ho to indexing, bind variables, ya SQL tuning check karna padta hai.
* Full table scan detect karna hoga — iska matlab proper indexing nahi hai ya index use nahi ho raha.

**Tools:**

* AWR Report
* V\$SQL, V\$SESSION
* SQL Execution Plan (EXPLAIN PLAN, AUTO TRACE)

---

## 🔹 **2. AWR Report Usage**

* AWR se top 5 foreground processes dekhe jaate hain.
* Check hota hai:

  * CPU utilization
  * Disk I/O
  * Soft Parsing vs Hard Parsing
  * Redo generation
  * Transaction per second
* Buffer Cache Hit Ratio, Library Cache Hit Ratio, Soft Parse Ratio — sab 90–100% ke beech hone chahiye.

---

## 🔹 **3. SQL Performance Check**

* SQL queries ka Execution Plan nikal ke dekhte hain:

  * `EXPLAIN PLAN FOR <your query>`
  * `SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);`
* Check karte hain:

  * Full table scan to nahi ja raha?
  * Index use ho raha ya nahi?

---

## 🔹 **4. SQL Developer Connection Issues**

* SQL Developer se jab connection issue aaye:

  * Listener.ora, tnsnames.ora me port & service name check karo.
  * Listener up hai ya nahi ye check karo:

    * `lsnrctl status`
  * TNS ping test bhi kar sakte hain:

    * `tnsping service_name`

---

## 🔹 **5. Real-Life Example (Extraordinary Work)**

**Scenario:**
"Ek baar system slow ho gaya tha, user complain kar rahe the. Maine AWR report nikala, top processes dekhe, V\$session se problematic SQL dekhi, Execution Plan nikal ke dekha ki full table scan ho raha hai. Fir developer ko bola ki query rewrite karein ya index banayein. Performance improve ho gaya."

---

## 🔹 **6. Load Profile / Performance Parameters**

* Load profile se:

  * Redo Generated
  * Logical Reads
  * Physical Reads
  * DB Time
* Sab parameters ideally **optimized** hone chahiye.
* Example:

  * Hard Parsing zyada hai to Bind variables ka use karo.
  * Transactions/sec bahut zyada hai to proper commit/rollback use ho raha ya nahi wo check karo.

---

## 🔹 **7. Indexing**

* **Why Indexing?**
  Query speed badhane ke liye — agar index hoga to result faster milega.
* **Index Banana:**

```sql
CREATE INDEX idx_salary ON employee(salary);
```

* Example:
  Agar query hai:

  ```sql
  SELECT * FROM employee WHERE salary > 5000;
  ```

  To salary column pe index hona chahiye for better performance.

---

## 🔹 **8. EXPLAIN PLAN (Execution Plan)**

* 2 Methods:

  1. **EXPLAIN PLAN**

     ```sql
     EXPLAIN PLAN FOR <your_query>;
     SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
     ```
  2. **SET AUTOTRACE ON**
     SQL Developer ya SQL\*Plus me:

     ```sql
     SET AUTOTRACE ON;
     ```

---

## 🔹 **9. Developer ke saath kaam karte waqt**

* Agar query slow hai:

  * Execution plan nikaal kar dekhte hain.
  * Index hai ya nahi check karte hain.
  * Query developer ne likhi hoti hai, to unko suggest karte hain ki query ko tune karein.
  * Hum sirf backend performance monitor karte hain.

---

## 🔹 **10. V\$ Views ka Use**

* V\$SQL → Top SQLs
* V\$SESSION → Active sessions
* V\$PROCESS → Background & foreground processes
* V\$EVENT → Wait events

---

## 🔹 **11. Interview ke liye Tips**

* Jab apne kaam ka explanation do, confidently batao ki tumne kya identify kiya, kaise solve kiya.
* "Main AWR report banata hoon aur senior ko bhejta hoon" se better hai:

  > "Jab performance issue hota hai, main AWR ya V\$ views ke through root cause find karta hoon, jaise top SQLs, full table scans, ya indexing issues, fir senior ke sath discuss karke fix karte hain."

---

## ✅ Summary Cheat Sheet

| Area                    | Tools / Commands Used                          |
| ----------------------- | ---------------------------------------------- |
| Performance Tuning      | AWR, V\$SQL, V\$SESSION, V\$PROCESS, SQL Plan  |
| SQL Check               | EXPLAIN PLAN, SET AUTOTRACE ON                 |
| Index Creation          | CREATE INDEX                                   |
| Connection Troubleshoot | lsnrctl, listener.ora, tnsnames.ora            |
| Load Profile Monitoring | Redo, Logical/Physical Reads, Tx/sec           |
| Real-World Scenario     | Slow system → AWR → SQL tune → performance fix |

---

> # Bonus: Ek Format Command Pack (SQL*Plus ke liye)

```
SET LINESIZE 200;
SET PAGESIZE 100;
SET TRIMSPOOL ON;
SET FEEDBACK OFF;

COLUMN sid FORMAT 9999;
COLUMN serial# FORMAT 99999;
COLUMN username FORMAT A15;
COLUMN sql_id FORMAT A13;
COLUMN event FORMAT A40;
COLUMN sql_text FORMAT A60;
COLUMN program FORMAT A30;
```

Bilkul! Niche maine aapko **ready-to-use SQL queries** de di hain jo aap Oracle 19c database me direct run karke **performance check**, **active sessions**, **top SQLs**, **wait events** jaise sab details dekh sakte ho.

---

## ✅ **1. V\$SQL → Top SQLs by CPU Usage**

```sql
SELECT *
FROM (
  SELECT sql_text, sql_id, executions, cpu_time, elapsed_time
  FROM v$sql
  WHERE executions > 0
  ORDER BY cpu_time DESC
)
WHERE ROWNUM <= 10;
```

> # 🔍 **Purpose:** Ye top 10 SQL queries dikhayega jo sabse zyada CPU use kar rahi hain.

---

## ✅ **2. V\$SESSION → Active Sessions (Current Logged-in Sessions)**

```sql
SELECT sid, serial#, username, status, osuser, machine, program, sql_id
FROM v$session
WHERE status = 'ACTIVE'
AND username IS NOT NULL;
```

🔍 **Purpose:** Ye currently active (running) sessions ko dikhata hai.

---

## ✅ **3. V\$PROCESS → Background aur Foreground Processes**

```sql
SELECT p.pid, p.spid, s.sid, s.serial#, s.username, s.program
FROM v$process p
JOIN v$session s ON p.addr = s.paddr
WHERE s.username IS NOT NULL;
```

🔍 **Purpose:** Ye query Oracle ke **foreground** (user sessions) aur **background** processes ke mapping dikhata hai.

---

## ✅ **4. V\$EVENT → Wait Events (Wait hone wali cheezein)**

```sql
SELECT event, total_waits, time_waited, average_wait
FROM v$system_event
WHERE event NOT LIKE 'SQL*Net message%'
ORDER BY time_waited DESC;
```

🔍 **Purpose:** Ye dikhata hai ki system me kis operation pe wait zyada ho raha hai (I/O, latch, lock, etc.)

---

## ✅ Bonus: **Check Top SQL by Elapsed Time (Slow queries)**

```sql
SELECT sql_id, sql_text, elapsed_time, executions
FROM v$sql
WHERE executions > 0
ORDER BY elapsed_time DESC
FETCH FIRST 5 ROWS ONLY;
```

---

## ✅ Bonus: **Check Session Waits in Real-time**

```sql
SELECT sid, event, wait_class, seconds_in_wait, state
FROM v$session_wait
WHERE wait_class != 'Idle';
```

> # Oracle DBA ka **daily shift handover** ya **EOD (End of Day) checklist** 

---

## ✅ **Daily DBA Checklist – Shift Over Hone Se Pehle**

Yeh checklist banayi gayi hai **production Oracle DB** ke liye – RAC, Data Guard, RMAN, Jobs, etc. ke hisaab se:

---

### 🔸 1. **Check Alert Log (For Errors)**

```sql
SELECT 
    TO_CHAR(originating_timestamp, 'DD-MON-YYYY HH24:MI:SS') AS TIME,
    message_text AS ALERT
FROM v$diag_alert_ext
WHERE originating_timestamp >= SYSDATE - 1
  AND message_text LIKE 'ORA-%'
ORDER BY originating_timestamp DESC;
```

📌 Ya Linux se:

```bash
tail -50 $ORACLE_BASE/diag/rdbms/<db>/<inst>/trace/alert_<inst>.log
```

---

### 🔸 2. **Check RMAN Backups (Last 24 Hours)**

```sql
SELECT 
    TO_CHAR(start_time, 'DD-MON HH24:MI') AS START_TIME,
    TO_CHAR(end_time, 'DD-MON HH24:MI') AS END_TIME,
    status, input_type, round(output_bytes/1024/1024,2) AS SIZE_MB
FROM v$rman_backup_job_details
WHERE start_time >= SYSDATE - 1
ORDER BY start_time DESC;
```

---

### 🔸 3. **Check Tablespace Usage**

```sql
SELECT 
    tablespace_name,
    ROUND((total_space - free_space), 2) AS USED_MB,
    ROUND(free_space, 2) AS FREE_MB,
    ROUND((free_space / total_space) * 100, 2) AS FREE_PERCENT
FROM (
    SELECT df.tablespace_name,
           SUM(df.bytes) / 1024 / 1024 AS total_space,
           SUM(f.bytes) / 1024 / 1024 AS free_space
    FROM dba_data_files df
    JOIN dba_free_space f USING (tablespace_name)
    GROUP BY df.tablespace_name
)
ORDER BY FREE_PERCENT;
```

📌 Alert if FREE\_PERCENT < 20%

---

### 🔸 4. **Check Listener Status**

```bash
lsnrctl status
```

Check for:

* Services registered
* Connection errors
* Listener uptime

---

### 🔸 5. **Check RAC Health (If RAC is used)**

```bash
crsctl check crs
crsctl stat res -t
```

Check:

* Node status
* Resource online/offline
* Interconnect status

---

### 🔸 6. **Check Data Guard Sync Status (If DG is used)**

#### 🔁 On Standby:

```sql
SELECT thread#, MAX(sequence#) "Last Received"
FROM v$archived_log
WHERE applied='NO'
GROUP BY thread#;

SELECT sequence#, applied FROM v$archived_log
ORDER BY sequence# DESC FETCH FIRST 10 ROWS ONLY;
```

#### 🔗 On Primary:

```sql
SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST WHERE STATUS != 'INACTIVE';
```

📌 Alert if GAP exists.

---

### 🔸 7. **Check Job Scheduler Status (DBMS\_SCHEDULER)**

```sql
SELECT 
    job_name, state, TO_CHAR(last_start_date, 'DD-MON HH24:MI') AS LAST_RUN,
    TO_CHAR(next_run_date, 'DD-MON HH24:MI') AS NEXT_RUN
FROM dba_scheduler_jobs
WHERE enabled = 'TRUE';
```

📌 Check for `FAILED` jobs:

```sql
SELECT * FROM dba_scheduler_job_run_details
WHERE status != 'SUCCEEDED'
  AND log_date >= SYSDATE - 1
ORDER BY log_date DESC;
```

---

### 🧾 **Extra Recommended Checks (Optional but Useful)**

| Task                 | Command                                                               |
| -------------------- | --------------------------------------------------------------------- |
| FRA Space Usage      | `SELECT * FROM v$recovery_file_dest;`                                 |
| ASM Diskgroup Health | `SELECT * FROM v$asm_diskgroup;`                                      |
| Invalid Objects      | `SELECT object_name, status FROM dba_objects WHERE status='INVALID';` |
| Blocking Sessions    | `SELECT * FROM v$session WHERE blocking_session IS NOT NULL;`         |
| Archive Log Gap      | `SELECT * FROM v$archive_gap;`                                        |

---

## ✅ **How to Use It Daily**

1. Save all queries in one file: `dba_daily_check.sql`
2. Login:

```bash
sqlplus / as sysdba
```

3. Run:

```sql
@/path/to/dba_daily_check.sql
```

4. 📤 Optional: Use `SPOOL dba_report.txt` to generate report.

---

## ✅ Summary Table (Checklist View)

| # | Task             | Query/Tool                         | Pass Criteria      |
| - | ---------------- | ---------------------------------- | ------------------ |
| 1 | Alert Log        | `v$diag_alert_ext`                 | No critical ORA-   |
| 2 | Backups          | `v$rman_backup_job_details`        | Status = COMPLETED |
| 3 | Tablespace Space | Custom query                       | Free > 20%         |
| 4 | Listener         | `lsnrctl status`                   | Listener running   |
| 5 | RAC Health       | `crsctl stat res -t`               | All Online         |
| 6 | Data Guard Sync  | `v$archived_log`, `v$archive_dest` | No gap             |
| 7 | Scheduler Jobs   | `dba_scheduler_jobs`               | No failed jobs     |

---

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
