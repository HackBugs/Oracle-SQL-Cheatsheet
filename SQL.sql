-- Original Records
CREATE TABLE employees (
    emp_id      NUMBER PRIMARY KEY,
    emp_name    VARCHAR2(50),
    department  VARCHAR2(30),
    salary      NUMBER(10, 2),
    hire_date   DATE,
    email       VARCHAR2(100) UNIQUE
);

INSERT INTO employees VALUES (101, 'Amit Sharma', 'IT',       60000, TO_DATE('2019-04-15', 'YYYY-MM-DD'), 'amit.sharma@abc.com');
INSERT INTO employees VALUES (102, 'Ravi Kumar',  'HR',       45000, TO_DATE('2020-06-20', 'YYYY-MM-DD'), 'ravi.kumar@abc.com');
INSERT INTO employees VALUES (103, 'Neha Singh', 'Finance',   55000, TO_DATE('2018-01-10', 'YYYY-MM-DD'), 'neha.singh@abc.com');
INSERT INTO employees VALUES (104, 'Preeti Jain','IT',        62000, TO_DATE('2021-03-05', 'YYYY-MM-DD'), 'preeti.jain@abc.com');
INSERT INTO employees VALUES (105, 'Suresh Mehta','Marketing',48000, TO_DATE('2017-11-23', 'YYYY-MM-DD'), 'suresh.mehta@abc.com');

-- Duplicates
INSERT INTO employees VALUES (106, 'Amit Sharma', 'IT',       61000, TO_DATE('2022-02-18', 'YYYY-MM-DD'), 'amit.sharma2@abc.com');
INSERT INTO employees VALUES (107, 'Ravi Kumar',  'HR',       46000, TO_DATE('2023-01-12', 'YYYY-MM-DD'), 'ravi.kumar2@abc.com');
INSERT INTO employees VALUES (108, 'Neha Singh',  'Finance',  56000, TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'neha.singh2@abc.com');

SELECT * from employees;

SELECT NAME, OPEN_MODE, CON_ID FROM V$PDBS;
SELECT NAME FROM V$PDBS;

ALTER PLUGGABLE DATABASE PDB1 OPEN;
ALTER SESSION SET CONTAINER = PDB1;
ALTER USER hr IDENTIFIED BY hr ACCOUNT UNLOCK;

CREATE USER hr IDENTIFIED BY hr;
GRANT CONNECT, RESOURCE TO hr;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO hr;

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'HR';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'HR';
SELECT username, account_status FROM dba_users WHERE username = 'HR';

SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;


SHOW CON_NAME;
SHOW PDBS;
ALTER SESSION SET CONTAINER = PDB1;

CREATE USER hr IDENTIFIED BY hr;
GRANT CONNECT, RESOURCE TO hr;
ALTER USER hr ACCOUNT UNLOCK;

---

Zaroor! Niche ek **SQL Important Topics + Queries Sheet** diya gaya hai jo interview ke liye bahut kaam aayega. Yeh sheet **theory + practical queries** dono cover karta hai.

---

## 📘 **SQL Interview Preparation Sheet**

