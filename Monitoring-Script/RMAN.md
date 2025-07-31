## RMAN backup **important commands aur steps** 

---

## RMAN Backup Important Commands & Steps List

1. **Check Archive Log Mode**

```sql
ARCHIVE LOG LIST;
```

2. **Start RMAN session**

```bash
rman target /
```

3. **Full Database Backup (with archivelogs)**

```rman
BACKUP DATABASE PLUS ARCHIVELOG;
```

4. **Incremental Backup (Level 1)**

```rman
BACKUP INCREMENTAL LEVEL 1 DATABASE;
```

5. **Backup All Archive Logs**

```rman
BACKUP ARCHIVELOG ALL;
```

6. **Validate Backupset**

```rman
VALIDATE BACKUPSET <backupset_number>;
```

7. **Configure Retention Policy - Redundancy**

```rman
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
```

8. **Configure Retention Policy - Recovery Window**

```rman
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
```

9. **Check Database Status**

```sql
SELECT LOG_MODE FROM V$DATABASE;
```

10. **Delete Obsolete Backups**

```rman
DELETE OBSOLETE;
```

11. **Crosscheck Backups**

```rman
CROSSCHECK BACKUP;
```

12. **Backup Control File**

```rman
BACKUP CURRENT CONTROLFILE;
```

13. **Backup Spfile**

```rman
BACKUP SPFILE;
```

14. **Backup with Compression**

```rman
BACKUP AS COMPRESSED BACKUPSET DATABASE;
```

15. **Monitor RMAN Backup Progress**
    (RMAN output logs during backup execution)

---

### General Steps Summary (Commands not all shown here):

* Plan backup strategy (full, incremental, archivelog)
* Ensure sufficient disk space
* Validate scripts in test environment
* Check archive log mode enabled
* Run backups using RMAN commands
* Monitor RMAN logs for errors
* Validate backups and do test restore
* Configure retention policy
* Automate backups with scheduler

---
