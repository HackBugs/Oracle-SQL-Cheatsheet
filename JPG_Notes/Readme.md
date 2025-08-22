> ## 1. Opatch CMDs
```
optach version
./opatch lspatches
opatch lsinv
opatch lsinv | grep -i applied
env | grep ora

chown -Rf oracle:oinstall /u01
chmod -Rf 755 /u01
unzip p6880880_190000_Linux-x86-64.zip -d /u01/app/oracle/product/19.0.0/db_home
opatch lsinventory -detail -oh /u01/app/oracle/product/19.0.0/db_1
./opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/software/37641958/37642901
sqlplus / as sysdba
select count(*) from dba_objects where status = 'INVALID';
shutdown immediate

lsnartl status
which optach

export PATH=$PATH:/u01/app/oracle/product/19.0.0/db_home/OPatch
export PATH=$ORACLE_HOME/OPatch:$PATH
opatch apply
./opatch lspatches
sqlplus / as sysdba
startup
select name, open_mode from V$database;
select count(*) from dba_objects where status = 'INVALID';
./datapatch verbose
```
```
select name, open_mode, database_role from v$database;

show parameter cluster;

set lines 200 pages 500
col owner for a15
col object_name for a35
select owner, object_name, object_type, status 
from dba_objects 
where status = 'INVALID';

col comp_name for a40
select comp_id, comp_name, version, status 
from dba_registry;

set lines 200 pages 500
col action_time for a30
col action for a30
col version for a10
col namespace for a20
col comments for a47
select action_time, action, version, namespace, id, comments 
from dba_registry_history;
```


---

> # **Index bana ke** sab topics ek hi jagah par hamesha yaad rahega. Tum isko **cheat-sheet index** samajh lo jo interview me turant yaad karne ke liye kaam aayega.

---

# 📖 Oracle DBA Pre–Post Steps Index

## 1. **OPatch (Oracle Patching)**

* Pre-Steps → OPatch version, lsinventory, conflict check, DB & listener shutdown, backup
* Apply → unzip patch, `opatch apply`
* Post → `opatch lspatches`, `datapatch -verbose`, DB startup

---

## 2. **Full Backup (RMAN)**

* Pre → Archivelog mode, space check
* Backup → `backup database plus archivelog`
* Post → `crosscheck backup`, `validate database`

---

## 3. **Logical Backup (Data Pump)**

* Export → `expdp full=y parallel=4`
* Import → `impdp full=y parallel=4`

---

## 4. **Oracle Database Installation (19c)**

* Pre → OS packages, kernel params, groups & users, ORACLE\_HOME
* Install → `runInstaller`
* Post → `netca`, `dbca`

---

## 5. **RAC Installation**

* Pre → Shared storage, SCAN IP, OS user & groups, SSH equivalence
* Install → `gridSetup.sh`, `runInstaller`
* Post → `srvctl`, `crsctl` checks

---

## 6. **GoldenGate Installation**

* Pre → Supplemental logging, archive log enable
* Install → `ggsci → create subdirs`
* Post → `info all`, `dblogin`

---

## 7. **OEM (Oracle Enterprise Manager)**

* Pre → Middleware home, repository DB ready
* Install → `em13c_installer`
* Post → Access URL, add targets

---

## 8. **Database Modes (Interview Special)**

* NOMOUNT → Control file recreate, DB create, restore (`startup nomount`)
* MOUNT → Recovery, rename datafiles, restore/backup (`startup mount`)
* OPEN → Normal DB usage (`startup`)

---

## 9. **Day-to-Day DBA Tasks (Shutdown/Startup Needed)**

* Backup/Restore → NOMOUNT/MOUNT
* Controlfile recreate → NOMOUNT
* Datafile rename/drop → MOUNT
* User operations → OPEN
* Patching → Shutdown + startup after patch

<hr>

> # **Oracle DBA Cheat Sheet Index** bana deta hoon jisme **Topic | Software/Package Name | Pre-Steps | Install/Apply | Post-Steps | Important Commands** sab cover hoga. Ye interview me tumhe direct reference milega aur koi step ya software miss nahi hoga.

---

# 📖 Oracle DBA Cheat Sheet (with Software/Packages)

