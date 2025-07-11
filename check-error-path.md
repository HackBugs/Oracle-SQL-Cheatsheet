
```
- lisnrtl path
/u01/app/oracle/product/19.0.0/db_1/network/admin

 - Listener Log Location
/u01/app/oracle/diag/tnslsnr/srv1/listener/alert/

- Check db_name aur instance_name
SELECT name FROM v$database;
SELECT instance_name FROM v$instance;

/u01/app/oracle/diag/rdbms/<db_name>/<instance_name>/alert/alert_<instance_name>.log
- Example
/u01/app/oracle/diag/rdbms/oradb/oradb/alert/alert_oradb.log

- Check error inside also - alert log file ka exact path hai
cat /u01/app/oracle/diag/rdbms/oradb/oradb/alert/log.xml
```

| Purpose                         | File Path                                                       |
| ------------------------------- | --------------------------------------------------------------- |
| Listener Errors (ORA-12541 etc) | `/u01/app/oracle/diag/tnslsnr/srv1/listener/alert/log.xml`      |
| DB Startup/Shutdown/Error Logs  | `/u01/app/oracle/diag/rdbms/oradb/oradb/alert/alert_oradb.log`  |
| Listener Debug Logs             | `/u01/app/oracle/diag/tnslsnr/srv1/listener/trace/listener.trc` |

---

> # ✅ Oracle DBA Important Paths Table (with Purpose)

| **Purpose** (with Hint)                          | **Path / File Location**                                                          | **Description** |
|--------------------------------------------------|-----------------------------------------------------------------------------------|-----------------|
| ✅ Oracle Base Directory (base folder)           | `$ORACLE_BASE` (e.g., `/u01/app/oracle`)                                          | Root folder for Oracle software, logs, configs |
| ✅ Oracle Home Directory (software location)     | `$ORACLE_HOME` (e.g., `/u01/app/oracle/product/19.0.0/db_1`)                      | Location where Oracle software is installed |
| ✅ Listener Config File (listener settings)      | `$ORACLE_HOME/network/admin/listener.ora`                                         | Listener port, host configuration |
| ✅ TNS Config File (client DB entries)           | `$ORACLE_HOME/network/admin/tnsnames.ora`                                         | Connection strings to DBs |
| ✅ SQL\*Net Config File (protocol settings)      | `$ORACLE_HOME/network/admin/sqlnet.ora`                                           | Defines network protocols, encryption, etc. |
| ✅ Listener Log File (connection logs)           | `/u01/app/oracle/diag/tnslsnr/<hostname>/listener/alert/log.xml`                  | Shows listener connection attempts and errors |
| ✅ Listener Trace File (listener debug)          | `/u01/app/oracle/diag/tnslsnr/<hostname>/listener/trace/listener.trc`             | Detailed debug log for listener troubleshooting |
| ✅ Database Alert Log (DB errors/events)         | `/u01/app/oracle/diag/rdbms/<db>/<inst>/alert/alert_<inst>.log`                  | Shows DB errors, startup/shutdown, background events |
| ✅ Datafiles Location (actual DB data)           | Query: `SELECT name FROM v$datafile;`                                             | Shows actual data file paths used by DB |
| ✅ Redo Log Files (for crash recovery)           | Query: `SELECT member FROM v$logfile;`                                            | Shows all redo log file paths |
| ✅ Control Files (DB structure info)             | Query: `SELECT name FROM v$controlfile;`                                          | Shows all control file paths |
| ✅ Archive Log Files (redo logs backup)          | `/u01/app/oracle/fast_recovery_area/<db_name>/archivelog/`                        | Stores archived redo logs (if archiving enabled) |
| ✅ Audit Logs (user activity logs)               | `$ORACLE_BASE/admin/<db_name>/adump/`                                             | Stores audit logs for user activities |
| ✅ RMAN Backup Location (for DB backups)         | e.g., `/u01/app/oracle/backup/` or FRA                                            | Stores DB backups taken via RMAN |
| ✅ Background Process Trace (for SMON, PMON)     | `/u01/app/oracle/diag/rdbms/<db>/<inst>/trace/`                                   | Trace files for processes like SMON, PMON, DBWn |
| ✅ User Session Trace (on-demand session log)    | Same as above (on-demand)                                                         | Trace files when session-level tracing is enabled |
| ✅ ORATAB File (lists all DBs on server)         | `/etc/oratab`                                                                     | Lists all Oracle DB instances on the machine |
| ✅ Password File (for SYS remote login)          | `$ORACLE_HOME/dbs/orapw<ORACLE_SID>`                                              | For SYSDBA password-based remote login |
 |

