> # `expdp` (Oracle **Data Pump Export**) ek powerful tool hai Oracle database ka, jo aapko database objects ko **export** (yaani backup bana ke nikaalna) allow karta hai.

---

## ✅ **`expdp` se kya-kya export kar sakte hain?**

### 🔹 1. **Full Database**

* **Poora database** ka backup le sakte ho.

```bash
expdp system/password FULL=Y DUMPFILE=full_db.dmp LOGFILE=full_db.log
```

---

### 🔹 2. **Schemas**

* Kisi **specific schema/user** ka export.

```bash
expdp system/password SCHEMAS=HR,SCOTT DUMPFILE=schemas.dmp LOGFILE=schemas.log
```

---

### 🔹 3. **Tables**

* Specific **tables** export karna.

```bash
expdp system/password TABLES=employees,departments DUMPFILE=tables.dmp LOGFILE=tables.log
```

---

### 🔹 4. **Tablespaces**

* Specific **tablespaces** export.

```bash
expdp system/password TABLESPACES=users,example DUMPFILE=tbs.dmp LOGFILE=tbs.log
```

---

### 🔹 5. **Views, Synonyms, Indexes, Functions, Procedures, Triggers**

* In sabko `expdp` schema level export ke through export kar sakte ho.

```bash
expdp system/password SCHEMAS=HR INCLUDE=FUNCTION,PROCEDURE,TRIGGER DUMPFILE=code.dmp LOGFILE=code.log
```

---

### 🔹 6. **Metadata Only / Data Only**

* Sirf structure chahiye ya sirf data?

```bash
-- Metadata (DDL only)
expdp system/password SCHEMAS=HR CONTENT=METADATA_ONLY DUMPFILE=meta.dmp LOGFILE=meta.log

-- Data only (no structure)
expdp system/password SCHEMAS=HR CONTENT=DATA_ONLY DUMPFILE=data.dmp LOGFILE=data.log
```

---

### 🔹 7. **Partitioned Tables**

* Sirf ek partition ya pura table export karna.

```bash
expdp system/password TABLES=emp:part1 DUMPFILE=part.dmp LOGFILE=part.log
```

---

### 🔹 8. **Query-based Export**

* Export sirf filtered data (jaise where condition ke sath):

```bash
expdp system/password TABLES=employees QUERY="WHERE department_id=10" DUMPFILE=query.dmp LOGFILE=query.log
```

---

### 🔹 9. **Parallel Export**

* Performance ke liye multiple processes:

```bash
expdp system/password FULL=Y DUMPFILE=full_%U.dmp LOGFILE=full.log PARALLEL=4
```

> `%U` = multiple dump files banenge: `full_01.dmp`, `full_02.dmp`, etc.

---

### 🔹 10. **Network Mode (Remote Export)**

* Ek server ka export directly dusre pe.

```bash
expdp system/password NETWORK_LINK=remote_db_link SCHEMAS=HR DUMPFILE=remote_hr.dmp LOGFILE=remote.log
```

---

## 📦 Summary Table:

| Export Type      | Option Used               |
| ---------------- | ------------------------- |
| Full DB          | `FULL=Y`                  |
| Schema           | `SCHEMAS=user1,user2`     |
| Tables           | `TABLES=table1,table2`    |
| Tablespaces      | `TABLESPACES=tbs1,tbs2`   |
| Specific objects | `INCLUDE=TABLE,INDEX` etc |
| Data Only        | `CONTENT=DATA_ONLY`       |
| Metadata Only    | `CONTENT=METADATA_ONLY`   |
| Partitioned Data | `TABLES=table:partition`  |
| With Query       | `QUERY="WHERE..."`        |
| Parallel         | `PARALLEL=n`              |

<hr>

> # 🔄 `expdp` (Export Data Pump) aur `impdp` (Import Data Pump) ka use hum Oracle Database me data export/import karne ke liye karte hain.

---

## 🔹 `expdp` se kya-kya export kar sakte hain?

`expdp` command se aap **Oracle database ke objects/data** ko export kar sakte hain:

| Export Type       | Kya Export Karta Hai                     | Example Command                                                                                      |
| ----------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Full Database** | Pure database ka data                    | `expdp system/password FULL=Y DIRECTORY=dpdir DUMPFILE=fulldb.dmp`                                   |
| **Schema**        | Specific user/schema ka data             | `expdp system/password SCHEMAS=HR DIRECTORY=dpdir DUMPFILE=hr.dmp`                                   |
| **Table**         | Specific table(s)                        | `expdp system/password TABLES=HR.EMPLOYEES DIRECTORY=dpdir DUMPFILE=emp.dmp`                         |
| **Tablespace**    | Specific tablespace ke sare objects/data | `expdp system/password TABLESPACES=USERS DIRECTORY=dpdir DUMPFILE=users_ts.dmp`                      |
| **Query Export**  | Filtered rows via SQL query              | `expdp system/password TABLES=EMPLOYEES QUERY="WHERE dept_id=10" DIRECTORY=dpdir DUMPFILE=emp10.dmp` |
| **Metadata Only** | Sirf structure (DDL), bina data ke       | `expdp system/password TABLES=EMPLOYEES CONTENT=METADATA_ONLY DIRECTORY=dpdir DUMPFILE=emp_meta.dmp` |
| **Data Only**     | Sirf data bina table definition          | `expdp system/password TABLES=EMPLOYEES CONTENT=DATA_ONLY DIRECTORY=dpdir DUMPFILE=emp_data.dmp`     |

