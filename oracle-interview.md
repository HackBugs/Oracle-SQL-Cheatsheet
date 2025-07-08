
```
gedit

hostname -I
sqlplus / as sysdba
startup
lsnrctl status

cat $ORACLE_HOME/network/admin/listener.ora
cat $ORACLE_HOME/network/admin/tnsnames.ora

SELECT username, account_status FROM dba_users;
ALTER USER system IDENTIFIED BY admin;
```
```
rman target /
report schema;

SHOW PARAMETER db_recovery_file_dest;
LIST BACKUP;

v$managed_standby

@?/rdbms/admin/awrrpt.sql
@?/rdbms/admin/addmrpt.sql
@$ORACLE_HOME/rdbms/admin/awrrpt.sql

######### Backup #########

rman target /
BACKUP DATABASE PLUS ARCHIVELOG;
BACKUP INCREMENTAL LEVEL 1 DATABASE;

expdp user/pass directory=exp_dir dumpfile=exp.dmp logfile=exp.log full=y
impdp user/pass directory=exp_dir dumpfile=exp.dmp logfile=imp.log
```

<hr>

**Oracle Database `STARTUP` & `SHUTDOWN` Quick Notes**

---

## 📝 **Oracle DB Startup & Shutdown – Quick Notes**

---

### 🔹 **Login as SYSDBA**

```bash
sqlplus / as sysdba
```

---

### 🔹 **Startup Commands**

| Mode            | Command            | Use Case                                   |
| --------------- | ------------------ | ------------------------------------------ |
| **Normal**      | `STARTUP;`         | Full DB start (Instance + Mount + Open)    |
| **NOMOUNT**     | `STARTUP NOMOUNT;` | For creating DB or restoring control files |
| **MOUNT**       | `STARTUP MOUNT;`   | For media recovery, renaming datafiles     |
| **Force Start** | `STARTUP FORCE;`   | Restart DB forcibly                        |

---

### 🔹 **Shutdown Commands**

| Command               | Description                          |
| --------------------- | ------------------------------------ |
| `SHUTDOWN NORMAL;`    | Waits for all users to log off       |
| `SHUTDOWN IMMEDIATE;` | Immediately disconnects users (Safe) |
| `SHUTDOWN ABORT;`     | Forcefully shuts DB (Last option)    |

---

### 🔹 **Check DB Status**

```sql
SELECT INSTANCE_NAME, STATUS FROM V$INSTANCE;
```

---

### 🔹 **Listener Commands** (outside SQL)

```bash
lsnrctl status     # Check status
lsnrctl start      # Start listener
lsnrctl stop       # Stop listener
```

---

### 🔹 **Auto Start on Boot**

Edit file:

```bash
/etc/oratab
```

Change:

```
orcl:/u01/app/oracle/product/19.0.0/db_1:Y
```

Then use:

```bash
dbstart
```

---

### 🔹 **Common Errors**

| Error Message | Reason / Fix                    |
| ------------- | ------------------------------- |
| ORA-01081     | DB already running              |
| ORA-01102     | Already mounted, shutdown first |
| ORA-00205     | Control file error              |

---

**Use case example:**

```bash
sqlplus / as sysdba
SHUTDOWN IMMEDIATE;
STARTUP;
```
