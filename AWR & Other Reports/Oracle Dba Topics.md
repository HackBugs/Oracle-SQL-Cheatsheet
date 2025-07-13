> # **Complete Oracle DBA Topics Guide (Hinglish + Real-Time + Interview-Ready)**

---

## 1. 🔄 Materialized View (MV)

### Kya Hai?

MV ek table jaisa object hota hai jo remote ya complex query ka **snapshot** store karta hai.

### Kyu Use Karte Hain?

* Fast reporting ke liye
* Remote DB ke data ko local store karne ke liye

### Command:

```sql
CREATE MATERIALIZED VIEW mv_emp
REFRESH COMPLETE ON DEMAND
AS SELECT * FROM emp@remote_db_link;
```

---

## 2. 🛋 Index Types

### 1. B-tree (default)

* Fast lookup on **equality/inequality** conditions
* Example: `SELECT * FROM emp WHERE emp_id = 101;`

### 2. Bitmap Index

* Best for **low cardinality** columns (e.g., gender, status)

### 3. Function-Based Index

* Index on expression

```sql
CREATE INDEX idx_lower_name ON emp(LOWER(name));
```

### 4. Reverse Key Index

* Useful for inserting sequential numbers (to avoid block contention)

---

## 3. 🪝 Triggers

### Kya Hai?

Automatically chalte hain jab INSERT/UPDATE/DELETE hota hai kisi table par

### Example:

```sql
CREATE OR REPLACE TRIGGER trg_before_emp_insert
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
  :new.created_on := SYSDATE;
END;
```

---

## 4. 🧰 User / Role / Grant

### Create User:

```sql
CREATE USER test_user IDENTIFIED BY pass123;
GRANT CONNECT, RESOURCE TO test_user;
```

### Create Role:

```sql
CREATE ROLE app_readonly;
GRANT SELECT ON employees TO app_readonly;
GRANT app_readonly TO test_user;
```

---

## 5. 🪨 RMAN Backup / Restore

### Full DB Backup:

```bash
rman target /
BACKUP DATABASE PLUS ARCHIVELOG;
```

### Restore:

```bash
RESTORE DATABASE;
RECOVER DATABASE;
```

---

## 6. 📦 Export / Import (Data Pump)

### Full DB Export:

```bash
expdp system/password full=y directory=DATA_DIR dumpfile=full_db.dmp logfile=exp.log
```

### Schema Import:

```bash
impdp system/password schemas=HR directory=DATA_DIR dumpfile=full_db.dmp logfile=imp.log
```

---

## 7. 🔐 TDE (Transparent Data Encryption)

### Kyu Use Karte Hai?

* Data-at-rest encryption (table data, backups)
* Compliance ke liye (e.g., GDPR, HIPAA)

### Setup Overview:

1. Set wallet location in sqlnet.ora
2. Create keystore:

```sql
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/wallet/path' IDENTIFIED BY oracle;
```

3. Open and set key

```sql
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY oracle;
ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY oracle WITH BACKUP;
```

4. Encrypt table column

```sql
ALTER TABLE employees MODIFY (ssn ENCRYPT); 
```

---

## 8. 📤 Archive Log Mode + Recovery

### Enable Archive Mode:

```sql
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
```

### Recovery Example:

```bash
RESTORE DATAFILE 5;
RECOVER DATAFILE 5;
```

---

## 9. ⚡ Performance Tuning Reports

### AWR:

```sql
@?/rdbms/admin/awrrpt.sql
```

### ASH:

```sql
@?/rdbms/admin/ashrpt.sql
```

### ADDM:

```sql
@?/rdbms/admin/addmrpt.sql
```

### Focus Sections:

* Top SQL by Elapsed Time, CPU Time
* Wait Events: DB kis kaam me atka
* Segment Stats: Kaunsi table/index hit ho rahi hai

---

## 10. 🤷 Mandatory Interview Topics Notes (Short Summary)

### ✔ Mandatory Knowledge of RAC:

* Clustered DB setup
* High availability and load balancing
* srvctl, crsctl, SCAN listener, shared storage

### ✔ GoldenGate:

* Real-time replication (source to target)
* Extract, Pump, Replicat
* Use in active-active or reporting DB

### ✔ Performance Tuning:

* AWR, ASH, ADDM, Top SQL
* Indexes, partitioning, SQL plan

### ✔ OEM (Enterprise Manager):

* Central GUI for monitoring and management
* Alerts, performance, storage, user/session tracking

### ✔ TDE (Transparent Data Encryption):

* Data-at-rest encryption
* Wallet, keystore, column encryption

