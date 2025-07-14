
### Check SMON / PMNON
```
ps -ef | grep pmon
ps -ef | grep smon

free -th
df -Th
```

###  Alert log check:
```
tail -100f /u01/app/oracle/diag/rdbms/oradb/oradb/trace/alert_oradb.log
```

### Listener status check:
```
lsnrctl status
```

### Agar kabhi ORACLE_HOME or ORACLE_SID set nahi mile, to:
```
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/db_1
export ORACLE_SID=oradb
export PATH=$ORACLE_HOME/bin:$PATH
```

### Apne ~/.bash_profile me ye lines daal do taaki reboot ke baad bhi environment set rahe:
```
# Oracle Environment Setup
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/db_1
export ORACLE_SID=oradb
export PATH=$ORACLE_HOME/bin:$PATH

source ~/.bash_profile
```

### Full Query: Used, Free, Total Tablespace (MB) + % Used

```
SELECT tablespace_name,
       ROUND(used_space*8/1024, 2) AS used_mb,
       ROUND((tablespace_size - used_space)*8/1024, 2) AS free_mb,
       ROUND(tablespace_size*8/1024, 2) AS total_mb,
       ROUND((used_space/tablespace_size)*100, 2) AS pct_used
FROM dba_tablespace_usage_metrics
ORDER BY pct_used DESC;
```

### Formatted SQL Query for Datafile Usage (MB + % Used)

```
SET LINES 200
SET PAGESIZE 100
COLUMN tablespace_name FORMAT A20
COLUMN file_name FORMAT A60
COLUMN total_mb FORMAT 999999.99
COLUMN used_mb FORMAT 999999.99
COLUMN free_mb FORMAT 999999.99
COLUMN pct_used FORMAT 999.99

SELECT 
    df.tablespace_name,
    df.file_name,
    ROUND(df.bytes/1024/1024, 2) AS total_mb,
    ROUND((df.bytes - NVL(fs.free_bytes,0))/1024/1024, 2) AS used_mb,
    ROUND(NVL(fs.free_bytes,0)/1024/1024, 2) AS free_mb,
    ROUND(((df.bytes - NVL(fs.free_bytes,0)) / df.bytes) * 100, 2) AS pct_used
FROM 
    dba_data_files df
LEFT JOIN 
    (SELECT file_id, SUM(bytes) AS free_bytes 
     FROM dba_free_space 
     GROUP BY file_id) fs
ON df.file_id = fs.file_id
ORDER BY pct_used DESC;
```

### Largest Tables in the DB (Segment Size)

```
SELECT owner, segment_name, segment_type, 
       ROUND(bytes/1024/1024,2) AS size_mb
FROM dba_segments
WHERE segment_type='TABLE'
ORDER BY bytes DESC FETCH FIRST 10 ROWS ONLY;
```

### Oracle Total Database Size — Total, Used, Free, and Available Space?"

```
SELECT 
  ROUND(SUM(df.bytes)/1024/1024/1024, 2) AS total_allocated_gb,
  ROUND(SUM(df.bytes - NVL(fs.bytes,0))/1024/1024/1024, 2) AS used_gb,
  ROUND(SUM(NVL(fs.bytes,0))/1024/1024/1024, 2) AS free_gb,
  ROUND(SUM(DECODE(df.autoextensible, 'YES', df.maxbytes, df.bytes))/1024/1024/1024, 2) AS max_possible_gb
FROM 
  dba_data_files df
LEFT JOIN 
  (SELECT file_id, SUM(bytes) bytes FROM dba_free_space GROUP BY file_id) fs
ON df.file_id = fs.file_id;
```

<hr>

> # **Oracle DBA interview**
**"Aap day-to-day me kya kya tasks karte ho as a DBA?"**

---

## ✅ Day-to-Day Oracle DBA Tasks (Practical + Real-Time Style)

### 🗓️ 1. **Daily Tasks (Roz Ka Kaam)**

