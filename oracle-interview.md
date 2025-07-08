
Name - testdb
Username - system
Hostname - 192.168.1.124
Port - 1521
Service name - oradb.localdomain

```
gedit
SELECT NAME, VALUE FROM V$DIAG_INFO; // log path find

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

<hr>
<hr>

# Oracle DBA Responsibilities with Real-Time Examples and Commands (Hinglish)

Yeh note Oracle DBA ke key responsibilities cover karta hai: Database Installation, User Management, Performance Tuning, Backup and Recovery, Security Management, aur Monitoring. Har section mein real-time example, commands, aur kaise karte hain woh step-by-step samjhaya gaya hai.

---

## 1. Database Installation and Configuration
**Description**: Oracle software install karna aur database setup karna, taaki applications data store aur access kar sakein.

**How It’s Done**:
1. **Pre-requisites**: Server pe OS (Linux/Windows) ready karo, memory aur disk space check karo.
2. **Software Installation**: Oracle software binary download aur install karo.
3. **Database Creation**: DBCA (Database Configuration Assistant) ya manual commands se database create karo.
4. **Configuration**: Listener aur tnsnames.ora configure karo for connectivity.

**Real-Time Example**: Maine ek e-commerce project ke liye Oracle 19c install kiya AWS EC2 instance pe. Server pe 16GB RAM aur 100GB disk tha. DBCA se database create kiya aur listener configure kiya taaki application connect kar sake.

**Commands Used**:
```sql
-- Oracle software install (Linux example)
$ unzip oracle19c.zip
$ cd database
$ ./runInstaller -silent -responseFile /home/oracle/db_install.rsp

-- Database create using DBCA
$ dbca -silent -createDatabase \
-templateName General_Purpose.dbc \
-gdbName ORCL \
-sid ORCL \
-sysPassword sys123 \
-systemPassword sys123 \
-characterSet AL32UTF8 \
-datafileDestination /oracle/oradata

-- Listener configure
$ vi /oracle/network/admin/listener.ora
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    )
  )

$ lsnrctl start
```

**Kaise Karte Hain**:
- Oracle binary download aur unzip karo.
- Response file banaya jata hai silent installation ke liye.
- DBCA se database create karo with proper SID aur character set.
- Listener.ora mein network details set karo aur listener start karo.

---

## 2. User Management
**Description**: Users create karna, unko permissions dena (grant) ya remove (revoke) karna taaki authorized access ho.

**How It’s Done**:
1. **Create User**: New user banate hain with username aur password.
2. **Assign Roles/Privileges**: Roles (like DBA, CONNECT) ya specific privileges (SELECT, INSERT) dete hain.
3. **Manage Permissions**: Unnecessary permissions revoke karte hain.
4. **Profile Management**: Password policies ya resource limits set karte hain.

**Real-Time Example**: Ek banking app ke liye ek new user “app_user” create kiya aur usko specific tables pe SELECT aur INSERT permissions di. Ek baar galti se developer ko DROP privilege diya tha, toh usko revoke kiya.

**Commands Used**:
```sql
-- User create
CREATE USER app_user IDENTIFIED BY app_pass123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 100M ON users;

-- Grant permissions
GRANT CONNECT, RESOURCE TO app_user;
GRANT SELECT, INSERT ON accounts TO app_user;

-- Revoke permission
REVOKE DROP ANY TABLE FROM app_user;

-- Password policy set
CREATE PROFILE app_profile LIMIT
PASSWORD_LIFE_TIME 90
FAILED_LOGIN_ATTEMPTS 3;
ALTER USER app_user PROFILE app_profile;
```

**Kaise Karte Hain**:
- `CREATE USER` se user banaya jata hai.
- `GRANT` se permissions dete hain, specific ya role-based.
- `REVOKE` se extra permissions hatao.
- Profile banakar password expiry ya login attempts limit karo.

---

## 3. Performance Tuning
**Description**: Slow queries ko optimize karna taaki database fast chal sake.

**How It’s Done**:
1. **Identify Issue**: AWR/ADDM reports ya Explain Plan se slow queries find karo.
2. **Indexing**: Missing ya inefficient indexes add karo.
3. **Query Rewrite**: Bind variables ya optimized joins use karo.
4. **Stats Update**: Table statistics update karo for better execution plans.
5. **Memory Tuning**: SGA/PGA parameters adjust karo.

**Real-Time Example**: Ek sales report query 30 seconds le rahi thi. Maine Explain Plan check kiya, full table scan ho raha tha. Ek composite index banaya aur stats update kiye, query time 3 seconds ho gaya.

**Commands Used**:
```sql
-- Explain Plan check
EXPLAIN PLAN FOR
SELECT * FROM sales WHERE order_date = '2025-01-01' AND customer_id = 100;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Composite index create
CREATE INDEX idx_sales_date_cust ON sales(order_date, customer_id);

-- Gather table stats
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCOTT', 'SALES');