### ✔ DB Patching:

* OPatch utility
* PSU, RU patch apply and rollback

### ✔ DB Refresh:

* Cloning from Prod to Dev/Test
* Via RMAN duplicate or datapump

### ✔ DB Reorganization:

* Table move, shrink, defragmentation
* Tablespace reorg

### ✔ Validating Practices & Tools:

* Health checks, script validations, log reviews
* OEM, AWR, SQLT, TKPROF

### ✔ DR (Disaster Recovery):

* Data Guard setup
* Switchover/failover testing

### ✔ Backup & Recovery:

* RMAN full/incr, archive log, restore scenarios

### ✔ Security Policies:

* Roles, auditing, TDE, DB vault

### ✔ Trend & Capacity Planning:

* Growth prediction, tablespace monitoring

### ✔ Root Cause Analysis:

* Performance issue tracing
* Alert log, trace files, session tracking


<hr>

> # **Complete Oracle DBA Topics Guide (Hinglish + Real-Time + Interview-Ready)**

---

## 1. 🔄 Materialized View (MV)

### Kya Hai?

MV ek table jaisa object hota hai jo remote ya complex query ka **snapshot** store karta hai.

### Kyu Use Karte Hain?

* Fast reporting ke liye
* Remote DB ke data ko local store karne ke liye

### Command:

```sql
CREATE MATERIALIZED VIEW mv_emp
REFRESH COMPLETE ON DEMAND
AS SELECT * FROM emp@remote_db_link;
```

---

## 2. 🛋 Index Types

### 1. B-tree (default)

* Fast lookup on **equality/inequality** conditions
* Example: `SELECT * FROM emp WHERE emp_id = 101;`

### 2. Bitmap Index

* Best for **low cardinality** columns (e.g., gender, status)

### 3. Function-Based Index

* Index on expression

```sql
CREATE INDEX idx_lower_name ON emp(LOWER(name));
```

### 4. Reverse Key Index

* Useful for inserting sequential numbers (to avoid block contention)

---

## 3. 🪝 Triggers

### Kya Hai?

Automatically chalte hain jab INSERT/UPDATE/DELETE hota hai kisi table par

### Example:

```sql
CREATE OR REPLACE TRIGGER trg_before_emp_insert
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
  :new.created_on := SYSDATE;
END;
```

---

## 4. 🧰 User / Role / Grant

### Create User:

```sql
CREATE USER test_user IDENTIFIED BY pass123;
GRANT CONNECT, RESOURCE TO test_user;
```

### Create Role:

```sql
CREATE ROLE app_readonly;
GRANT SELECT ON employees TO app_readonly;
GRANT app_readonly TO test_user;
```

---

## 5. 🪨 RMAN Backup / Restore

### Full DB Backup:

```bash
rman target /
BACKUP DATABASE PLUS ARCHIVELOG;
```

### Restore:

```bash
RESTORE DATABASE;
RECOVER DATABASE;
```

---

## 6. 📦 Export / Import (Data Pump)

### Full DB Export:

```bash
expdp system/password full=y directory=DATA_DIR dumpfile=full_db.dmp logfile=exp.log
```

### Schema Import:

```bash
impdp system/password schemas=HR directory=DATA_DIR dumpfile=full_db.dmp logfile=imp.log
```

---

## 7. 🔐 TDE (Transparent Data Encryption)

### Kyu Use Karte Hai?

* Data-at-rest encryption (table data, backups)
* Compliance ke liye (e.g., GDPR, HIPAA)

### Setup Overview:

1. Set wallet location in sqlnet.ora
2. Create keystore:

```sql
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/wallet/path' IDENTIFIED BY oracle;
```

3. Open and set key

```sql
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY oracle;
ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY oracle WITH BACKUP;
```

4. Encrypt table column

```sql
ALTER TABLE employees MODIFY (ssn ENCRYPT);
```

---

## 8. 📤 Archive Log Mode + Recovery

### Enable Archive Mode:

```sql
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
```

### Recovery Example:

```bash
RESTORE DATAFILE 5;
RECOVER DATAFILE 5;
```

---

## 9. ⚡ Performance Tuning Reports

### AWR:

```sql
@?/rdbms/admin/awrrpt.sql
```

### ASH:

```sql
@?/rdbms/admin/ashrpt.sql
```

### ADDM:

```sql
@?/rdbms/admin/addmrpt.sql
```

### Focus Sections:

* Top SQL by Elapsed Time, CPU Time
* Wait Events: DB kis kaam me atka
* Segment Stats: Kaunsi table/index hit ho rahi hai

---
