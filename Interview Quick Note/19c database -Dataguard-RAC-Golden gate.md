> **✅ Oracle 19c + Data Guard + RAC + GoldenGate – Complete Installation Cheatsheet (Oracle Linux)**
Well-organized, downloadable file names + installation + config locations + components where each is needed.

---

## 🧾 **Cheatsheet Overview**

| Component     | Oracle DB Required | Extra Software Needed  | OS Required  | Shared Storage Needed | Cluster Needed |
| ------------- | ------------------ | ---------------------- | ------------ | --------------------- | -------------- |
| Oracle 19c DB | ✅ Yes              | ❌ No                   | Oracle Linux | ❌ No                  | ❌ No           |
| Data Guard    | ✅ Yes (both nodes) | ❌ No                   | Oracle Linux | ❌ No                  | ❌ No           |
| Oracle RAC    | ✅ Yes (all nodes)  | ✅ Grid Infrastructure  | Oracle Linux | ✅ Yes                 | ✅ Yes          |
| GoldenGate    | ✅ Yes (src & tgt)  | ✅ GoldenGate Installer | Oracle Linux | ❌ No                  | ❌ No           |

---

## 🗂️ **Software Download List with File Names**

| File Name                                       | Used In         | Description                                  | Source Link                                                                                           |
| ----------------------------------------------- | --------------- | -------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `LINUX.X64_193000_db_home.zip`                  | DB, DG, RAC, GG | Oracle 19c Database Software                 | [Oracle 19c DB Download](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html) |
| `LINUX.X64_193000_grid_home.zip`                | RAC             | Oracle Grid Infrastructure for Cluster Setup | [Oracle 19c GI Download](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html) |
| `123456_ggs_Linux_x64_shiphome.zip` *(example)* | GG              | Oracle GoldenGate for Oracle                 | [GoldenGate Download](https://www.oracle.com/middleware/technologies/goldengate-downloads.html)       |
| `OracleLinux-R8-U6-x86_64-dvd.iso`              | All             | Oracle Linux OS ISO for Server Installation  | [Oracle Linux ISO](https://yum.oracle.com/iso/)                                                       |
| `oracle-database-preinstall-19c` (YUM)          | All             | Preinstall RPM – installs dependencies       | Installed via: `sudo yum install oracle-database-preinstall-19c`                                      |

---

## 📁 **Installation Paths (Recommended)**

| Software           | Install Location (example)                 |
| ------------------ | ------------------------------------------ |
| Oracle DB Software | `/u01/app/oracle/product/19.0.0/dbhome_1/` |
| Oracle Grid (RAC)  | `/u01/app/19.0.0/grid/`                    |
| Oracle GoldenGate  | `/u01/ogg/` or `/u01/app/goldengate/`      |

---

## ⚙️ **Important Configuration Files**

| Tool/Feature   | Config File(s) Name                                                   | Typical Path                  |
| -------------- | --------------------------------------------------------------------- | ----------------------------- |
| **Oracle DB**  | `init.ora` or `spfile.ora`                                            | `$ORACLE_HOME/dbs/`           |
|                | `listener.ora`, `tnsnames.ora`                                        | `$ORACLE_HOME/network/admin/` |
|                | `oratab`                                                              | `/etc/oratab`                 |
| **Data Guard** | Same as DB + these params: `log_archive_dest_n`, `log_archive_config` | In `spfile` or `init.ora`     |
|                | `dgmgrl.conf` (Broker managed)                                        | Managed internally            |
| **Oracle RAC** | Cluster Config: `OCR`, `Voting Disk`, `/etc/hosts`                    | Set during Grid Infra install |
|                | `listener.ora`, `tnsnames.ora`                                        | `$GRID_HOME/network/admin/`   |
| **GoldenGate** | `GLOBALS`, `dirprm/*.prm`, `ggserr.log`                               | Inside GG Home: `/u01/ogg/`   |

---

## 🔁 **Where to Install DB Software**

| Component            | Install Oracle DB Software? | Details                              |
| -------------------- | --------------------------- | ------------------------------------ |
| Oracle 19c DB        | ✅ Yes                       | Main database engine                 |
| Data Guard – Primary | ✅ Yes                       | Full Oracle DB software required     |
| Data Guard – Standby | ✅ Yes                       | Same version as primary              |
| RAC Node 1           | ✅ Yes                       | After installing Grid Infrastructure |
| RAC Node 2+          | ✅ Yes                       | On every RAC node                    |
| GoldenGate Source    | ✅ Yes                       | Required for replication from Oracle |
| GoldenGate Target    | ✅ Yes (if Oracle DB target) | Required if target DB is Oracle      |

---

## 🧠 Hinglish Explanation (Simple Summary)

* **Oracle 19c DB software (`db_home.zip`)** sab jagah chahiye jahan Oracle database kaam karega.
* **RAC setup** me extra chahiye: `grid_home.zip` + shared storage + public/private IP.
* **GoldenGate** me alag installer chahiye (`ggs_Linux_x64_shiphome.zip`), par agar Oracle source/target ho to `db_home.zip` bhi chahiye.
* Sab kuch **Oracle Linux** pe hi install karna chahiye (recommended platform).

---

## 📌 Example Command Snippets

### Preinstall (Oracle Linux):

```bash
sudo yum install -y oracle-database-preinstall-19c
```

### Unzip Oracle DB:

```bash
unzip LINUX.X64_193000_db_home.zip -d /u01/app/oracle/product/19.0.0/dbhome_1
```

### Unzip Grid Infra:

```bash
unzip LINUX.X64_193000_grid_home.zip -d /u01/app/19.0.0/grid
```

### Unzip GoldenGate:

```bash
unzip 123456_ggs_Linux_x64_shiphome.zip -d /u01/ogg/
```

---

<hr>

> # Oracle 19c, Data Guard, RAC & GoldenGate: Full Setup Guide (Oracle Linux)

---

## ✅ PART 1: Oracle 19c Single Instance Setup

### 📂 Required Software

* Oracle 19c DB: `LINUX.X64_193000_db_home.zip`
* OS: Oracle Linux 7/8
* Preinstall: `oracle-database-preinstall-19c`

### 🔧 Installation Steps

```bash
# 1. Install OS Packages
sudo yum install -y oracle-database-preinstall-19c unzip

# 2. Create Oracle Directories
mkdir -p /u01/app/oracle/product/19.0.0/dbhome_1
chown -R oracle:oinstall /u01

# 3. Set Oracle User Environment
su - oracle
vi ~/.bash_profile
```

Add:

```bash
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19.0.0/dbhome_1
export ORACLE_SID=ORCL
export PATH=$ORACLE_HOME/bin:$PATH
```

```bash
# 4. Unzip and Run Installer
unzip LINUX.X64_193000_db_home.zip -d $ORACLE_HOME
cd $ORACLE_HOME
./runInstaller
```

Use GUI or silent install.

---

## ✅ PART 2: Oracle Data Guard (Primary + Standby)

### 📂 Required Software

* Oracle 19c DB: `LINUX.X64_193000_db_home.zip`
* OS: Oracle Linux
* Same setup on both primary & standby

### 🔧 Key Configuration

1. **Enable ArchiveLog & Force Logging**

```sql
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE FORCE LOGGING;
```

2. **Configure Listener & TNS** (`listener.ora`, `tnsnames.ora`)
3. **Passwordless SSH between servers**
4. **Use RMAN to duplicate DB**

```bash
rman target sys@primary auxiliary sys@standby
DUPLICATE TARGET DATABASE FOR STANDBY FROM ACTIVE DATABASE;
```

5. **Enable Data Guard Broker (Optional)**

```bash
dgmgrl
CREATE CONFIGURATION 'dgconfig' AS PRIMARY DATABASE IS 'ORCL' CONNECT IDENTIFIER IS 'orcl';
ADD DATABASE 'ORCLDR' AS CONNECT IDENTIFIER IS 'orcldr' MAINTAINED AS PHYSICAL;
ENABLE CONFIGURATION;
```

---

## ✅ PART 3: Oracle RAC (Real Application Clusters)

### 📂 Required Software

* `LINUX.X64_193000_db_home.zip`
* `LINUX.X64_193000_grid_home.zip`
* Shared storage: ASM / NFS / iSCSI

### 🔧 Installation Steps (Two Nodes)

```bash
# 1. Setup Users, Groups, and Directories (both nodes)
useradd oracle
groupadd oinstall
groupadd dba

# 2. Setup passwordless SSH (oracle user)
ssh-keygen
ssh-copy-id node2

# 3. Configure Shared Disks & DNS
```

Edit `/etc/hosts`:

```bash
192.168.0.10 node1
192.168.0.11 node2
192.168.0.20 node1-vip
192.168.0.21 node2-vip
192.168.0.30 node1-priv
192.168.0.31 node2-priv
```

```bash
# 4. Install Grid Infrastructure First
unzip LINUX.X64_193000_grid_home.zip -d /u01/app/19.0.0/grid/
cd /u01/app/19.0.0/grid
./gridSetup.sh
```

Use GUI or response file.

```bash
# 5. Then install RAC DB
unzip LINUX.X64_193000_db_home.zip -d /u01/app/oracle/product/19.0.0/dbhome_1
cd $ORACLE_HOME
./runInstaller
```

---

## ✅ PART 4: Oracle GoldenGate (Oracle to Oracle)

### 📂 Required Software

* GoldenGate: `ggs_Linux_x64_shiphome.zip`
* Oracle 19c DB: `LINUX.X64_193000_db_home.zip`

### 🔧 Setup Steps (Source & Target)

```bash
# 1. Unzip GoldenGate
mkdir /u01/ogg
cd /u01/ogg
unzip ggs_Linux_x64_shiphome.zip
./runInstaller

# 2. Create GG User in Oracle
CREATE USER ggadmin IDENTIFIED BY password;
GRANT DBA, CONNECT, RESOURCE TO ggadmin;

# 3. Enable Supplemental Logging (source)
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

# 4. Configure Extract & Replicat (GGSCI)
cd /u01/ogg
./ggsci
```

In GGSCI:

```bash
CREATE SUBDIRS;
ADD EXTRACT ext1, TRANLOG, BEGIN NOW;
ADD EXTTRAIL ./dirdat/ea, EXTRACT ext1;
ADD REPLICAT rep1, EXTTRAIL ./dirdat/ea, MAP ...;
```

Use parameter files in `dirprm/`.

---

## 🤖 Final Tips

* Always match Oracle DB and GG versions.
* Use Oracle Linux 7/8 for compatibility.
* Keep `/etc/hosts`, SSH, and file ownerships consistent.
* For production, use Grid Naming Service (GNS) and SCAN listeners in RAC.

<hr>

> # **Production Database, Data Guard, RAC, GoldenGate** ke cases me hum **Oracle software install karte hain ya nahi**, aur **DBCA use karte hain ya nahi**.

---

## 🔧 Summary Table: Oracle Software vs DBCA Use Case

| 🔢 Use Case                         | Oracle Software Install? | DBCA Use?        | Notes                                  |
| ----------------------------------- | ------------------------ | ---------------- | -------------------------------------- |
| **Production DB (Single Instance)** | ✅ Yes                    | ✅ Yes            | Software + DB create manually          |
| **Data Guard - Primary DB**         | ✅ Yes                    | ✅ Yes            | Yehi actual DB hota hai                |
| **Data Guard - Standby DB**         | ✅ Yes (same version)     | ❌ No (Usually)   | RMAN se clone karte hain               |
| **RAC - Node 1**                    | ✅ Yes (after Grid Infra) | ✅ Yes            | Clustered DB create karne ke liye      |
| **RAC - Node 2, 3...**              | ✅ Yes                    | ❌ No             | DB Node1 se shared hota hai            |
| **GoldenGate - Source (Oracle DB)** | ✅ Yes                    | ❌ (if DB exists) | Agar DB already hai, DBCA nahi chahiye |
| **GoldenGate - Target (Oracle DB)** | ✅ Yes                    | ❌ (if DB exists) | Same as source                         |

---

## 🔍 Case-by-Case Breakdown:

### 🟩 1. **Production Database (Single Instance)**

* ✅ **Oracle software install** karte ho (`runInstaller`)
* ✅ **Database create** karte ho (`dbca`)
* ✔️ Normal scenario

### 🟩 2. **Data Guard - Primary DB**

* ✅ `runInstaller` → Oracle software install karo
* ✅ `dbca` → Actual primary DB create karo
* ❗ Yehi DB se standby banega

### 🟨 3. **Data Guard - Standby DB**

* ✅ `runInstaller` → Same Oracle version install karo
* ❌ `dbca` → DB create **nahi** karte (kyunki RMAN duplicate se standby banate hain)

```bash
rman target sys@prim auxiliary sys@standby
DUPLICATE TARGET DATABASE FOR STANDBY FROM ACTIVE DATABASE ...
```

### 🟦 4. **RAC Environment**

#### 🔸 Node 1:

* ✅ Grid Infrastructure install karo
* ✅ Oracle Software install karo (`runInstaller`)
* ✅ RAC enabled DB create karo (`dbca`)

#### 🔸 Node 2+:

* ✅ Oracle Software install karo
* ❌ `dbca` run nahi karte (DB already cluster me shared hota hai)

### 🟧 5. **GoldenGate Source / Target**

* ✅ Oracle Software chahiye (agar source ya target Oracle hai)
* ❌ `dbca` tabhi chahiye jab new DB banana ho
* Agar DB already bana hua hai (HRDB, FINDB), to `dbca` ki jarurat nahi

---

## 🧠 Interview Line Bolne ke Liye:

> "Oracle DB installation me pehle hum `runInstaller` se software install karte hain, fir `dbca` se DB create karte hain. Production ya primary database me dono chahiye hote hain. Standby database RMAN duplicate se banate hain isliye wahan `dbca` nahi chahiye. RAC me Node1 par dbca chalta hai par baaki nodes pe shared hota hai. GoldenGate me bhi agar DB bana hua hai to dbca ki zarurat nahi padti."

<hr>

> # **Production DB (Single Instance)**, **Data Guard - Primary**, aur **Data Guard - Standby** — in tino ka kaam **alag hai**, role alag hai, lekin base Oracle software same hota hai.

---

## 🧠 Real-Life Example for Understanding:

> मान लो ek **college ki main office** hai (Production DB),
> aur uska ek **backup branch office** hai (Standby DB).
> Dono me same files/document chahiye, lekin **real-time me sync hoti hain**.
> Agar main office band ho jaye, to backup office chalu ho jata hai.

---

## 🔍 Detailed Difference Table

| 🔢 Feature                 | **Production DB (Single Instance)**   | **Data Guard – Primary DB**      | **Data Guard – Standby DB**      |
| -------------------------- | ------------------------------------- | -------------------------------- | -------------------------------- |
| 📌 Purpose                 | Main Database for application         | Main DB with DR setup            | Backup DB (failover/fetch-only)  |
| 🧠 Kaam kya karta hai?     | Application read/write yahin hoti hai | Real-time transaction processing | Standby mode me sync hota hai    |
| 🧾 Write operations        | Yes                                   | Yes                              | ❌ No (read-only ya recover mode) |
| 🔁 Failover/Fast recovery? | ❌ No DR setup                         | ✅ Yes, standby ready hota hai    | ✅ Used during failover           |
| 🔀 Active/Passive          | Active                                | Active                           | Passive until needed             |
| 🔧 DB creation             | `dbca` se banate hain                 | `dbca` se create karte hain      | `RMAN duplicate` se banate hain  |
| 🛠️ Changes allow?         | Yes                                   | Yes                              | ❌ No (read-only or managed)      |
| 🔐 Archivelog mode         | ✅ ON                                  | ✅ ON                             | ✅ Required for log apply         |
| 🔗 Data sync hota hai?     | N/A                                   | Logs send karta hai standby ko   | Logs receive & apply karta hai   |
| 🔧 Software install        | ✅ Yes (`runInstaller`)                | ✅ Yes (`runInstaller`)           | ✅ Yes (`runInstaller`)           |

---

## 🎯 Use Case Summary:

### 1️⃣ **Production DB (Single Instance)**

* Ye **normal standalone database** hota hai
* No Data Guard setup
* App yahin se read/write karti hai
* Koi DR backup nahi

📌 **Use:** Small/medium applications without DR

---

### 2️⃣ **Data Guard – Primary DB**

* Ye bhi ek **production DB** hota hai
* Lekin uska ek ya zyada **standby DBs** hote hain
* Ye **logs forward** karta hai standby ko
* Failover ya switchover ho sakta hai

📌 **Use:** Critical systems jinke liye **Disaster Recovery** chahiye

---

### 3️⃣ **Data Guard – Standby DB**

* Ye **active DB nahi** hota by default
* Ye sirf **Primary ke redo logs ko apply** karta hai
* Normal mode me ye **read-only ya MOUNTED** hota hai
* Failover hone par **ye active ban jata hai**

📌 **Use:** DR site (Disaster Recovery), Reporting server

---

## 🧠 Interview Me Kaise Bolna:

> "Production DB single instance hota hai jisme application directly kaam karti hai. Data Guard ka Primary DB bhi ek production DB hota hai, lekin uske sath ek standby DB hota hai jo logs receive karke apply karta hai. Standby DB by default passive hota hai, aur failover ke time pe active hota hai. Standby DB ko RMAN se clone karke banaya jata hai."

---