-- SGA size adjust
ALTER SYSTEM SET sga_target=2G SCOPE=BOTH;
```

**Kaise Karte Hain**:
- `EXPLAIN PLAN` se query ka execution path dekho.
- Indexes banaye (`CREATE INDEX`) for frequently queried columns.
- `DBMS_STATS` se stats update karo taaki optimizer better plan banaye.
- Memory parameters adjust karo for better resource allocation.

---

## 4. Backup and Recovery
**Description**: Data loss se bachane ke liye regular backups aur recovery plans banate hain.

**How It’s Done**:
1. **Backup Types**: Full, incremental, aur archivelog backups RMAN se.
2. **Archivelog Mode**: Point-in-time recovery ke liye enable karo.
3. **Restore/Recover**: Corrupt data ya database ko restore aur recover karo.
4. **Test Recovery**: Regular testing for reliability.

**Real-Time Example**: Production database mein ek datafile corrupt ho gaya. Maine RMAN se incremental backup restore kiya aur database ko specific timestamp tak recover kiya. Downtime sirf 1.5 hours ka tha.

**Commands Used**:
```sql
-- Enable archivelog mode
ALTER DATABASE ARCHIVELOG;

-- RMAN full backup
RMAN> BACKUP DATABASE PLUS ARCHIVELOG;

-- Incremental backup
RMAN> BACKUP INCREMENTAL LEVEL 1 DATABASE;

-- Restore aur recover
RMAN> RESTORE DATAFILE '/oracle/oradata/ORCL/users01.dbf';
RMAN> RECOVER DATABASE UNTIL TIME '2025-07-01:10:00:00';
RMAN> ALTER DATABASE OPEN;
```

**Kaise Karte Hain**:
- Database ko archivelog mode mein rakho for recovery.
- `RMAN> BACKUP` se regular backups lo.
- Corruption ya crash ke case mein `RESTORE` aur `RECOVER` commands use karo.
- Recovery test karo taaki production mein issue na ho.

---

## 5. Security Management
**Description**: Unauthorized access se database protect karna, jaise user authentication aur data encryption.

**How It’s Done**:
1. **User Authentication**: Strong passwords aur profiles set karo.
2. **Privileges**: Least privilege principle follow karo.
3. **Auditing**: User actions track karo.
4. **Encryption**: Sensitive data encrypt karo (TDE - Transparent Data Encryption).

**Real-Time Example**: Ek client ke database mein sensitive customer data tha. Maine TDE configure kiya aur auditing enable ki taaki DDL commands track ho sakein. Ek unauthorized access attempt detect kiya aur user ko lock kiya.

**Commands Used**:
```sql
-- TDE configure
ALTER SYSTEM SET ENCRYPTION KEY IDENTIFIED BY "tde_pass123";

-- Create encrypted tablespace
CREATE TABLESPACE secure_data
DATAFILE '/oracle/oradata/secure_data01.dbf' SIZE 100M
ENCRYPTION USING 'AES256'
DEFAULT STORAGE (ENCRYPT);

-- Auditing enable
AUDIT ALL BY app_user BY ACCESS;
AUDIT SELECT, INSERT, UPDATE, DELETE ON customers BY ACCESS;

-- Lock user
ALTER USER suspicious_user ACCOUNT LOCK;
```

**Kaise Karte Hain**:
- TDE setup karo sensitive data ke liye.
- `AUDIT` commands se user actions track karo.
- Suspicious activity ho to user account lock karo (`ALTER USER`).
- Minimum privileges do taaki security tight rahe.

---

## 6. Monitoring
**Description**: Database health check karna, jaise CPU usage, memory, aur disk space, taaki issues pehle detect ho.

**How It’s Done**:
1. **Alerts**: Alert log file monitor karo for errors.
2. **Performance Metrics**: CPU, memory, I/O usage check karo.
3. **Tools**: Enterprise Manager (OEM) ya scripts use karo.
4. **AWR Reports**: Regular reports generate karo for trends.

**Real-Time Example**: Ek database mein disk space low ho gaya tha, alert log mein errors aaye. Maine tablespace size increase kiya aur OEM se CPU usage monitor kiya. Ek query high CPU use kar rahi thi, usko optimize kiya.

**Commands Used**:
```sql
-- Alert log check
$ cat /oracle/diag/rdbms/orcl/ORCL/trace/alert_ORCL.log

-- Tablespace size increase
ALTER DATABASE DATAFILE '/oracle/oradata/ORCL/users01.dbf' RESIZE 200M;

-- AWR report generate
BEGIN
  DBMS_WORKLOAD_REPOSITORY.CREATE_SNAPSHOT();
END;
/

-- CPU usage check (via SQL)
SELECT name, value FROM v$sysstat WHERE name LIKE '%CPU%';
```

**Kaise Karte Hain**:
- Alert log file (`alert_ORCL.log`) regularly check karo.
- `V$SYSSTAT` ya OEM se CPU/memory usage monitor karo.
- AWR reports generate karo for performance trends.
- Disk space issues ke liye datafiles resize ya new add karo.

---

## Interview Preparation Tips
1. **Practice Commands**: Upar diye commands practice karo taaki confidently explain kar sako.
2. **Real-Time Examples**: Har responsibility ke liye apne experience se examples do.
3. **Tools Knowledge**: OEM, RMAN, SQL*Plus jaise tools ka use samjho.
4. **Stay Updated**: Oracle 19c/21c ke new features revise karo.
5. **STAR Method**: Behavioral questions mein use karo.