| 🔢 Sr | 🧠 **Topic**                         | 📄 **Important Concepts**                         | 💻 **Common Queries (Examples)**                                                                       |
| ----- | ------------------------------------ | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| 1     | **Database Basics**                  | Table, Row, Column, Primary Key, Foreign Key      | `CREATE DATABASE mydb;`<br>`USE mydb;`                                                                 |
| 2     | **DDL (Data Definition Language)**   | CREATE, ALTER, DROP, TRUNCATE                     | `CREATE TABLE emp (id INT, name VARCHAR(50));`<br>`ALTER TABLE emp ADD salary INT;`                    |
| 3     | **DML (Data Manipulation Language)** | INSERT, UPDATE, DELETE                            | `INSERT INTO emp VALUES (1, 'Amit', 20000);`<br>`UPDATE emp SET salary = 25000 WHERE id = 1;`          |
| 4     | **DQL (Data Query Language)**        | SELECT                                            | `SELECT * FROM emp;`<br>`SELECT name FROM emp WHERE salary > 20000;`                                   |
| 5     | **WHERE Clause**                     | Filtering rows                                    | `SELECT * FROM emp WHERE department = 'IT';`                                                           |
| 6     | **Operators**                        | `=, !=, >, <, AND, OR, IN, BETWEEN, LIKE`         | `SELECT * FROM emp WHERE salary BETWEEN 10000 AND 30000;`<br>`SELECT * FROM emp WHERE name LIKE 'A%';` |
| 7     | **ORDER BY & GROUP BY**              | Sorting & Aggregating                             | `SELECT * FROM emp ORDER BY salary DESC;`<br>`SELECT dept, COUNT(*) FROM emp GROUP BY dept;`           |
| 8     | **Joins**                            | INNER, LEFT, RIGHT, FULL                          | `SELECT e.name, d.dept_name FROM emp e JOIN dept d ON e.dept_id = d.id;`                               |
| 9     | **Aggregate Functions**              | COUNT, SUM, AVG, MAX, MIN                         | `SELECT AVG(salary) FROM emp;`<br>`SELECT dept, MAX(salary) FROM emp GROUP BY dept;`                   |
| 10    | **Subqueries**                       | Nested queries                                    | `SELECT name FROM emp WHERE salary = (SELECT MAX(salary) FROM emp);`                                   |
| 11    | **UNION vs UNION ALL**               | Combining Results                                 | `SELECT name FROM emp1 UNION SELECT name FROM emp2;`                                                   |
| 12    | **Constraints**                      | NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK | `CREATE TABLE emp (id INT PRIMARY KEY, salary INT CHECK (salary > 0));`                                |
| 13    | **Normalization**                    | 1NF, 2NF, 3NF (Basic theory)                      | — (Theory based)                                                                                       |
| 14    | **Indexes**                          | Speed up searching                                | `CREATE INDEX idx_name ON emp(name);`                                                                  |
| 15    | **Views**                            | Virtual tables                                    | `CREATE VIEW emp_view AS SELECT name, salary FROM emp;`                                                |
| 16    | **Stored Procedures**                | Reusable SQL code block                           | `CREATE PROCEDURE GetEmp() BEGIN SELECT * FROM emp; END;`                                              |
| 17    | **Triggers**                         | Auto-execution on events                          | `CREATE TRIGGER trg BEFORE INSERT ON emp FOR EACH ROW SET NEW.created_at = NOW();`                     |
| 18    | **Transactions**                     | BEGIN, COMMIT, ROLLBACK                           | `BEGIN; UPDATE emp SET salary = 50000 WHERE id = 1; COMMIT;`                                           |
| 19    | **CASE Statement**                   | IF-ELSE Logic in SQL                              | `SELECT name, CASE WHEN salary > 30000 THEN 'High' ELSE 'Low' END AS category FROM emp;`               |
| 20    | **Date Functions**                   | NOW(), CURDATE(), DATEDIFF(), etc.                | `SELECT name FROM emp WHERE hire_date < CURDATE();`                                                    |

---

### 📁 **Extra Practice Queries:**

1. **Find second highest salary:**

   ```sql
   SELECT MAX(salary) FROM emp WHERE salary < (SELECT MAX(salary) FROM emp);
   ```

2. **Count employees in each department:**

   ```sql
   SELECT department, COUNT(*) FROM emp GROUP BY department;
   ```

3. **Delete duplicate records:**

   ```sql
   DELETE FROM emp WHERE id NOT IN (
     SELECT MIN(id) FROM emp GROUP BY name, salary
   );
   ```

4. **Find employees who joined in last 30 days:**

   ```sql
   SELECT * FROM emp WHERE hire_date >= CURDATE() - INTERVAL 30 DAY;
   ```

5. **Update salary by 10% for all:**

   ```sql
   UPDATE emp SET salary = salary * 1.10;
   ```

---


