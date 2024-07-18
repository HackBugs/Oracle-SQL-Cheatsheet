## Oracle-Cheatsheet
- Author : HackBugs , Shahnwaj Aalam
**ORACLE OBA ADMIN - SHEAT SHEET**
- https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/V-SESSION.html#GUID-28E2DC75-E157-4C0A-94AB-117C205789B9
---

**RMAN Backup:**
- Consistent backup: Cold backup - when database is offline
- Inconsistent backup: Hot backup - when database is online
- Full backup: All data backed up
- Incremental backup: Daily backup

**Database Utility:**
1. Day to day tasks and queries of Oracle Database
2. Overview of SQL Statements

**Oracle Documentation:**
- v$session: [Oracle Database Release 19 Database Reference](https://docs.oracle.com/en/database/oracle/oracle-database/19/refrn/V$SESSION.html#GUID-28E2DC75-E157-4C0A-94AB-117C205789B9)

**Data Guard:**
- Standby: Clone of production database called standby
- 3 types of standby:
  - Physical: Block by block copy of primary database
  - Logical: Not same replica, used for analysis
  - Snapshot: Used for testing, create restore points using DML

**Miscellaneous:**
- TNS: Transparent Network Substrate
- Rack: One database, multiple instances
- ASM: Automatic Storage Management
- Patching: Program to resolve bugs and vulnerabilities
- Tablespace: Logical container, default block size 8KB

**RMAN Commands:**
- Report schema: `RMAN> report schema;`
- List backup: `RMAN> list backup;`
- Full backup, Incremental backup: Both consistent (offline) and inconsistent (online)

**Oracle Export/Import:**
- Data Pump Directory: Create at OS and database level
- Schema, table, row level exports and imports
- Network Import using Data Pump over DB link

**Roles, User, Profile Management:**
- User management commands: `create user`, `alter user`, `drop user`
- Role creation and privilege assignment
- Profile management: Password and resource management

**Data Pump Performance Tuning:**
- Use `DIRECT=y` and `PARALLEL` parameters for faster performance
- Schedule exports using crontab

**Export-Import Utility:**
- Physical backup, cloning of database, restore and recover
- Logical backup using export/import utilities

**Script Examples:**
- Schedule Data Pump Export in crontab
- Data Pump PAR file example

This sheet covers essential commands, backup strategies, and user management in Oracle Database Administration.

---

# Oracle DBA Admin - Cheat Sheet

## RMAN Backup

- **Consistent backup** (Cold backup): when the database is offline
- **Inconsistent backup** (Hot backup): when the database is online
- **Full backup**: all data backup
- **Incremental backup**: day-by-day backup

## Database Utility

- **Day-to-day tasks and queries of Oracle Database**
- **Overview of SQL Statements**

### Oracle Site
- **v$session**: [Oracle Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/)

### SQL Commands
- `cl scr`: clear SQL terminal

## Data Guard
- **Standby**: Clone of the production database
  - **Types of standby**:
    - **Physical**: block-by-block copy of the primary database
    - **Logical**: not the same replica, used for analysis (separate DB ID)
    - **Snapshot**: used for testing applications with flashback and restore point using DML

## DB Link
- **DB Link**: Access and manipulate objects on a remote database
- **TNS**: Transparent Network Substrate - `TNSNAMES.ORA`

## RAC and ASM
- **RAC**: One database with multiple instances
- **ASM**: Automatic Storage Management
- **Patching**: Program to resolve software bugs, vulnerabilities, and problems

## SQL Commands

```sql
show user;
conn / as sysdba;
conn username;
```

### Tablespace

- **Logical container**
- Extents > Tablespace > Segments > Extents > Data blocks

### Tablespace Quota

```sql
create user username identified by password;
grant ...
```

### SQL for System Info

```sh
set linesize ...
set oracle_sid=orcl
SQL> archive log list;
```

### Unix Commands

```sh
id
uptime
lsnrctl status
cat /etc/hostname
cat /etc/oratab
cat /tmp/init.ora
ps -ef | grep pmon
ps -ef | grep ora
. oraenv
sqlplus / as sysdba
startup
```

### User and Privileges

```sql
select username from all_users;
alter user username identified by password;
grant dba to system;
```

### Descriptions

```sql
desc dba_tables;
desc v$database;
desc v$tablespace;
desc v$datafile;
desc v$controlfile;
desc v$logfile;
desc v$session;
desc v$processes;
desc v$instance;
desc v$bgprocess;
```

### Sysdba Permissions

```sql
select * from v$pwfile_users;
select count(*) from v$bgprocess;
```

### SGA Information

```sql
select * from v$sgainfo;
show sga;
desc v$sga;
desc dba_directories;
desc dba_data_files;
desc dba_users;
select OPEN_MODE, CURRENT_SCN from v$database;
show parameter db_recover;
select * from v$database;
```

## ADDM, AWR, ASH Reports

- **ADDM**: Automatic Database Diagnostic Monitor
- **AWR**: Automatic Workload Repository
- **ASH**: Active Session History

## Datapump

### Creating Datapump Directory

1. Create OS-level directory:
   ```sh
   mkdir -p /u/dp_exp_dir
   ```

2. Create directory inside the database:
   ```sql
   create directory datapump as '/u/dp_exp_dir';
   grant read, write on directory datapump to scott;
   ```

3. View directory information:
   ```sql
   select * from dba_directories;
   ```

4. Get help on `expdp` or `impdp` utility:
   ```sh
   expdp help=y
   impdp help=y
   ```

### Export and Import Commands

#### Table Level

1. Export:
   ```sh
   expdp directory=datapump dumpfile=emp_bkp.dmp logfile=emp_bkp.log tables='SCOTT.EMP'
   ```

2. Import:
   ```sh
   impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP'
   ```

3. Import to another schema:
   ```sh
   impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP' remap_schema='SCOTT:HR'
   ```

4. Import to another tablespace:
   ```sh
   impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP' remap_schema='SCOTT:HR' remap_tablespace='USERS:MYTBS'
   ```

5. Import with a different name:
   ```sh
   impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP' remap_table='SCOTT.EMP:HR.EMPLOYEE'
   ```

6. Import only rows:
   ```sh
   impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP' content=DATA_ONLY
   ```

#### Schema Level

1. Export:
   ```sh
   expdp directory=datapump dumpfile=scott_bkp.dmp logfile=scott_bkp.log schemas='SCOTT'
   ```

2. Import to the same schema:
   ```sh
   impdp directory=datapump dumpfile=scott_bkp.dmp logfile=imp_schema.log remap_schema='SCOTT:SCOTT'
   ```

3. Import to a different schema:
   ```sh
   impdp directory=datapump dumpfile=scott_bkp.dmp logfile=imp_schema.log remap_schema='SCOTT:HR'
   ```

#### Row Level

1. Export:
   ```sh
   expdp directory=datapump dumpfile=emprows_bkp.dmp logfile=emprows_bkp.log tables='SCOTT.EMP' query="where deptno="
   ```

2. Import:
   ```sh
   impdp directory=datapump dumpfile=emprows_bkp.dmp logfile=imp_emprows.log tables='SCOTT.EMP'
   ```

#### Database Level

1. Export:
   ```sh
   expdp directory=datapump dumpfile=fullprod.dmp logfile=fullprod.log full=y
   ```

2. Import:
   ```sh
   impdp directory=datapump dumpfile=fullprod.dmp logfile=imp_fullprod.log full=y
   ```

### Data Pump Import over Network

1. Create a TNS entry in `tnsnames.ora`:
   ```sh
   devdb = 
   (DESCRIPTION = 
     (ADDRESS_LIST = 
       (ADDRESS = (PROTOCOL = TCP)(HOST = ...)(PORT = ...))
     )
     (CONNECT_DATA = 
       (SERVICE_NAME = ...)
     )
   )
   ```

2. Create a database link:
   ```sql
   create database link SOURCE_DB connect to scott identified by tiger using 'devdb';
   ```

3. Import using the database link:
   ```sh
   impdp directory=MY_DUMP_DIR LOGFILE=dblink_transfer.log network_link=SOURCE_DB remap_schema=scott:hr
   ```

4. Import multiple schemas:
   ```sh
   impdp sys directory=MY_DUMP_DIR LOGFILE=dblink_transfer.log network_link=SOURCE_DB schemas=IJS,scott,hr
   ```

### Data Pump Performance Tuning

1. Use `DIRECT=y` for faster exports/imports.
2. Use `PARALLEL` for multiple export/import processes.
3. Use `%U` with the dumpfile name for multiple dumpfiles.

### Export Using PAR File

1. Create a PAR file:
   ```sh
   vi exp.par
   ```

   ```txt
   username=scott/tiger
   tables=scott.emp
   directory=EXP_DIR
   dumpfile=QUERY_EXP.dmp
   logfile=QUERY_EXP.log
   parallel=4
   ```

2. Call the PAR file:
   ```sh
   expdp parfile=exp.par
   ```

### Schedule Data Pump Export in Crontab

1. Create a script:
   ```sh
   vi daily_export.sh
   ```

   ```sh
   export DATE=$(date +%m_%d_%y_%H_%M)
   export ORACLE_SID=orcl
   export ORACLE_HOME=/u/app/oracle/product/../db_
   $ORACLE_HOME/bin/expdp username/password@sid directory=export_dir dumpfile=backup_$DATE.dmp logfile=backup_$DATE.log full=y
   ```

2. Give execute permissions:
   ```sh
   chmod +x daily_export.sh
   ```

3. Schedule in crontab:
   ```sh
   crontab -e -u oracle
   ```

   ```sh
   */30 * * * * /home/oracle/backup_script
   ```

### Data Pump Export Progress

1. Query to get export progress:
   ```sql
   SELECT SID, SERIAL#, USERNAME, CONTEXT, SOFAR, TOTALWORK, ROUND(SOFAR/TOTALWORK * 100, 2) "%_COMPLETE" FROM V$SESSION_LONGOPS WHERE TOTALWORK != 0 AND SOFAR <> TOTALWORK;
   ```

## Export-Import Utility

### RMAN Commands

```sh
rman target /
rman> report

 schema;
rman> show all;
rman> list backup of database;
rman> list backup of controlfile;
rman> backup database;
rman> backup current controlfile;
rman> backup database plus archivelog;
rman> restore controlfile;
rman> restore database;
rman> recover database;
rman> recover database using backup controlfile;
```

### Hot Backup

```sql
alter tablespace <tbs_name> begin backup;
host cp /u01/app/oracle/oradata/orcl/<tbs_name> /backup/<tbs_name>;
alter tablespace <tbs_name> end backup;
```

### Cold Backup

```sql
shutdown immediate;
startup mount;
host cp /u01/app/oracle/oradata/orcl/* /backup;
alter database open;
```

### Datapump

```sh
expdp scott/tiger@orcl directory=dp dumpfile=scott.dmp logfile=scott.log full=y
impdp scott/tiger@orcl directory=dp dumpfile=scott.dmp logfile=scott.log full=y
```

### ASM

```sh
asmcmd lsdg
asmcmd lsdsk
asmcmd ls / +DATA +FRA +REDO
```

## Oracle RAC Administration

### Checking Cluster Status

```sh
crsctl check crs
crsctl check cluster -all
```

### Starting/Stopping Cluster

```sh
crsctl start crs
crsctl stop crs
```

### Node Management

```sh
srvctl start nodeapps -n <node_name>
srvctl stop nodeapps -n <node_name>
```

## Oracle Performance Tuning

### SQL Query Tuning

- Analyze execution plans
- Use indexes effectively
- Avoid full table scans

### Database Configuration

- Optimize SGA and PGA sizes
- Adjust init.ora parameters

### Monitoring and Troubleshooting

- Use AWR, ASH, and ADDM reports
- Monitor system performance metrics

## Oracle Backup and Recovery

### Backup Strategies

- Full backup
- Incremental backup
- Cumulative backup

### Recovery Scenarios

- Complete recovery
- Incomplete recovery
- Tablespace point-in-time recovery (TSPITR)

## Oracle Patching

### Checking Patch Levels

```sh
opatch lsinventory
```

### Applying Patches

1. Download patch from Oracle support
2. Extract patch:
   ```sh
   unzip p<patch_number>_<version>_<os>.zip
   ```

3. Apply patch:
   ```sh
   cd <patch_directory>
   opatch apply
   ```

### Post-Patch Actions

- Restart database and services
- Verify patch application

## Oracle Data Guard

### Setting Up Data Guard

1. Configure primary and standby databases
2. Set up data guard broker:
   ```sh
   dgmgrl sys/password
   add database <standby_db> as connect identifier is '<db_service>' maintained as physical;
   ```
3. Enable data guard:
   ```sh
   enable configuration;
   ```

### Monitoring Data Guard

- Use `DGMGRL` commands:
  ```sh
  show configuration;
  show database <db_name>;
  show database verbose <db_name>;
  ```

## Oracle SQL Developer

### Connecting to Databases

- Use TNS names or direct connections
- Configure connection details

### Executing Queries

- Use SQL Worksheet
- Run scripts and statements

### Database Administration

- Create and manage users
- Backup and restore databases
- Perform data pump operations

---

**Note:** Customize this cheat sheet based on your specific Oracle environment and requirements. Always refer to the official Oracle documentation for detailed instructions and best practices.

----------------------------------------------------------------------

```sh
-- ## desc all_sequences

CREATE TABLE employees_afsar (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100),
    phone_number VARCHAR2(20),
    hire_date DATE,
    job_id VARCHAR2(10),
    salary NUMBER(8, 2),
    manager_id NUMBER,
    department_id NUMBER
);

select * from employees_afsar;
SELECT employee_id FROM employees ORDER BY employee_id;
CREATE SEQUENCE emp_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

INSERT INTO employees_afsar (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
VALUES (emp_seq.NEXTVAL, 'afsar', 'Aalam', 'afsar@example.com', '+911234567895', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'IT_PROG', 45000.00, 100, 20);

INSERT INTO employees_afsar (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
VALUES (emp_seq.NEXTVAL, 'hackbugs', 'Aalam', 'afsar@example.com', '+911234567895', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'IT_PROG', 45000.00, 100, 20);

INSERT INTO employees_afsar (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
VALUES (emp_seq.NEXTVAL, 'elfin', 'Aalam', 'afsar@example.com', '+911234567895', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'IT_PROG', 45000.00, 100, 20);

INSERT INTO employees_afsar (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
VALUES (emp_seq.NEXTVAL, 'ruler', 'Aalam', 'afsar@example.com', '+911234567895', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'IT_PROG', 45000.00, 100, 20);

-- Generate and insert 50 random users records PL/SQL procedure in "employees_afsar" table
BEGIN
  FOR i IN 1..50 LOOP
    INSERT INTO employees_afsar (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
    VALUES (emp_seq.NEXTVAL,
            'First'||LPAD(i, 2, '0'), -- Concatenate 'First' with a two-digit number (e.g., First01, First02, etc.) for first_name
            'Last'||LPAD(i, 2, '0'),  -- Concatenate 'Last' with a two-digit number (e.g., Last01, Last02, etc.) for last_name
            'user'||i||'@example.com', -- Concatenate 'user' with the loop index and '@example.com' for email
            '+91'||LPAD(dbms_random.value(1000000000, 9999999999), 10, '0'), -- Random 10-digit phone number prefixed with '+91'
            TO_DATE('2023-01-01', 'YYYY-MM-DD') + dbms_random.value(1, 365), -- Random hire_date within 1 year from 2023-01-01
            'IT_PROG', -- Fixed job_id
            ROUND(dbms_random.value(30000, 80000), 2), -- Random salary between 30000 and 80000
            100, -- Fixed manager_id
            20); -- Fixed department_id
  END LOOP;
  COMMIT; -- Commit the transaction
END;
/

--if only i created a table ther have not data than use this code to isert data in table
ALTER TABLE employees_afsar ADD (employee_id NUMBER PRIMARY KEY);
ALTER TABLE employees_afsar ADD (first_name VARCHAR2(50));
ALTER TABLE employees_afsar ADD (last_name VARCHAR2(50));
ALTER TABLE employees_afsar ADD (email VARCHAR2(100));
ALTER TABLE employees_afsar ADD (phone_number VARCHAR2(20));
ALTER TABLE employees_afsar ADD (hire_date DATE);
ALTER TABLE employees_afsar ADD (job_id VARCHAR2(10));
ALTER TABLE employees_afsar ADD (salary NUMBER(8, 2));
ALTER TABLE employees_afsar ADD (manager_id NUMBER);
ALTER TABLE employees_afsar ADD (department_id NUMBER);
ALTER TABLE employees_afsar ADD (password VARCHAR2(50));

-- use update cmd
UPDATE employees_afsar
SET phone_number = '+9161664204'
WHERE first_name = 'afsar' AND last_name = 'Aalam' AND phone_number = '+911234567895';
commit

-- create datafile and tablespace 
CREATE TABLESPACE users07 
DATAFILE 'users07.dbf' 
SIZE 100M 
AUTOEXTEND ON 
NEXT 10M 
MAXSIZE UNLIMITED;

-- retrive all tablespace name
SELECT tablespace_name FROM dba_tablespaces;
 
-- check information of PDBS
show pdbs;
SELECT CDB FROM V$DATABASE;
SELECT name FROM v$pdbs;
SELECT pdb_name, status FROM dba_pdbs;

ALTER SESSION SET CONTAINER = PDB$SEED;
ALTER PLUGGABLE DATABASE PDB$SEED CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE PDB$SEED OPEN READ WRITE;
ALTER SESSION SET CONTAINER = PDB$SEED;

SELECT sys_context('USERENV', 'CON_NAME') AS current_pdb_name FROM dual;
SELECT name AS current_pdb_name FROM v$database;


--In Oracle Database, when you create a user with a name prefixed by C##, such as C##USERNAME,
--it denotes a "Common User" or "Container Database (CDB) User". This prefix was introduced to 
--differentiate between common users and local users within a multitenant architecture.

-- create user and assign on that tablespce which i created on top
CREATE USER C##user07 IDENTIFIED BY password
DEFAULT TABLESPACE users07
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- check all privileges
SELECT COUNT(*) AS total_privileges
FROM DBA_SYS_PRIVS;

-- find the user which i creted in which table space assign
SELECT username, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'C##USER07';

-- count how many table have contain in SYS user
SELECT COUNT(*) AS table_count
FROM dba_tables
WHERE owner = 'SYS';

-- count total DBA users
select count(*) as total_users
from dba_users

-- count total DBA tables
select count(*) as total_tables
from dba_tables

-- resize of datafiles
example  - ALTER DATABASE DATAFILE 'path_to_datafile' RESIZE new_size;
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/ORCL/users01.dbf' RESIZE 200M;

-- datafile loaction and tablespace details 

SELECT file_name,
       tablespace_name,
       bytes / 1024 / 1024 AS size_mb,
       (bytes - NVL(free_space, 0)) / 1024 / 1024 AS used_mb,
       NVL(free_space, 0) / 1024 / 1024 AS free_mb
  FROM (SELECT file_id,
               file_name,
               tablespace_name,
               bytes,
               (SELECT SUM(bytes)
                  FROM dba_free_space
                 WHERE file_id = df.file_id) AS free_space
          FROM dba_data_files df)
ORDER BY tablespace_name, file_name;

-- check tablespces details in MB total size, used size, free size, and used in persentage

SELECT tablespace_name,
       status,
       total_size_mb,
       used_size_mb,
       (total_size_mb - used_size_mb) AS free_size_mb,
       ROUND((used_size_mb / total_size_mb) * 100, 2) AS used_percent
  FROM (
        SELECT df.tablespace_name,
               'ONLINE' AS status,
               ROUND(SUM(df.bytes) / 1024 / 1024, 2) AS total_size_mb,
               ROUND(SUM(df.bytes) / 1024 / 1024, 2) - ROUND(NVL(SUM(fs.bytes), 0) / 1024 / 1024, 2) AS used_size_mb
          FROM dba_data_files df
          LEFT JOIN dba_free_space fs
            ON df.tablespace_name = fs.tablespace_name
         GROUP BY df.tablespace_name
        UNION ALL
        SELECT tf.tablespace_name,
               'ONLINE' AS status,
               ROUND(SUM(tf.bytes) / 1024 / 1024, 2) AS total_size_mb,
               ROUND(SUM(tf.bytes) / 1024 / 1024, 2) - ROUND(NVL(SUM(fst.bytes), 0) / 1024 / 1024, 2) AS used_size_mb
          FROM dba_temp_files tf
          LEFT JOIN dba_free_space fst
            ON tf.tablespace_name = fst.tablespace_name
         GROUP BY tf.tablespace_name
      )
ORDER BY tablespace_name;

-- check tablespace details in GB

SELECT tablespace_name,
       ROUND(SUM(bytes) / 1024 / 1024 / 1024, 2) AS total_size_gb,
       ROUND(SUM(bytes - NVL(free_space, 0)) / 1024 / 1024 / 1024, 2) AS used_size_gb,
       ROUND(SUM(NVL(free_space, 0)) / 1024 / 1024 / 1024, 2) AS free_space_gb,
       ROUND((SUM(bytes - NVL(free_space, 0)) / SUM(bytes)) * 100, 2) AS used_percent
  FROM (
        SELECT tablespace_name,
               bytes,
               0 AS free_space
          FROM dba_data_files
        UNION ALL
        SELECT tablespace_name,
               bytes,
               bytes AS free_space
          FROM dba_free_space
        UNION ALL
        SELECT tablespace_name,
               bytes,
               0 AS free_space
          FROM dba_temp_files
      )
GROUP BY tablespace_name
ORDER BY tablespace_name;


-- To find out how many users have objects in each tablespace

SELECT ts.tablespace_name,
       COUNT(DISTINCT u.username) AS user_count
  FROM dba_users u
  JOIN dba_segments s
    ON u.username = s.owner
  JOIN dba_tablespaces ts
    ON s.tablespace_name = ts.tablespace_name
 GROUP BY ts.tablespace_name
 ORDER BY ts.tablespace_name;

-- check tablespces and total size, used size, free size, and used in persentage, user count as well

WITH tablespace_usage AS (
  SELECT tablespace_name,
         status,
         total_size_mb,
         used_size_mb,
         (total_size_mb - used_size_mb) AS free_size_mb,
         ROUND((used_size_mb / total_size_mb) * 100, 2) AS used_percent
    FROM (
          SELECT df.tablespace_name,
                 'ONLINE' AS status,
                 ROUND(SUM(df.bytes) / 1024 / 1024, 2) AS total_size_mb,
                 ROUND(SUM(df.bytes) / 1024 / 1024, 2) - ROUND(NVL(SUM(fs.bytes), 0) / 1024 / 1024, 2) AS used_size_mb
            FROM dba_data_files df
            LEFT JOIN dba_free_space fs
              ON df.tablespace_name = fs.tablespace_name
           GROUP BY df.tablespace_name
          UNION ALL
          SELECT tf.tablespace_name,
                 'ONLINE' AS status,
                 ROUND(SUM(tf.bytes) / 1024 / 1024, 2) AS total_size_mb,
                 ROUND(SUM(tf.bytes) / 1024 / 1024, 2) - ROUND(NVL(SUM(fst.bytes), 0) / 1024 / 1024, 2) AS used_size_mb
            FROM dba_temp_files tf
            LEFT JOIN dba_free_space fst
              ON tf.tablespace_name = fst.tablespace_name
           GROUP BY tf.tablespace_name
        )
),
tablespace_users AS (
  SELECT ts.tablespace_name,
         COUNT(DISTINCT u.username) AS user_count
    FROM dba_users u
    JOIN dba_segments s
      ON u.username = s.owner
    JOIN dba_tablespaces ts
      ON s.tablespace_name = ts.tablespace_name
   GROUP BY ts.tablespace_name
)
SELECT tu.tablespace_name,
       tu.status,
       tu.total_size_mb,
       tu.used_size_mb,
       tu.free_size_mb,
       tu.used_percent,
       NVL(tu2.user_count, 0) AS user_count
  FROM tablespace_usage tu
  LEFT JOIN tablespace_users tu2
    ON tu.tablespace_name = tu2.tablespace_name
 ORDER BY tu.tablespace_name;

-- check tablespces and total size, used size, free size, and used in persentage, user count, datafile count

WITH tablespace_usage AS (
  SELECT tablespace_name,
         status,
         total_size_mb,
         used_size_mb,
         (total_size_mb - used_size_mb) AS free_size_mb,
         ROUND((used_size_mb / total_size_mb) * 100, 2) AS used_percent,
         datafile_count
    FROM (
          SELECT df.tablespace_name,
                 'ONLINE' AS status,
                 ROUND(SUM(df.bytes) / 1024 / 1024, 2) AS total_size_mb,
                 ROUND(SUM(df.bytes) / 1024 / 1024, 2) - ROUND(NVL(SUM(fs.bytes), 0) / 1024 / 1024, 2) AS used_size_mb,
                 COUNT(df.file_id) AS datafile_count
            FROM dba_data_files df
            LEFT JOIN dba_free_space fs
              ON df.tablespace_name = fs.tablespace_name
           GROUP BY df.tablespace_name
          UNION ALL
          SELECT tf.tablespace_name,
                 'ONLINE' AS status,
                 ROUND(SUM(tf.bytes) / 1024 / 1024, 2) AS total_size_mb,
                 ROUND(SUM(tf.bytes) / 1024 / 1024, 2) - ROUND(NVL(SUM(fst.bytes), 0) / 1024 / 1024, 2) AS used_size_mb,
                 COUNT(tf.file_id) AS datafile_count
            FROM dba_temp_files tf
            LEFT JOIN dba_free_space fst
              ON tf.tablespace_name = fst.tablespace_name
           GROUP BY tf.tablespace_name
        )
),
tablespace_users AS (
  SELECT ts.tablespace_name,
         COUNT(DISTINCT u.username) AS user_count
    FROM dba_users u
    JOIN dba_segments s
      ON u.username = s.owner
    JOIN dba_tablespaces ts
      ON s.tablespace_name = ts.tablespace_name
   GROUP BY ts.tablespace_name
)
SELECT tu.tablespace_name,
       tu.status,
       tu.total_size_mb,
       tu.used_size_mb,
       tu.free_size_mb,
       tu.used_percent,
       tu.datafile_count,
       NVL(tu2.user_count, 0) AS user_count
  FROM tablespace_usage tu
  LEFT JOIN tablespace_users tu2
    ON tu.tablespace_name = tu2.tablespace_name
 ORDER BY tu.tablespace_name;
 
--------------------------------------------------------------------------------------------------

SELECT member FROM v$logfile;
desc v$sgainfo;
select name, BYTES, RESIZEABLE,CON_ID from v$sgainfo

-----------------------------------------------------------------------------
 Give the grand and PRIVILEGES of user base on role an resposbilities
---------------------------------------------------------------------
GRANT CONNECT, RESOURCE TO new_schema;
GRANT CREATE TABLE TO new_schema;
GRANT CREATE VIEW TO new_schema;
GRANT CREATE PROCEDURE TO new_schema;
GRANT CREATE SEQUENCE TO new_schema;

GRANT CONNECT, RESOURCE, CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO new_schema;

GRANT ALL PRIVILEGES TO new_schema;
GRANT DBA TO new_schema;
REVOKE ALL PRIVILEGES FROM new_schema;

FROM dba_sys_privs
FROM dba_tab_privs
FROM dba_role_privs
FROM dba_users;

SELECT grantee, privilege 
FROM dba_sys_privs 
WHERE grantee = 'USERNAME';

SELECT * FROM DBA_SYS_PRIVS;
SELECT * FROM DBA_TAB_PRIVS;
SELECT * FROM DBA_ROLE_PRIVS;

SELECT * FROM dba_ts_quotas WHERE username = 'new_schema';

SELECT grantee, owner, table_name, privilege 
FROM dba_tab_privs 
WHERE grantee = 'new_schema';

SELECT grantee, privilege 
FROM dba_sys_privs;

SELECT username, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'NEW_SCHEMA1';

SELECT username FROM dba_users WHERE username = 'NEW_SCHEMA'; 

ALTER SESSION SET CONTAINER = PDB$SEED;

GRANT CREATE TABLE TO new_schema;
ALTER USER new_schema QUOTA UNLIMITED ON users;

show user;


SELECT name, open_mode FROM v$database;

CREATE DATABASE CDB1
USER SYS IDENTIFIED BY oracle
USER SYSTEM IDENTIFIED BY oracle
ENABLE PLUGGABLE DATABASE;

SELECT name, open_mode FROM v$database;
select name,CON_ID,open_mode from v$pdbs;
desc v$pdbs;
show pdbs;
show user;
desc v$tablespace;

Datafiles
-------------
SELECT tablespace_name, file_name
FROM dba_data_files;

tablespaces
------------
SELECT tablespace_name, status, contents, logging, block_size
FROM dba_tablespaces;

SELECT file#, name, status
FROM v$datafile;

find all important loaction of oracle database
---------------------------------------------------
 Connect to the database as SYSDBA
 ---------------------------------------
sqlplus sys as sysdba

 Find control file locations
 ---------------------------------------
SELECT name FROM v$controlfile;

 Find redo log file locations
 ---------------------------------------
SELECT member FROM v$logfile;

 Find all tablespaces
 ---------------------------------------
SELECT tablespace_name FROM dba_tablespaces;

 Find datafile locations for tablespaces
 -----------------------------------------
SELECT tablespace_name, file_name FROM dba_data_files;

 Find temporary tablespace file locations
 --------------------------------------------
SELECT tablespace_name, file_name FROM dba_temp_files;

 Find archive log file locations
 ---------------------------------------
SELECT name FROM v$archived_log;

 Find shared pool and other SGA information
 --------------------------------------------
SELECT * FROM v$sga;

 Connect to the database as SYSDBA
 ---------------------------------------
sqlplus sys as sysdba

 Get information about the shared pool
 ---------------------------------------
SELECT * FROM v$sgastat WHERE pool = 'shared pool';

 Get information about the Java pool
 ---------------------------------------
SELECT * FROM v$sgastat WHERE pool = 'java pool';

 Get information about the large pool
 ---------------------------------------
SELECT * FROM v$sgastat WHERE pool = 'large pool';

 Get information about the streams pool
 ---------------------------------------
SELECT * FROM v$sgastat WHERE pool = 'streams pool';

 Get overall SGA information
 ---------------------------------------
SELECT * FROM v$sga;

 Get detailed SGA component information
SELECT * FROM v$sgainfo;

select * from v$sgastat where pool ='java pool';

SELECT status FROM v$instance;
shutdown immediate;
startup mount;
ALTER PLUGGABLE DATABASE pdb_name OPEN;

@ C:\Oracle\WINDOWS.X64_193000_db_home\rdbms\xml\schema\db-sample-schemas-21.1\human_resources\hr_main.sql

 PDBS conncet and conncet wtih schema means users;

# Connect to the CDB as SYSDBA
---------------------------------------
sqlplus sys as sysdba

# Switch to the PDB `pdbtest`
---------------------------------------
ALTER SESSION SET CONTAINER = pdbtest;

# Change the password for the user `hr`
-----------------------------------------
ALTER USER hr IDENTIFIED BY new_password;

# Verify the password change by connecting as `hr` with the new password
----------------------------------------------------------------------------
CONNECT hr/new_password@pdbtest;

------------------------------------------

-- Sure, here's a list of some common courses/topics typically covered in SQL and Oracle training:

1. SQL Basics
2. Data Manipulation Language (DML)
3. Data Definition Language (DDL)
4. Data Query Language (DQL)
5. Joins and Subqueries
6. Indexes and Views
7. Transactions and Locking
8. Constraints and Triggers
9. Stored Procedures and Functions
10. Performance Tuning
11. Data Warehousing Concepts
12. Backup and Recovery
13. Oracle Database Architecture
14. PL/SQL Programming
15. Oracle SQL Developer Tools
16. Advanced SQL Techniques

----------------------------------------------

-- Certainly! Here's a list of common types of functions used in SQL, which are typically supported across various relational database management systems (RDBMS):

### Types of SQL Functions

1. **Aggregate Functions**
   - Perform calculations on sets of values and return a single value.
   - Examples:
     - `COUNT()`: Returns the number of rows that match a specified condition.
     - `SUM()`: Returns the sum of values in a column.
     - `AVG()`: Returns the average value of a numeric column.
     - `MIN()`: Returns the minimum value in a set.
     - `MAX()`: Returns the maximum value in a set.

2. **Scalar Functions**
   - Operate on a single value and return a single value.
   - Examples:
     - `UPPER()`, `LOWER()`: Converts a string to uppercase or lowercase.
     - `LEN()`, `LENGTH()`: Returns the length of a string.
     - `CONCAT()`: Concatenates two or more strings.
     - `SUBSTRING()`, `SUBSTR()`: Extracts a substring from a string.
     - `ROUND()`, `TRUNC()`: Rounds or truncates a numeric value.

3. **String Functions**
   - Manipulate string data.
   - Examples:
     - `LEFT()`, `RIGHT()`: Extracts a specified number of characters from the start or end of a string.
     - `LTRIM()`, `RTRIM()`, `TRIM()`: Removes leading or trailing spaces from a string.
     - `REPLACE()`: Replaces occurrences of a substring within a string.
     - `CHAR_LENGTH()`, `CHARACTER_LENGTH()`: Returns the number of characters in a string.

4. **Numeric Functions**
   - Operate on numeric data types.
   - Examples:
     - `ABS()`: Returns the absolute value of a number.
     - `CEILING()`, `FLOOR()`: Rounds a number up or down to the nearest integer.
     - `POWER()`, `SQRT()`: Calculates the power or square root of a number.
     - `RAND()`, `ROUND()`: Generates a random number or rounds a number to a specified number of decimal places.

5. **Date and Time Functions**
   - Manipulate date and time values.
   - Examples:
     - `NOW()`, `CURRENT_TIMESTAMP()`: Returns the current date and time.
     - `DATE()`, `TIME()`: Extracts the date or time part from a datetime value.
     - `DATEADD()`, `DATEDIFF()`: Adds or subtracts a specified time interval from a date.
     - `DAYOFWEEK()`, `MONTH()`, `YEAR()`: Extracts components of a date.

6. **Conversion Functions**
   - Convert data types from one type to another.
   - Examples:
     - `CAST()`, `CONVERT()`: Converts a value from one data type to another.
     - `TO_CHAR()`, `TO_DATE()`, `TO_NUMBER()`: Converts strings to dates or numbers in Oracle SQL.

7. **Conditional Functions**
   - Perform conditional logic.
   - Examples:
     - `CASE`: Evaluates a list of conditions and returns one of multiple possible results.
     - `COALESCE()`: Returns the first non-null value in a list of expressions.
     - `IF()`, `IFNULL()`: Returns one value if a condition is true and another value if the condition is false.

8. **System Functions**
   - Provide information about the database or environment.
   - Examples:
     - `DATABASE()`, `USER()`: Returns the current database or user.
     - `VERSION()`: Returns the version of the database server.
     - `SESSION_USER()`: Returns the current session user.

9. **User-Defined Functions (UDFs)**
   - Created by users to perform specific tasks.
   - Examples:
     - Scalar UDFs: Operate on a single row and return a single value.
     - Table-Valued UDFs: Return a table result set.

Each SQL function type serves specific purposes and is used to perform various operations on data within SQL queries.
The syntax and availability of these functions may vary slightly between different database management systems. 
If you have specific questions or need examples for any function type, feel free to ask!

----------------------------------------------

-- Certainly! Here's a comprehensive list of SQL clauses commonly used in database querying and management:

### List of SQL Clauses

1. **SELECT**
   - Retrieves data from one or more tables.
   - Example:
     ```sql
     SELECT column1, column2 FROM table_name;
     ```

2. **FROM**
   - Specifies the tables from which to retrieve data in a `SELECT` statement.
   - Example:
     ```sql
     SELECT column1, column2 FROM table_name1, table_name2;
     ```

3. **WHERE**
   - Filters rows based on specified conditions.
   - Example:
     ```sql
     SELECT column1, column2 FROM table_name WHERE condition;
     ```

4. **GROUP BY**
   - Groups rows that have the same values into summary rows.
   - Example:
     ```sql
     SELECT COUNT(*), column1 FROM table_name GROUP BY column1;
     ```

5. **HAVING**
   - Filters groups based on specified conditions.
   - Example:
     ```sql
     SELECT column1, COUNT(*) FROM table_name GROUP BY column1 HAVING COUNT(*) > 1;
     ```

6. **ORDER BY**
   - Sorts the result set in ascending or descending order.
   - Example:
     ```sql
     SELECT column1, column2 FROM table_name ORDER BY column1 ASC;
     ```

7. **LIMIT**
   - Specifies the maximum number of rows to return from a query.
   - Example:
     ```sql
     SELECT column1, column2 FROM table_name LIMIT 10;
     ```

8. **OFFSET**
   - Skips the specified number of rows before returning the result set.
   - Example:
     ```sql
     SELECT column1, column2 FROM table_name LIMIT 10 OFFSET 5;
     ```

9. **INSERT INTO**
   - Adds new rows of data into a table.
   - Example:
     ```sql
     INSERT INTO table_name (column1, column2) VALUES (value1, value2);
     ```

10. **UPDATE**
    - Modifies existing records in a table.
    - Example:
      ```sql
      UPDATE table_name SET column1 = value1 WHERE condition;
      ```

11. **DELETE**
    - Removes existing records from a table.
    - Example:
      ```sql
      DELETE FROM table_name WHERE condition;
      ```

12. **JOIN**
    - Retrieves data from multiple tables based on a related column between them.
    - Example:
      ```sql
      SELECT column1, column2 FROM table1 INNER JOIN table2 ON table1.column = table2.column;
      ```

13. **INNER JOIN**
    - Retrieves rows that have matching values in both tables.
    - Example:
      ```sql
      SELECT * FROM table1 INNER JOIN table2 ON table1.column = table2.column;
      ```

14. **LEFT JOIN**
    - Retrieves all rows from the left table and matching rows from the right table.
    - Example:
      ```sql
      SELECT * FROM table1 LEFT JOIN table2 ON table1.column = table2.column;
      ```

15. **RIGHT JOIN**
    - Retrieves all rows from the right table and matching rows from the left table.
    - Example:
      ```sql
      SELECT * FROM table1 RIGHT JOIN table2 ON table1.column = table2.column;
      ```

16. **FULL OUTER JOIN**
    - Retrieves all rows from both tables and matches rows where possible.
    - Example:
      ```sql
      SELECT * FROM table1 FULL OUTER JOIN table2 ON table1.column = table2.column;
      ```

17. **UNION**
    - Combines the result sets of two or more `SELECT` statements into a single result set.
    - Example:
      ```sql
      SELECT column1 FROM table1 UNION SELECT column2 FROM table2;
      ```

18. **UNION ALL**
    - Combines the result sets of two or more `SELECT` statements into a single result set, including duplicates.
    - Example:
      ```sql
      SELECT column1 FROM table1 UNION ALL SELECT column2 FROM table2;
      ```

19. **DISTINCT**
    - Returns unique values from a column or expression in a `SELECT` statement.
    - Example:
      ```sql
      SELECT DISTINCT column1 FROM table_name;
      ```

20. **LIKE**
    - Searches for a specified pattern in a column.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE column1 LIKE 'pattern%';
      ```

21. **IN**
    - Specifies multiple values for a `WHERE` clause.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE column1 IN (value1, value2, ...);
      ```

22. **BETWEEN**
    - Specifies a range to search for in a `WHERE` clause.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE column1 BETWEEN value1 AND value2;
      ```

23. **IS NULL**
    - Tests for empty values (NULL) in a `WHERE` clause.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE column1 IS NULL;
      ```

24. **IS NOT NULL**
    - Tests for non-empty values (not NULL) in a `WHERE` clause.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE column1 IS NOT NULL;
      ```

25. **CASE**
    - Evaluates a list of conditions and returns one of multiple possible result expressions.
    - Example:
      ```sql
      SELECT column1, 
             CASE
                 WHEN condition1 THEN result1
                 WHEN condition2 THEN result2
                 ELSE result3
             END AS result_column
      FROM table_name;
      ```

26. **EXISTS**
    - Tests for the existence of any rows in a subquery.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE EXISTS (SELECT * FROM another_table WHERE condition);
      ```

27. **ANY/ALL**
    - Compares a value to a set of values returned by a subquery.
    - Example:
      ```sql
      SELECT column1 FROM table_name WHERE column1 > ALL (SELECT column2 FROM another_table);
      ```

28. **ORDER BY**
    - Sorts the result set in ascending or descending order.
    - Example:
      ```sql
      SELECT column1, column2 FROM table_name ORDER BY column1 ASC;
      ```

29. **GROUP BY**
    - Groups rows that have the same values into summary rows.
    - Example:
      ```sql
      SELECT COUNT(*), column1 FROM table_name GROUP BY column1;
      ```

30. **HAVING**
    - Filters groups based on specified conditions.
    - Example:
      ```sql
      SELECT column1, COUNT(*) FROM table_name GROUP BY column1 HAVING COUNT(*) > 1;
      ```

31. **PARTITION BY**
    - Divides the result set into partitions to which the window function is applied.
    - Example:
      ```sql
      SELECT column1, column2, AVG(column3) OVER (PARTITION BY column1) AS avg_column3 FROM table_name;
      ```

32. **WINDOW FUNCTION**
    - Performs a calculation across a set of table rows related to the current row.
    - Example:
      ```sql
      SELECT column1, column2, AVG(column3) OVER (PARTITION BY column1) AS avg_column3 FROM table_name;
      ```

33. **TRANSACTION**
    - Groups one or more SQL operations into a single unit of work that either succeeds completely or fails completely.
    - Example:
      ```sql
      START TRANSACTION;
      -- SQL statements --
      COMMIT;
      ```

34. **COMMIT**
    - Saves all changes made since the start of the current transaction.
    - Example:
      ```sql
      COMMIT;
      ```

35. **ROLLBACK**
    - Undoes all changes made in the current transaction.
    - Example:
      ```sql
      ROLLBACK;
      ```

36. **SAVEPOINT**
    - Sets a point in the transaction to which you can later roll back.
    - Example:
      ```sql
      SAVEPOINT savepoint_name;
      ```

37. **SET**
    - Sets session-level variables for the current session.
    - Example:
      ```sql
      SET @variable_name = value;
      ```

38. **GRANT**
    - Provides privileges to users.
    - Example:
      ```sql
      GRANT SELECT, INSERT ON table_name TO user_name;
      ```

39. **REVOKE**
    - Removes privileges from users.
    - Example:
      ```sql
      REVOKE SELECT ON table_name FROM user_name;
      ```

40. **CREATE TABLE**
    - Creates a new table in the database.
    - Example:
      ```sql
      CREATE TABLE table_name (
          column1 datatype,
          column2 datatype,
          ...
      );
      ```

41. **ALTER TABLE**
    - Modifies an existing table structure.
    - Example:
      ```sql
      ALTER TABLE table_name ADD column_name datatype;
      ```

42. **DROP TABLE**
    - Deletes an existing table from the database.
    - Example:
      ```sql
      DROP TABLE table_name;
      ```

43. **CREATE INDEX**
    - Creates an index on a table.
    - Example:
      ```sql
      CREATE INDEX idx_name ON table_name (column_name);
      ```

44. **DROP INDEX**
    - Deletes an existing index from the database.
    - Example:
      ```sql
      DROP INDEX idx_name ON table_name;
      ``

45. **CREATE VIEW**
    - Creates a virtual table based on the result set of a SELECT statement.
    - Example:
      ```sql
      CREATE VIEW view_name AS SELECT column1, column2 FROM table_name WHERE condition;
      ```

46. **DROP VIEW**
    - Deletes an existing view from the database.
    - Example:
      ```sql
      DROP VIEW view_name;
      ```

47. **CREATE PROCEDURE**
    - Creates a stored procedure in the database.
    - Example:
      ```sql
      CREATE PROCEDURE procedure_name
      AS
      BEGIN
          -- SQL statements --
      END;
      ```

48. **DROP PROCEDURE**
    - Deletes an existing stored procedure from the database.
    - Example:
      ```sql
      DROP PROCEDURE procedure_name;
      ```

49. **CREATE FUNCTION**
    - Creates a user-defined function in the database.
    - Example:
      ```sql
      CREATE FUNCTION function_name (parameters)
      RETURNS return_type
      BEGIN
          -- SQL statements --
      END;
      ```

50. **DROP FUNCTION**
    - Deletes an existing user-defined function from the database.
    - Example:
      ```sql
      DROP FUNCTION function_name;
      ```

This list covers the essential SQL clauses used for querying, managing, and manipulating data in relational databases.
Each clause has its specific use case and syntax, which may vary slightly depending on the SQL dialect (e.g., MySQL, PostgreSQL, Oracle SQL).
If you need further explanations or examples for any specific clause, feel free to ask!

===============================================================================================================================
===============================================================================================================================

CREATE USER new_schema1 IDENTIFIED BY password
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;


CREATE TABLESPACE users2                             
DATAFILE 'users02.dbf' 
SIZE 100M 
AUTOEXTEND ON 
NEXT 10M 
MAXSIZE UNLIMITED;


CREATE DATABASE CDB1
USER SYS IDENTIFIED BY oracle
USER SYSTEM IDENTIFIED BY oracle
ENABLE PLUGGABLE DATABASE;


CREATE PLUGGABLE DATABASE pdbtest
  ADMIN USER pdb_admin IDENTIFIED BY pdbtest
  ROLES=(DEFAULT_ROLE)
  FILE_NAME_CONVERT=(
    '/path/to/pdbseed_files',   -- Source file path (PDB$SEED files)
    '/path/to/pdbtest_files'    -- Target file path (new PDB files)
  );

show pdbs;
SELECT CDB FROM V$DATABASE;
SELECT name FROM v$pdbs;
SELECT pdb_name, status FROM dba_pdbs;

ALTER SESSION SET CONTAINER = PDB$SEED;
ALTER PLUGGABLE DATABASE PDB$SEED CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE PDB$SEED OPEN READ WRITE;
ALTER SESSION SET CONTAINER = PDB$SEED;

===============================================================================================================================

create tablescpae users1
create user new_schema identified by password
default tablespace user2
temporary tablespace temp
quota unlimited on users;

===============================================================================================================================
expdp sys/sys@database_alias DIRECTORY=c:// DUMPFILE=dumpfile_name.dmp LOGFILE=logfile_name.log SCHEMAS=sys
expdp sys/sys@database_alias DIRECTORY=C:\Oracle\WINDOWS.X64_193000_db_home\log DUMPFILE=dumpfile_name.dmp LOGFILE=logfile_name.log SCHEMAS=sys

DIRECTORY
DUMPFILE
LOGFILE
SCHEMAS
===============================================================================================================================

-- Full Database Backup
BACKUP DATABASE;

-- Tablespace Backup
BACKUP TABLESPACE tablespace_name;

-- Datafile Backup
BACKUP DATAFILE 'full_path_to_datafile';
BACKUP DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/users01.dbf';

-- Archive Log Backup
BACKUP ARCHIVELOG ALL;

-- Control File Backup
BACKUP CURRENT CONTROLFILE;

-- SPFILE Backup
BACKUP SPFILE;

-- Incremental Backup (Level 1)
BACKUP INCREMENTAL LEVEL 1 DATABASE;

-- Cumulative Incremental Backup (Level 1 Cumulative)
BACKUP INCREMENTAL LEVEL 1 CUMULATIVE DATABASE;

==============================================================================================================================

-- When performing backups with RMAN (Recovery Manager) in Oracle databases it's essential to back up critical files that are necessary for recovery in case of data loss or database corruption. Here are the essential files you should include in your backup strategy: --

consolidated list of essential files you should back up using RMAN in Oracle databases:
"Consolidated" ka matlab hota hai "ek sath ya ek jagah par ekatra karna"

-- Full Database Backup (includes datafiles, control file, and SPFILE)
BACKUP DATABASE;

-- Control File Backup
BACKUP CURRENT CONTROLFILE;

-- SPFILE Backup
BACKUP SPFILE;

-- Archive Log Backup
BACKUP ARCHIVELOG ALL;

==============================================================================================================================

When you perform a `BACKUP DATABASE` command in RMAN (Recovery Manager) in Oracle, it automatically includes several key components of the database. Here's what `BACKUP DATABASE` typically backs up:

1. **Datafiles**: This includes all datafiles associated with the database, which contain the actual data of tables, indexes, and other database objects.

2. **Control File**: The control file is a crucial part of the Oracle database that contains metadata about the physical structure of the database and its allocation.

3. **SPFILE (Server Parameter File)**: The SPFILE contains initialization parameters for the database instance. It's necessary for instance startup and recovery.

4. **Redo Logs**: Depending on the RMAN configuration and backup strategy, `BACKUP DATABASE` may also include redo logs. Redo logs are critical for database recovery to apply changes after a backup.

5. **Archive Logs**: If your database is in ARCHIVELOG mode, `BACKUP DATABASE` will also include archive logs. Archive logs are essential for point-in-time recovery and applying changes to the database since the last backup.

6. **Data Pump Export (optional)**: `BACKUP DATABASE` does not include logical backups (export dumps) of data, which are typically done using `expdp` (Data Pump Export) for logical backup purposes.

To summarize, `BACKUP DATABASE` in RMAN is comprehensive and typically includes all necessary components for database recovery and operation, including datafiles, control file, SPFILE, redo logs, and archive logs (if applicable). Always review your RMAN configuration and backup strategy to ensure it aligns with your recovery objectives and data protection requirements.

===============================================================================================================================

SQL> CREATE PLUGGABLE DATABASE pdbtest
      ADMIN USER pdb_admin IDENTIFIED BY pdbtest
      ROLES=(DEFAULT_ROLE)
      FILE_NAME_CONVERT=('pdb_seed_file_path', 'pdb_file_path');
	  
  CREATE PLUGGABLE DATABASE pdbtest
  ADMIN USER pdb_admin IDENTIFIED BY pdbtest
  ROLES=(DEFAULT_ROLE)
  FILE_NAME_CONVERT=(
    'C:\ORACLE\ORADATA\ORCL\PDBSEED\SYSTEM01.DBF', 
    'C:\ORACLE\ORADATA\ORCL\PDBTEST\SYSAUX01.DBF'
  );
 
===============================================================================================================================
-- SQL Commands --

1. DDL Commands (Data Definition Language):
   CREATE TABLE: Creates a new table.
   ALTER TABLE: Modifies an existing table.
   DROP TABLE: Deletes a table and its data.
   CREATE INDEX: Creates an index on a table.
   DROP INDEX: Deletes an index.

2. DML Commands (Data Manipulation Language):
   INSERT INTO: Adds new rows into a table.
   UPDATE: Modifies existing rows in a table.
   DELETE FROM: Removes rows from a table.
   SELECT: Retrieves data from one or more tables.

3. DDL Commands for Users and Roles:
   CREATE USER: Creates a new database user.
   ALTER USER: Modifies properties of an existing user.
   DROP USER: Deletes a database user.
   GRANT: Provides privileges to users or roles.
   REVOKE: Removes privileges from users or roles.

4. Other Useful Commands:
   CREATE VIEW: Creates a virtual table based on a SELECT statement.
   CREATE SEQUENCE: Creates a sequence object.
   CREATE PROCEDURE: Creates a stored procedure.
   COMMIT: Saves changes made in the current transaction.
   ROLLBACK: Reverts changes made in the current transaction.

-- SQL*Plus/SQLcl Commands --

1. Connection and Navigation:
   CONNECT: Connects to Oracle Database.
   DISCONNECT: Disconnects from Oracle Database.
   ALTER SESSION: Sets session-specific options.

2. Script Execution and Output:
   @ (Run Script): Executes a script file.
   SPOOL: Redirects output to a file.
   SET: Sets formatting options.

3. Metadata Queries:
   DESCRIBE: Describes the structure of an object.
   SELECT (for querying metadata): Retrieves information from data dictionary views.

4. Database Administration:
   STARTUP: Starts the database instance.
   SHUTDOWN: Shuts down the database instance.
   ALTER SYSTEM: Modifies database-wide settings.


===============================================================================================================================

-- SQL Commands --

1. DDL Commands (Data Definition Language):
   CREATE TABLE: Creates a new table.
     Syntax: CREATE TABLE table_name (
                column1 datatype,
                column2 datatype,
                ...
             );

   ALTER TABLE: Modifies an existing table.
     Syntax: ALTER TABLE table_name
             ADD column_name datatype;

   DROP TABLE: Deletes a table and its data.
     Syntax: DROP TABLE table_name;

   CREATE INDEX: Creates an index on a table.
     Syntax: CREATE INDEX index_name
             ON table_name (column_name);

   DROP INDEX: Deletes an index.
     Syntax: DROP INDEX index_name;

2. DML Commands (Data Manipulation Language):
   INSERT INTO: Adds new rows into a table.
     Syntax: INSERT INTO table_name (column1, column2, ...)
             VALUES (value1, value2, ...);

   UPDATE: Modifies existing rows in a table.
     Syntax: UPDATE table_name
             SET column1 = value1, column2 = value2
             WHERE condition;

   DELETE FROM: Removes rows from a table.
     Syntax: DELETE FROM table_name
             WHERE condition;

   SELECT: Retrieves data from one or more tables.
     Syntax: SELECT column1, column2, ...
             FROM table_name
             WHERE condition;

3. DDL Commands for Users and Roles:
   CREATE USER: Creates a new database user.
     Syntax: CREATE USER username IDENTIFIED BY password
             [DEFAULT TABLESPACE tablespace_name]
             [TEMPORARY TABLESPACE temp_tablespace_name];

   ALTER USER: Modifies properties of an existing user.
     Syntax: ALTER USER username
             [IDENTIFIED BY new_password]
             [DEFAULT TABLESPACE new_tablespace]
             [TEMPORARY TABLESPACE new_temp_tablespace];

   DROP USER: Deletes a database user.
     Syntax: DROP USER username;

   GRANT: Provides privileges to users or roles.
     Syntax: GRANT privilege(s)
             ON object_name
             TO user_or_role;

   REVOKE: Removes privileges from users or roles.
     Syntax: REVOKE privilege(s)
             ON object_name
             FROM user_or_role;

4. Other Useful Commands:
   CREATE VIEW: Creates a virtual table based on a SELECT statement.
     Syntax: CREATE VIEW view_name AS
             SELECT column1, column2, ...
             FROM table_name
             WHERE condition;

   CREATE SEQUENCE: Creates a sequence object.
     Syntax: CREATE SEQUENCE sequence_name
             START WITH start_value
             INCREMENT BY increment_value
             [MINVALUE min_value]
             [MAXVALUE max_value]
             [CYCLE | NOCYCLE];

   CREATE PROCEDURE: Creates a stored procedure.
     Syntax: CREATE PROCEDURE procedure_name
             (parameter_list)
             AS
             BEGIN
               SQL statements;
             END;

   COMMIT: Saves changes made in the current transaction.
     Syntax: COMMIT;

   ROLLBACK: Reverts changes made in the current transaction.
     Syntax: ROLLBACK;

-- SQL*Plus/SQLcl Commands --

1. Connection and Navigation:
   CONNECT: Connects to Oracle Database.
     Syntax: CONNECT username/password@connect_identifier;

   DISCONNECT: Disconnects from Oracle Database.
     Syntax: DISCONNECT;

   ALTER SESSION: Sets session-specific options.
     Syntax: ALTER SESSION SET parameter_name = value;

2. Script Execution and Output:
   @ (Run Script): Executes a script file.
     Syntax: @path/to/script_file.sql;

   SPOOL: Redirects output to a file.
     Syntax: SPOOL path/to/output_file.log;

   SET: Sets formatting options.
     Syntax: SET option_name value;

3. Metadata Queries:
   DESCRIBE: Describes the structure of an object.
     Syntax: DESCRIBE object_name;

   SELECT (for querying metadata): Retrieves information from data dictionary views.
     Syntax: SELECT column1, column2, ...
             FROM dba_objects
             WHERE condition;

4. Database Administration:
   STARTUP: Starts the database instance.
     Syntax: STARTUP [FORCE];

   SHUTDOWN: Shuts down the database instance.
     Syntax: SHUTDOWN [IMMEDIATE];

   ALTER SYSTEM: Modifies database-wide settings.
     Syntax: ALTER SYSTEM SET parameter_name = value;


===============================================================================================================================

-- SQL Clauses --

1. SELECT Clause:
   Retrieves data from one or more tables.
   Syntax: SELECT column1, column2, ...
           FROM table_name
           [WHERE condition]
           [GROUP BY column1, column2, ...]
           [HAVING condition]
           [ORDER BY column1 [ASC|DESC]];

2. INSERT INTO Clause:
   Adds new rows into a table.
   Syntax: INSERT INTO table_name (column1, column2, ...)
           VALUES (value1, value2, ...);

3. UPDATE Clause:
   Modifies existing rows in a table.
   Syntax: UPDATE table_name
           SET column1 = value1, column2 = value2, ...
           [WHERE condition];

4. DELETE FROM Clause:
   Removes rows from a table.
   Syntax: DELETE FROM table_name
           [WHERE condition];

5. CREATE TABLE Clause:
   Creates a new table.
   Syntax: CREATE TABLE table_name (
              column1 datatype [constraint],
              column2 datatype [constraint],
              ...
           );

6. ALTER TABLE Clause:
   Modifies an existing table structure.
   Syntax: ALTER TABLE table_name
           ADD (column_name datatype [constraint],
                MODIFY (column_name datatype),
                DROP COLUMN column_name);

7. DROP TABLE Clause:
   Deletes a table and its data.
   Syntax: DROP TABLE table_name;

8. CREATE INDEX Clause:
   Creates an index on a table.
   Syntax: CREATE INDEX index_name
           ON table_name (column_name);

9. DROP INDEX Clause:
   Deletes an index.
   Syntax: DROP INDEX index_name;

10. GRANT Clause:
    Provides privileges to users or roles.
    Syntax: GRANT privilege(s)
            ON object_name
            TO user_or_role;

11. REVOKE Clause:
    Removes privileges from users or roles.
    Syntax: REVOKE privilege(s)
            ON object_name
            FROM user_or_role;

12. COMMIT Clause:
    Saves changes made in the current transaction.
    Syntax: COMMIT;

13. ROLLBACK Clause:
    Reverts changes made in the current transaction.
    Syntax: ROLLBACK;

14. CREATE VIEW Clause:
    Creates a virtual table based on a SELECT statement.
    Syntax: CREATE VIEW view_name AS
            SELECT column1, column2, ...
            FROM table_name
            [WHERE condition];

15. CREATE SEQUENCE Clause:
    Creates a sequence object.
    Syntax: CREATE SEQUENCE sequence_name
            START WITH start_value
            INCREMENT BY increment_value
            [MINVALUE min_value]
            [MAXVALUE max_value]
            [CYCLE | NOCYCLE];

16. CREATE PROCEDURE Clause:
    Creates a stored procedure.
    Syntax: CREATE PROCEDURE procedure_name
            (parameter_list)
            AS
            BEGIN
              SQL statements;
            END;

17. ALTER SESSION Clause:
    Sets session-specific options.
    Syntax: ALTER SESSION SET parameter_name = value;

18. ALTER SYSTEM Clause:
    Modifies database-wide settings.
    Syntax: ALTER SYSTEM SET parameter_name = value;

19. CONNECT BY Clause:
    Specifies hierarchical queries.
    Syntax: SELECT column1, column2, ...
            FROM table_name
            START WITH condition
            CONNECT BY PRIOR column = parent_column;

20. MERGE Clause:
    Combines INSERT, UPDATE, and DELETE operations.
    Syntax: MERGE INTO target_table
            USING source_table
            ON (join_condition)
            WHEN MATCHED THEN
              UPDATE SET column1 = value1, column2 = value2, ...
            WHEN NOT MATCHED THEN
              INSERT (column1, column2, ...)
              VALUES (value1, value2, ...);

21. WITH Clause (Common Table Expressions):
    Defines temporary result sets for use within a larger query.
    Syntax: WITH cte_name AS (
              SELECT column1, column2, ...
              FROM table_name
              WHERE condition
           )
           SELECT column1, column2, ...
           FROM cte_name
           [JOIN other_table ON condition];

22. UNION Clause:
    Combines result sets of two or more SELECT statements.
    Syntax: SELECT column1, column2, ...
            FROM table1
            UNION
            SELECT column1, column2, ...
            FROM table2;

23. CASE Clause:
    Provides conditional logic within a query.
    Syntax: SELECT column1,
                  CASE
                    WHEN condition1 THEN result1
                    WHEN condition2 THEN result2
                    ELSE default_result
                  END AS new_column
            FROM table_name;

24. WINDOW Functions:
    Perform calculations across a set of table rows that are related to the current row.
    Syntax: SELECT column1, column2, ...,
                  AVG(column1) OVER (PARTITION BY column2 ORDER BY column3 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS avg_value
            FROM table_name;

25. ANALYTIC Functions:
    Calculate values from a group of rows and return a single result for each row.
    Syntax: SELECT column1, column2, ...,
                  ROW_NUMBER() OVER (PARTITION BY column1 ORDER BY column2) AS row_num
            FROM table_name;

26. LISTAGG Function:
    Concatenates values from multiple rows into a single string.
    Syntax: SELECT department,
                  LISTAGG(employee_name, ', ') WITHIN GROUP (ORDER BY hire_date) AS employees
            FROM employees
            GROUP BY department;
===============================================================================================================================

-- Aggregate Functions --

1. AVG():
   Calculates the average value of a numeric column.
   Syntax: SELECT AVG(column_name) FROM table_name;

2. SUM():
   Calculates the sum of values in a numeric column.
   Syntax: SELECT SUM(column_name) FROM table_name;

3. MIN():
   Retrieves the minimum value in a column.
   Syntax: SELECT MIN(column_name) FROM table_name;

4. MAX():
   Retrieves the maximum value in a column.
   Syntax: SELECT MAX(column_name) FROM table_name;

5. COUNT():
   Counts the number of rows in a table or the number of times a value appears in a column.
   Syntax: SELECT COUNT(*) FROM table_name;
           SELECT COUNT(column_name) FROM table_name;

6. COUNT(DISTINCT):
   Counts the number of distinct values in a column.
   Syntax: SELECT COUNT(DISTINCT column_name) FROM table_name;

7. GROUPING Functions (GROUP BY Clause):
   Used with GROUP BY to group rows and apply aggregate functions.
   Syntax: SELECT column1, aggregate_function(column2)
           FROM table_name
           GROUP BY column1;

8. LISTAGG():
   Concatenates values from multiple rows into a single string.
   Syntax: SELECT LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY column_order)
           FROM table_name
           GROUP BY grouping_column;

9. MEDIAN():
   Calculates the median value in a set of values.
   Syntax: SELECT MEDIAN(column_name) WITHIN GROUP (ORDER BY column_order)
           FROM table_name;

10. STDDEV() and STDDEV_POP():
    Calculate the standard deviation of a set of values.
    Syntax: SELECT STDDEV(column_name) FROM table_name;
            SELECT STDDEV_POP(column_name) FROM table_name;

11. VARIANCE() and VAR_POP():
    Calculate the variance of a set of values.
    Syntax: SELECT VARIANCE(column_name) FROM table_name;
            SELECT VAR_POP(column_name) FROM table_name;

===============================================================================================================================

-- Data Types --

1. Numeric Data Types:
   - NUMBER(precision, scale)
   - INTEGER
   - FLOAT(precision)
   - REAL
   - DOUBLE PRECISION
   - DECIMAL(precision, scale)

2. Character String Data Types:
   - CHAR(size)
   - VARCHAR2(size)
   - VARCHAR(size)
   - NVARCHAR2(size)
   - NCHAR(size)
   - CLOB
   - NCLOB

3. Date and Time Data Types:
   - DATE
   - TIMESTAMP
   - TIMESTAMP WITH TIME ZONE
   - TIMESTAMP WITH LOCAL TIME ZONE
   - INTERVAL YEAR TO MONTH
   - INTERVAL DAY TO SECOND

4. Binary Data Types:
   - BLOB
   - BFILE
   - RAW(size)
   - LONG RAW

5. Large Object Data Types:
   - CLOB
   - NCLOB
   - BLOB

6. Miscellaneous Data Types:
   - BOOLEAN
   - XMLType
   - ROWID
   - UROWID

7. Composite Data Types:
   - RECORD
   - TABLE
   - VARRAY

8. Spatial Data Types:
   - GEOMETRY
   - GEOGRAPHY
   - POINT
   - LINESTRING
   - POLYGON
   - ...

9. User-Defined Types (UDTs):
   - OBJECT
   - REF
   - VARRAY
   - NESTED TABLE
   - ...

10. Collection Types:
    - VARRAY
    - Nested Table
    - Associative Arrays

11. JSON Data Types:
    - JSON
    - JSON_ARRAY
    - JSON_OBJECT

===============================================================================================================================
-- Operators --

1. Arithmetic Operators:
   - Addition: +
   - Subtraction: -
   - Multiplication: *
   - Division: /
   - Modulus (Remainder): %

2. Comparison Operators:
   - Equal to: =
   - Not equal to: <>
   - Greater than: >
   - Less than: <
   - Greater than or equal to: >=
   - Less than or equal to: <=
   - IS NULL
   - IS NOT NULL
   - BETWEEN ... AND ...
   - LIKE
   - IN
   - EXISTS

3. Logical Operators:
   - AND
   - OR
   - NOT

4. Bitwise Operators:
   - Bitwise AND: &
   - Bitwise OR: |
   - Bitwise XOR: ^
   - Bitwise NOT: ~

5. Assignment Operators:
   - Assignment: =
   - Add and assign: +=
   - Subtract and assign: -=
   - Multiply and assign: *=
   - Divide and assign: /=
   - Modulus and assign: %=

6. Concatenation Operator:
   - Concatenation: ||

7. Membership Operators (used with collections):
   - MEMBER OF
   - NOT MEMBER OF
   - SUBMULTISET OF
   - NOT SUBMULTISET OF
   - MULTISET EQUALS
   - MULTISET NOT EQUALS

8. Type Test Operators (used with collections and objects):
   - IS A SET
   - IS EMPTY
   - IS OF TYPE
   - IS UNDER (object inheritance)
   - REF()

9. Special Operators:
   - ROWID
   - ROWNUM
   - NEXTVAL (sequence)
   - CURRVAL (sequence)
   - PRIOR
   - CONNECT BY (hierarchical query)

10. JSON Operators (used with JSON data types):
    - JSON_VALUE
    - JSON_QUERY
    - JSON_TABLE
    - ...

11. Spatial Operators (used with spatial data types):
    - SDO_GEOM.SDO_DISTANCE
    - SDO_GEOM.SDO_INTERSECTION
    - ...

12. Text Search Operators (used with text and full-text search):
    - CONTAINS
    - CATSEARCH
    - MATCHES
    - ...


===============================================================================================================================
-- Example usage in one box for quick copy-paste:
SET LINESIZE 200
COLUMN FILE_ID FORMAT 999
COLUMN FILE_NAME FORMAT A50
COLUMN TABLESPACE_NAME FORMAT A15
COLUMN BYTES FORMAT 999,999,999
COLUMN AUTOEXTENSIBLE FORMAT A3

SELECT 
    FILE_ID,
    TABLESPACE_NAME,
    AUTOEXTENSIBLE,
    FILE_NAME,
    BYTES/1024/1024 AS SIZE_MB
FROM 
    DBA_DATA_FILES
ORDER BY 
    FILE_ID;

-- USER_***
SELECT * FROM USER_TABLES;
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_TAB_COLUMNS;
SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_SEQUENCES;

-- ALL_***
SELECT * FROM ALL_TABLES;
SELECT * FROM ALL_VIEWS;
SELECT * FROM ALL_INDEXES;
SELECT * FROM ALL_TAB_COLUMNS;
SELECT * FROM ALL_CONSTRAINTS;
SELECT * FROM ALL_TAB_PRIVS;
SELECT * FROM ALL_SEQUENCES;

-- DBA_***
SELECT * FROM DBA_TABLES;
SELECT * FROM DBA_VIEWS;
SELECT * FROM DBA_INDEXES;
SELECT * FROM DBA_TAB_COLUMNS;
SELECT * FROM DBA_CONSTRAINTS;
SELECT * FROM DBA_TAB_PRIVS;
SELECT * FROM DBA_USERS;
SELECT * FROM DBA_ROLES;
SELECT * FROM DBA_SYS_PRIVS;
SELECT * FROM DBA_TAB_PRIVS;
SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_TS_QUOTAS;
SELECT * FROM DBA_SEQUENCES;

-- CDB_***
SELECT * FROM CDB_TABLES;
SELECT * FROM CDB_VIEWS;
SELECT * FROM CDB_INDEXES;
SELECT * FROM CDB_TAB_COLUMNS;
SELECT * FROM CDB_CONSTRAINTS;
SELECT * FROM CDB_USERS;
SELECT * FROM CDB_ROLES;
SELECT * FROM CDB_PDBS;
SELECT * FROM CDB_SERVICES;

-- V$***
SELECT * FROM V$DATABASE;
SELECT * FROM V$INSTANCE;
SELECT * FROM V$SESSION;
SELECT * FROM V$PROCESS;
SELECT * FROM V$DATAFILE;
SELECT * FROM V$TABLESPACE;
SELECT * FROM V$TEMPFILE;
SELECT * FROM V$LOG;
SELECT * FROM V$CONTROLFILE;
SELECT * FROM V$ARCHIVED_LOG;
SELECT * FROM V$SGA;
SELECT * FROM V$PGASTAT;
SELECT * FROM V$PARAMETER;
SELECT * FROM V$SQL;
SELECT * FROM V$SESSION_LONGOPS;

-- SHOW Commands
SHOW PARAMETER control_files;
SHOW PARAMETER db_name;
SHOW PARAMETER instance_name;
SHOW PARAMETER service_names;
SHOW PARAMETER db_block_size;
SHOW PARAMETER open_cursors;
SHOW PARAMETER sessions;
SHOW PARAMETER processes;
SHOW PARAMETER sga_target;
SHOW PARAMETER pga_aggregate_target;
SHOW SGA;
SHOW PGA;
SHOW USER;
SHOW ALL;
SHOW ERROR;

===============================================================================================================================
-- USER Views
SELECT view_name
FROM user_views
WHERE view_name LIKE 'USER%'
ORDER BY view_name;

-- ALL Views
SELECT view_name
FROM all_views
WHERE view_name LIKE 'ALL%'
ORDER BY view_name;

-- DBA Views
SELECT view_name
FROM dba_views
WHERE view_name LIKE 'DBA%'
ORDER BY view_name;

-- CDB Views
SELECT view_name
FROM cdb_views
WHERE view_name LIKE 'CDB%'
ORDER BY view_name;

-- V$ Views
SELECT view_name
FROM v$fixed_view_definition
WHERE view_name LIKE 'V$%'
ORDER BY view_name;

-- SHOW PARAMETER Commands

SELECT name, value
FROM v$parameter
ORDER BY name;

SHOW PARAMETER control_files;
SHOW PARAMETER db_name;
SHOW PARAMETER instance_name;
SHOW PARAMETER service_names;
SHOW PARAMETER db_block_size;
SHOW PARAMETER open_cursors;
SHOW PARAMETER sessions;
SHOW PARAMETER processes;
SHOW PARAMETER sga_target;
SHOW PARAMETER pga_aggregate_target;
SHOW PARAMETER undo_tablespace;
SHOW PARAMETER compatible;
SHOW PARAMETER log_archive_dest;
SHOW PARAMETER log_archive_format;
SHOW PARAMETER remote_login_passwordfile;
SHOW PARAMETER memory_target;
SHOW PARAMETER db_create_file_dest;
SHOW PARAMETER db_recovery_file_dest;
SHOW PARAMETER db_files;
SHOW PARAMETER audit_trail;
SHOW PARAMETER global_names;
SHOW PARAMETER job_queue_processes;
SHOW PARAMETER optimizer_mode;
SHOW PARAMETER shared_pool_size;
SHOW PARAMETER cursor_sharing;
SHOW PARAMETER statistics_level;
SHOW PARAMETER timed_statistics;
SHOW PARAMETER undo_management;
SHOW PARAMETER workarea_size_policy;
SHOW SGA;
SHOW PGA;
SHOW USER;
SHOW ALL;
SHOW ERROR;
===============================================================================================================================

-- CREATE TABLE employees (
--    employee_id NUMBER PRIMARY KEY,
--    first_name VARCHAR2(50),
--    last_name VARCHAR2(50),
--    email VARCHAR2(100),
--    phone_number VARCHAR2(20),
--    hire_date DATE,
--    job_id VARCHAR2(10),
--    salary NUMBER(8, 2),
--    manager_id NUMBER,
--    department_id NUMBER
--);

--select * from employees;

--if only i created a table ther have not data than use this code to isert data in table
--ALTER TABLE employees ADD (employee_id NUMBER PRIMARY KEY);
--ALTER TABLE employees ADD (first_name VARCHAR2(50));
--ALTER TABLE employees ADD (last_name VARCHAR2(50));
--ALTER TABLE employees ADD (email VARCHAR2(100));
--ALTER TABLE employees ADD (phone_number VARCHAR2(20));
--ALTER TABLE employees ADD (hire_date DATE);
--ALTER TABLE employees ADD (job_id VARCHAR2(10));
--ALTER TABLE employees ADD (salary NUMBER(8, 2));
--ALTER TABLE employees ADD (manager_id NUMBER);
--ALTER TABLE employees ADD (department_id NUMBER);
--ALTER TABLE employees ADD (password VARCHAR2(50));


--insert data used this AI - https://gemini.google.com/app/d60bacc1309f666d

--INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
--VALUES (1, 'Shahanwaj', 'Aalam', 'shahanwaj@example.com', '+911234567890', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 'IT_PROG', 45000.00, 100, 20);
--
--INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
--VALUES (2, 'Firoj', 'Khan', 'firoj@example.com', '+919876543210', TO_DATE('2022-06-15', 'YYYY-MM-DD'), 'SALES', 50000.00, 100, 30);
--
--INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
--VALUES (3, 'Syed', 'Salim', 'syed@example.com', '+918523147690', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'HR', 40000.00, 101, 20);

--update cmd use

--UPDATE employees
--SET phone_number = '+9161664204'
--WHERE first_name = 'Shahnawaj' AND last_name = 'Aalam' AND phone_number = '+911234567890';


--inset data used chatgpt but not worked this is code 

--INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
--VALUES
--    (1, 'Shahnwaj', 'Aalam', 'shahnwaj@example.com', '123-456-7890', TO_DATE('2024-05-26', 'YYYY-MM-DD'), 'JR001', 50000.00, NULL, 100),
--    (2, 'Firoj', 'Khan', 'firoj@example.com', '987-654-3210', TO_DATE('2024-05-27', 'YYYY-MM-DD'), 'JR002', 55000.00, 1, 100),
--    (3, 'Syed', 'Salim', 'salim@example.com', '555-555-5555', TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'JR003', 60000.00, 2, 200);


--for example to know how to create table 
--CREATE TABLE employees (
--    employee_id NUMBER PRIMARY KEY,                  -- Numeric primary key
--    first_name VARCHAR2(50),                         -- Variable-length string for first names
--    middle_initial CHAR(1),                          -- Fixed-length string for middle initial
--    last_name VARCHAR2(50),                          -- Variable-length string for last names
--    email VARCHAR2(100) UNIQUE NOT NULL,             -- Unique and not null string for email addresses
--    phone_number VARCHAR2(20),                       -- Variable-length string for phone numbers
--    age INTEGER,                                     -- Integer for age
--    hire_date DATE DEFAULT SYSDATE,                  -- Date with default value
--    job_id VARCHAR2(10) NOT NULL,                    -- Variable-length string for job identifiers
--    salary NUMBER(8, 2) CHECK (salary > 0),          -- Numeric with check constraint
--    profile_picture BLOB,                            -- Binary large object for profile pictures
--    article_content CLOB,                            -- CLOB for storing article content
--    last_updated TIMESTAMP,                          -- Timestamp for when the record was last updated
--    latitude FLOAT,                                  -- Float for geographical latitude
--    FOREIGN KEY (job_id) REFERENCES jobs(job_id)     -- Foreign key constraint
--);
===============================================================================================================================
-- chat GPT help -
-- oracle help - 
desc dba_tables;
select table_name from dba_tables;
select * from employee;

desc v$database;
SELECT * FROM v$diag_info WHERE name = 'Diag Trace';
SELECT directory_name, directory_path FROM dba_directories;
===============================================================================================================================
show pdbs;
SELECT CDB FROM V$DATABASE;
SELECT pdb_name, status FROM dba_pdbs;

ALTER PLUGGABLE DATABASE pdb_name OPEN;

ALTER SESSION SET CONTAINER = PDB$SEED;
ALTER PLUGGABLE DATABASE PDB$SEED CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE PDB$SEED OPEN READ WRITE;
ALTER SESSION SET CONTAINER = PDB$SEED;


SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_DATA_FILES;
SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES;
SELECT PDB_ID, PDB_NAME, FILE_NAME_CONVERT FROM DBA_PDBS;
===============================================================================================================================
-- Create the tabelscpece_name and datafile and define size
SELECT tablespace_name FROM dba_tablespaces;

CREATE TABLESPACE users3 
DATAFILE 'users03.dbf' 
SIZE 100M 
AUTOEXTEND ON 
NEXT 10M 
MAXSIZE UNLIMITED;

SELECT file_name, tablespace_name
FROM dba_data_files
WHERE tablespace_name = 'USERS2';
===============================================================================================================================
-- Create the user with provided parameters
CREATE USER new_schema2 IDENTIFIED BY password
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;
===============================================================================================================================
-- Give the grand and PRIVILEGES of user base on role an resposbilities
GRANT CONNECT, RESOURCE TO new_schema;
GRANT CREATE TABLE TO new_schema;
GRANT CREATE VIEW TO new_schema;
GRANT CREATE PROCEDURE TO new_schema;
GRANT CREATE SEQUENCE TO new_schema;

GRANT CONNECT, RESOURCE, CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE TO new_schema;

GRANT ALL PRIVILEGES TO new_schema;
GRANT DBA TO new_schema;
REVOKE ALL PRIVILEGES FROM new_schema;

FROM dba_sys_privs
FROM dba_tab_privs
FROM dba_role_privs
FROM dba_users;

SELECT grantee, privilege 
FROM dba_sys_privs 
WHERE grantee = 'USERNAME';

SELECT * FROM DBA_SYS_PRIVS;
SELECT * FROM DBA_TAB_PRIVS;
SELECT * FROM DBA_ROLE_PRIVS;

SELECT * FROM dba_ts_quotas WHERE username = 'new_schema';

SELECT grantee, owner, table_name, privilege 
FROM dba_tab_privs 
WHERE grantee = 'new_schema';

SELECT grantee, privilege 
FROM dba_sys_privs;

SELECT username, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'NEW_SCHEMA1';

SELECT username FROM dba_users WHERE username = 'NEW_SCHEMA'; 
-------------------------------------------------------------
ALTER SESSION SET CONTAINER = PDB$SEED;

GRANT CREATE TABLE TO new_schema;
ALTER USER new_schema QUOTA UNLIMITED ON users;

show user;

------------------------------------------------
SELECT name, open_mode FROM v$database;

CREATE DATABASE CDB1
USER SYS IDENTIFIED BY oracle
USER SYSTEM IDENTIFIED BY oracle
ENABLE PLUGGABLE DATABASE;

SELECT name, open_mode FROM v$database;
select name,CON_ID,open_mode from v$pdbs;
desc v$pdbs;
show pdbs;
show user;
desc v$tablespace;

Datafiles
---------------
SELECT tablespace_name, file_name
FROM dba_data_files;

tablespaces
--------------
SELECT tablespace_name, status, contents, logging, block_size
FROM dba_tablespaces;

SELECT file#, name, status
FROM v$datafile;

--------------------------------------------------------
find all important loaction of oracle database
-------------------------------------------------------
-- Connect to the database as SYSDBA
sqlplus sys as sysdba

-- Find control file locations
SELECT name FROM v$controlfile;

-- Find redo log file locations
SELECT member FROM v$logfile;

-- Find all tablespaces
SELECT tablespace_name FROM dba_tablespaces;

-- Find datafile locations for tablespaces
SELECT tablespace_name, file_name FROM dba_data_files;

-- Find temporary tablespace file locations
SELECT tablespace_name, file_name FROM dba_temp_files;

-- Find archive log file locations
SELECT name FROM v$archived_log;

-- Find shared pool and other SGA information
SELECT * FROM v$sga;

---------------------------------------------
-- Connect to the database as SYSDBA
sqlplus sys as sysdba

-- Get information about the shared pool
SELECT * FROM v$sgastat WHERE pool = 'shared pool';

-- Get information about the Java pool
SELECT * FROM v$sgastat WHERE pool = 'java pool';

-- Get information about the large pool
SELECT * FROM v$sgastat WHERE pool = 'large pool';

-- Get information about the streams pool
SELECT * FROM v$sgastat WHERE pool = 'streams pool';

-- Get overall SGA information
SELECT * FROM v$sga;

-- Get detailed SGA component information
SELECT * FROM v$sgainfo;
------------------------------------------------------

select * from v$sgastat where pool ='java pool';
--------------------------------------------------------

SELECT status FROM v$instance;
shutdown immediate;
startup mount;
ALTER PLUGGABLE DATABASE pdb_name OPEN;


@ C:\Oracle\WINDOWS.X64_193000_db_home\rdbms\xml\schema\db-sample-schemas-21.1\human_resources\hr_main.sql

-- PDBS conncet and conncet wtih schema means users;

# Connect to the CDB as SYSDBA
sqlplus sys as sysdba

# Switch to the PDB `pdbtest`
ALTER SESSION SET CONTAINER = pdbtest;

# Change the password for the user `hr`
ALTER USER hr IDENTIFIED BY new_password;

# Verify the password change by connecting as `hr` with the new password
CONNECT hr/new_password@pdbtest;

===============================================================================================================================
```
--------------------------------------------------------------------------------------------------------

```sh


 
 
 ORACLE OBA ADMIN - SHEAT SHEET 
 ==================================================================================== 
 https://youtu.be/gXJhYjBDRk 
 
 RMAN Backup 
 consistent backup - cold backup - when database is offline 
 inconsistent backup - hot backup - when deatabase is online 
 
 full backup - mean all backup 
 incremental backup - mean day by day backup 
 ---------------------------------------------  
 , Database utility 
 , Day to day task and quries of oracle Database 
 , Overview of SQL Statements 
 
 oracle site 
 v$session 
 Database/Oracle/Oracle/DatabaseRelease//Database Reference 
 https://docs.oracle.com/en/database/oracle/oracle-database//refrn/VSESSION.html#GUID-EDC-E-CA-AB-CB 
 
 cl scr = for clear sql Terminal 
 ---------------------------------  
 Data Guard - Standby= clone of production database we called standby 
 (production database call primary database) and (copy of database call standby 
database) 
 
  types of standby 
 ==================  physical, = block by block copy of primary database 
 logiacl, not same replica of primary it has (separate DB ID) use for analysis 
purpose 
 snapshot use for test purpose of app which features called flashback create 
restore point use DML 
 
 DB Link= Access and manipulate objects on a remote database. 
 TNS = Transparent Network Substrate - TNSNAMES.ORA -
 
 Rack= one database multiple instance 
 ASM and cluster software manage nad multiple host put together 
 
 ASM = Automatic Storage Management 
 Patching= patch is progaram which made by softwaer to resolve the bugs, 
vul•ner•abil•ity, problam of software 
 row device= 
 cluster file system= 
 
 ========= 
 show user; 
 conn/ as sysdba; 
 conn usrname 
 enter passowrd 
 ===================  
 Tablespace is logiacl contaner 
 =================================== 
 Extents> Tbalespace >Segments> Extents> Data blocks by difault block create  
kB 
 but we can make , , , ,  kb 
 
 (Datafile max increase size gb) 
 
 ============================================ 
 
 Tablespace Quota : 
 You can specify a limit onto how much tablespace quota (size) a user can use 
 
 create user 
 what have privlage of users? if nothing use grant CMD ---
 grant 
 
 
 set linesize  
 set page  
 col (filename) for a 
 
 set oracle_sid=orclc 
 SQL> archive log list; 
 
 ========================= 
 id 
 uptime 
 lsnrctl status 
 cat /etc/hostname 
 cat/etc/oratab 
 cat/tmp/init.ora 
 
 ps -ef grep pmon 
 ps -ef grep ora 
 
 . oraenv 
 aqlplus / as sysdba 
 startup 
 ====================== 
 
 select username from all_users; 
 alter user username identified by password; 
 grant dba to system; 
 
 desc dba_tables; 
 desc v$database; 
 desc v$tablespace; 
 desc v$datafile; 
 desc v$controlfile; 
 desc v$logfile; 
 desc v$session; 
 desc v$processes; 
 desc v$instance; 
 desc v$bgprocess; 
 
 select *from v$pwfile_users; II show the who have permisson of sysdba; 
 
 select count(*) from v$bgprocess; 
 
 all information of SGA 
 ========================== 
 select *from v$sgainfo; 
 Show sga; 
 desc v$sga; 
 
 desc dba_directories; 
 desc dba_data_files; 
 desc dba_users; 
 select OPEN_MODE, CURRENT_SCN from v$database; 
 
 show parameter db_recover 
 select *from v$database; 
 
 ============================== 
 Awr, Ash and addm report 
 ============================== 
 
 Oracle ADDM, AWR, ASH Reports 
 
 Using ADDM AWR ASH Reports . ADDM is diagnostic software built into Oracle Database . 
 
 
ADDM examines and analyzes data captured in Automatic Workload Repository (AWR) to 
determine possible database performance problems. Automatic Database Diagnostic 
Monitor ( ADDM) can analyze performance issues during a particular period and 
provide suggestion. 
 (AWR)- Automatic Workload Repository 
 (ADDM)- Automatic Database Diagnostic Monitor 
 (ASH)- (Active Session History) 
 
 
 ================================== 
 Datapump 
 ================================= 
 
 Create Data Pump Directory: 
 ========================== 
 l)The first step in Oracle Data Pump is to create an OS level directory which will 
