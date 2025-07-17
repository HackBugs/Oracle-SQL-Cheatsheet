## 🔍 Sawal:

> Mera Oracle Database VM me chal raha hai aur `EM Express` open ho raha hai.
> **Lekin mujhe OEM (13c ya 24c)** bhi sikhna hai.
> ➤ To kya **usi VM jahan EM Express hai usi pe OEM install kar sakta hoon?**
> ➤ Ya mujhe **alag se OEM install karne ke liye dusri machine/VM chahiye?**

---

## ✅ Simple & Clear Answer (Hinglish):

### ✔️ **Yes – Aap usi VM jahan Oracle Database (19c) install hai, wahan hi OEM (13c/24c) bhi install kar sakte ho.**

**Lekin kuch cheezein zaruri hain:**

---

## 🔧 OEM ko usi system pe install karne ke liye yeh conditions honi chahiye:

| Requirement                        | Details                                          |
| ---------------------------------- | ------------------------------------------------ |
| ✅ RAM                              | Minimum **8–10 GB** (Recommended: 12 GB for OEM) |
| ✅ Disk Space                       | At least **30–40 GB free**                       |
| ✅ Oracle Database (for Repository) | Already installed 19c – ✅ Perfect                |
| ✅ OS                               | Linux (Oracle Linux, CentOS, RHEL preferred)     |
| ✅ Java                             | Java 11 (for OEM 24c) or Java 8 (for OEM 13c)    |
| ✅ Hostname & IP setup              | Properly configured hostname (recommended)       |

---

## 📌 Practical Scenario:

Aapne Oracle 19c install kar rakha hai jisme:

* `EM Express` (`https://<ip>:5500/em`) already chal raha hai ✅
* Aap OEM 13c ya 24c bhi sikhna chahte ho 👨‍💻

**➡️ To aap usi Virtual Machine pe OEM install kar sakte ho.**

OEM usi Oracle 19c DB ko use karega **repository database** banane ke liye.

---

## ✅ Kaise Install Kare – High Level Steps:

### 📁 1. OEM Files Download karo (24.1 preferred)

