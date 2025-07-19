# **OEM (Oracle Enterprise Manager)** me **SQL Monitoring** ke liye queries practice karna chahte ho – toh main aapko **intentionally slow aur resource-consuming SQL queries** dunga jo **SQL Monitor** me dikhenge.

OEM me koi SQL tab monitor hoti hai jab:

* Query thoda time leti hai ya
* Zyada rows process karti hai ya
* Parallel execution ya full table scan hota hai

---

## ✅ Queries for SQL Monitoring Practice

### 🔹 1. **Slow Full Table Scan**

```sql
SELECT *
FROM all_objects
WHERE object_name LIKE '%A%';
```

> Ye query `ALL_OBJECTS` view pe full scan karti hai.

---

### 🔹 2. **Cartesian Join (Heavy CPU Use)**

```sql
SELECT a.object_name, b.object_name
FROM all_objects a, all_objects b
WHERE a.object_type = 'TABLE'
AND b.object_type = 'INDEX';
```

> Ye `all_objects` ko `all_objects` se cross join karta hai, jo monitoring me easily dikhega.

---

### 🔹 3. **Hash Join + Filtering**

```sql
SELECT a.owner, a.object_name, b.object_name
FROM all_objects a
JOIN all_objects b ON a.owner = b.owner
WHERE a.object_type = 'TABLE'
AND b.object_type = 'VIEW';
```

> Ye join + filter ke combination se monitor trigger karega.

---

### 🔹 4. **Parallel Query** (agar system allow kare)

```sql
SELECT /*+ parallel(4) */ *
FROM all_objects
WHERE object_id IS NOT NULL;
```

> Parallel hint ke saath query chalane se OEM SQL Monitor me jaldi dikhta hai.

---

### 🔹 5. **PL/SQL Block with Delay**

```sql
BEGIN
  FOR i IN 1..100000 LOOP
    NULL;
  END LOOP;
END;
```

> PL/SQL anonymous block me loop daal ke time increase kiya gaya hai.

---

### 🔹 6. **Create Dummy Table and Do Full Scan**

```sql
-- Step 1: Dummy table create karo
CREATE TABLE dummy_data AS
SELECT * FROM all_objects;

-- Step 2: Query for monitoring
SELECT COUNT(*) FROM dummy_data WHERE object_name LIKE '%X%';
```

---

## 🧠 Check Monitoring in OEM:

1. Open Oracle Enterprise Manager
2. Go to **Performance → SQL Monitoring**
3. Filter by your user/session or time
4. Aapko above queries show ho jaayengi

---

### 🧪 Tip for best results:

* Query **5 seconds se zyada chale** toh monitoring tab me dikhti hai
* `v$sql_monitor` view se bhi query status check kar sakte ho:

```sql
SELECT sql_id, status, sql_text
FROM v$sql_monitor
WHERE status = 'EXECUTING';
```

---

Agar chaho toh main ek dummy table ke saath aur bhi join-heavy ya aggregation-heavy queries de sakta ho for advanced practice.

Batao aur chahiye toh!