be used by Oracle for performing exports and imports. Create directory at OS level 
 $ mkdir - p /u/dp_exp_dir 
 )Create directory inside the database 
 SQL> create directory datapump as '/u/dp_exp_dir'; 
 a.)Grant permissions on directory 
 SQL> grant read,write on directory datapump to scott; 
 )View directory information 
 SQL> select* from dba_directories; 
 )Get help on expdp or impdp utility 
 $ expdp help=y 
 $ impdp help=y 
 
 
 
 A)Table Export and Import: 
 ============================  
 l)Take table level export 
 $ expdp directory=datapump dumpfile=emp_bkp .dmp logfile=emp_bkp.log 
tables='SCOTT. EMP' 
 
 )Import table where source and target schema are same 
 $ impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP' 
 
 )Import table to another schema 
 $ impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp.log tables='EMP' 
remap_schema= ' SCOTT :HR' 
 
 )Import tables to another tablespace (only in datapump) 
 $ impdp directory=datapump dumpfile=emp_bkp .dmp logfile=imp_emp . log tables='EMP ' 
remap_schema='SCOTT :HR' remap_tablespace='USERS:MYTBS' 
 
 )Import table to a different name or rename table or remap_table 
 $ impdp directory=datapump dumpfile=emp_bkp.dmp logfile=imp_emp . log tables='EMP' 