From Oracle:
🔗 [https://www.oracle.com/enterprise-manager/downloads/](https://www.oracle.com/enterprise-manager/downloads/)

### 📦 2. Saare 6 ZIP files ko ek folder me rakho aur extract karo

### 🔧 3. Pre-requisite check aur Java install

### ▶️ 4. Run Installer:

```bash
./runInstaller
```

### 📊 5. Installation Wizard me:

* Oracle base path do
* Repository DB ke liye Oracle 19c ka info do
* Listener port confirm karo (usually 1521)
* SYSMAN user password set karo

### 🌐 6. Installation ke baad OEM ka web URL:

```
https://<vm-ip>:7802/em
```

---

## 🔄 Parallel Use:

| Tool       | URL Example                     | Purpose                    |
| ---------- | ------------------------------- | -------------------------- |
| EM Express | `https://192.168.1.124:5500/em` | Local single DB GUI        |
| OEM 24c    | `https://192.168.1.124:7802/em` | Full enterprise monitoring |

Aap dono tools ek sath use kar sakte ho, koi dikkat nahi.

---

## 📝 Recommendation (Aapke liye):

| Situation                                | Action                      |
| ---------------------------------------- | --------------------------- |
| Oracle 19c already installed in VM       | ✅ Use as Repository DB      |
| EM Express already running               | ✅ Keep it running           |
| OEM sikhna hai                           | ✅ OEM 24.1 install karo     |
| Machine me 10–12 GB RAM + 40 GB free hai | ✅ Install on same VM        |
| Nahi to RAM kam hai                      | ❌ Tab alag VM banani padegi |

<hr>

> # **OEM 24.1 ko same VM pe install karne ka full process** mai aapko step-by-step deta hoon:

---

## 🚀 OEM 24.1 Installation on Same VM (Oracle 19c already installed)

---

### ✅ Step 1: Check System Requirements

| Resource        | Recommended Minimum         |
| --------------- | --------------------------- |
| RAM             | 10–12 GB                    |
| Free Disk Space | 40–50 GB                    |
| OS              | Oracle Linux 7/8, RHEL 7/8  |
| DB Installed    | Oracle 19c (Already Done ✅) |
| Java            | Oracle JDK 11+              |

Check RAM:

```bash
free -h
```

Check Disk Space:

```bash
df -h /
```

---

### ✅ Step 2: Download OEM 24.1 Files

🔗 Go to: [OEM 24c Download Page](https://www.oracle.com/enterprise-manager/downloads/)

Download these 6 files:

```
V1046951-01.zip
V1046952-01.zip
V1046953-01.zip  ✅ Base
V1046954-01.zip
V1046955-01.zip
V1046956-01.zip
```

Put all in one folder like `/u01/oem24_install`.

---

### ✅ Step 3: Extract Base File

```bash
cd /u01/oem24_install
unzip V1046953-01.zip
```

It will auto detect all 5 parts.

---

### ✅ Step 4: Install Java 11

```bash
sudo yum install -y java-11-openjdk java-11-openjdk-devel

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-11
export PATH=$JAVA_HOME/bin:$PATH
```

Add above lines in `~/.bash_profile` also.

---

### ✅ Step 5: Start the Installer

```bash
cd em24.1_base/
./runInstaller
```

⚙️ GUI wizard open hoga → fill the following:

| Prompt                     | Enter                              |
| -------------------------- | ---------------------------------- |
| Oracle Base                | `/u01/app/oracle` (same as DB)     |
| Middleware Home (new path) | `/u01/app/oracle/em/middleware`    |
| Agent Base                 | `/u01/app/oracle/em/agent`         |
| Repository DB              | Oracle 19c info (SID, port = 1521) |
| SYS user password          | `admin` (or jo aapne set kiya ho)  |
| SYSMAN password            | Set new for OEM                    |
| Listener                   | Select your existing one           |

---

### ✅ Step 6: Post Install — Access OEM

OEM successfully install ho jaane ke baad:

🔗 Open in browser:

```
https://<your-vm-ip>:7802/em
```

Example:

```
https://192.168.1.124:7802/em
```

Username: `SYSMAN`
Password: (jo aapne setup ke time diya)

---

### ✅ Step 7: Add Target Databases (Optional for later)

* Jaise jaise aap sikhte jaoge, aap OEM me aur databases, hosts, WebLogic, cloud targets bhi add kar sakte ho.

---

## 🔄 Parallel Use:

| Tool       | URL                             | Use-case              |
| ---------- | ------------------------------- | --------------------- |
| EM Express | `https://192.168.1.124:5500/em` | Single DB access      |
| OEM 24c    | `https://192.168.1.124:7802/em` | Full infra monitoring |

---

## 📌 Bonus: OEM Installation Silent Mode Script (if needed)

Agar aap GUI nahi chala pa rahe ho toh mai `responseFile` ke through silent install script bhi de sakta hoon.

<hr>

> # ✅ Silent Installation Steps for OEM 24c using Response File (for Linux):

#### 🔹 Step 1: Create Directories

```bash
mkdir -p /u01/app/oracle/em
cd /u01/app/oracle/em
```

#### 🔹 Step 2: Extract All Downloaded OEM ZIPs

```bash
unzip V1046953-01.zip
unzip V1046951-01.zip
unzip V1046952-01.zip
unzip V1046954-01.zip
unzip V1046955-01.zip
```

Ye sab `em/` folder me extract ho jaye.

---

#### 🔹 Step 3: Prepare Response File

Create a file called `oem_response.rsp`:

```bash
vi oem_response.rsp
```

Paste the following content and modify as needed:

```ini
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oraInventory
ORACLE_HOME=/u01/app/oracle/em
ORACLE_BASE=/u01/app/oracle
CONFIGURE_ORACLE_EM=true
DEPLOYMENT_TYPE=ADVANCED
ADMIN_USER=weblogic
ADMIN_PASSWORD=Admin1234
DATABASE_HOSTNAME=localhost
LISTENER_PORT=1521
SERVICENAME_OR_SID=orcl
SYS_PASSWORD=admin
AGENT_REGISTRATION_PASSWORD=Agent123
PLUGINS_TO_INSTALL=oracle.sysman.db,oracle.sysman.oh
DECLINE_SECURITY_UPDATES=true
```

> 🧠 Note:
>
> * `ORACLE_HOME` and `ORACLE_BASE` location same hona chahiye jaha aap OEM install karna chahte hain.
> * `DATABASE_HOSTNAME` me apna actual host/IP do agar VM use kar rahe ho.
> * `SERVICENAME_OR_SID` = `orcl` (ya jo aapne DB install karte waqt diya ho).

---

#### 🔹 Step 4: Start Silent Installation

```bash
./em13200_linux64.bin -silent -responseFile /u01/app/oracle/em/oem_response.rsp
```

Yeh command silently OEM install karega bina kisi GUI ke.

---

#### 🔹 Step 5: Access OEM Console

Installation ke baad OEM URL kuch aisa hoga:

```
https://<your-hostname>:7802/em
```

---

### ✅ Final Tips:

* Make sure ports like `7802`, `5500` are **open** in your firewall (VM/network settings).
* You can check OEM status by:

```bash
$ORACLE_HOME/bin/emctl status oms
```

---

Agar aap chahte ho to mai aapke system ke hisaab se customized `oem_response.rsp` file bana ke de sakta hoon — aap bas apne:

* Hostname / IP
* Oracle DB SID
* SYS user password
* WebLogic password

ye 4 cheeze mujhe bata do.

<hr>

> # ✅ 1. Oracle 19c Database Silent Install Response File (`db_install.rsp`)

```ini
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oraInventory
ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
ORACLE_BASE=/u01/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
DECLINE_SECURITY_UPDATES=true
```

---

## ✅ 2. Oracle Data Guard Configuration Response File (`dataguard.rsp`) — Sample (Manual Steps Preferred)

> ⚠️ Data Guard zyada tar **manual RMAN + SQLNET + listener + parameters** se configure hota hai. Lekin reference `.ini`:

```ini
PRIMARY_DB_UNIQUE_NAME=PRIMDB
STANDBY_DB_UNIQUE_NAME=STANDBYDB
DB_NAME=orcl
DB_FILE_NAME_CONVERT='/u01/app/oracle/oradata/PRIMDB/','/u01/app/oracle/oradata/STANDBYDB/'
LOG_FILE_NAME_CONVERT='/u01/app/oracle/oradata/PRIMDB/','/u01/app/oracle/oradata/STANDBYDB/'
LOG_ARCHIVE_CONFIG='DG_CONFIG=(PRIMDB,STANDBYDB)'
LOG_ARCHIVE_DEST_2='SERVICE=STANDBYDB LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=STANDBYDB'
FAL_SERVER=STANDBYDB
FAL_CLIENT=PRIMDB
```

> **Note:** Use manually with SQL/parameter changes.

---

## ✅ 3. Oracle RAC 19c Grid Infrastructure Install (`grid_install.rsp`)

```ini
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v19.0.0
INVENTORY_LOCATION=/u01/app/oraInventory
oracle.install.option=CRS_CONFIG
ORACLE_BASE=/u01/app/grid
ORACLE_HOME=/u01/app/19.0.0/grid
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.gpnp.scanName=rac-scan
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.ClusterConfiguration=STANDALONE
oracle.install.crs.config.configureAsExtendedCluster=false
oracle.install.crs.config.clusterName=rac-cluster
oracle.install.crs.config.networkInterfaceList=eth0:192.168.1.0:1
oracle.install.crs.config.storageOption=FLEX_ASM_STORAGE
DECLINE_SECURITY_UPDATES=true
```

---

## ✅ 4. Oracle GoldenGate Silent Install (`oggcore.rsp`)

```ini
[oracle.install.responseFileVersion]
OGG_HOME=/u01/app/oracle/ogg
INVENTORY_LOCATION=/u01/app/oraInventory
SOFTWARE_LOCATION=/u01/app/oracle/ogg
UNIX_GROUP_NAME=oinstall
INSTALL_TYPE=Oracle GoldenGate for Oracle
DECLINE_SECURITY_UPDATES=true
```

---

## ✅ 5. Oracle OEM 13c/24c Silent Install Response File (`oem_response.rsp`)

```ini
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oraInventory
ORACLE_HOME=/u01/app/oracle/em
ORACLE_BASE=/u01/app/oracle
CONFIGURE_ORACLE_EM=true
DEPLOYMENT_TYPE=ADVANCED
ADMIN_USER=weblogic
ADMIN_PASSWORD=Admin1234
DATABASE_HOSTNAME=localhost
LISTENER_PORT=1521
SERVICENAME_OR_SID=orcl
SYS_PASSWORD=admin
AGENT_REGISTRATION_PASSWORD=Agent123
PLUGINS_TO_INSTALL=oracle.sysman.db,oracle.sysman.oh
DECLINE_SECURITY_UPDATES=true
```

---

### ✅ Bonus: DBCA Silent Response File for Creating DB (`dbca.rsp`)

```ini
gdbName=orcl
sid=orcl
databaseConfigType=SI
templateName=General_Purpose.dbc
sysPassword=admin
systemPassword=admin
emConfiguration=DBEXPRESS
emExpressPort=5500
dbsnmpPassword=admin123
datafileDestination=/u01/app/oracle/oradata
recoveryAreaDestination=/u01/app/oracle/flash_recovery_area
storageType=FS
characterSet=AL32UTF8
nationalCharacterSet=AL16UTF16
totalMemory=2048
```

---

### ⚙️ Installation Commands (Examples):

* **Oracle 19c**:

```bash
./runInstaller -silent -responseFile /path/to/db_install.rsp
```

* **DBCA DB Creation**:

```bash
dbca -silent -createDatabase -responseFile /path/to/dbca.rsp
```

* **OEM 24c**:

```bash
./em13200_linux64.bin -silent -responseFile /path/to/oem_response.rsp
```