| #     | Topic                                  | Software / Package Name                                             | Pre-Steps                                                                                                              | Install / Apply Steps                               | Post-Steps                                                             | Important Commands                                                                                         |
| ----- | -------------------------------------- | ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **1** | **OPatch (Database Patching)**         | **OPatch Utility** (Oracle site se download, `$ORACLE_HOME/OPatch`) | - OPatch version check<br>- lsinventory check<br>- Conflict check<br>- DB shutdown<br>- Listener stop<br>- Full Backup | `unzip patch`<br>`opatch apply -silent`             | - `opatch lspatches`<br>- `datapatch -verbose`<br>- DB startup         | `opatch version`<br>`opatch lsinventory`<br>`lsnrctl stop`<br>`sqlplus / as sysdba` → `shutdown immediate` |
| **2** | **Full Backup**                        | **RMAN (Recovery Manager)** (inbuilt with Oracle)                   | - Archivelog mode check<br>- Disk space check                                                                          | `rman target /` → `backup database plus archivelog` | - `crosscheck backup`<br>- `validate database`                         | `rman target /`<br>`list backup summary`                                                                   |
| **3** | **Logical Backup**                     | **Oracle Data Pump (expdp/impdp)**                                  | - Directory object create<br>- Grant access                                                                            | `expdp system/... full=y parallel=4`                | `impdp system/... full=y parallel=4`                                   | `expdp` / `impdp` commands                                                                                 |
| **4** | **Oracle Database Installation (19c)** | **Oracle Database 19c Software** (LINUX/Windows Installer ISO/zip)  | - OS packages install<br>- Kernel params (`/etc/sysctl.conf`)<br>- Groups/users (`oracle:dba`)<br>- Set ORACLE\_HOME   | `./runInstaller`                                    | `netca` (listener)<br>`dbca` (create DB)                               | `yum install binutils gcc libaio`<br>`./runInstaller`                                                      |
| **5** | **RAC Installation**                   | **Grid Infrastructure + Oracle RAC**                                | - Shared storage ready (ASM/SAN)<br>- SCAN IP / VIP set<br>- OS users/groups<br>- SSH equivalence                      | `./gridSetup.sh`<br>`./runInstaller`                | `srvctl status database -d <db>`<br>`crsctl stat res -t`               | `srvctl` / `crsctl` commands                                                                               |
| **6** | **GoldenGate Installation**            | **Oracle GoldenGate** (separate zip/installer)                      | - Supplemental logging<br>- Archive log enable<br>- GoldenGate user create                                             | `./ggsci` → `create subdirs`                        | `ggsci` → `info all`, `dblogin`                                        | `alter database add supplemental log data;`<br>`./ggsci`                                                   |
| **7** | **OEM (Enterprise Manager 13c)**       | **Oracle Enterprise Manager 13c Installer**                         | - Middleware home<br>- Repository DB ready<br>- OS permission check                                                    | `./em13c_installer`                                 | Access: `https://hostname:7802/em`<br>Add targets (DB, listener, host) | `emctl start oms`<br>`emctl status oms`                                                                    |
| **8** | **Database Modes**                     | **Oracle Database (SQL\*Plus)**                                     | - Decide operation (DB create, recovery, normal use)                                                                   | `startup nomount/mount/open`                        | Use accordingly (restore/recovery/operations)                          | `startup nomount`<br>`startup mount`<br>`startup`                                                          |
| **9** | **Day-to-Day DBA Tasks**               | **SQL\*Plus, RMAN, OEM, OPatch**                                    | - Backup & Restore (RMAN)<br>- Patching (OPatch)<br>- Maintenance (SQL\*Plus)<br>- Monitoring (OEM)                    | Use required tool                                   | Verify logs, validate DB, restart services                             | `shutdown immediate`<br>`startup`<br>`crosscheck backup`                                                   |

---

# 🧠 Memory Note (Modes Quick Recap)

* **NOMOUNT** → DB creation, controlfile recreate, restore start
* **MOUNT** → Recovery, redo log apply, rename/move datafiles
* **OPEN** → Normal operations (users access)

<hr>

> # interview me DBA/DevOps level ka detailing puchenge toh tumhe **step by step with Pre, Installation, Post, aur related commands** pata hona chahiye. Main tumhe **expert level ka structured notes** bana kar deta hoon. Tumhare given topics ko main break kar raha hoon:

---

# 🔥 Oracle DBA Expert Checklist

## 1. **OPatch Apply Karna (Database Patching)**

👉 **Software:** OPatch utility (Oracle site se download, `$ORACLE_HOME/OPatch/` me hota hai).