remap_table='SCOTT.EMP:HR.EMPLOYEE' 
 
 )Import only the rows from an exported table without loading table any table 
definitions 
 $ impdp directory=datapump dumpfile=emp_bkp .dmp logfile=imp_emp . log tables= ' EMP ' 
content=DATA_ONLY 
 
 
 B)Schema Export and Import: 
 ============================  
 l)Take schema level export 
 $ expdp directory=datapump dumpfile=scott_bkp .dmp logfile=scott_bkp .log 
schemas='SCOTT' 
 )Import source schema objects into same schema on target 
 $ impdp directory=datapump dumpfile=scott_bkp .dmp logfile=imp_schema .log 
remap_schema='SCOTT :SCOTT' 
 )Import source schema objects into a different schema on target 
 $ impdp directory=datapump dumpfile=scott_bkp .dmp logfile=imp_schema.log 
remap_schema= ' SCOTT :HR' 
 
 
 C)Rows Export and Import: 
 =========================  l)Take row level export 
 $ expdp directory=datapump dumpfile=emprows_bkp.dmp logfile=emprows_bkp.log 
tables='SCOTT.EMP' query=\"where deptno=\" 
 )Import rows where source and target schema are same 
 $ impdp directory=datapump dumpfile=emprows_bkp . dmp logfile=imp_emprows. log 
