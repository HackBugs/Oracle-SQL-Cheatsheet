* **User creation, privilege, tablespace** commands
* **DDL (Data Definition Language)** commands
* **ALTER, BACKUP, CHECK, MONITORING** commands
* **Interview-oriented practical stuff**

---

### ✅ Bash-Style Oracle DBA Cheat Sheet (3 Yrs Experience)

```bash
# 🔐 USER MANAGEMENT
CREATE USER test_user IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO test_user;
ALTER USER test_user ACCOUNT UNLOCK;
DROP USER test_user CASCADE;

# 👑 SYSTEM PRIVILEGES
GRANT DBA TO test_user;
REVOKE DBA FROM test_user;

# 🗃️ TABLESPACE MANAGEMENT
CREATE TABLESPACE userspace DATAFILE '/u01/app/oracle/oradata/ORCL/userspace01.dbf' SIZE 100M AUTOEXTEND ON;
ALTER TABLESPACE userspace ADD DATAFILE '/u01/.../userspace02.dbf' SIZE 100M;
DROP TABLESPACE userspace INCLUDING CONTENTS AND DATAFILES;

# 🔄 DDL COMMANDS
CREATE TABLE employees (id NUMBER, name VARCHAR2(50));
ALTER TABLE employees ADD (email VARCHAR2(100));
ALTER TABLE employees MODIFY (name VARCHAR2(100));
ALTER TABLE employees DROP COLUMN email;
DROP TABLE employees;

# 🛠 OBJECT MANAGEMENT
CREATE INDEX emp_idx ON employees(name);
DROP INDEX emp_idx;
CREATE VIEW emp_view AS SELECT * FROM employees;
DROP VIEW emp_view;

# 🔍 MONITORING & QUERIES
SELECT username, account_status FROM dba_users;
SELECT * FROM dba_tables WHERE owner='TEST_USER';
SELECT * FROM v$session;
SELECT * FROM v$database;
SELECT * FROM dba_data_files;
SELECT name, open_mode FROM v$database;

# 🔄 RMAN BACKUP & ARCHIVE
rman target /
BACKUP DATABASE;
BACKUP DATABASE PLUS ARCHIVELOG;
LIST BACKUP;
DELETE OBSOLETE;

# 🧱 ARCHIVE LOG MANAGEMENT
ARCHIVE LOG LIST;
ALTER SYSTEM ARCHIVE LOG CURRENT;
SHOW PARAMETER log_archive_dest;

# 🚨 ALERT LOG & PERFORMANCE
SHOW PARAMETER background_dump_dest;
TAIL -f /u01/app/oracle/diag/.../alert_ORCL.log
SELECT * FROM v$alert_log;  -- (in newer versions)

# 📂 DIRECTORY OBJECTS (For Data Pump)
CREATE OR REPLACE DIRECTORY dp_dir AS '/u01/exports';
GRANT READ, WRITE ON DIRECTORY dp_dir TO test_user;

# 📦 EXPORT / IMPORT (Data Pump)
expdp test_user/password@ORCL DIRECTORY=dp_dir DUMPFILE=backup.dmp LOGFILE=export.log;
impdp test_user/password@ORCL DIRECTORY=dp_dir DUMPFILE=backup.dmp LOGFILE=import.log;

# 📊 SPACE USAGE CHECK
SELECT tablespace_name, BYTES/1024/1024 "Size_MB" FROM dba_data_files;
SELECT segment_name, SUM(bytes)/1024/1024 "Used_MB" FROM dba_segments GROUP BY segment_name;

# 🔁 TEMP TABLESPACE MONITORING
SELECT * FROM dba_temp_files;
SELECT tablespace_name, SUM(bytes_used)/1024/1024 AS used_mb FROM v$temp_space_header GROUP BY tablespace_name;

# 🔐 PASSWORD MANAGEMENT
ALTER PROFILE DEFAULT LIMIT FAILED_LOGIN_ATTEMPTS 5;
ALTER USER test_user IDENTIFIED BY newpassword;
```

---

### 📌 Interview Tips (3 Yrs Oracle DBA):

* **What happens when you take backup with `PLUS ARCHIVELOG`?**
* **How to recover from lost datafile?**
* **How to monitor session locks or long-running queries?**
* **Difference between `SHUTDOWN IMMEDIATE` vs `SHUTDOWN ABORT`?**
* **What is the use of `v$session`, `v$datafile`, `v$logfile`, `v$tablespace`?**
* **How to enable archivelog mode?**
* **What is Data Guard, FRA, ASM (basic idea)?**

```
SHUTDOWN IMMEDIATE;

STARTUP NOMOUNT;

RMAN> RESTORE CONTROLFILE;

ALTER DATABASE MOUNT;

RMAN> RESTORE DATABASE;

RMAN> RECOVER DATABASE;

ALTER DATABASE OPEN RESETLOGS;
```

