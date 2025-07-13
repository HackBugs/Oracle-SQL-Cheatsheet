> # **“Interview Topics Note Sheet”**

---

### ✅ Topics Covered:

1. **RAC** – Cluster setup, SCAN listener, HA
2. **GoldenGate** – Real-time replication, Extract & Replicat
3. **Performance Tuning** – AWR, ASH, Top SQL analysis
4. **OEM** – Monitoring, alert, session & resource view
5. **TDE** – Encryption + Compliance setup
6. **Database Patching** – PSU, RU patching with OPatch
7. **DB Refresh** – Prod → Dev copy using RMAN/Data Pump
8. **DB Reorganization** – Move, shrink, defrag for space optimization
9. **Validation Practices & Tools** – SQLT, TKPROF, AWR, logs
10. **Disaster Recovery** – Data Guard + switchover/failover
11. **Backup & Recovery** – RMAN scenarios
12. **Security Policies** – Roles, grants, auditing
13. **Trend Analysis & Capacity Planning** – DB growth and usage
14. **Root Cause Analysis** – Slow query, session, alert log, trace analysis

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

## 10. 🤷 Mandatory Interview Topics Notes (With Purpose & Usage)

### ✔ RAC (Real Application Cluster):

**Purpose:** High Availability + Scalability
**Use:** Ek hi DB ko multiple servers pe run karna
**Tools:** Grid Infrastructure, SCAN listener, srvctl, crsctl
**Real Example:** Banking apps jisme downtime allowed nahi hota

### ✔ GoldenGate:

**Purpose:** Real-time data replication
**Use:** Source DB se Target DB me data send karna
**Components:** Extract, Pump, Replicat, Trail files
**Real Example:** Reporting DB ya live failover setup

### ✔ Performance Tuning:

**Purpose:** Slow query ko fast banana
**Use:** AWR, ASH, ADDM reports dekhke tuning karna
**Focus Areas:** CPU usage, Wait events, SQL Plan

### ✔ OEM (Oracle Enterprise Manager):

**Purpose:** Graphical interface for DBA tasks
**Use:** Monitor DB, alerts, session activity, storage
**Real Use:** DBA ko visual dashboard provide karna

### ✔ TDE:

**Purpose:** Data ko secure karna at-rest (disk par)
**Use:** Table columns ya tablespace ko encrypt karna
**Real Use:** Financial ya government data compliance

### ✔ DB Patching:

**Purpose:** Bugs fix karna, security update dena
**Tool:** OPatch utility
**Use:** PSU (Patch Set Update), RU (Release Update)

### ✔ DB Refresh:

**Purpose:** Dev/Test environment update karna
**Use:** Production se copy karke lower env me restore karna
**Tools:** RMAN duplicate, datapump

### ✔ DB Reorganization:

**Purpose:** Space optimize karna
**Use:** Table move, shrink, reorg, rebuild index

### ✔ Validating Practices & Tools:

**Purpose:** Health check aur issue trace karna
**Tools:** AWR, TKPROF, SQLT, OEM logs, alert log

### ✔ Disaster Recovery (DR):

**Purpose:** Crash hone ke baad data recover karna
**Use:** Data Guard setup, switchover, failover testing

### ✔ Backup & Recovery:

**Purpose:** Data loss avoid karna
**Tools:** RMAN, Archive logs, Incremental/full backup
**Use:** Datafile loss, controlfile loss, media recovery

### ✔ Security Policies:

**Purpose:** Unauthorized access rokna
**Use:** Role-based access, auditing, TDE, DB Vault

### ✔ Trend Analysis & Capacity Planning:

**Purpose:** Future growth predict karna
**Use:** Tablespace growth, user session patterns track karna
**Tools:** OEM, SQL scripts, AWR trending

### ✔ Root Cause Analysis:

**Purpose:** Repeating issue ka asli reason pakadna
**Use:** Session trace, alert log, wait event analysis
**Tools:** TKPROF, trace file, v\$ views

---

🧠 Tip:
Interview me short me confidently samjhao:
"Sir, main RAC me SCAN listener, golden gate me extract/replicat, performance tuning me AWR, OEM dashboard, TDE setup, aur DR ke liye Data Guard use karta hoon. Har task ka real-time use jaanta hoon aur daily health check, patching aur refresh bhi karta hoon."