| 🔍 Task                            | 💬 Description                 | 🧪 Practical Commands                            |                                                      |
| ---------------------------------- | ------------------------------ | ------------------------------------------------ | ---------------------------------------------------- |
| 🔹 DB up hai ya nahi check karna   | Instance, listener check karna | \`ps -ef                                         | grep pmon`, `lsnrctl status`, `sqlplus / as sysdba\` |
| 🔹 Tablespace full to nahi ho raha | Usage monitor karna            | `dba_tablespace_usage_metrics`                   |                                                      |
| 🔹 FRA full to nahi ho raha        | Archive space check karna      | `v$recovery_file_dest`, `archive log list`       |                                                      |
| 🔹 Alert log errors check karna    | Warnings, ORA- errors          | `tail -100f alert_oradb.log`                     |                                                      |
| 🔹 Backup complete hua ya nahi     | RMAN logs check                | `cat /backup/logs/rman_*.log`                    |                                                      |
| 🔹 Blocking session detect karna   | Lock to nahi laga              | `v$session` where `blocking_session IS NOT NULL` |                                                      |
| 🔹 Invalid objects check karna     | Compile/recompile objects      | `dba_objects` with status = 'INVALID'            |                                                      |
| 🔹 Disk usage check karna          | Server full to nahi ho gaya    | `df -h`                                          |                                                      |

---

### 🗓️ 2. **Weekly Tasks (Har Hafte)**

| 🔍 Task                            | 💬 Description                                  |
| ---------------------------------- | ----------------------------------------------- |
| 📦 Full RMAN Backup Schedule check | `rman catalog start with`, verify logs          |
| 📄 AWR Report generate karna       | Performance check                               |
| 🔍 Segment size monitor karna      | Top tables, growth pattern                      |
| 🔄 Clone DB for UAT/Testing        | `RMAN duplicate`, `expdp/impdp`                 |
| 💽 Space Forecasting               | Growth chart banana tablespace ka               |
| 🔁 Redo log switch monitor         | `select sequence#, applied from v$archived_log` |

---

### 🗓️ 3. **Monthly Tasks (Har Mahine)**

| 🔍 Task                          | 💬 Description                  |
| -------------------------------- | ------------------------------- |
| 🔐 Patching apply karna          | PSU/CPU patch with `opatch`     |
| 🔄 Data Guard switchover testing | DR readiness check              |
| 📈 Capacity planning             | Total size, tablespace growth   |
| 🧪 Flashback test                | `FLASHBACK ON`, retention check |
| 💾 Export Backup (expdp)         | Schema level ya full DB         |

---

### 🛠️ Bonus: Admin/Config Tasks

| ⚙️ Task                            | 💬 Description                                 |
| ---------------------------------- | ---------------------------------------------- |
| 🧑‍🔧 User Creation / Grants       | Create user + quota + role                     |
| 🧱 Tablespace Create/Resize        | Autoextend ON, resize files                    |
| 🧪 Parameter tuning                | `pga_aggregate_target`, `db_cache_size` tuning |
| 📡 TNS/Listener config             | `listener.ora`, `tnsnames.ora`                 |
| 🔧 Init.ora / spfile param changes | `ALTER SYSTEM SET ... SCOPE=BOTH;`             |

---

## 🧠 Interview Me Kaise Bolo (Hinglish Example Answer):

> “Sir, main daily database ka health check karta hoon — jaise ki DB up hai ya nahi, listener status, tablespace usage, FRA, alert logs. RMAN backups verify karta hoon, blocking session detect karta hoon. Weekly AWR report nikalta hoon aur growth pattern check karta hoon. Monthly cloning, patching aur data guard testing karta hoon. Main har task ka script bana kar schedule bhi karta hoon crontab se."

---

### ✅ Ready-to-use Scripts for These Tasks:

| 📝 Script Name         | 🧪 Purpose                   |
| ---------------------- | ---------------------------- |
| `health_check.sh`      | Daily DB status report       |
| `rman_backup.sh`       | Run and log backup           |
| `tablespace_alert.sql` | Auto alert on >90% usage     |
| `fra_usage.sql`        | Archive log space monitoring |
| `awr_report.sql`       | Weekly performance           |
| `data_guard_check.sql` | Verify redo apply            |

---