---

## 🔹 `impdp` se kya-kya import kar sakte hain?

`impdp` se `expdp` se nikla hua data wapas database me import kiya jata hai:

| Import Type             | Kya Import Karta Hai                                 | Example Command                                                                                         |
| ----------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Full Database**       | Pura database ka dump file import karta hai          | `impdp system/password FULL=Y DIRECTORY=dpdir DUMPFILE=fulldb.dmp`                                      |
| **Schema**              | Sirf specified schema import karta hai               | `impdp system/password SCHEMAS=HR DIRECTORY=dpdir DUMPFILE=hr.dmp`                                      |
| **Table**               | Sirf table(s) import karta hai                       | `impdp system/password TABLES=HR.EMPLOYEES DIRECTORY=dpdir DUMPFILE=emp.dmp`                            |
| **Remap Schema**        | Data ko ek schema se doosre schema me daalne ke liye | `impdp system/password SCHEMAS=HR REMAP_SCHEMA=HR:NEWHR DIRECTORY=dpdir DUMPFILE=hr.dmp`                |
| **Remap Tablespace**    | Tablespace change karne ke liye                      | `impdp system/password TABLESPACES=USERS REMAP_TABLESPACE=USERS:NEW_TS DIRECTORY=dpdir DUMPFILE=ts.dmp` |
| **Table Exists Action** | Purane table pe overwrite ya append                  | `impdp system/password TABLES=EMPLOYEES TABLE_EXISTS_ACTION=REPLACE DIRECTORY=dpdir DUMPFILE=emp.dmp`   |

---

## 🔸 Directory Banane ka Command:

```sql
CREATE OR REPLACE DIRECTORY dpdir AS '/u01/backups';
GRANT READ, WRITE ON DIRECTORY dpdir TO system;
```

<hr>

> # **`expdp`** (Export Data Pump) Oracle ka **logical backup tool** hai, iska matlab hai ye **data aur metadata** ka backup banata hai—not the physical datafiles. Chaliye simple Hinglish mein samjhte hain:

---

### 🔍 `expdp` se kya-kya hota hai?

```bash
expdp system/password FULL=Y DIRECTORY=dpdir DUMPFILE=fulldb.dmp
```

#### 🧠 Iska matlab:

* `system/password` → kis user se login kar rahe ho.
* `FULL=Y` → pura database ka logical backup lena hai (all schemas, tables, views, procedures, etc.).
* `DIRECTORY=dpdir` → jahan dump file save hoga (Oracle directory object hona chahiye).
* `DUMPFILE=fulldb.dmp` → dump file ka naam jisme backup jayega.

---

### 📦 Kya Export hota hai?

Ye **Logical backup** hota hai, jisme ye cheezein hoti hain:

| 🔢 Element    | Export hota hai? | Note                                            |
| ------------- | ---------------- | ----------------------------------------------- |
| Tables        | ✅ Yes            | Including rows (unless `CONTENT=METADATA_ONLY`) |
| Views         | ✅ Yes            | As metadata only                                |
| Indexes       | ✅ Yes            | Metadata only                                   |
| Sequences     | ✅ Yes            | Metadata only                                   |
| PL/SQL Code   | ✅ Yes            | Procedures, functions, triggers, packages       |
| Grants/Roles  | ✅ Yes            | Permission details                              |
| Data          | ✅ Yes            | Rows of tables                                  |
| Tablespaces   | ❌ No             | Physical storage info not exported              |
| Datafiles     | ❌ No             | Not included                                    |
| Control Files | ❌ No             | Not included                                    |
| Redo Logs     | ❌ No             | Not included                                    |

---

### 🤔 Logical vs Physical Backup Difference:

| Feature                 | Logical Backup (`expdp`)      | Physical Backup (`RMAN`)                      |
| ----------------------- | ----------------------------- | --------------------------------------------- |
| Type of data            | Data & metadata only          | Actual datafiles, archive logs, control files |
| Speed                   | Slower for large DBs          | Faster and consistent                         |
| Use-case                | Data migration, small backups | Disaster recovery, full restore               |
| Format                  | .dmp file (dump)              | Binary files                                  |
| Partial backup support  | Yes (tables, schemas, etc.)   | Yes                                           |
| Flashback compatibility | No                            | Yes (with archive logs)                       |

---

### 🛠 Real-Life Example:

**Use `expdp` when:**

* Aapko ek schema ya table ka backup lena hai aur dusre server pe import karna hai.
* Production to development data migration karna hai.
* User ne galti se kuch delete kar diya hai, aur logical dump se uss part ko import karna hai.

---