Shandar! Aapka request bilkul sahi hai — **interview ke liye SQL ka ek full sheet chahiye** jisme:

✅ Clauses
✅ Operators
✅ Aggregate Functions
✅ DISTINCT
✅ Data Types
✅ Aur baki sab essential cheezein — from **Basic to Advanced**

---

## ✅ **Complete SQL Sheet for Interviews (With Examples)**

---

### 🟢 **1. SQL Clauses (Rules/Laws in Query)**

| Clause     | Use                                 | Example                                |
| ---------- | ----------------------------------- | -------------------------------------- |
| `SELECT`   | Columns choose karne ke liye        | `SELECT name, salary FROM emp;`        |
| `FROM`     | Kis table se data lena hai          | `FROM emp`                             |
| `WHERE`    | Filter karne ke liye                | `WHERE salary > 20000`                 |
| `GROUP BY` | Group banana hai column ke basis pe | `GROUP BY department`                  |
| `HAVING`   | Filter karna groups ke liye         | `HAVING COUNT(*) > 1`                  |
| `ORDER BY` | Sort karna ascending/descending     | `ORDER BY salary DESC`                 |
| `LIMIT`    | Rows limit karna (MySQL)            | `LIMIT 5`                              |
| `OFFSET`   | Rows skip karna                     | `OFFSET 10`                            |
| `DISTINCT` | Unique records chahiye              | `SELECT DISTINCT department FROM emp;` |

---

### 🟢 **2. SQL Operators**

#### 🔹 **Comparison Operators**

| Operator    | Use                              | Example           |
| ----------- | -------------------------------- | ----------------- |
| `=`         | Equals                           | `salary = 20000`  |
| `!=` / `<>` | Not equal                        | `salary != 20000` |
| `>` / `<`   | Greater / Less than              | `salary > 10000`  |
| `>=` / `<=` | Greater or equal / Less or equal | `salary >= 15000` |

#### 🔹 **Logical Operators**

| Operator | Use                    | Example                          |
| -------- | ---------------------- | -------------------------------- |
| `AND`    | Both conditions true   | `salary > 20000 AND dept = 'IT'` |
| `OR`     | Any one condition true | `dept = 'IT' OR dept = 'HR'`     |
| `NOT`    | Negation               | `NOT salary = 10000`             |

#### 🔹 **Other Operators**

| Operator  | Use             | Example                          |
| --------- | --------------- | -------------------------------- |
| `IN`      | Multiple values | `WHERE dept IN ('IT', 'HR')`     |
| `BETWEEN` | Range           | `salary BETWEEN 20000 AND 50000` |
| `LIKE`    | Pattern search  | `name LIKE 'A%'`                 |
| `IS NULL` | NULL check      | `WHERE bonus IS NULL`            |

---

### 🟢 **3. Aggregate Functions**

| Function  | Description          | Example                        |
| --------- | -------------------- | ------------------------------ |
| `COUNT()` | Total number of rows | `SELECT COUNT(*) FROM emp;`    |
| `SUM()`   | Total sum            | `SELECT SUM(salary) FROM emp;` |
| `AVG()`   | Average value        | `SELECT AVG(salary) FROM emp;` |
| `MAX()`   | Highest value        | `SELECT MAX(salary) FROM emp;` |
| `MIN()`   | Lowest value         | `SELECT MIN(salary) FROM emp;` |

---

### 🟢 **4. SQL Data Types (MySQL)**

| Type           | Use            | Example               |
| -------------- | -------------- | --------------------- |
| `INT`          | Integer number | `age INT`             |
| `VARCHAR(n)`   | String (text)  | `name VARCHAR(50)`    |
| `TEXT`         | Long text      | `description TEXT`    |
| `DATE`         | Only date      | `hire_date DATE`      |
| `DATETIME`     | Date + time    | `created_at DATETIME` |
| `BOOLEAN`      | True/False     | `is_active BOOLEAN`   |
| `DECIMAL(p,s)` | Decimal number | `price DECIMAL(10,2)` |

---

### 🟢 **5. SQL Table Creation**

