> # Oracle Database 19c Primary and Physical Standby databases
> WebLogic and Tuxedo [Ahmedbaraka](https://www.ahmedbaraka.com/downloads/)


## Primary databases
```
# .bash_profile
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_SID=oradb; export ORACLE_SID
ORACLE_HOME=$ORACLE_BASE/product/19.0.0/db_1; export ORACLE_HOME
NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=${PATH}:/usr/bin:/bin:/usr/local/bin
PATH=.:${PATH}:$ORACLE_HOME/bin
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ORACLE_HOME/oracm/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib
export CLASSPATH
export TEMP=/tmp
export TMPDIR=/tmp
umask 022

```

## Physical Standby databases
```
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/db_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:$ORACLE_HOME/rdbms/lib
export PATH=$ORACLE_HOME/bin

env
select open_mode, database_role from v$database;
show parameter service
alter database recover managed standby database disconnect from session;
ps -ef | grep mrp
archive log list
select process, status, sequence#, block# from v$managed_standby;
```

## Physical Standby databases
```
# .bash_profile
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
ORACLE_SID=oradb_s2; export ORACLE_SID
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/db_1
NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=${PATH}:/usr/bin:/bin:/usr/local/bin
PATH=.:${PATH}:$ORACLE_HOME/bin
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ORACLE_HOME/oracm/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib
export CLASSPATH
export TEMP=/tmp
export TMPDIR=/tmp
umask 022

```

> ## Oracle RAC Database 19c on Linux 7
> ## Oracle GoldenGate 19c on Two Oracle Databases

<hr>

## Agar aapko **4 se 8 saal ke experience level tak ka complete Oracle DBA + EM + Data Guard + RAC + GoldenGate** ka real-world setup seekhna hai, toh aapko **step-by-step** ye environments install aur configure karne chahiye **Virtual Machines (VMs)** par.

### 🔰 Aapka Goal:

✅ Oracle Core DBA
✅ ASM
✅ CDB/PDB Architecture
✅ Enterprise Manager (OEM)
✅ Data Guard (DR setup)
✅ RAC (Real Application Cluster)
✅ GoldenGate (Replication)

---

## ✅ Step-by-Step Learning Plan

### 1️⃣ **Basic Oracle 19c Database with OEM**

* **Install This**:
  **A019** – `Oracle Database 19c on Linux 7` (Standalone with CDB)

  * Size: 9.7 GB
  * Platform: Linux 7 – 64-bit
  * **Why**: Ye aapka *base* hoga jisme aap Oracle installation, CDB/PDB, OEM 5500 port, users, backup/restore, listener, services sab sikhoge.

---

### 2️⃣ **Oracle with ASM + OEM + Restart**

* **Install This**:
  **A021** – `Oracle Database 19c Standalone + ASM (Oracle Restart)`

  * Size: 11.4 GB
  * Platform: Linux 7 – 64-bit
  * **Why**: ASM seekhna mandatory hota hai for production-level DBAs. Isme `Grid Infrastructure` + `Oracle DB` dono ek machine me setup hota hai.

---

### 3️⃣ **Data Guard Setup (Primary + Standby)**

* **Install This**:
  **A024** – `Oracle Database 19c Primary and Physical Standby databases`

  * Size: 12 GB
  * Platform: Linux 7 – 64-bit
  * **Why**: Isme do servers pre-configured hote hain (Primary + Standby). Aap real-time log shipping, role switchover/failover, monitoring seekh sakte ho.

---

### 4️⃣ **Oracle RAC (2-node cluster)**

* **Install This**:
  **A027** – `Oracle RAC Database 19c on Linux 7`

  * Size: 21 GB
  * Platform: Linux 7 – 64-bit
  * ASM + CDB included
  * **Why**: RAC ek high-availability setup hai. Interview me iske architecture aur troubleshooting ke questions fix hote hain.

---

### 5️⃣ **Oracle GoldenGate (2-way replication)**

* **Install This**:
  **A030** – `Oracle GoldenGate 19c on Two Oracle Databases`

  * Size: 21 GB
  * Platform: Linux 7 – 64-bit
  * **Why**: GG is used for near real-time replication (Active-Active or Active-Passive). Interviews me GoldenGate architecture and lag monitoring aata hai.

---

## 🔧 OEM Install Karne ki Jarurat?

Agar aap **A019** ya **A021** use karte ho, toh OEM 5500 port pe enabled hota hai.

* URL: `https://<VM-IP>:5500/em`
* Login: `sys as sysdba` ya `dbsnmp` user.

Agar aap **Cloud control** version (Enterprise Manager OMS 13c ya 24c) install karna chahte ho toh wo ek *alag* centralized monitoring setup hai — uske liye alag VM banani chahiye.

---

## 📦 Recommended Order to Install (Learning Roadmap)

| Step | Topic                       | VM ID | Size  | Purpose                                  |
| ---- | --------------------------- | ----- | ----- | ---------------------------------------- |
| 1️⃣  | Oracle 19c Base Setup + OEM | A019  | 9.7G  | Start with Oracle installation & OEM     |
| 2️⃣  | ASM Setup with Restart      | A021  | 11.4G | Learn ASM & Oracle Restart               |
| 3️⃣  | Data Guard (DR Setup)       | A024  | 12G   | Learn disaster recovery and log shipping |
| 4️⃣  | RAC 2-node Cluster          | A027  | 21G   | Learn high availability and clustering   |
| 5️⃣  | GoldenGate                  | A030  | 21G   | Learn replication across DBs             |

---


