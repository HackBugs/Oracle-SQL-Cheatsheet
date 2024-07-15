# Oracle-Cheatsheet
Author : HackBugs , Shahnwaj Aalam
**ORACLE OBA ADMIN - SHEAT SHEET**

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
