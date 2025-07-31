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