```
#!/bin/bash

echo "Step 1: Shutdown Database if running"
echo "sqlplus / as sysdba <<EOF
SHUTDOWN IMMEDIATE;
EXIT;
EOF"

echo "Step 2: Startup Database in NOMOUNT mode"
echo "sqlplus / as sysdba <<EOF
STARTUP NOMOUNT;
EXIT;
EOF"

echo "Step 3: Restore Control File"
echo "rman target / <<EOF
RUN {
  RESTORE CONTROLFILE FROM '<backup_location>';
  ALTER DATABASE MOUNT;
}
EXIT;
EOF"

echo "Step 4: Restore Database Datafiles"
echo "rman target / <<EOF
RUN {
  RESTORE DATABASE;
}
EXIT;
EOF"

echo "Step 5: Recover Database Datafiles"
echo "rman target / <<EOF
RUN {
  RECOVER DATABASE;
}
EXIT;
EOF"

echo "Step 6: Open Database"
echo "sqlplus / as sysdba <<EOF
ALTER DATABASE OPEN;
EXIT;
EOF"

echo "If required, Open Database with RESETLOGS"
echo "sqlplus / as sysdba <<EOF
ALTER DATABASE OPEN RESETLOGS;
EXIT;
EOF"

echo "Step 7: Validate Backups"
echo "rman target / <<EOF
VALIDATE DATABASE;
EXIT;
EOF"

echo "Step 8: Crosscheck Backups"
echo "rman target / <<EOF
CROSSCHECK BACKUP;
EXIT;
EOF"

echo "Step 9: Delete Expired Backups"
echo "rman target / <<EOF
DELETE EXPIRED BACKUP;
EXIT;
EOF"

echo "Step 10: Catalog Backup Pieces (if needed)"
echo "rman target / <<EOF
CATALOG START WITH '<backup_piece_location>';
EXIT;
EOF"
```

## Agar Oracle DBA (datafile, control file, archivelog, backup file) delete ho jaye, toh CMD for recovery:
---

# Oracle Files Delete Hone Par Recovery Commands & Steps List

---

### 1. **Accidentally Deleted Datafile Recovery**

* Check current datafiles:

```sql
SELECT file_name, file_id FROM dba_data_files;
```

* Take the datafile offline (if needed):

```sql
ALTER DATABASE DATAFILE '<file_path>' OFFLINE;
```

* Restore the deleted datafile from backup (using RMAN):

```rman
RESTORE DATAFILE <file_id>;
```

* Recover the datafile:

```rman
RECOVER DATAFILE <file_id>;
```

* Bring datafile online:

```sql
ALTER DATABASE DATAFILE '<file_path>' ONLINE;
```

---

### 2. **Deleted Control File Recovery**

* Shutdown database:

```sql
SHUTDOWN IMMEDIATE;
```

* Restore control file from backup:

```rman
RESTORE CONTROLFILE;
```

* Mount database:

```sql
ALTER DATABASE MOUNT;
```

* Recover database (if required):

```rman
RECOVER DATABASE;
```

* Open database with resetlogs:

```sql
ALTER DATABASE OPEN RESETLOGS;
```

---

### 3. **Deleted Archive Log Recovery**

* Identify missing archive logs:

```rman
CROSSCHECK ARCHIVELOG ALL;
```

* Restore missing archive logs:

```rman
RESTORE ARCHIVELOG ALL;
```

* Recover database using restored archive logs:

```rman
RECOVER DATABASE;
```

---

### 4. **Deleted Backup Files Recovery**

* Check backup status:

```rman
LIST BACKUP;
```

* Crosscheck backups to update RMAN catalog:

```rman
CROSSCHECK BACKUP;
```

* If backup files are deleted physically but catalog thinks they exist:

```rman
DELETE EXPIRED BACKUP;
```

* Restore datafile or database from existing valid backups

---

### 5. **Deleted Spfile Recovery**

* If spfile is deleted, recreate from pfile (init.ora) or restore from backup:

```rman
RESTORE SPFILE;
```

* Or create spfile from pfile:

```sql
CREATE SPFILE FROM PFILE;
```

---

### 6. **File Recovery Using OS Commands (If Oracle Backup Not Present)**

* If RMAN backups are not available, try to recover from OS-level backup (if configured).

* Use filesystem recovery tools or shadow copies (outside Oracle scope).

---

### 7. **General RMAN Recovery Commands**

* Start RMAN session:

```bash
rman target /
```

* Restore and recover entire database:

```rman
RESTORE DATABASE;
RECOVER DATABASE;
```

---

### 8. **Additional Useful RMAN Commands**

* Show RMAN configuration:

```rman
SHOW ALL;
```

* List current backups:

```rman
LIST BACKUP SUMMARY;
```

* Delete obsolete backups:

```rman
DELETE OBSOLETE;
```

---

# Summary Table of Commands

| Scenario               | Commands                                 |
| ---------------------- | ---------------------------------------- |
| Deleted Datafile       | RESTORE DATAFILE, RECOVER DATAFILE       |
| Deleted Controlfile    | RESTORE CONTROLFILE, RECOVER DATABASE    |
| Deleted Archive Log    | RESTORE ARCHIVELOG ALL, RECOVER DATABASE |
| Deleted Backup Files   | CROSSCHECK BACKUP, DELETE EXPIRED BACKUP |
| Deleted Spfile         | RESTORE SPFILE, CREATE SPFILE FROM PFILE |
| Full Database Recovery | RESTORE DATABASE, RECOVER DATABASE       |

---