### Pre-Steps:

* Current OPatch version check
* Latest OPatch version compare karo
* Inventory verify
* Conflict check
* Database aur listener stop karo
* Full/Logical backup

**Commands:**

```bash
$ export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
$ export PATH=$ORACLE_HOME/OPatch:$PATH

$ opatch version                        # OPatch version check
$ opatch lsinventory                    # Inventory check
$ opatch prereq CheckConflictAgainstOHWithDetail -ph /u01/patch
$ lsnrctl stop                          # Stop listener
$ sqlplus / as sysdba
SQL> shutdown immediate;                # DB Shutdown
```

### Apply Steps:

```bash
$ unzip p<patch_number>_<version>.zip -d /u01/patch
$ cd /u01/patch
$ opatch apply -silent
```

### Post-Steps:

```bash
$ opatch lspatches
$ cd $ORACLE_HOME/OPatch
$ datapatch -verbose                    # Apply SQL registry
$ sqlplus / as sysdba
SQL> startup;
```

---

## 2. **Full Backup (RMAN Backup)**

👉 **Software:** RMAN (Recovery Manager)

### Pre-Steps:

* ARCHIVELOG mode enable check
* Backup location verify
* Disk space check

**Commands:**

```bash
$ rman target /
RMAN> show all;
RMAN> backup database plus archivelog;
```

### Post:

* Crosscheck backup
* Validate

```bash
RMAN> crosscheck backup;
RMAN> list backup summary;
RMAN> validate database;
```

---

## 3. **Logical Backup (Data Pump: expdp/impdp)**

👉 **Software:** Oracle Data Pump

### Export (expdp):

```bash
$ expdp system/password directory=DATA_PUMP_DIR dumpfile=full_expdp_%U.dmp logfile=full_expdp.log full=y parallel=4 filesize=10G
```

### Import (impdp):

```bash
$ impdp system/password directory=DATA_PUMP_DIR dumpfile=full_expdp_%U.dmp logfile=full_impdp.log full=y parallel=4
```

---

## 4. **Oracle Database Installation (19c)**

👉 **Software:** Oracle Database 19c (LINUX/Windows installer)

### Pre-Steps:

* OS dependencies install karo (`yum install -y binutils gcc libaio …`)
* Kernel parameters set karo (`/etc/sysctl.conf`)
* Groups & users banao (`oracle:dba`)
* Inventory & ORACLE\_HOME set

### Install:

```bash
$ ./runInstaller
```

### Post:

```bash
$ netca       # listener config
$ dbca        # database creation
```

---

## 5. **RAC Installation (Real Application Clusters)**

👉 **Software:** Grid Infrastructure + Oracle RAC binaries

### Pre-Steps:

* Shared storage configure (ASM / SAN)
* SCAN IP, Virtual IP set
* OS user, groups
* SSH equivalence between nodes

### Install:

```bash
$ ./gridSetup.sh
$ ./runInstaller
```

### Post:

```bash
$ srvctl status database -d <db_name>
$ crsctl stat res -t
```

---

## 6. **GoldenGate Installation**

👉 **Software:** Oracle GoldenGate

### Pre-Steps:

* Source aur Target DB user create karo (with supplemental logging)
* Archive log enable karo

**Commands:**

```sql
SQL> alter database add supplemental log data;
SQL> alter system switch logfile;
```

### Install:

```bash
$ ./ggsci
GGSCI> create subdirs
```

### Post:

```bash
GGSCI> dblogin userid ggs_admin,password
GGSCI> info all
```

---

## 7. **OEM (Oracle Enterprise Manager) Installation**

👉 **Software:** Oracle Enterprise Manager 13c

### Pre-Steps:

* Middleware home set
* Repository DB ready
* OS user permission

### Install:

```bash
$ ./em13c_installer
```

### Post:

* Access URL: `https://hostname:7802/em`
* Add targets (DB, listener, host)

---

# 📌 Important: Database Modes (Interview Special)

| Mode        | Use Case (Kab kaam aata hai)                                             | Command           |
| ----------- | ------------------------------------------------------------------------ | ----------------- |
| **NOMOUNT** | Database creation, control file recreate, restore operations             | `startup nomount` |
| **MOUNT**   | Control file access, redo log recovery, rename datafiles, restore/backup | `startup mount`   |
| **OPEN**    | Normal DB operations (users can connect, queries run)                    | `startup`         |

