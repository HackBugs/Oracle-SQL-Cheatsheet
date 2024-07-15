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
