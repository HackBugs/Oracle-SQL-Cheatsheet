> # Oracle 19c, Data Guard, RAC (Real Application Clusters), aur GoldenGate **step-by-step 

---

## 🧠 Chat-style Guide: Oracle 19c, Data Guard, RAC, GoldenGate – Install & Configure (Hinglish)

---

### 👨‍💻 \[You]: Sir, Oracle 19c ka installation kaise hota hai? Mujhe interview ke liye step-by-step batayein.

---

### 🤖 \[ChatGPT]: Bilkul! Chalo shuru karte hain basic se – sabse pehle **Oracle 19c Installation**:

---

## 🔷 1. Oracle 19c Installation – Single Instance (Linux)

### ✅ Prerequisites:

* OS: Oracle Linux 7/8 ya RHEL 7/8
* RAM: 4GB min (Production: 8GB+)
* Swap, Hostname, IP set ho
* Yum repo configured ho

### ✅ Download:

* Official site: [https://www.oracle.com/database/technologies/](https://www.oracle.com/database/technologies/)
* Login karo → Oracle Database 19c (Linux x86\_64) zip file download karo

### ✅ Steps:

```bash
# 1. User & Group create karo
groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
passwd oracle

# 2. Directory banao
mkdir -p /u01/app/oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01

# 3. Oracle user ke liye environment set karo (~/.bash_profile)
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_SID=orcl
export PATH=$ORACLE_HOME/bin:$PATH

# 4. X11 or GUI setup ho to runInstaller run karo
cd /path/to/database
./runInstaller
```

> During installation → Inventory location, ORACLE\_HOME, ORACLE\_SID set karo
> Install hone ke baad root user se 2 scripts run karne ko bolega – run them.

---

### 🔍 \[You]: Sir Oracle Data Guard kaise configure karte hai? Kya ye DR ke liye hota hai?

---

### 🤖 \[ChatGPT]: Yes! Oracle **Data Guard** ka use hota hai **Disaster Recovery (DR)** ke liye. Ek Primary DB hoti hai, dusri Standby DB.

---

## 🔷 2. Oracle Data Guard – Step-by-Step (Primary + Standby DB)

### ✅ Requirement:

* Dono servers par Oracle 19c installed hona chahiye
* Same OS, same Oracle version
* Network connectivity ho
* Archivelog mode on

### ✅ Steps:

```bash
# On Primary:
ALTER SYSTEM SET log_archive_config='DG_CONFIG=(ORCL,ORCLDG)';
ALTER SYSTEM SET log_archive_dest_2='SERVICE=ORCLDG ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ORCLDG';
ALTER DATABASE FORCE LOGGING;
ALTER DATABASE ARCHIVELOG;
SHUTDOWN IMMEDIATE; STARTUP MOUNT; ALTER DATABASE ARCHIVELOG; ALTER DATABASE OPEN;

# Create password file
orapwd file=$ORACLE_HOME/dbs/orapwORCL password=oracle

# Listener and tnsnames.ora configure karo
# Create standby controlfile
RMAN> BACKUP CURRENT CONTROLFILE FOR STANDBY;

# Datafile copy karke standby server pe bhejo
scp *.dbf, controlfile etc. to standby

# On Standby:
-- Configure listener, init.ora, tns
-- Mount the database
STARTUP NOMOUNT;
RMAN> DUPLICATE TARGET DATABASE FOR STANDBY FROM ACTIVE DATABASE DORECOVER;
```

> Dono side pe listener, tnsnames.ora properly configured hone chahiye
> Lag apply status verify karne ke liye:

```sql
SELECT DATABASE_ROLE FROM V$DATABASE;
SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST_STATUS;
```

---

### 🧑‍💼 \[You]: Sir RAC kya hota hai? Iska setup kaise karte hain?

---

### 🤖 \[ChatGPT]: RAC matlab **Real Application Clusters**. Ek hi DB multiple servers (nodes) pe chalti hai. Ye high availability aur load balancing ke liye hota hai.

---

## 🔷 3. Oracle RAC – Basic Concept & Setup (2 Node Cluster)

### ✅ Prerequisites:

* Minimum 2 servers (nodes)
* Shared storage (like ASM)
* Public, Private (interconnect), SCAN IPs
* Oracle Grid Infrastructure + Oracle RAC DB

### ✅ Steps (high-level):

```bash
# 1. Grid Infrastructure install karo (clusterware)
# 2. SCAN IP, VIP, interconnect IP configure karo
# 3. ASM setup karo (for shared disk)
# 4. Oracle RAC binaries install karo
# 5. Create RAC database using DBCA
```

> Oracle Clusterware `cluutil`, `olsnodes`, and `srvctl` commands use hote hain.
> Ye highly complex setup hota hai, mostly production-grade systems me.

---

### 🧑‍💼 \[You]: GoldenGate kya karta hai? Installation kaise hoti hai?

---

### 🤖 \[ChatGPT]: GoldenGate real-time replication ke liye hota hai. Real-time me data ek DB se dusre DB me sync hota hai (Oracle to Oracle, ya heterogeneous DBs).

---

## 🔷 4. Oracle GoldenGate Installation & Configuration

### ✅ Download:

* [https://www.oracle.com/middleware/technologies/goldengate-downloads.html](https://www.oracle.com/middleware/technologies/goldengate-downloads.html)

### ✅ Steps:

```bash
# 1. Source aur Target pe GoldenGate install karo
unzip ggs_Linux_x64.zip -d /u01/ogg
cd /u01/ogg
./ggsci

# 2. Source DB me:
-- Enable supplemental logging
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

# 3. Create Extract process
GGSCI> ADD EXTRACT ext1, TRANLOG, BEGIN NOW
GGSCI> ADD EXTTRAIL /u01/ogg/dirdat/lt, EXTRACT ext1

# 4. Create Data Pump (optional)
GGSCI> ADD EXTRACT dpump1, EXTTRAILSOURCE /u01/ogg/dirdat/lt
GGSCI> ADD RMTTRAIL /u01/ogg/dirdat/rt, EXTRACT dpump1

# 5. On Target side:
-- ADD REPLICAT process
GGSCI> ADD REPLICAT rep1, EXTTRAIL /u01/ogg/dirdat/rt, MAP ...

# 6. Start all processes
GGSCI> START EXTRACT ext1
GGSCI> START REPLICAT rep1
```

---

## 🧾 Summary Table

| Component  | Purpose                        | Tools & Commands                           |
| ---------- | ------------------------------ | ------------------------------------------ |
| Oracle 19c | RDBMS Installation             | `runInstaller`, `.bash_profile`, GUI Setup |
| Data Guard | DR Setup (Primary <-> Standby) | AWR, RMAN, `ARCHIVELOG`, `DUPLICATE`       |
| RAC        | High Availability DB           | Grid Infra, SCAN IP, ASM, DBCA             |
| GoldenGate | Real-time replication          | GGSCI, EXTRACT, REPLICAT, MAP, RMTTRAIL    |

---