---

# ✅ Day-to-Day DBA Tasks (with shutdown/startup needs)

* **Startup/Shutdown DB** → Maintenance windows
* **RMAN Backup/Restore** → Often NOMOUNT/MOUNT required
* **Recovery operations** → MOUNT required
* **Controlfile recreate** → NOMOUNT
* **Datafile rename/drop** → MOUNT
* **Normal user operations** → OPEN

---


<hr>
# Oracle SQL Cheatsheet - Quick Notes (Gallery View)

Ye notes interview ke time quick revision ke liye banaye gaye hain. 
<!-- grid / square layout -->

---

<table>
  <tr>
    <td><b>Page 1</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/1.jpg" width="250"/></td>
    <td><b>Page 2</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/2.jpg" width="250"/></td>
    <td><b>Page 3</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/3.jpg" width="250"/></td>
  </tr>
  <tr>
    <td><b>Page 4</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/4.jpg" width="250"/></td>
    <td><b>Page 5</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/5.jpg" width="250"/></td>
    <td><b>Page 6</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/6.jpg" width="250"/></td>
  </tr>
  <tr>
    <td><b>Page 7</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/7.jpg" width="250"/></td>
    <td><b>Page 8</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/8.jpg" width="250"/></td>
    <td><b>Page 9</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/9.jpg" width="250"/></td>
  </tr>
  <tr>
    <td><b>Page 10</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/10.jpg" width="250"/></td>
    <td><b>Page 11</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/11.jpg" width="250"/></td>
    <td><b>Page 11</b><br><img src="https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/12.jpg" width="250"/></td>
    <td></td>
  </tr>
</table>

<hr>
<!--
# Oracle SQL Cheatsheet - Quick Notes
Ye notes interview ke time quick revision ke liye banaye gaye hain.
1. https://github.com/HackBugs/PostgreSQL-EDB-Installation/tree/main
2. https://github.com/HackBugs/PostgreSQL-EDB-Installation/blob/main/EDB_Installation.md
3. https://github.com/HackBugs/PostgreSQL-EDB-Installation/blob/main/EDB-Tools/PgBouncer.md
4. https://github.com/HackBugs/PostgreSQL-EDB-Installation/blob/main/EDB-Tools/EDB%20Postgres%20Enterprise%20Manager.md
5. https://github.com/HackBugs/DevOps-sheet
6. https://github.com/HackBugs/docker-cmd
-->

# Useful Repositories — Quick Access

| Title | Description |
|-------|-------------|
| **PostgreSQL EDB Installation (main repo)** | [Repository Home](https://github.com/HackBugs/PostgreSQL-EDB-Installation/tree/main) |
| **EDB Installation Guide (EDB_Installation.md)** | [View Installation Guide](https://github.com/HackBugs/PostgreSQL-EDB-Installation/blob/main/EDB_Installation.md) |
| **PgBouncer Tool Documentation** | [View PgBouncer Tools](https://github.com/HackBugs/PostgreSQL-EDB-Installation/blob/main/EDB-Tools/PgBouncer.md) |
| **Postgres Enterprise Manager (PEM) Docs** | [View PEM Tools](https://github.com/HackBugs/PostgreSQL-EDB-Installation/blob/main/EDB-Tools/EDB%20Postgres%20Enterprise%20Manager.md) |
| **DevOps Sheet (Cheatsheet)** | [View DevOps Sheet](https://github.com/HackBugs/DevOps-sheet) |
| **Docker Commands Cheatsheet** | [View Docker-cmd](https://github.com/HackBugs/docker-cmd) |

<hr>

## Page 1
![Notes 1](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/1.jpg)

## Page 2
![Notes 2](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/2.jpg)

## Page 3
![Notes 3](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/3.jpg)

## Page 4
![Notes 4](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/4.jpg)

## Page 5
![Notes 5](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/5.jpg)

## Page 6
![Notes 6](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/6.jpg)

## Page 7
![Notes 7](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/7.jpg)

## Page 8
![Notes 8](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/8.jpg)

## Page 9
![Notes 9](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/9.jpg)

## Page 10
![Notes 10](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/10.jpg)

## Page 11
![Notes 11](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/11.jpg)

## Page 12
![Notes 11](https://raw.githubusercontent.com/HackBugs/Oracle-SQL-Cheatsheet/main/JPG_Notes/12.jpg)

<hr>
