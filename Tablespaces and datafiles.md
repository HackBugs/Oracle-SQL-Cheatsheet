> # Perfect Shahnwaj bhai 🔥
Aapka requirement bilkul clear hai — **ek naya user create karna hai**, **uske liye tablespace banana hai**, aur **datafile assign karna hai**.
Main aapko **step-by-step + correct SQL commands** de raha hu 👇

```
SELECT name FROM v$datafile;
```
---

## 🧱 **Step 1️⃣: Tablespace Create Karna**

```sql
CREATE TABLESPACE hack01
DATAFILE '/u01/app/oracle/oradata/orcl/hack01.dbf'
SIZE 500M
AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
```

### 🧠 Explanation:

* `hack01` → tablespace ka naam
* `hack01.dbf` → physical file jisme data store hoga
* `SIZE 500M` → starting size
* `AUTOEXTEND` → file automatically badhta rahega jab full ho jaye

---

## 👤 **Step 2️⃣: User Create Karna**

```sql
CREATE USER hack IDENTIFIED BY hack
DEFAULT TABLESPACE hack01
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON hack01;
```

### 🧠 Explanation:

* `hack` → username
* `IDENTIFIED BY hack` → password
* `DEFAULT TABLESPACE hack01` → user ka data `hack01` tablespace me jayega
* `TEMPORARY TABLESPACE temp` → sorting operations ke liye
* `QUOTA UNLIMITED ON hack01` → user ko space limit nahi

---

## 🔑 **Step 3️⃣: User Ko Permission Dena**

```sql
GRANT CONNECT, RESOURCE TO hack;
```

### 🧠 Explanation:

* `CONNECT` → user ko login karne ki permission deta hai
* `RESOURCE` → user ko apna tables, indexes, etc. banane ki permission deta hai

---

## ✅ **Final Output**

Ab user `hack` ready hai —

* Uska apna **tablespace hack01** hai
* Uske andar ek **datafile hack01.dbf** hai
* User login karke apna data manage kar sakta hai

---

## 🔍 **Optional Verification Commands**

1️⃣ Check user:

```sql
SELECT username, default_tablespace FROM dba_users WHERE username='HACK';
```

2️⃣ Check tablespace:

```sql
SELECT tablespace_name, file_name, bytes/1024/1024 AS size_MB FROM dba_data_files WHERE tablespace_name='HACK01';
```
<hr>

> # Perfect Shahnwaj bhai 😎
Yahan mai aapke liye **full setup + rollback commands** likh raha hu — ready-to-use, step by step.

---

# **1️⃣ Create Tablespace, User, Datafile**

```sql
-- Step 1: Create Tablespace
CREATE TABLESPACE hack01
DATAFILE '/u01/app/oracle/oradata/orcl/hack01.dbf'
SIZE 500M
AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;

-- Step 2: Create User
CREATE USER hack IDENTIFIED BY hack
DEFAULT TABLESPACE hack01
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON hack01;

-- Step 3: Grant Permissions
GRANT CONNECT, RESOURCE TO hack;
```

### ✅ Explanation:

* Tablespace = hack01 → data store location
* Datafile = hack01.dbf → physical file
* User = hack → login & manage tables
* TEMP tablespace = temp → sorting operations
* QUOTA UNLIMITED → space limit nahi

---

# **2️⃣ Verification Commands**

```sql
-- Check user info
SELECT username, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username='HACK';

-- Check tablespace and datafile
SELECT tablespace_name, file_name, bytes/1024/1024 AS size_MB
FROM dba_data_files
WHERE tablespace_name='HACK01';
```

---

# **3️⃣ Rollback / Drop Commands (Cleanup)**

```sql
-- Step 1: Drop user
DROP USER hack CASCADE;

-- Step 2: Drop tablespace (including datafile)
DROP TABLESPACE hack01 INCLUDING CONTENTS AND DATAFILES;
```

### 🧠 Notes:

* `CASCADE` → user ke saare objects delete kar dega
* `INCLUDING CONTENTS AND DATAFILES` → tablespace ke andar saara data aur physical file bhi delete ho jayega

---

💡 **Tip:**

* Test environment me pehle create karo, verify karo, phir production me use karo
* Datafile ka path apne environment ke hisaab se adjust karo (`/u01/app/oracle/oradata/orcl/`)

<hr>

> # Tablespace, datafile, aur user creation ke commands me chhoti chhoti galtiyaan aur confusion clear kar lete hain step-by-step 👇

---

## 💾 1️⃣ **CREATE TABLESPACE**

### ❌ Aapka likha:

```sql
create tablespce hack01 datafile 'hack01.dbf' size 100mb auto extend on next 500 mb maxsize unlimited
```