```sql
CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50),
  department VARCHAR(30),
  salary INT,
  hire_date DATE
);
```

---

### 🟢 **6. SQL Joins**

| Join Type         | Use                      | Example                                                      |
| ----------------- | ------------------------ | ------------------------------------------------------------ |
| `INNER JOIN`      | Common records           | `SELECT * FROM emp e INNER JOIN dept d ON e.dept_id = d.id;` |
| `LEFT JOIN`       | All left + matched right | `LEFT JOIN dept d ON e.dept_id = d.id;`                      |
| `RIGHT JOIN`      | All right + matched left | `RIGHT JOIN dept d ON e.dept_id = d.id;`                     |
| `FULL OUTER JOIN` | All records from both    | *MySQL me direct support nahi*                               |

---

### 🟢 **7. SQL Subquery Examples**

```sql
-- Highest salary
SELECT MAX(salary) FROM emp;

-- Name of highest paid employee
SELECT name FROM emp
WHERE salary = (SELECT MAX(salary) FROM emp);
```

---

### 🟢 **8. SQL Constraints**

| Constraint    | Use                     | Example                                                  |
| ------------- | ----------------------- | -------------------------------------------------------- |
| `PRIMARY KEY` | Unique + Not Null       | `emp_id INT PRIMARY KEY`                                 |
| `FOREIGN KEY` | Link with another table | `dept_id INT, FOREIGN KEY (dept_id) REFERENCES dept(id)` |
| `UNIQUE`      | Only unique values      | `email VARCHAR(100) UNIQUE`                              |
| `NOT NULL`    | Cannot be empty         | `name VARCHAR(50) NOT NULL`                              |
| `CHECK`       | Condition               | `salary INT CHECK (salary > 0)`                          |
| `DEFAULT`     | Default value           | `is_active BOOLEAN DEFAULT TRUE`                         |

---

### 🟢 **9. Other Important Topics**

| Topic                | Description                       | Example                                                                                         |
| -------------------- | --------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Index**            | Speed up search                   | `CREATE INDEX idx_name ON emp(name);`                                                           |
| **View**             | Virtual table                     | `CREATE VIEW emp_view AS SELECT name, salary FROM emp;`                                         |
| **Stored Procedure** | Reusable function                 | `CREATE PROCEDURE GetAllEmp() BEGIN SELECT * FROM emp; END;`                                    |
| **Trigger**          | Auto action on insert/update      | `CREATE TRIGGER before_insert_emp BEFORE INSERT ON emp FOR EACH ROW SET NEW.hire_date = NOW();` |
| **Transaction**      | Rollback, commit group of queries | `BEGIN; UPDATE ...; COMMIT;`                                                                    |

---

## ✅ Bonus: SQL Practice Questions for Interviews

1. Find second highest salary:

```sql
SELECT MAX(salary) FROM emp WHERE salary < (SELECT MAX(salary) FROM emp);
```

2. Show number of employees in each department:

```sql
SELECT department, COUNT(*) FROM emp GROUP BY department;
```

3. Delete duplicate rows:

```sql
DELETE FROM emp WHERE id NOT IN (
  SELECT MIN(id) FROM emp GROUP BY name, salary
);
```

4. Top 5 highest paid employees:

```sql
SELECT * FROM emp ORDER BY salary DESC LIMIT 5;
```

---

Bilkul! Niche sabhi headings ka **clean and clear list** de raha hoon jo ab tak ke SQL full interview sheet me cover kiye gaye hain:

---

## 📋 **List of All SQL Topics / Headings Covered**

1. SQL Clauses
2. SQL Operators
3. Aggregate Functions
4. DISTINCT Keyword
5. SQL Data Types
6. SQL Table Creation
7. SQL Joins
8. SQL Subqueries
9. SQL Constraints
10. SQL Index
11. SQL View
12. Stored Procedures
13. Triggers
14. Transactions (BEGIN, COMMIT, ROLLBACK)
15. SQL Practice Questions (Interview-based)

---
