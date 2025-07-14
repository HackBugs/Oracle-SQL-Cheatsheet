> # 1 **Oracle Database Restore** ke 3 practical scenarios — **step-by-step real-time commands ke saath** in simple **Hinglish**. Interview me directly yehi questions puchte hain:

---

# 🧠 Scenario 1: 🔁 Full Database Restore + Recovery (Crash Recovery)

> 💥 Maan lo server crash ho gaya ya poora DB corrupt ho gaya – kaise wapas laayein?

### ✅ Steps:

```bash
rman target /

-- 1. Start DB in MOUNT mode
STARTUP MOUNT;

-- 2. Restore full database from RMAN backup
RESTORE DATABASE;

-- 3. Recover using archive logs + redo logs
RECOVER DATABASE;

-- 4. Open the DB
ALTER DATABASE OPEN;
```

> 🔐 NOTE: Archivelog mode pehle se ON hona chahiye, aur backup available hona chahiye.

---

# 🧠 Scenario 2: 💥 **Single Datafile Restore** (Partial Corruption)

> 🧪 Maan lo sirf ek datafile delete/corrupt ho gaya (e.g. users01.dbf) — kaise fix karoge?

### ✅ Steps:

```bash
rman target /

-- 1. Check which datafile is missing (Error will show file# like 5)
-- 2. Mount DB
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

-- 3. Restore missing datafile
RESTORE DATAFILE 5;

-- 4. Recover it
RECOVER DATAFILE 5;

-- 5. Open the DB
ALTER DATABASE OPEN;
```

---

# 🧠 Scenario 3: ⏱️ **Point-in-Time Recovery** (PITR)

> 🔙 Maan lo galti se kuch data delete/overwrite ho gaya – ab aapko database **back le jaana hai kisi particular time tak**.

### ✅ Steps:

```bash
rman target /

-- 1. Mount mode
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

-- 2. Restore & recover till time
RUN {
  SET UNTIL TIME "TO_DATE('2024-07-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS')";
  RESTORE DATABASE;
  RECOVER DATABASE;
}

-- 3. Open with resetlogs
ALTER DATABASE OPEN RESETLOGS;
```

> ⚠️ `RESETLOGS` zaroori hai jab aap PITR karte ho — ye naye redo logs se start karega.

---

## 📌 Real-Time Example of RMAN Backup:

```bash
rman target /
BACKUP DATABASE PLUS ARCHIVELOG;
```

---

## 🧠 Interview Tips:

| Question                      | What to Say                                                                  |
| ----------------------------- | ---------------------------------------------------------------------------- |
| DB crash ho gaya, kya karoge? | Sir, RMAN se restore & recover karta hoon using full backup and archivelogs. |
| Datafile delete ho gaya?      | Mount karke us specific file ka restore & recover karta hoon                 |
| Galti se data delete ho gaya? | SET UNTIL TIME karke point-in-time recovery karta hoon using RESETLOGS       |

---

<hr>

> # 2 **expdp/impdp (Data Pump Export/Import)** ka **full backup**, **schema-level backup**, aur **kaise recovery karte hain (import)** — sab kuch step-by-step in **Hinglish + real-time example**

---

## 📦 Oracle Data Pump Overview

| Tool    | Purpose                         |
| ------- | ------------------------------- |
| `expdp` | Data ka **logical backup** lena |
| `impdp` | Data ko wapas **import** karna  |

Ye tools internal Oracle utilities hain. Physical file nahi, balki **metadata + data** ka export hota hai.

---

# ✅ 1. **FULL DATABASE EXPORT (expdp full backup)**

### 💼 Step-by-Step:

#### 👇 Step 1: Directory Object Create Karo

```sql
CREATE DIRECTORY data_dir AS '/u01/backups';
GRANT READ, WRITE ON DIRECTORY data_dir TO system;
```

#### 👇 Step 2: Full Export Run Karo

```bash
expdp system/password full=y \
directory=data_dir \
dumpfile=full_db_%U.dmp \
logfile=full_db_exp.log \
parallel=4
```

✅ Isse pura DB ka logical backup milega (metadata + table data)

---

# ✅ 2. **SCHEMA EXPORT (Specific user ka backup)**

### 🧑‍💼 Maan lo HR user ka backup lena hai:

```bash
expdp system/password schemas=HR \
directory=data_dir \
dumpfile=hr_schema.dmp \
logfile=hr_exp.log
```

---

# ✅ 3. **TABLE-LEVEL EXPORT**

```bash
expdp system/password \
tables=HR.EMPLOYEES,HR.DEPARTMENTS \
directory=data_dir \
dumpfile=emp_dept.dmp \
logfile=emp_exp.log
```

---

# 🔁 IMPORT / RECOVERY using `impdp`

---

## 🧩 A. FULL DB IMPORT:

```bash
impdp system/password full=y \
directory=data_dir \
dumpfile=full_db_%U.dmp \
logfile=full_db_imp.log \
parallel=4
```

📝 Use only if old DB corrupt ho gaya ho ya naye server me restore karna ho

---

## 🧩 B. SCHEMA IMPORT:

```bash
impdp system/password schemas=HR \
directory=data_dir \
dumpfile=hr_schema.dmp \
logfile=hr_imp.log \
remap_schema=HR:HR_RESTORE
```

📌 `remap_schema` ka use karte hain agar naya user banana hai.

---

## 🧩 C. TABLE IMPORT:

```bash
impdp system/password \
tables=HR.EMPLOYEES \
directory=data_dir \
dumpfile=emp_dept.dmp \
logfile=emp_imp.log
```

---

## 🔐 💡 Bonus Options:

| Option                        | Use Kya Hai?                                 |
| ----------------------------- | -------------------------------------------- |
| `remap_schema`                | HR → HR2 (schema rename)                     |
| `remap_tablespace`            | USERS → DATA\_TS                             |
| `table_exists_action=replace` | Purani table overwrite ho jaye               |
| `include/exclude`             | Specific objects export/import karne ke liye |

---

## 🧠 Interview Me Aise Bolna Hai:

> “Sir, hum production me expdp se daily ya weekly logical backups lete hain. Mostly full DB ya schema-level backups. Import me impdp use karke ya to schema wapas late hain ya naya clone banate hain test ke liye.”

---

## 🔁 Summary Table

| Task           | Command                         |
| -------------- | ------------------------------- |
| Full Backup    | `expdp full=y ...`              |
| Schema Backup  | `expdp schemas=HR ...`          |
| Table Backup   | `expdp tables=HR.EMPLOYEES ...` |
| Full Restore   | `impdp full=y ...`              |
| Schema Restore | `impdp schemas=HR ...`          |
| Table Restore  | `impdp tables=...`              |

---

🧪 Realtime Lab steps bana du kya full + schema backup ka?
📂 Directory errors & fix (ORA-39002)?
📋 impdp me error aaye to troubleshoot kaise karein?