### ✅ Correct syntax:

```sql
CREATE TABLESPACE hack01
DATAFILE '/u01/app/oracle/oradata/orcl/hack01.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 500M MAXSIZE UNLIMITED;
```

### 🧠 Explanation:

* `CREATE TABLESPACE hack01` → tablespace ka naam
* `DATAFILE` → file ka location & name
* `SIZE 100M` → initial size
* `AUTOEXTEND ON NEXT 500M` → jab full ho jaye to 500MB aur badhe
* `MAXSIZE UNLIMITED` → koi limit nahi

🟢 **Purpose:** Naya tablespace banata hai jisme user ka data store hoga.

---

## 👤 2️⃣ **CREATE USER**

### ❌ Aapka likha:

```sql
create user hack indentifed by hack defult tablesapce hack temprary tablespce temp qouta unlimted on user
```

### ✅ Correct syntax:

```sql
CREATE USER hack IDENTIFIED BY hack
DEFAULT TABLESPACE hack01
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON hack01;
```

### 🧠 Explanation:

* `CREATE USER hack IDENTIFIED BY hack` → user create with password
* `DEFAULT TABLESPACE hack01` → jisme user ke tables store honge
* `TEMPORARY TABLESPACE temp` → sort/temporary operations ke liye
* `QUOTA UNLIMITED ON hack01` → user ko tablespace me unlimited space allow

🟢 **Purpose:** Naya Oracle user create karta hai aur uske data store location define karta hai.

---

## ⚙️ 3️⃣ **ALTER DATABASE DATAFILE RESIZE**

### ❌ Aapka likha:

```sql
alter database datafile /path/.dbf resize 32 gb;
```

### ✅ Correct syntax:

```sql
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/orcl/hack01.dbf' RESIZE 32G;
```

### 🧠 Explanation:

* Existing datafile ka size badhata hai (resize).
  🟢 **Purpose:** Jab datafile full ho jaye, size increase karne ke liye use hota hai.

---

## 📂 4️⃣ **ALTER TABLESPACE ADD DATAFILE**

### ❌ Aapka likha:

```sql
alter tablespce hack01 add databfile /path/.dbf size 32gb
```

### ✅ Correct syntax:

```sql
ALTER TABLESPACE hack01
ADD DATAFILE '/u01/app/oracle/oradata/orcl/hack02.dbf'
SIZE 32G;
```

### 🧠 Explanation:

* Tablespace `hack01` me ek naya datafile add karta hai.
  🟢 **Purpose:** Jab tablespace me jagah kam ho, naya file add karke expand karte hain.

---

## 🧱 5️⃣ **ALTER DATABASE ADD DATAFILE**

### ❌ Aapka likha:

```sql
alter dabase add datafile /path/.dbf size 32 gb
```

### ✅ Correct syntax:

```sql
ALTER DATABASE
ADD DATAFILE '/u01/app/oracle/oradata/orcl/hack03.dbf'
SIZE 32G;
```

### 🧠 Explanation:

* Ye **database level** command hai (tablespace specify nahi hota).
* Oracle automatically decide karta hai kis tablespace me ye datafile add hoga (agar system tablespace ka part ho).

🟢 **Purpose:** Generally SYSTEM ya SYSAUX tablespaces me new datafile add karne ke liye use hota hai.

---

## 🔍 **6️⃣ Summary Table**

| Command                              | Purpose                                            | Example                                                                |
| ------------------------------------ | -------------------------------------------------- | ---------------------------------------------------------------------- |
| `CREATE TABLESPACE`                  | Naya tablespace create karne ke liye               | `CREATE TABLESPACE hack01 DATAFILE '/u01/.../hack01.dbf' SIZE 100M;`   |
| `CREATE USER`                        | Naya database user banane ke liye                  | `CREATE USER hack IDENTIFIED BY hack DEFAULT TABLESPACE hack01;`       |
| `ALTER DATABASE DATAFILE ... RESIZE` | Existing datafile ka size badhane ke liye          | `ALTER DATABASE DATAFILE '/u01/.../hack01.dbf' RESIZE 32G;`            |
| `ALTER TABLESPACE ADD DATAFILE`      | Tablespace me naya datafile add karne ke liye      | `ALTER TABLESPACE hack01 ADD DATAFILE '/u01/.../hack02.dbf' SIZE 32G;` |
| `ALTER DATABASE ADD DATAFILE`        | Database-level datafile add (system/special cases) | `ALTER DATABASE ADD DATAFILE '/u01/.../hack03.dbf' SIZE 32G;`          |

---

* Create / Alter / Resize / Add commands
* Error examples (ORA-01653, ORA-01659 etc.)
* Real production use-cases