tables='SCOTT.EMP' 
 
 
 D)Database Export and Import: 
 =============================  
 l)Take database level export 
 $ expdp directory=datapump dumpfile=fullprod.dmp logfile=fullprod.log full=y 
 )Import full database 
 
 -- On source 
 SQL> select name from v$tablespace; 
 
 -- On target 
 SQL> select name from v$tablespace; 
 
 Create missing tablespaces on target 
 Make sure target tablespace has enough free space 
 
 $ impdp directory=datapump dumpfile=fullprod.dmp logfile=imp_fullprod.log full=y 
 
 
 Data Pump Import over Network: 
 ==============================  
 When you try to move large tables or schema between two Oracle databases, datapump 
export might take lot of disk space. 
 The exported dump files may take lot of space on the disk. The best workaround is to 
use dblink with Oracle datapump to move data 
 from one oracle database to another. 
 
 Note: when you use datapump with dblink, there are no dumpfiles created on source. 
The data is transferred from one database to another over network 
 
 Add source database TNS entry into tnsnames.ora of the target database 
 
 devdb = 
 (DESCRIPTION 
 (ADDRESS_LIST 
 (ADDRESS= (PROTOCOL TCP)(HOST ...)(PORT )) 
 
 
) 
(CONNECT_DATA = 
 (SERVICE_NAME 
 ) 
 ) 
devdb) 
 On target, we need to create a database link using the TNS entry created above 
 
 create database link SOURCE_DB connect to scott identified by tiger using 'devdb'; 
 
 Database link created. 
 It's time to import source schema on target database via db link. Run below command 
