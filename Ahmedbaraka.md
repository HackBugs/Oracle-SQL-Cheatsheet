> # Oracle Database 19c Primary and Physical Standby databases

```
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/db_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:$ORACLE_HOME/rdbms/lib
export PATH=$ORACLE_HOME/bin


select open_mode, database_role from v$database;
show parameter service
alter database recover managed standby database disconnect from session;
ps -ef | grep mrp
archive log list
select process, status, sequence#, block# from v$managed_standby;
```
<hr>

> # Oracle RAC Database 19c on Linux 7

```
```

<he>

> # Oracle GoldenGate 19c on Two Oracle Databases

```
```
