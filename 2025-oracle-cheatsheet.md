
```
select name, value from v$parameter where lower(name ) like '%pfile%';

host ls $ORACLE_HOME/dbs/*.ora -lF
```

<hr>

### **Oracle Database Cheat Sheet: Important Commands and Locations**  
**Ye cheat sheet me Oracle Database ke sabse important configuration files, logs, modes, shutdown types, aur recovery commands diye gaye hain. Isme real-life examples bhi diye hain jo production ya development environment me kaam aate hain.**  

---

## **1. Initialization Parameter Files (PFILE aur SPFILE):**  
- **PFILE (init.ora) Location:**  
  ```
  $ORACLE_HOME/dbs/init<ORACLE_SID>.ora
  ```
- **SPFILE Location:**  
  ```
  $ORACLE_HOME/dbs/spfile<ORACLE_SID>.ora
  ```
- **Check SPFILE Location:**  
  ```sql
  SHOW PARAMETER spfile;
  ```

---

## **2. Control Files:**  
- **Location Check:**  
  ```sql
  SHOW PARAMETER control_files;
  ```
- **Example Output:**  
  ```
  /u01/app/oracle/oradata/orcl/control01.ctl
  ```

- **Recovery (Agar Control File Delete Ho Jaye):**  
  ```sql
  STARTUP NOMOUNT;
  RESTORE CONTROLFILE FROM AUTOBACKUP;
  ALTER DATABASE MOUNT;
  RECOVER DATABASE;
  ALTER DATABASE OPEN RESETLOGS;
  ```

---

## **3. Data Files:**  
- **Location Check:**  
  ```sql
  SELECT FILE_NAME FROM DBA_DATA_FILES;
  ```

---

## **4. Redo Log Files:**  
- **Location Check:**  
  ```sql
  SELECT MEMBER FROM V$LOGFILE;
  ```

---

## **5. Archive Log Files:**  
- **Types of Archive:**  
  - **ARCHIVELOG Mode**: Redo logs archive hone ke baad overwrite hote hain.  
  - **NOARCHIVELOG Mode**: Redo logs directly overwrite hote hain bina archive kiye.  

- **Check Archive Mode:**  
  ```sql
  ARCHIVE LOG LIST;
  ```

- **Enable ARCHIVELOG Mode:**  
  ```sql
  SHUTDOWN IMMEDIATE;
  STARTUP MOUNT;
  ALTER DATABASE ARCHIVELOG;
  ALTER DATABASE OPEN;
  ```

- **Disable ARCHIVELOG Mode:**  
  ```sql
  SHUTDOWN IMMEDIATE;
  STARTUP MOUNT;
  ALTER DATABASE NOARCHIVELOG;
  ALTER DATABASE OPEN;
  ```

- **Archive Log Location Check:**  
  ```sql
  SHOW PARAMETER log_archive_dest;
  ```

---

## **6. Alert Log File:**  
- **Location Check:**  
  ```sql
  SHOW PARAMETER diagnostic_dest;
  ```
- **Default Location:**  
  ```
  $ORACLE_BASE/diag/rdbms/<DB_NAME>/<INSTANCE_NAME>/trace/alert_<INSTANCE_NAME>.log
  ```

---

## **7. Password File:**  
- **Location:**  
  ```
  $ORACLE_HOME/dbs/orapw<ORACLE_SID>
  ```
- **Check User Access:**  
  ```sql
  SELECT * FROM V$PWFILE_USERS;
  ```

---

## **8. Listener.ora aur Tnsnames.ora Files:**  
- **Location:**  
  ```
  $ORACLE_HOME/network/admin/listener.ora
  $ORACLE_HOME/network/admin/tnsnames.ora
  ```
- **Manual Check:**  
  ```sh
  cd $ORACLE_HOME/network/admin/
  ls -l listener.ora tnsnames.ora
  ```

---

## **9. Dump Files (Trace Files):**  
- **Location:**  
  ```
  $ORACLE_BASE/diag/rdbms/<DB_NAME>/<INSTANCE_NAME>/trace/
  ```
- **Check Dump Location:**  
  ```sql
  SHOW PARAMETER background_dump_dest;
  SHOW PARAMETER user_dump_dest;
  ```

---

## **10. Shutdown Types and Modes:**  
| **Shutdown Type** | **Description**                                | **Real-Life Use Case**                               |
|------------------|-------------------------------------------------|------------------------------------------------------|
| **NORMAL**        | Connected users automatically logout.          | Maintenance without urgency.                         |
| **IMMEDIATE**     | Active transactions rollback. Fast shutdown.   | Urgent maintenance without corruption risk.           |
| **TRANSACTIONAL** | Waits for active transactions to complete.     | During application upgrades.                         |
| **ABORT**         | Force shutdown, no rollback. Needs recovery.   | Emergency (System crash or hang).                     |

- **Example Commands:**  
  ```sql
  SHUTDOWN NORMAL;
  SHUTDOWN IMMEDIATE;
  SHUTDOWN TRANSACTIONAL;
  SHUTDOWN ABORT;
  ```