on target database to start import 
 
 SQL> SQL> create or replace directory MY_DUMP_DIR as'/u/dump_files'; 
 
 impdp directory=MY_DUMP_DIR LOGFILE=dblink_transfer.log 
 network_link=SOURCE_DB remap_schema=scott:hr 
 To import multiple schemas, make sure to use a DBA user (sys) to perform this action 
 
 impdp sys directory=MY_DUMP_DIR LOGFILE=dblink_transfer.log 
 network_link=SOURCE_DB schemas=IJS,scott,hr 
 
 
 Data Pump Performance Tuning 
 
 You can always use DIRECT=y parameter to perform faster exports and imports. You can 
also use PARALLEL parameter to start multiple export and import process for faster 
performance. 
 
 Make sure to use %U with the dumpfile name so multiple dumpfiles can be read/write 
simultaneously 
 expdp directory=DUMP_DIR dumpfile=SCOTT_%U.dmp logfile=expdp_SCOTT.log schemas=SCOTT 
parallel= 
 
 impdp directory=DUMP_DIR dumpfile=SCOTT_%U.dmp logfile=impdp_SCOTT.log schemas=SCOTT 
parallel= 
 
 
 EXPDP PAR File Example 
 
 Data Pump jobs can be automated using PAR file. You basically create one par file 
