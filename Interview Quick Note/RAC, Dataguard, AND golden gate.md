> # *RAC (Real Application Clusters)**, **Data Guard**, aur **GoldenGate** ke **important commands**, **configuration file paths**, aur **unke use**
---

## ✅ 1. **Oracle RAC (Real Application Cluster)**

### 🔹 **Purpose:**

Multiple instances of a single database running on different servers for **High Availability & Scalability**.

### 🔸 **Important Commands:**

| Command                                                 | Use                                  |
| ------------------------------------------------------- | ------------------------------------ |
| `crsctl check crs`                                      | Check Oracle Clusterware status      |
| `crsctl start crs` / `stop crs`                         | Start/Stop Clusterware               |
| `srvctl config database -d <db_name>`                   | Show DB config under RAC             |
| `srvctl status database -d <db_name>`                   | DB status across nodes               |
| `olsnodes -n`                                           | List cluster nodes with node numbers |
| `srvctl start instance -d <db_name> -i <instance_name>` | Start specific instance              |

### 🔸 **Config Paths:**

| File/Path                               | Purpose                    |
| --------------------------------------- | -------------------------- |
| `$ORACLE_HOME/dbs/spfile*.ora`          | Shared parameter file      |
| `$GRID_HOME/network/admin/tnsnames.ora` | RAC TNS entries            |
| `$ORACLE_HOME/srvm/admin`               | Cluster scripts            |
| `/etc/oracle/olr.loc`                   | Oracle Local Registry info |

---

## ✅ 2. **Oracle Data Guard**

### 🔹 **Purpose:**

Primary DB ka ek standby DB bana kar real-time ya near real-time replication for **Disaster Recovery**.

### 🔸 **Important Commands:**

| Command                                            | Use                     |
| -------------------------------------------------- | ----------------------- |
| `DGMGRL`                                           | Data Guard broker CLI   |
| `show configuration`                               | Check overall DG config |
| `show database verbose <db_name>`                  | Details of a DB         |
| `edit database <db_name> set state='apply-ready';` | Start apply on standby  |
| `switchover to <standby_db>;`                      | Switchover command      |
| `failover to <standby_db>;`                        | Failover command        |

### 🔸 **Config Files:**

| File                         | Purpose                         |
| ---------------------------- | ------------------------------- |
| `tnsnames.ora`               | Service configuration           |
| `listener.ora`               | Listener for both DBs           |
| `init*.ora` or `spfile*.ora` | DB parameter configuration      |
| `log_archive_dest_n`         | Archiving path setup            |
| `dg_broker_start=true`       | Enable DG broker in init/spfile |

### 🔸 **Configuration Path:**

* `$ORACLE_HOME/dbs`
* `$ORACLE_HOME/network/admin/`

---

## ✅ 3. **Oracle GoldenGate (OGG)**

### 🔹 **Purpose:**

Real-time data replication for **data integration, reporting, migrations**, etc.

### 🔸 **Important Commands:**

| Command                                  | Use                          |
| ---------------------------------------- | ---------------------------- |
| `ggsci`                                  | GoldenGate command-line tool |
| `info all`                               | Show status of all processes |
| `start <process>` / `stop <process>`     | Start/stop extract/replicat  |
| `add extract <name>, tranlog, begin now` | Create extract process       |
| `add replicat <name>, exttrail <path>`   | Create replicat process      |
| `view report <process>`                  | View process logs            |

### 🔸 **Config Files:**

| File                    | Purpose                 |
| ----------------------- | ----------------------- |
| `GLOBALS`               | Global parameters       |
| `dirprm/<extract>.prm`  | Extract process config  |
| `dirprm/<replicat>.prm` | Replicat process config |
| `dirchk/`               | Checkpoint files        |
| `ggserr.log`            | Error log file          |

### 🔸 **Configuration Path:**

* `$OGG_HOME/dirprm/`
* `$OGG_HOME/dirchk/`
* `$OGG_HOME/ggserr.log`

---

## 🎯 Interview Tips:

> 🗣️ **"Sir, RAC ke through multiple nodes same database ko access karte hain for HA; Data Guard se hum ek live backup maintain karte hain for DR; aur GoldenGate use karte hain for near real-time data replication across DBs – cross-platform bhi possible hai. In tino ke setup me specific config files, parameters, and commands hote hain jo mene hands-on practice kiya hai."**