---

## **11. Startup and Mount Modes:**  
| **Mode**         | **Description**                                  | **Real-Life Use Case**                               |
|------------------|-------------------------------------------------|------------------------------------------------------|
| **NOMOUNT**      | Control file not read. Used for control file recovery. | When control files are corrupted or deleted.          |
| **MOUNT**        | Control file read, but data files not accessed.  | For database recovery or changing ARCHIVELOG mode.    |
| **OPEN**         | Full database access.                           | Normal operation for end-users.                      |

- **Example Commands:**  
  ```sql
  STARTUP NOMOUNT;
  STARTUP MOUNT;
  ALTER DATABASE OPEN;
  ```

---

## **12. Network Configuration for RAC, GoldenGate, and DataGuard:**  
- **Files Involved:**  
  - **listener.ora**  
  - **tnsnames.ora**  
  - **sqlnet.ora**  

- **Location Check:**  
  ```sh
  cd $ORACLE_HOME/network/admin/
  ls -l listener.ora tnsnames.ora sqlnet.ora
  ```

---

## **13. Summary of Important Commands:**  
| **Command**                         | **Purpose**                                    |
|-------------------------------------|------------------------------------------------|
| `SHOW PARAMETER <name>`              | Check parameter value (e.g., spfile, control_files) |
| `ARCHIVE LOG LIST`                   | Check ARCHIVELOG or NOARCHIVELOG mode            |
| `SELECT FILE_NAME FROM DBA_DATA_FILES;` | List data files' location                     |
| `SELECT MEMBER FROM V$LOGFILE;`      | List redo log files' location                    |
| `SELECT * FROM V$PWFILE_USERS;`      | Check users with SYSDBA/SYSOPER privileges       |
| `SHUTDOWN IMMEDIATE;`                | Fast shutdown without waiting for users          |
| `STARTUP MOUNT;`                     | Mount database without opening data files        |

---

## **14. Real-Life Examples:**  
- **Production Crash:** Alert log check karenge to find root cause.  
- **Data Recovery:** Archive logs use karke **Point-in-Time Recovery** karenge.  
- **Security Audit:** Password file aur Listener logs check karenge for unauthorized access.  
- **Performance Issue:** Redo log aur Alert log check karenge for potential bottlenecks.  

---

## **15. Cheat Sheet Summary:**  
- **ARCHIVELOG Mode**: Data protection with Point-in-Time Recovery.  
- **NOARCHIVELOG Mode**: Fast performance but no Point-in-Time Recovery.  
- **Shutdown Types**: NORMAL, IMMEDIATE, TRANSACTIONAL, ABORT.  
- **Startup Modes**: NOMOUNT, MOUNT, OPEN.  
- **Critical Files**: Control Files, Data Files, Redo Log Files, Archive Logs, Alert Logs, PFILE, SPFILE, Listener.ora, Tnsnames.ora.  

---

### **Tips for Practical Use:**  
- **Production me kabhi bhi `SHUTDOWN ABORT` avoid karo**, kyunki ye data corruption cause kar sakta hai.  
- **ARCHIVELOG Mode hamesha Production Database me enable rakho** for data safety.  
- **Alert Log regularly monitor karo** to catch errors and warnings early.  

<hr>

### **Command to Find Trace File (.trc) Location in Oracle Database**  
Oracle Database me trace files ka location pata karne ke liye `SHOW PARAMETER` command use karte hain. Ye files usually diagnostic aur debugging purpose ke liye use hoti hain.  

---

### **1. Background Trace File Location:**  
```sql
SHOW PARAMETER background_dump_dest;
```
- **Explanation:** Ye command background processes (e.g., DBWR, LGWR) ke trace files ka location batata hai.  

---

### **2. User Trace File Location:**  
```sql
SHOW PARAMETER user_dump_dest;
```
- **Explanation:** Ye command user session se related trace files ka location batata hai.  

---

### **3. ADR (Automatic Diagnostic Repository) Trace Location:**  
```sql
SHOW PARAMETER diagnostic_dest;
```
- **Explanation:** Oracle 11g aur uske baad ke versions me trace files ADR structure me store hote hain. Iska default location hota hai:
```
$ORACLE_BASE/diag/rdbms/<DB_NAME>/<INSTANCE_NAME>/trace/
```

---

### **4. Real-Life Example:**  
- Agar kisi production server me performance issue ho raha hai, to pehle `SHOW PARAMETER user_dump_dest` se trace file ka location dekhoge.  
- Uske baad uss directory me jaake `.trc` files ko analyze karoge using tools like **tkprof** ya direct `vi` command se check karoge.  

```sh
cd $ORACLE_BASE/diag/rdbms/<DB_NAME>/<INSTANCE_NAME>/trace/
ls -l *.trc
```

---

### **5. Note:**  
- `diagnostic_dest` Oracle 11g aur uske baad ke versions me use hota hai.  
- `background_dump_dest` aur `user_dump_dest` Oracle 10g aur usse pehle ke versions me zyada common hai.  

