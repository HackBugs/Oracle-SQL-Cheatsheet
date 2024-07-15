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