---

## 🧠 Bonus: Useful Commands for Interview

| **Check**         | **Command**                                                                  |
| ----------------- | ---------------------------------------------------------------------------- |
| ORACLE\_SID       | `echo $ORACLE_SID`                                                           |
| ORACLE\_HOME      | `echo $ORACLE_HOME`                                                          |
| ORACLE\_BASE      | `echo $ORACLE_BASE`                                                          |
| Listener status   | `lsnrctl status`                                                             |
| Listener log tail | `tail -f $ORACLE_BASE/diag/tnslsnr/$(hostname)/listener/alert/log.xml`       |
| Alert log tail    | `tail -f $ORACLE_BASE/diag/rdbms/<db>/<instance>/alert/alert_<instance>.log` |
| Datafile list     | `SELECT name FROM v$datafile;`                                               |
| Controlfile list  | `SELECT name FROM v$controlfile;`                                            |
| Redo log list     | `SELECT member FROM v$logfile;`                                              |

---

### ✅ Interview Tip:

Jab interviewer bole:
🔹 “Agar user connect nahi kar pa raha to aap kaun kaun se log check karenge?”
Aap confidently batao:

> "Main sabse pehle listener log (`log.xml`), alert log (`alert_<sid>.log`), listener.ora, tnsnames.ora files ko check karunga. Agar zarurat pade to trace files aur firewall/network config bhi check karunga."

<hr>

> # Oracle ka **alert log file** sabse important diagnostic file hai — iska use **Oracle DBA har din karta hai** to troubleshoot errors, track startup/shutdown, aur background events.

---

## 📄 **`alert_oradb.log` me kya kya check kar sakte hain?**

### 🔍 1. **Instance Startup & Shutdown**

* Kab database start/shutdown hua?
* Kya koi error aaya startup ke waqt?

🧾 Example:

```
Starting ORACLE instance (normal)
ORACLE instance started.
Total System Global Area  1073741824 bytes
Database mounted.
Database opened.
```

---

### 🔍 2. **Listener Registration Issues**

* Agar instance listener ke saath register nahi ho raha, toh alert log me dikhega.

🧾 Example:

```
PMON started with pid=2, OS id=12345
Starting background process CJQ0
Failed to contact listener. Error: ORA-12541: TNS:no listener
```

---

### 🔍 3. **Errors & Warnings (ORA-xxxx)**

* Sabhi major **ORA- errors** alert log me capture hote hain.

🧾 Example:

```
ORA-00600: internal error code
ORA-01578: block corrupted
ORA-19809: limit exceeded for recovery files
```

---

### 🔍 4. **Tablespace Issues**

* Agar koi tablespace full ho gaya ho ya autoextend fail ho gaya ho.

🧾 Example:

```
Errors in file /.../ora_1234.trc:
ORA-01653: unable to extend table USERS in tablespace USERS
```

---

### 🔍 5. **Archiver Status**

* Archive log on/off ka status, aur archiver failures bhi.

🧾 Example:

```
ARC0: Completed archiving
ORACLE Instance ORADB - Archiver hung
```

---

### 🔍 6. **Checkpoint & Recovery Events**

* Checkpoint details, redo apply, media recovery.

🧾 Example:

```
Media Recovery Start
Media Recovery Log /path/to/archivelog1.arc
```

---

### 🔍 7. **Background Process Failures**

* Agar koi internal process (PMON, SMON, LGWR) crash ho gaya ho.

🧾 Example:

```
SMON: cleaning temp segments
DBW0: terminating due to error 600
```

---

### 🔍 8. **Parameter Changes (ALTER SYSTEM)**

* Agar kisi ne `ALTER SYSTEM` command diya ho to wo bhi show hota hai.

🧾 Example:

```
ALTER SYSTEM SET db_recovery_file_dest_size=10G SCOPE=BOTH;
```

---

### 🔍 9. **PDB (Pluggable DB) Open/Close Status** *(if using multitenant)*

🧾 Example:

```
Pluggable database PDB1 opened read write
```

---

### ✅ Interview ke liye Ek Line Summary:

> "Alert log file me main startup/shutdown, listener registration, background process failures, ORA errors, archiver issues, aur tablespace related problems jaise sab kuch monitor karta hoon. Ye file troubleshooting ka first step hoti hai."

---

### 📌 File Path Reminder:

```
/u01/app/oracle/diag/rdbms/oradb/oradb/alert/alert_oradb.log
```

Check karne ke liye:

```bash
tail -f /u01/app/oracle/diag/rdbms/oradb/oradb/alert/alert_oradb.log
```

---



