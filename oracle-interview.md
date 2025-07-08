
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
```
