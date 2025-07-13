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

Let me know if you want the **response files or automation shell scripts** for silent install! ✅