<hr>

> # **Oracle RAC**, **Data Guard**, aur **GoldenGate** ke installation setup ke high-level step-by-step workflows diye gaye hain, ek tarah ki ASCII diagram ke saath—taaki aap interview mein confidently explain kar sako. Har component ka **flow**, **core tools/commands**, aur **configuration points** clear diye gaye hain.

---

## 🟢 1. Oracle RAC (Grid Infrastructure + ASM)

```
[Node1]                 [Node2]
   │                        │
Install Grid Infrastructure (includes ASM)
   │                        │
Configure Clusterware (SSH, OCR, Voting Disks)
   └─── Shared Storage (ASM Disk Group) ───┘
                     │
       Install Oracle RAC Database Software
                     │
              Create RAC Database
```

### ✅ Steps:

1. Install **Oracle Linux** on all nodes, setup **password-less SSH** between them.
2. Install **Grid Infrastructure** (includes ASM).
3. Create **ASM Disk Groups** using `asmca` or `srvctl`.
4. Install **Oracle RAC Database** binaries.
5. Create RAC database using `DBCA` or `srvctl`.
6. Manage via commands like `crsctl`, `srvctl`.

---

## 🟢 2. Data Guard Setup (Primary + Standby)

```
[Primary DB Server] ─── RMAN Duplicate ───> [Standby DB Server]
       │                                           │
Data Guard Broker CLI/DGMGRL                        │
       │                                           │
Configure TNS, listener, init parameters            │
       └─── Start Standby in MOUNT + Managed Recovery
```

### ✅ Steps:

1. Ensure both servers have **Oracle Database Enterprise Edition 19c**.
2. Enable **ARCHIVELOG mode**, create **standby redo logs**.
3. Create RMAN backup and restore to Standby server.
4. Configure `tnsnames.ora`, `listener.ora`, and **DG Broker**.
5. Use **DGMGRL** to create configuration and open **managed recovery**.

---

## 🟢 3. GoldenGate Setup (Source → Target)

```
[Source DB Server]                          [Target DB Server]
   │                                            │
Install OGG binaries                            │
   │                                            │
Create Extract → Write Trail Files ───> Pump → Transfer → Target Replicat
```

### ✅ Steps:

1. Install **GoldenGate software** on both source and target servers.
2. Set up `GLOBALS` file and configure **manager process**.
3. Create **Extract process** to read redo logs.
4. Create **Pump** to ship trail files.
5. Create **Replicat** on target to apply data.
6. Use `ggsci` commands like `add extract`, `add replicat`, `start`, `info all`.

---

## 📊 Summary Table:

| Component  | Key Steps                                     | Tools/Commands                         |
| ---------- | --------------------------------------------- | -------------------------------------- |
| RAC        | Install Grid, ASM, configure shared storage   | `crsctl`, `srvctl`, `asmca`            |
| Data Guard | Enable ARCHIVELOG, configure standby via RMAN | `dgmgrl`, `alter database`, RMAN       |
| GoldenGate | Configure Extract, Pump, Replicat processes   | `ggsci`, `EXTRACT`, `REPLICAT` scripts |

---

### 🎯 Interview Sample:

> “Sir, main Oracle RAC mein Grid Infrastructure aur ASM install karta hoon, shared storage configure karne ke baad nodes pe database software install karke RAC DB create karta hoon.
> Data Guard ke liye primary DB ko ARCHIVELOG mode me set karke standby pe duplicate restore kiya jata hai, phir DGMGRL se broker setup kiya jaata hai.
> GoldenGate ke liye Extract, Pump, aur Replicat processes configure hote hain log shipping ke liye, jisse real‑time replication achieve hota hai.”

<hr>

> # 🔧 Available Components for Deep Dive:

1. **Oracle RAC (Real Application Clusters)**
2. **Oracle Data Guard**
3. **Oracle GoldenGate**
4. **ASM (Automatic Storage Management)**
5. **Oracle Grid Infrastructure**
6. **OEM (Oracle Enterprise Manager)**

### Har component ke liye aapko milega:

* **Architecture diagram**
* **Installation prerequisites**
* **Required packages and software download links**
* **Step-by-step installation (commands + explanation)**
* **Important configuration files & their path**
* **Basic use-case commands**

