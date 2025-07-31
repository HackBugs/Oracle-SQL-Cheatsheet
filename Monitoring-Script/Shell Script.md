> ## Shell Script to Take Backup using Function

```
#!/bin/bash
#setting up oracle environment
export ORACLE_HOME=/data/app/oracle/product/19c/dbhome
export ORACLE_SID=prim
export PATH=$PATH:$ORACLE_HOME/bin
date=$(date +"%y-%m-%d")
echo "RMAN BACKUP STARTED...$date"
INCREMENTAL_LEVEL_0(){
rman target / &amp;amp;lt; /home/oracle/rman_level0_log_$date
RUN
{
ALLOCATE CHANNEL ch11 TYPE DISK MAXPIECESIZE 10G;
ALLOCATE CHANNEL ch12 TYPE DISK MAXPIECESIZE 10G;
ALLOCATE CHANNEL ch13 TYPE DISK MAXPIECESIZE 10G;
BACKUP
FORMAT '/data/rman/%d_D_%T_%u_s%s_p%p'
INCREMENTAL LEVEL 0 DATABASE
CURRENT CONTROLFILE
FORMAT '/data/rman/%d_C_%T_%u'
SPFILE
FORMAT '/data/rman/%d_S_%T_%u'
PLUS ARCHIVELOG
FORMAT '/data/rman/%d_A_%T_%u_s%s_p%p';
RELEASE CHANNEL ch11;
RELEASE CHANNEL ch12;
RELEASE CHANNEL ch13;
}
exit
EOF
}
INCREMENTAL_LEVEL_1(){
rman target / &amp;amp;lt; /home/oracle/rman_level1_log_$date
RUN
{
ALLOCATE CHANNEL ch11 TYPE DISK MAXPIECESIZE 10G;
ALLOCATE CHANNEL ch12 TYPE DISK MAXPIECESIZE 10G;
ALLOCATE CHANNEL ch13 TYPE DISK MAXPIECESIZE 10G;
BACKUP
FORMAT '/data/rman/%d_D_%T_%u_s%s_p%p'
INCREMENTAL LEVEL 1 DATABASE
CURRENT CONTROLFILE
FORMAT '/data/rman/%d_C_%T_%u'
SPFILE
FORMAT '/data/rman/%d_S_%T_%u'
PLUS ARCHIVELOG
FORMAT '/data/rman/%d_A_%T_%u_s%s_p%p';
RELEASE CHANNEL ch11;
RELEASE CHANNEL ch12;
RELEASE CHANNEL ch13;
}
exit
EOF
}
filename=/home/oracle/rman_$1_log_$date
echo "filename is $filename"
if [ "$#" == 1 -a "$1" == "level0" ]
then
        echo "correct argument passed...$1"
        INCREMENTAL_LEVEL_0
elif [ "$#" == 1 -a "$1" == "level1" ]
then
        echo "correct argument passed...$1"
        INCREMENTAL_LEVEL_1
        echo "Backup is successfull" | mailx -s "Backup Script" -a $filename infoorcldata@gmail.com
elif [ $# -eq 0 ]
then
        echo "Please pass one argument - level0 or level1"
else
        echo "Something went wrong"
fi
```
