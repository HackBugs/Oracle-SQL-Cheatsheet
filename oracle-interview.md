
```
hostname -I
sqlplus / as sysdba
startup
lsnrctl status

cat $ORACLE_HOME/network/admin/listener.ora
cat $ORACLE_HOME/network/admin/tnsnames.ora

SELECT username, account_status FROM dba_users;
ALTER USER system IDENTIFIED BY admin;
```
```
rman target /
report schema;

SHOW PARAMETER db_recovery_file_dest;
LIST BACKUP;

v$managed_standby

@?/rdbms/admin/awrrpt.sql
@?/rdbms/admin/addmrpt.sql
@$ORACLE_HOME/rdbms/admin/awrrpt.sql

######### Backup #########

rman target /
BACKUP DATABASE PLUS ARCHIVELOG;
BACKUP INCREMENTAL LEVEL 1 DATABASE;

expdp user/pass directory=exp_dir dumpfile=exp.dmp logfile=exp.log full=y
impdp user/pass directory=exp_dir dumpfile=exp.dmp logfile=imp.log
```