which contains all the export or import parameters and just call the par file at 
expdp utility 
 
 vi exp.par 
 
 Username=scott/tiger 
 tables=scott.emp 
 directory=EXP_DIR 
 dumpfile=QUERY_EXP.dmp 
 logfile=QUERY_EXP .log 
 parallel= 
 And! Its very simple to call the above export PAR file 
 
 expdp parfile=exp.par 
 You can specify any extension but it is recommended to use .par 
 
 
 Schedule Data Pump Export in crontab: 
 =====================================  
 Create a file which contains expdp script 
 
 vi daily_export.sh 
 
 export DATE=$(date +%m_%d_%y_%H_%M) 
 export ORACLE_SID=orcl 
 export ORACLE_HOME=/u/app/oracle/product/../db_ 
 
 $RACLE_HOME/bin/expdp username/password@sid directory=export_dir 
dumpfile=backup_$DATE.dmp logfile=backup_$DATE.log full=y 
 Give permissions to execute on above file 
 
 chmod  daily_export.sh 
 Schedule export under crontab 
 
 crontab -e -u oracle 
 
 ***/home/oracle/backup_script 
 
 
 Data Pump Export Progress% 
 ===========================  
 When you run a data pump export in the background and want to know the progress 
status, use below query to get the percentage(%) completion of the export process 
 
 SELECT SID, SERIAL#, USERNAME, CONTEXT, SOFAR, 
 
