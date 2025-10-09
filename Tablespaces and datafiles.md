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
