# 1. **OEM (Oracle Enterprise Manager)** me **SQL Monitoring** ke liye queries practice karna chahte ho – toh main aapko **intentionally slow aur resource-consuming SQL queries** dunga jo **SQL Monitor** me dikhenge.

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

<hr>

# 2. **dummy tables ke saath join-heavy aur aggregation-heavy advanced SQL queries** dunga — ye sab OEM me **SQL Monitor** tab me definitely dikhenge agar aap Oracle Enterprise Manager ya Cloud Control use kar rahe ho.

---

## 🏗️ Step 1: Dummy Tables Bana Lo (Base for Practice)

### 🔹 Table 1: `employees`

```sql
CREATE TABLE employees AS
SELECT
  ROWNUM AS emp_id,
  'Emp_' || ROWNUM AS emp_name,
  MOD(ROWNUM, 10) + 1 AS dept_id,
  TRUNC(DBMS_RANDOM.VALUE(30000, 100000)) AS salary,
  TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 1000)) AS hire_date
FROM all_objects
WHERE ROWNUM <= 100000;
```

---

### 🔹 Table 2: `departments`

```sql
CREATE TABLE departments AS
SELECT
  LEVEL AS dept_id,
  'Dept_' || LEVEL AS dept_name,
  'Location_' || MOD(LEVEL, 5) AS location
FROM dual
CONNECT BY LEVEL <= 20;
```

---

## ✅ OEM Monitor Friendly Advanced SQL Queries

---

### 🔸 1. **JOIN + AGGREGATION (Group By Department)**

```sql
SELECT d.dept_name, COUNT(e.emp_id) AS total_emps, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;
```

> Ye query join + aggregation karti hai — **SQL Monitor tab me dikhegi**.

---

### 🔸 2. **Nested Aggregation + Subquery**

```sql
SELECT dept_id, MAX(avg_sal) AS max_avg_salary
FROM (
  SELECT dept_id, TRUNC(AVG(salary)) AS avg_sal
  FROM employees
  GROUP BY dept_id
)
GROUP BY dept_id;
```

---

### 🔸 3. **Complex Join + Filter**

```sql
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > (
  SELECT AVG(salary)
  FROM employees
)
AND d.location = 'Location_2';
```

---

### 🔸 4. **Self Join (Heavy Join on Employees)**

```sql
SELECT a.emp_id AS emp1, b.emp_id AS emp2, a.salary - b.salary AS salary_diff
FROM employees a
JOIN employees b ON a.dept_id = b.dept_id
WHERE a.emp_id < 1000 AND b.emp_id < 1000;
```

> Self join zyada heavy lagta hai SQL monitor ke liye — esp. agar rows > 10k ho.

---

### 🔸 5. **Window Function (Analytics Function)**

```sql
SELECT emp_id, emp_name, dept_id, salary,
       RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees
WHERE dept_id <= 10;
```

---

### 🔸 6. **Join + Aggregation + Order By**

```sql
SELECT d.dept_name, COUNT(*) AS emp_count
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY emp_count DESC;
```

---

## 🧠 OEM me Monitor kaise karoge:

* `Performance → SQL Monitoring` → dekho running ya recently executed queries
* Ya query ke `sql_id` se check karo:

```sql
SELECT sql_id, status, sql_text FROM v$sql_monitor WHERE status = 'EXECUTING';
```

---

Agar chaho to main in queries ko **stored procedures** ya **PL/SQL block** me daal ke aur bhi advanced practice ke liye ready kar sakta hoon.

<hr>

# 3. Bahut badiya! Ab main aapko wahi join-heavy aur aggregation-heavy queries ko **Stored Procedures** aur **PL/SQL blocks** ke form me dunga — taaki aap:

✅ Oracle SQL Monitor me unhe **track kar pao**
✅ PL/SQL ka bhi real-world **practice kar sako**
✅ Procedures ko baar-baar run karke performance observe kar sako

---

## 🔷 Step-by-Step: Stored Procedure + Monitoring Practice

---

### ✅ Step 1: Stored Procedure — `analyze_department_salaries`

```sql
CREATE OR REPLACE PROCEDURE analyze_department_salaries AS
BEGIN
  FOR rec IN (
    SELECT d.dept_name, COUNT(e.emp_id) AS total_emps, ROUND(AVG(e.salary), 2) AS avg_salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('Dept: ' || rec.dept_name || ' | Total: ' || rec.total_emps || ' | Avg: ' || rec.avg_salary);
  END LOOP;
END;
/
```

**Run it:**

```sql
EXEC analyze_department_salaries;
```

---

### ✅ Step 2: Stored Procedure — `compare_employee_salaries`

```sql
CREATE OR REPLACE PROCEDURE compare_employee_salaries AS
BEGIN
  FOR rec IN (
    SELECT a.emp_id AS emp1, b.emp_id AS emp2, a.salary - b.salary AS diff
    FROM employees a
    JOIN employees b ON a.dept_id = b.dept_id
    WHERE a.emp_id < 500 AND b.emp_id < 500
  )
  LOOP
    NULL; -- processing logic, ya DBMS_OUTPUT.PUT_LINE bhi use kar sakte ho
  END LOOP;
END;
/
```

**Run it:**

```sql
EXEC compare_employee_salaries;
```

---

### ✅ Step 3: Stored Procedure — `rank_employees_by_dept`

```sql
CREATE OR REPLACE PROCEDURE rank_employees_by_dept AS
BEGIN
  FOR rec IN (
    SELECT emp_id, emp_name, dept_id, salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
    FROM employees
    WHERE dept_id <= 10
  )
  LOOP
    NULL; -- Output suppress to increase runtime for monitoring
  END LOOP;
END;
/
```

**Run it:**

```sql
EXEC rank_employees_by_dept;
```

---

## ✅ Optional: Add Wait/Delay for Slowness (For Monitoring Trigger)

```sql
-- Add in any loop for delay
DBMS_LOCK.SLEEP(0.1);  -- 0.1 second delay per loop
```

Example:

```sql
FOR rec IN (...) LOOP
  DBMS_LOCK.SLEEP(0.01);
END LOOP;
```

---

## 🔎 OEM Monitoring Tips:

* Run procedures from `sqlplus`, `SQL Developer`, or any tool
* Go to **Enterprise Manager → Performance → SQL Monitoring**
* Look for your SQL (especially if it runs > 5 seconds or uses lots of CPU)
* Use:

```sql
SELECT sql_id, status, sql_text FROM v$sql_monitor WHERE status = 'EXECUTING';
```

---

## 🔧 Bonus: Procedure to Insert Logs (for real practice)

```sql
CREATE OR REPLACE PROCEDURE log_department_summary AS
BEGIN
  INSERT INTO dept_summary_log (dept_name, emp_count, avg_salary)
  SELECT d.dept_name, COUNT(e.emp_id), ROUND(AVG(e.salary), 2)
  FROM employees e
  JOIN departments d ON e.dept_id = d.dept_id
  GROUP BY d.dept_name;

  COMMIT;
END;
/
```

> Assume `dept_summary_log` is a custom log table you create.

---

Aap chahein toh main `PL/SQL package`, `function`, ya `parallel execution` versions bhi bana sakta hoon for monitoring practice.