TOTALWORK, ROUND(SOFAR/TOTALWORK *, ) "%_COMPLETE"FROM V$SESSION_LONGOPS WHERE 
TOTALWORK !=  AND SOFAR <> TOTALWORK; 
 ===================================== 
 Export-Import Utility 
 -------------------------------------  
 Physical backup 
 cloning of database .. . 
 restore database, recover, backup, full backup, incremental backup. 
 
 -------------------  RMAN --
 
 conncet target/ enter 
 Rman> report schema; 
 Rman> list backup; 
 
 Full backup 
 Incremental backup 
 
 consistent backup= shutdown normal, shutdown immediate mode 
 inconsistent backup= runing and open mode when we take backup and also need to be 
database in archive log mode 
 
 Hot backup= should be up and running mode 
 cold backup= in cold backup datbase should be down 
 
 
 
 logical backup 
 
 
 
 Oracle Export 
 ====================== 
 l)To know options of export 
 $ exp help=y 
 )To take full database level export 
 $ exp file=/u/fullbkp_prod.dmp log=/u/fullbkp_prod.log full=y 
 )To take schema level export 
 $ exp file=/u/scott_bkp.dmp log=/u/scott_bkp.log owner='SCOTT' 
 )To take table level export  
 $ exp file=/u/emp_bkp.dmp log=/u/emp_bkp.log 
tables='SCOTT.EMP', 'SCOTT.DEP' , .. • 
 )To take row level export 
 $ exp file=/u/emp_rows_bkp.dmp log=/u/emp_rows.log tables='SCOTT.EMP• 
query=\"where deptno=\ " 
 
 scp file.dmp oracle@...:file_location 
 
 
 Oracle Import 
 ====================== 
 l)To know options of import 
 $ imp help=y 
 )To import full database 
 $ imp file=/u/fullprod.dmp log=/u/imp_fullprod.log full= y 
 )To import a schema 
 $ imp file=/u/scott_bkp.dmp log=/u/imp_schema.log fromuser='SCOTT' 
touser='SCOTT• 
 )To import a table 
 $ imp file=/u/emp_bkp.dmp log=/u/imp_emp.log fromuser='SCOTT' touser='SCOTT' 
tables='EMP' 
 )To import a table to another user 
 $ imp file=/u/emp_bkp.dmp log=/u/imp_emp.log fromuser='SCOTT' touser='SYSTEM' 
tables='EMP' 
 
 ---------------------------------  
 
 
Roles,User,Profile Management 
 Oracle User Management 
 --------------------------  l)To check all users inside database : 
 SQL> select username, account_status, default_tablespace from dba_users; 
 
 )To check current user: 
 SQL> show user; 
 
 )To Lock/ Unlock user: 
 SQL> alter user scott account unlock; 
 SQL> alter user scott account lock; 
 
 )To Create new user 
 SQL> create user usrl identified by usrl; 
 
 )To create new user by assigning a default tablespace : 
 SQL> create user usr identified by usr default tablespace users; 
 
 )To change user password: 
 SQL> alter user usrl identified by oracle; 
 
 )Check Database Default Tablespace: 
 When you create a new user without specifying a default tablespace, database 
default tablespace is assigned to the user. 
 SQL>select PROPERTY_NAME, PROPERTY_VALUE from database_properties where 
PROPERTY_NAME like '%DEFAULT%'; 
 
 )Change User Default Tablespace: 
 SQL> alter user usrl default tablespace example; 
 Note: The objects created in the old tablespace remain unchanged even after 
