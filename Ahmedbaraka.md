> # Oracle Database 19c Primary and Physical Standby databases
> WebLogic and Tuxedo

## Primary databases
```
# .bash_profile
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_SID=oradb; export ORACLE_SID
ORACLE_HOME=$ORACLE_BASE/product/19.0.0/db_1; export ORACLE_HOME
NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=${PATH}:/usr/bin:/bin:/usr/local/bin
PATH=.:${PATH}:$ORACLE_HOME/bin
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ORACLE_HOME/oracm/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib
export CLASSPATH
export TEMP=/tmp
export TMPDIR=/tmp
umask 022

```

## Physical Standby databases
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

## Physical Standby databases
```
# .bash_profile
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
ORACLE_SID=oradb_s2; export ORACLE_SID
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/db_1
NLS_DATE_FORMAT="DD-MON-YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=${PATH}:/usr/bin:/bin:/usr/local/bin
PATH=.:${PATH}:$ORACLE_HOME/bin
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$ORACLE_HOME/oracm/lib
LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib
export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/JRE
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/rdbms/jlib
CLASSPATH=${CLASSPATH}:$ORACLE_HOME/network/jlib
export CLASSPATH
export TEMP=/tmp
export TMPDIR=/tmp
umask 022

```
<hr>

> # Oracle RAC Database 19c on Linux 7

```
```

<he>

> # Oracle GoldenGate 19c on Two Oracle Databases

```
```