changing a default tablespace for a user 
 
 )Tablespace Quota: 
 You can specify a limit onto how much tablespace quota (size) a user can use 
 SQL> Alter user usrl quota M on users; 
 Note: Allocating quota doesn't represent reserving the space . If  or more users 
are sharing a tablespace, quota will be filled up in first come first serve basis 
 
 )Drop user: 
 SQl> drop user usrl;--no object created by user 
 SQL> drop user usrl cascade;---when own some object 
 
 Roles in Oracle 
 ===============  l)When you create a new user, you must at least assign CREATE SESSIONS privilege so 
the user can connect to the database : 
 SQL>grant create session to usrl; 
 SQL>grant connect, resource to usrl; 
 SQL>revoke connect, resource to usrl; 
 
 When you work in real-time, there are more than one permission which must be 
assigned to a user. Sometimes the list might be very big. For example, 
 there is a manager who must be able to perform: 
 Insert into EMP & DEPT table 
 Update DEPT table 
 Delete from BONUS table 
 Instead of giving above privileges to the user one by one, we can create a role 
inside the database. 
 We then assign all privileges to the role and then assign the role to a user. It 
makes your life easy! 
 
 }Create New Role: 
 SQL> CREATE ROLE SALES_MANAGER; 
 
 }Grant Privileges to Role : 
 Assign all the privileges to the role NOT THE USER 
 SQL> GRANT INSERT ON SCOTT.EMP TO SALES_MANAGER; 
 SQL> GRANT INSERT ON SCOTT.DEPT TO SALES_MANAGER; 
 SQL> GRANT UPDATE ON SCOTT.DEPT TO SALES_MANAGER; 
 SQL> GRANT DELETE ON SCOTT.BONUS TO SALES_MANAGER; 
 
 }Grant Role to a User: 
 Now that you have assigned all the necessary privileges to a role, its time to 
assign the role to a user 
 SQL> GRANT SALES_MANAGER TO USRl; 
 
 
 Profile Management in Oracle 
 ============================ 
 A profile is a way to control system resource that can be used by a database user. 
Profile management is of two types 
 *Password management 
 *Resource management 
 
 A}Password Management: 
 The password management allows a DBA to have more control over user passwords. 
Some of the parameters you might be familiar 
 in general like failed login attempts, password lock time etc 
 
 FAILED_LOGIN_ATTEMPTS: How many times a user can fail to login 
 PASSWORD_LOCK_TIME: Users who exceed failed login attempts, their password will be 
locked for specific time 
 PASSWORD_LIFE_TIME: Till when password is valid in days 
 PASSWORD_GRACE_TIME : Grace period for user to change password, else account will be 
locked 
 PASSWORD_REUSE_TIME: After how many days user can re-use same password 
 PASSWORD_REUSE_MAX: Specify how many times old password can be used 
 PASSWORD_VERIFY_FUNCTION: Defines rules for setting a new password 
 
 
 B)Resource Management: 
 Resource management helps in limiting the database abuse a user can cause. For 
example, if a user connects to database and never runs a query then this ideal 
connection will take system resources like CPU. To restrict such kind of issues, we 
have resource management parameters 
 
 SESSIONS_PER_USER : How many concurrent sessions user can open 
 IDLE_TIME: Total time user can stay inside database without doing any activity 
 CONNECT_TIME: Total time user can stay inside database whether idle of active 
 
 Note: resource management parameters will take in effect only if RESOURCE_LIMIT 
parameter is set to TRUE. 
 
 l}Use below command to check the RESOURCE_LIMIT parameter 
 SQL> show parameter resource_limit; 
 By default the parameter is set to FALSE. You can change it via below 
 SQL> alter system set resource_limit=TRUE scope=both; 
 
 }To create a new user profile 
 SQL> create profile my_profile limit 
 failed_login_attempts  
 password_lock_time  
 sessions_per_user  
 idle_time ; 
 Note: password lock time by default is for  day. You can specify it in minutes 
(n/} or even in seconds (n/} 
 
 }To assign profile to a user 
 SQL> alter user scott profile my_profile; 
 
 }To check profiles assigned to a user 
 SQL> SELECT USERNAME, PROFILE FROM DBA_USERS WHERE USERNAME='SCOTT'; 
 
 )To check profile parameter values 
 SQL> SELECT* FROM DBA_PROFILES WHERE PROFILE='&PROFILE_NAME'; 
 
 Note: sessions terminated because of idle time marked as SNIPPED in V$SESSION DBA 
need to manually kill the related OS proccess to clear the session. 
 )To kill a Session. 
 SQL> select sid,serial#,status from v$session where username ='SCOTT'; 
 SQL> Alter system kill session 'SID,SERIAL#' immediate; 
 
 
 Find User Permissions: 
 ----------------------------------  
 l)To check system privileges granted to a user 
 SQL>select privilege from dba_sys_privs where grantee='SCOTT'; 
 
 )To check object level privileges granted to a user or role 
 SQL> select owner, table_name, privilege from dba_tab_privs where 
grantee='SALES_CLERK'; 
 SQL> select* from session_privs 
 
 
 )To check roles assigned to a user 
 SQL>select granted_role from dba_role_privs where grantee='SCOTT'; 
 
 )To check permissions assigned to role 
 SQL>select privilege from role_sys_privs where role='SALES_CLERK'; 
 SQL>select owner, table_name, privilege from role_tab_privs where 
role='SALES_CLERK'; 
 
 )To check roles granted to another role 
 SQL> select granted_role from role_role_privs where role='SALES_CLERK'; 
 
 
 Tablespace Management 
 ======================================  
 Find Tablespace & Associated Data Files 
 
 
 Query V$TABLESPACE or DBA_TABLESPACES to find tablespaces inside a database: 
 =========================================================================== 
 
 SQL> select name from v$tablespace; 
 SQL> select tablespace_name from dba_tablespaces; 
 
 To find datafiles associated with tablespace: 
 SQL> select tablespace_name, file_name, bytes// from dba_data_files where 
tablespace_name='&tablespace_name'; 
 
 To find temp files associated with a temp tablespace: 
 SQL> select file_name, bytes//from dba_temp_files; 
 
 
 Find Tablespace Utilization : 
 ===========================  Use below query to find% used inside a tablespace 
 
 set colsep I 
 set linesize  pages  trimspool on numwidth  
 col name format a 
 col owner format a 
 col "Used (GB)" format a 
 col "Free (GB)" format a 
 col "(Used)%" format a 
 col "Size (M)" format a 
 SELECT d.status "Status", d.tablespace_name "Name", 
 TO_CHAR(NVL(a.bytes /  /  /, ), ',,.') "Size (GB)", 
 TO_CHAR(NVL(a.bytes - NVL(f.bytes, ), )// /, '.') "Used 
(GB)", 
 TO_CHAR(NVL(f.bytes /  /  /, ), ',,.') "Free (GB)", 
 TO_CHAR(NVL((a.bytes - NVL(f.bytes, )) /a.bytes* , ), '.') "(Used)%" 
 FROM sys.dba_tablespaces d, 
 (select tablespace_name, sum(bytes) bytes from dba_data_files group by 
tablespace_name) a, 
 (select tablespace_name, sum(bytes) bytes from dba_free_space group by 
tablespace_name) f WHERE 
 d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = f.tablespace_name(+) AND NOT 
 (d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY') 
 UNION ALL 
 SELECT d.status 
 "Status", d.tablespace_name "Name", 
 TO_CHAR(NVL(a.bytes /  /  /, ), ',,.') "Size (GB)", 
 TO_CHAR(NVL(t.bytes,)// /, '.') "Used (GB)", 
 TO_CHAR(NVL((a.bytes -NVL(t.bytes, )) /  /  /, ), ',,.') 
"Free (GB)", 
 TO_CHAR(NVL(t . bytes /a.bytes* , ), '.') "(Used)%" 
 FROM sys.dba_tablespaces d, 
 (select tablespace_name, sum(bytes) bytes from dba_temp_files group by 
tablespace_name) a, 
 (select tablespace_name, sum(bytes_cached) bytes from v$temp_extent_pool group by 
tablespace_name) t 
 WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name 
t.tablespace_name(+) AND 
 d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY'; 
 
 
 Create Tablespace 
 ================== 
 To create new tablespace inside database 
 SQL> Create tablespace test_tbs datafile '/u/test_tbs_.dbf' size m; 
 
 We can resuse the drop tablespace including all its contents: 
 SQL> Create tablespace test_tbs datafile '/u/test_tbs_.dbf' resuse; 
 
 Where, 
 test_tbs is the name of new tablespace 
 /u/test_tbs_.dbf is the location of the datafile 
 m is the size of the datafile 
 
 
 Add Space to Tablespace 
 ======================== 
 There are two ways to add space to a tablespace: 
 
 )Add new datafile 
 
 Before adding space, you must check OS level space. Never proceed without checking 
it 
 l)Resize existing datafile 
 SQL> Alter database datafile '/u/test_tbs_.dbf' resize m; 
 
 )Add new datafile 
 SQL> Alter tablespace test_tbs add datafile '/u/test_tbs_.dbf' size m; 
 
 
 Drop Tablespace 
 =============== 
 Below command will drop tablespace including all its contents 
 SQL> drop tablespace test_tbs including contents; 
 
 Below command will drop tablespace including all its contents and associated 
datafiles 
 SQL> drop tablespace test_tbs including contents and datafiles; 
 
 How to drop empty datafiles: 
 ============================ 
 Alter tablespace &tablespace_Name drop Datafile '&datafile_name'; 
 
 How to check memory used/Free in datafile: 
 ========================================== 
 col file_name for a; 
 set pagesize ; 
 set linesize ; 
 SELECT SUBSTR (df.NAME, , ) file_name, df.bytes /  /  "Allocated 
Size(MB)", 
 (( df. bytes /  / ) - NVL ( SUM ( dfs. bytes) /  / , )) "Used Size 
(MB)", 
 NVL (SUM (dfs.bytes) /  / , ) "Free Size(MB)" 
 FROM v$datafile df, dba_free_space dfs 
 WHERE df.file# = dfs.file_id(+) 
 GROUP BY dfs.file_id, df.NAME, df.file#, df.bytes 
 ORDER BY file_name; 
 
 
 Tablespace Coalesce 
 
 Tablespace Coalesce combines all contiguous free extents into larger contiguous 
extents inside all datafiles 
 
 It takes any free extents that are right next to some other free extent and make one 
bigger free extent 
 
 SMON will perform this coalescing in the background but if you need it to happen 
right now, coalesce will do it 
 
 SQL> ALTER TABLESPACE USERS COALESCE;
```
------------------------------------------------------------------------------------------

```sh
### Method 1: Adding a New Datafile
To extend the tablespace size in an Oracle database, you typically need to add a new datafile to the tablespace or increase the size of an existing datafile. Here are the steps to achieve both methods:

1. **Connect to the Database**:
   ```sql
   sqlplus / as sysdba
   ```

2. **Add a New Datafile to the Tablespace**:
   ```sql
   ALTER TABLESPACE tablespace_name 
   ADD DATAFILE '/path/to/datafile.dbf' SIZE 100M;
   ```

   - `tablespace_name`: The name of the tablespace you want to extend.
   - `/path/to/datafile.dbf`: The path where the new datafile will be created.
   - `SIZE 100M`: The initial size of the new datafile.

### Method 2: Increasing the Size of an Existing Datafile

1. **Connect to the Database**:
   ```sql
   sqlplus / as sysdba
   ```

2. **Increase the Size of an Existing Datafile**:
   ```sql
   ALTER DATABASE DATAFILE '/path/to/datafile.dbf' RESIZE 200M;
   ```

   - `/path/to/datafile.dbf`: The path of the existing datafile you want to resize.
   - `RESIZE 200M`: The new size for the datafile.

### Automatic Extension (Optional)

You can also set a datafile to automatically extend as needed.

1. **Connect to the Database**:
   ```sql
   sqlplus / as sysdba
   ```

2. **Enable Automatic Extension**:
   ```sql
   ALTER DATABASE DATAFILE '/path/to/datafile.dbf' AUTOEXTEND ON NEXT 10M MAXSIZE 500M;
   ```

   - `AUTOEXTEND ON`: Enables automatic extension.
   - `NEXT 10M`: The size increment for each extension.
   - `MAXSIZE 500M`: The maximum size the datafile can grow to.

### Example

Let's assume you have a tablespace named `USERS` and you want to extend it.

#### Adding a New Datafile

```sql
ALTER TABLESPACE USERS 
ADD DATAFILE '/u01/app/oracle/oradata/orcl/users02.dbf' SIZE 100M;
```

#### Increasing the Size of an Existing Datafile

```sql
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/orcl/users01.dbf' RESIZE 500M;
```

#### Enabling Automatic Extension

```sql
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/orcl/users01.dbf' AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;
```

### Checking Tablespace Usage

To monitor tablespace usage, you can use the following query:

```sql
SELECT
    df.tablespace_name,
    df.file_name,
    df.bytes / 1024 / 1024 AS size_mb,
    (df.bytes - fs.bytes) / 1024 / 1024 AS used_mb,
    fs.bytes / 1024 / 1024 AS free_mb,
    ROUND(((df.bytes - fs.bytes) / df.bytes) * 100, 2) AS pct_used
FROM
    dba_data_files df,
    (SELECT
         file_id,
         SUM(bytes) AS bytes
     FROM
         dba_free_space
     GROUP BY
         file_id) fs
WHERE
    df.file_id = fs.file_id(+)
ORDER BY
    tablespace_name;

This will give you an overview of the tablespace sizes and their usage.

### Summary

- **Adding a new datafile** extends the tablespace by creating a new file.
- **Increasing the size of an existing datafile** extends the tablespace by resizing the file.
- **Enabling automatic extension** allows the datafile to grow automatically as needed.

These methods ensure that your tablespace has enough space to accommodate the data growth.
```
-------------------------------------------------------------------------------------------------
