# ##################################################################################################################################
# DATABASE DAILY HEALTH CHECK MONITORING SCRIPT
VER="[6.2]"
# ===================================================================================================
# CAUTION: THIS SCRIPT MAY CAUSE A SLIGHT OVEARHEAD, DO NOT RUN IT TOO FREQUENT, ONCE A DAY IS IDEAL.
# ===================================================================================================
# ***********
# How To Use:
# ***********
# 1- Set your Email by modifying this parameter below: EMAIL="shahnwaza7@gmail.com"
# 2- Check the THRESHOLDS section and make sure they meet your policy.
# 3- You can DISABLE/ENABLE some section by altering the parameter that accept Y or N values
#    e.g. Disable Memory Check Section in the report:
#	  Go to THRESHOLDS section and set:
#	  CHECK_MEMORY=N
# ****************************************************************************************************
# FEATURES:
# ********
# CHECKING CPU UTILIZATION.
# CHECKING FILESYSTEM UTILIZATION.
# CHECKING TABLESPACES UTILIZATION.
# CHECKING FLASH RECOVERY AREA UTILIZATION.
# CHECKING ASM DISKGROUPS UTILIZATION.
# CHECKING BLOCKING SESSIONS ON THE DATABASE.
# CHECKING UNUSABLE INDEXES ON THE DATABASE.
# CHECKING INVALID OBJECTS ON THE DATABASE.
# CHECKING CORRUPTED BLOCKS ON THE DATABASE.
# CHECKING FAILED JOBS IN THE DATABASE.
# CHECKING LONG RUNNING JOBS [For More than 1 Day].
# CHECKING ACTIVE INCIDENTS.
# CHECKING OUTSTANDING ALERTS.
# CHECKING DATABASE SIZE GROWTH.
# CHECKING RMAN BACKUPs.
# REPORT UNRECOVERABLE DB FILES.
# CHECKING OS / HARDWARE STATISTICS.
# CHECKING RESOURCE LIMITS.
# CHECKING RECYCLEBIN.
# CHECKING CURRENT RESTORE POINTS.
# CHECKING HEALTH MONITOR CHECKS RECOMMENDATIONS THAT RUN BY DBMS_HM PACKAGE.
# CHEKCING MONITORED INDEXES.
# CHECKING REDOLOG SWITCHES.
# CHECKING MODIFIED INTIALIZATION PARAMETERS SINCE THE LAST DB STARTUP.
# CHECKING ADVISORS RECOMMENDATIONS:
#	   - SQL TUNING ADVISOR
#	   - SGA ADVISOR
#	   - PGA ADVISOR
#	   - BUFFER CACHE ADVISOR
#	   - SHARED POOL ADVISOR
#	   - SEGMENT ADVISOR
# CHECKING NEW CREATED OBJECTS.
# CHECKING AUDIT RECORDS.
# CHECKING FAILED LOGIN ATTEMPTS.
#
#					#   #     #
# Author:	Mahmmoud ADEL	      # # # #   ###
# 				    #   #   # #   #  
#
# Created:      22-12-13 Based on dbalarm.sh script.
# Modifications:18-05-14 Added Filsystem monitoring.
#		19-05-14 Added CPU monitoring.
#		09-12-14 Added Tablespaces monitoring
#			 Added BLOCKING SESSIONS monitoring
#			 Added UNUSABLE INDEXES monitoring 
#			 Added INVALID OBJECTS monitoring
#			 Added FAILED LOGINS monitoring
#			 Added AUDIT RECORDS monitoring
#			 Added CORRUPTED BLOCKS monitoring
#			 [It will NOT run a SCAN. It will look at V$DATABASE_BLOCK_CORRUPTION]
#			 Added FAILED JOBS monitoring.
#		06-10-15 Replaced mpstat with iostat for CPU Utilization Check
#		02-11-15 Enhanced "FAILED JOBS monitoring" part.
#               13-12-15 Added Advisors Recommendations to the report
#               04-04-16 dba_tablespace_usage_metrics view will be used for 11g onwards versions
#                        for checking tablespaces size, advised by: Satyajit Mohapatra
#               10-04-16 Add Flash Recovery Area monitoring
#               10-04-16 Add ASM Disk Groups monitoring
#		15-07-16 Add ACTIVE INCIDENTS, RESOURCE LIMITS, RECYCLEBIN, RESTORE POINTS,
#			  MONITORED INDEXES, REDOLOG SWITCHES, MODIFIED SPFILE PARAMETERS checks.
#		02-01-17 Removed ALERTLOG check for DB & Listener +
#			 Merged alerts with advisors. 		[Recommended by: ABD-ELGAWAD]
#		03-01-17 Added checking RAC status feature. 	[Recommended by: Samer ALJazzar]
#		09-01-17 Added RMAN BACKUP CHECK.
#		04-05-17 Added Reporting of Newly Created Objects in the last 24Hours.
#		12-06-17 Added Long Running Jobs Alert.
#		20-07-17 Neutralize login.sql if found under Oracle user home directory due to bugs.
#               10-10-17 Added reporting Long Running Queries to the report.
#		09-01-18 Workaround for df command bug "`/root/.gvfs': Permission denied"
#		16-05-18 Added SHOWSQLTUNINGADVISOR, SHOWMEMORYADVISORS, SHOWSEGMENTADVVISOR, SHOWJOBS
#			 and SHOWHASHEDCRED parameters to allow the user to decide whether to show their
#			 results in the report or not.
#		21-06-18 Added MODOBJCONTTHRESHOLD to control the display of LAST MODIFIED OBJECTS in the report.
#		15-08-18 Added REPORT UNRECOVERABLE DATABASE FILES that don't have a valid backup.
#		10-02-19 Removed the failed jobs alerting from the script.
#		19-02-19 Added HTML email format content.
#		04-04-19 Added Reporting of Top Fragmented Tables.
#		16-06-20 Excluding goldengate modules from Long Running Queries reporting.
#		22-06-20 Modified the check for cluster services to get compatible with 12c+.
#		23-06-20 Listed: Running Instances/listeners, open ports in the report.
#		14-09-20 Added Memory utilization check feature, combining both RAM and SWAP in the calculation.
#		14-09-20 Reorganize script sections to make it easy to edit by users.
#		23-11-20 Enhance df command output in HTML mode
#		04-04-21 Listing Dormant accounts in the report.
#		04-04-21 Auditing data will be included in the report by default. [If AUD$ is big this section will take much time]
#		20-09-21 Show yesterday's hardware (CPU & Memory) stats if crossed the thresholds.
#
#
#
# ##################################################################################################################################
# HERE YOU SET YOUR EMAIL:
EMAIL="shahnwaza7@gmail.com"

# HERE YOU SET THE SMTP SERVER IF EXIST. UNHASH THE BELOW LINE AND REPLACE "mailrelay.mycompany.com" WITH YOUR COMPANY's SMTP:
#export smtp="mailrelay.mycompany.com:25"       # This is an example, your Network Admin knows the SMTP NAME & PORT to use.

# #########################
# THRESHOLDS:
# #########################
# Send an E-mail for each THRESHOLD if been reached:
# ADJUST the following THRESHOLD VALUES as per your requirements:

HTMLENABLE=Y            # Enable HTML Email Format                                      [DB]
FSTHRESHOLD=95          # THRESHOLD FOR FILESYSTEM %USED                                [OS]
CPUTHRESHOLD=95         # THRESHOLD FOR CPU %UTILIZATION                                [OS]
CHECK_MEMORY=Y          # REPORT LOW MEMORY USING BELOW TWO DEFINED THRESHOLDS COMBINED [OS]
 USEDPHYSICALMEM_PCT=95	# THRESHOLD FOR RAM %UTILIZATION                                [OS]
 USEDSWAPMEM_PCT=75	# THRESHOLD FOR SWAP SPACE %UTILIZATION                         [OS]
CHECK_CLUSTER=Y         # CHECK CLUSTERWARE HEALTH                                      [CL]
CHKAUDITRECORDS=Y       # INCLUDE AUDIT RECORDS IN THE REPORT [increases CPU Load]      [DB]
SHOWDORMANTACCOUNTS=Y   # SHOW INACTIVE ACCOUNTS IN THE REPORT                          [DB]
 DORMANT_INACTIVE_DAYS=45 # SHOW Inactive Accounts with NO login attempts since 45 days.[DB]
SHOWSQLTUNINGADVISOR=Y  # INCLUDE SQL TUNING ADVISOR RESULTS IN THE REPORT              [DB]
SHOWMEMORYADVISORS=Y    # INCLUDE MEMORY ADVISORS RESULTS IN THE REPORT                 [DB]
SHOWSEGMENTADVVISOR=N   # INCLUDE SEGMENT ADVISOR RESULTS IN THE REPORT                 [DB]
SHOWJOBS=Y              # INCLUDE DB JOBS DETAILS IN THE REPORT                         [DB]
SHOWHASHEDCRED=N        # INCLUDE DB USERS HASHED VERSION CREDENTIALS IN THE REPORT     [DB]
REPORTUNRECOVERABLE=Y   # INCLUDE UNRECOVERABLE DATAFILES IN THE REPORT.                [DB]
TBSTHRESHOLD=95         # THRESHOLD FOR TABLESPACE %USED                                [DB]
FRATHRESHOLD=95         # THRESHOLD FOR FLASH RECOVERY AREA %USED                       [DB]
ASMTHRESHOLD=95         # THRESHOLD FOR ASM DISK GROUPS                                 [DB]
UNUSEINDXTHRESHOLD=1    # THRESHOLD FOR NUMBER OF UNUSABLE INDEXES                      [DB]
INVOBJECTTHRESHOLD=1    # THRESHOLD FOR NUMBER OF INVALID OBJECTS                       [DB]
FAILLOGINTHRESHOLD=1    # THRESHOLD FOR NUMBER OF FAILED LOGINS                         [DB]
AUDITRECOTHRESHOLD=1    # THRESHOLD FOR NUMBER OF AUDIT RECORDS                         [DB]
CORUPTBLKTHRESHOLD=1    # THRESHOLD FOR NUMBER OF CORRUPTED BLOCKS                      [DB]
FAILDJOBSTHRESHOLD=1    # THRESHOLD FOR NUMBER OF FAILED JOBS                           [DB]
JOBSRUNSINCENDAY=1      # THRESHOLD FOR JOBS RUNNING LONGER THAN N DAY                  [DB]
NEWOBJCONTTHRESHOLD=1   # THRESHOLD FOR NUMBER OF NEWLY CREATED OBJECTS                 [DB]
MODOBJCONTTHRESHOLD=1   # THRESHOLD FOR NUMBER OF MODIFIED OBJECTS                      [DB]
LONG_RUN_QUR_HOURS=1    # THRESHOLD FOR QUERIES RUNNING LONGER THAN N HOURS             [DB]
SHOW_YESTERDAY_STATS=Y	# CHECKER FOR SHOWING HARDWARE RESOURCES THAT CROSSED THRESHOLDS[OS]


# #######################################
# Excluded Modules:
# #######################################
# Here you can exclude the modules you don't want their queries to get reported in the Long Running Queries list:
# goldegate modules are excluded below, to add extra modules, make sure to enclose them between single quote and separating them by a comma:
EXCLUDED_MODULES="'OGG-USE_OCI_THREAD','OGG-OCI_META_THREAD'"

# #######################################
# Excluded INSTANCES:
# #######################################
# Here you can mention the instances the script will IGNORE and will NOT run against:
# Use pipe "|" as a separator between each instance name.
# e.g. Excluding: -MGMTDB, ASM instances:

EXL_DB="\-MGMTDB|ASM|APX"           #Excluding INSTANCES [Will get excluded from the report].

# #########################
# Excluded ERRORS:
# #########################
# Here you can exclude the errors that you don't want to be alerted when they appear in the logs:
# Use pipe "|" between each error.

EXL_ALERT_ERR="ORA-2396|TNS-00507|TNS-12502|TNS-12560|TNS-12537|TNS-00505"              #Excluded ALERTLOG ERRORS [Will not get reported].
EXL_LSNR_ERR="TNS-00507|TNS-12502|TNS-12560|TNS-12537|TNS-00505"                        #Excluded LISTENER ERRORS [Will not get reported].

# ################################
# Excluded FILESYSTEM/MOUNT POINTS:
# ################################
# Here you can exclude specific filesystems/mount points from being reported by the script:
# e.g. Excluding: /dev/mapper, /dev/asm mount points:

EXL_FS="\/dev\/mapper\/|\/dev\/asm\/"                                                   #Excluded mount points [Will be skipped during the check].

# Workaround df command output bug "`/root/.gvfs': Permission denied"
if [ -f /etc/redhat-release ]
 then
  export DF='df -hTPx fuse.gvfs-fuse-daemon'
 else
  export DF='df -hT'
fi


export SRV_NAME="`uname -n`"


	case ${EMAIL} in "shahnwaza7@gmail.com")
	 echo
	 echo "##############################################################################################"
	 echo "You Missed Something! :-)"
	 echo "In order to receive the HEALTH CHECK report via Email, set your E-mail at line# 110"
	 echo "by replacing this template [shahnwaza7@gmail.com] with YOUR E-mail address."
	 echo "DB HEALTH CHECK report will be saved on disk..."
	 echo "##############################################################################################"
	 export SQLLINESIZE=165
	 echo;;
	 *)
	 export SQLLINESIZE=200
	 export OSLINESIZE=300
	 ;;
	esac

SCRIPT_NAME="dbdailychk${VER}"
# In case your company Emails go through a specific SMTP server. Specify it in the below line and UN-HASH it:
#export smtp="mailrelay.mycompany.com:25"       #This is an example, you have to check with your Network Admin for the SMTP NAME/PORT to use.

export MAIL_LIST="${EMAIL}"
#export MAIL_LIST="-r ${SRV_NAME} ${EMAIL}"

echo
echo "[dbdailychk Script Started ...]"


# #########################
# Checking The FILESYSTEM:
# #########################

# Report Partitions that reach the threshold of Used Space:

FSLOG=/tmp/filesystem_DBA_BUNDLE.log
echo "[Reported By ${SCRIPT_NAME} Script" >  ${FSLOG}
echo ""                                   >> ${FSLOG}
${DF}                                     >> ${FSLOG}
${DF} | grep -v "^Filesystem" |awk '{print substr($0, index($0, $2))}'| egrep -v "${EXL_FS}"|awk '{print $(NF-1)" "$NF}'| while read OUTPUT
   do
        PRCUSED=`echo ${OUTPUT}|awk '{print $1}'|cut -d'%' -f1`
        FILESYS=`echo ${OUTPUT}|awk '{print $2}'`
                if [ ${PRCUSED} -ge ${FSTHRESHOLD} ]
                 then
mail -s "ALARM: Filesystem [${FILESYS}] on Server [${SRV_NAME}] has reached ${PRCUSED}% of USED space" ${MAIL_LIST} < ${FSLOG}
                fi
   done

rm -f ${FSLOG}


# #########################
# Getting ORACLE_SID:
# #########################
# Exit with sending Alert mail if No DBs are running:
INS_COUNT=$( ps -ef|grep pmon|grep -v grep|egrep -v ${EXL_DB}|wc -l )
	if [ $INS_COUNT -eq 0 ]
	 then
	 echo "[Reported By ${SCRIPT_NAME} Script]" 						>  /tmp/oracle_processes_DBA_BUNDLE.log
	 echo " " 										>> /tmp/oracle_processes_DBA_BUNDLE.log
	 echo "Current running INSTANCES on server [${SRV_NAME}]:" 				>> /tmp/oracle_processes_DBA_BUNDLE.log
	 echo "***************************************************"				>> /tmp/oracle_processes_DBA_BUNDLE.log
	 ps -ef|grep -v grep|grep pmon 								>> /tmp/oracle_processes_DBA_BUNDLE.log
         echo " "                                                                               >> /tmp/oracle_processes_DBA_BUNDLE.log
         echo "Current running LISTENERS on server [${SRV_NAME}]:"                              >> /tmp/oracle_processes_DBA_BUNDLE.log
         echo "***************************************************"                        	>> /tmp/oracle_processes_DBA_BUNDLE.log
         ps -ef|grep -v grep|grep tnslsnr                                                       >> /tmp/oracle_processes_DBA_BUNDLE.log
mail -s "ALARM: No Databases Are Running on Server ${SRV_NAME} !!!" ${MAIL_LIST} 		<  /tmp/oracle_processes_DBA_BUNDLE.log
	 rm -f /tmp/oracle_processes_DBA_BUNDLE.log
 	 exit
	fi

# #########################
# Setting ORACLE_SID:
# #########################
for ORACLE_SID in $( ps -ef|grep pmon|grep -v grep|egrep -v ${EXL_DB}|awk '{print $NF}'|sed -e 's/ora_pmon_//g'|grep -v sed|grep -v "s///g" )
   do
    export ORACLE_SID

# #########################
# Getting ORACLE_HOME
# #########################
  ORA_USER=`ps -ef|grep ${ORACLE_SID}|grep pmon|grep -v grep|egrep -v ${EXL_DB}|grep -v "\-MGMTDB"|awk '{print $1}'|tail -1`
  USR_ORA_HOME=`grep -i "^${ORA_USER}:" /etc/passwd| cut -f6 -d ':'|tail -1`

# SETTING ORATAB:
if [ -f /etc/oratab ]
  then
ORATAB=/etc/oratab
export ORATAB
## If OS is Solaris:
elif [ -f /var/opt/oracle/oratab ]
  then
ORATAB=/var/opt/oracle/oratab
export ORATAB
fi

# ATTEMPT1: Get ORACLE_HOME using pwdx command:
export PGREP=`which pgrep`
export PWDX=`which pwdx`
if [[ -x ${PGREP} ]] && [[ -x ${PWDX} ]]
then
PMON_PID=`pgrep  -lf _pmon_${ORACLE_SID}|awk '{print $1}'`
export PMON_PID
ORACLE_HOME=`pwdx ${PMON_PID}|awk '{print $NF}'|sed -e 's/\/dbs//g'`
export ORACLE_HOME
fi

# ATTEMPT2: If ORACLE_HOME not found get it from oratab file:
if [ ! -f ${ORACLE_HOME}/bin/sqlplus ]
 then
## If OS is Linux:
if [ -f /etc/oratab ]
  then
ORATAB=/etc/oratab
ORACLE_HOME=`grep -v '^\#' ${ORATAB} | grep -v '^$'| grep -i "^${ORACLE_SID}:" | perl -lpe'$_ = reverse' | cut -f3 | perl -lpe'$_ = reverse' |cut -f2 -d':'`
export ORACLE_HOME

## If OS is Solaris:
elif [ -f /var/opt/oracle/oratab ]
  then
ORATAB=/var/opt/oracle/oratab
ORACLE_HOME=`grep -v '^\#' ${ORATAB} | grep -v '^$'| grep -i "^${ORACLE_SID}:" | perl -lpe'$_ = reverse' | cut -f3 | perl -lpe'$_ = reverse' |cut -f2 -d':'`
export ORACLE_HOME
fi
fi

# ATTEMPT3: If ORACLE_HOME is in /etc/oratab, use dbhome command:
if [ ! -f ${ORACLE_HOME}/bin/sqlplus ]
 then
ORACLE_HOME=`dbhome "${ORACLE_SID}"`
export ORACLE_HOME
fi

# ATTEMPT4: If ORACLE_HOME is still not found, search for the environment variable: [Less accurate]
if [ ! -f ${ORACLE_HOME}/bin/sqlplus ]
 then
ORACLE_HOME=`env|grep -i ORACLE_HOME|sed -e 's/ORACLE_HOME=//g'`
export ORACLE_HOME
fi

# ATTEMPT5: If ORACLE_HOME is not found in the environment search user's profile: [Less accurate]
if [ ! -f ${ORACLE_HOME}/bin/sqlplus ]
 then
ORACLE_HOME=`grep -h 'ORACLE_HOME=\/' ${USR_ORA_HOME}/.bash_profile ${USR_ORA_HOME}/.*profile | perl -lpe'$_ = reverse' |cut -f1 -d'=' | perl -lpe'$_ = reverse'|tail -1`
export ORACLE_HOME
fi

# ATTEMPT6: If ORACLE_HOME is still not found, search for orapipe: [Least accurate]
if [ ! -f ${ORACLE_HOME}/bin/sqlplus ]
 then
	if [ -x /usr/bin/locate ]
 	 then
ORACLE_HOME=`locate -i orapipe|head -1|sed -e 's/\/bin\/orapipe//g'`
export ORACLE_HOME
	fi
fi

# TERMINATE: If all above attempts failed to get ORACLE_HOME location, EXIT the script:
if [ ! -f ${ORACLE_HOME}/bin/sqlplus ]
 then
  echo "Please export ORACLE_HOME variable in your .bash_profile file under oracle user home directory in order to get this script to run properly"
  echo "e.g."
  echo "export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1"
mail -s "dbdailychk script on Server [${SRV_NAME}] failed to locate ORACLE_HOME for SID [${ORACLE_SID}], Please export ORACLE_HOME variable in your .bash_profile file under oracle user home directory" ${MAIL_LIST} < /dev/null
exit
fi

export LD_LIBRARY_PATH=${ORACLE_HOME}/lib

# #############################
# Getting hostname in lowercase:
# #############################
HOSTNAMELOWER=$( echo "`hostname --short`"| tr '[A-Z]' '[a-z]' )
export HOSTNAMELOWER

# ########################
# Getting GRID_HOME:
# ########################

CHECK_OCSSD=`ps -ef|grep 'ocssd.bin'|grep -v grep|wc -l`
CHECK_CRSD=`ps -ef|grep 'crsd.bin'|grep -v grep|wc -l`

 if [ ${CHECK_OCSSD} -gt 0 ]
  then
GRID_HOME=`ps -ef|grep 'ocssd.bin'|grep -v grep|awk '{print $NF}'|sed -e 's/\/bin\/ocssd.bin//g'|grep -v sed|grep -v "//g"|tail -1`
export GRID_HOME

        if [ ! -d ${GRID_HOME} ]
         then
ASM_INSTANCE_NAME=`ps -ef|grep pmon|grep -v grep|grep asm_pmon_|awk '{print $NF}'|sed -e 's/asm_pmon_//g'|grep -v sed|grep -v "s///g"|tail -1`
GRID_HOME=`dbhome ${ASM_INSTANCE_NAME}`
export GRID_HOME
        fi

# ########################
# Getting GRID_BASE:
# ########################

# Locating GRID_BASE:

GRID_BASE=`cat ${GRID_HOME}/crs/install/crsconfig_params|grep ^ORACLE_BASE|tail -1|awk '{print $NF}'|sed -e 's/ORACLE_BASE=//g'`
export GRID_BASE

        if [ ! -d ${GRID_BASE} ]
         then
GRID_BASE=`cat ${GRID_HOME}/crs/utl/appvipcfg|grep ^ORACLE_BASE|tail -1|awk '{print $NF}'|sed -e 's/ORACLE_BASE=//g'`
export GRID_BASE
        fi

        if [ ! -d ${GRID_BASE} ]
         then
GRID_BASE=`cat ${GRID_HOME}/install/envVars.properties|grep ^ORACLE_BASE|tail -1|awk '{print $NF}'|sed -e 's/ORACLE_BASE=//g'`
export GRID_BASE
        fi
 fi

# #########################
# Variables:
# #########################
export PATH=${PATH}:${ORACLE_HOME}/bin
export LOG_DIR=${USR_ORA_HOME}/BUNDLE_Logs
mkdir -p ${LOG_DIR}
chown -R ${ORA_USER} ${LOG_DIR}
chmod -R go-rwx ${LOG_DIR}

        if [ ! -d ${LOG_DIR} ]
         then
          mkdir -p /tmp/BUNDLE_Logs
          export LOG_DIR=/tmp/BUNDLE_Logs
          chown -R ${ORA_USER} ${LOG_DIR}
          chmod -R go-rwx ${LOG_DIR}
        fi

cat /dev/null > ${LOG_DIR}/dbdailychk.part.log
export LOGFILE=${LOG_DIR}/dbdailychk.part.log

# #########################
# HTML Preparation:
# #########################
   case ${HTMLENABLE} in
   y|Y|yes|YES|Yes|ON|On|on)
        if [ -x /usr/sbin/sendmail ]
        then
export SENDMAIL="/usr/sbin/sendmail -t"
export MAILEXEC="echo #"
export HASHHTML=""
export HASHNONHTML="--"
export HASHHTMLOS=""
export HASHNOHTMLOS="echo #"
SENDMAILARGS=$(
echo "To:           ${EMAIL};"
echo "Subject:      ${MSGSUBJECT} ;"
echo "Content-Type: text/html;"
echo "MIME-Version: 1.0;"
cat ${LOGFILE}
)
export SENDMAILARGS
        else
export SENDMAIL="echo #"
export MAILEXEC="mail -s"
export HASHHTML="--"
export HASHNONHTML=""
export HASHHTMLOS="echo #"
export HASHNOHTMLOS=""
        fi
   ;;
   *)
export SENDMAIL="echo #"
export HASHHTML="--"
export HASHNONHTML=""
export HASHHTMLOS="echo #"
export HASHNOHTMLOS=""
export MAILEXEC="mail -s"
   ;;
   esac

export LOGFILE=${LOG_DIR}/dbdailychk.part.log
export SRV_NAME="`uname -n`"


# ##########################
# Neutralize login.sql file: [Bug Fix]
# ##########################
# Existance of login.sql file under Oracle user Linux home directory eliminates many functions during the execution of this script from crontab:

        if [ -f ${USR_ORA_HOME}/login.sql ]
         then
#echo "login.sql file found and will be neutralized."
mv ${USR_ORA_HOME}/login.sql   ${USR_ORA_HOME}/login.sql_NeutralizedBy${SCRIPT_NAME}
        fi

# ########################
# Getting ORACLE_BASE:
# ########################
# Get ORACLE_BASE from user's profile if it EMPTY:

if [ ! -d "${ORACLE_BASE}" ]
 then
ORACLE_BASE=`cat ${ORACLE_HOME}/install/envVars.properties|grep ^ORACLE_BASE|tail -1|awk '{print $NF}'|sed -e 's/ORACLE_BASE=//g'`
export ORACLE_BASE
fi

if [ ! -d "${ORACLE_BASE}" ]
 then
ORACLE_BASE=`grep -h 'ORACLE_BASE=\/' ${USR_ORA_HOME}/.bash* ${USR_ORA_HOME}/.*profile | perl -lpe'$_ = reverse' |cut -f1 -d'=' | perl -lpe'$_ = reverse'|tail -1`
export ORACLE_BASE
fi


# #########################
# Getting DB_NAME:
# #########################
DB_NAME_RAW=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" <<EOF
set pages 0 feedback off lines 1000;
prompt
SELECT name from v\$database;
exit;
EOF
)
# Getting DB_NAME in Uppercase & Lowercase:
DB_NAME_UPPER=`echo ${DB_NAME_RAW}| perl -lpe'$_ = reverse' |awk '{print $1}'|perl -lpe'$_ = reverse'`
DB_NAME_LOWER=$( echo "${DB_NAME_UPPER}" | tr -s  '[:upper:]' '[:lower:]' )
export DB_NAME_UPPER
export DB_NAME_LOWER

export DB_NAME=${DB_NAME_UPPER}


# #########################
# Getting DB_UNQ_NAME:
# #########################
VAL121=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" <<EOF
set pages 0 feedback off;
prompt
select value from v\$parameter where name='db_unique_name';
exit;
EOF
)
# Getting DB_NAME in Uppercase & Lowercase:
DB_UNQ_NAME=`echo ${VAL121}| perl -lpe'$_ = reverse' |awk '{print $1}'|perl -lpe'$_ = reverse'`
export DB_UNQ_NAME

# In case DB_UNQ_NAME variable is empty then use DB_NAME instead:
case ${DB_UNQ_NAME} in
'') DB_UNQ_NAME=${DB_NAME}; export DB_UNQ_NAME;;
esac


        if [ -d ${ORACLE_BASE}/diag/rdbms/${DB_NAME_UPPER} ]
        then
                DB_NAME=${DB_NAME_UPPER}
        fi

        if [ -d ${ORACLE_BASE}/diag/rdbms/${DB_NAME_LOWER} ]
        then
                DB_NAME=${DB_NAME_LOWER}
        fi

        if [ -d ${ORACLE_BASE}/diag/rdbms/${DB_UNQ_NAME} ]
        then
                DB_NAME=${DB_UNQ_NAME}
        fi

export DB_NAME


# ###################
# Checking DB Version:
# ###################

VAL311=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" <<EOF
set pages 0 feedback off;
prompt
select version from v\$instance;
exit;
EOF
)
DB_VER=`echo ${VAL311}|perl -lpe'$_ = reverse' |awk '{print $1}'|perl -lpe'$_ = reverse'|cut -f1 -d '.'`


# #####################
# Getting DB Block Size:
# #####################
VAL302=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" <<EOF
set pages 0 feedback off;
prompt
select value from v\$parameter where name='db_block_size';
exit;
EOF
)
blksize=`echo ${VAL302}|perl -lpe'$_ = reverse' |awk '{print $1}'|perl -lpe'$_ = reverse'|cut -f1 -d '.'`


# #####################
# Getting DB ROLE:
# #####################
VAL312=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" <<EOF
set pages 0 feedback off lines 1000;
prompt
select DATABASE_ROLE from v\$database;
exit;
EOF
)
DB_ROLE=`echo ${VAL312}|perl -lpe'$_ = reverse' |awk '{print $1}'|perl -lpe'$_ = reverse'|cut -f1 -d '.'`

        case ${DB_ROLE} in
         PRIMARY)
export DB_ROLE_ID=0
        ;;
               *)
export DB_ROLE_ID=1
# Disable the reporting of BLOCKED Sessions if the DB Role is not a PRIMARY:
export BLOCKTHRESHOLD=100000
        ;;
        esac

export SRV_NAME="`uname -n`"


# ############################################
# Checking LONG RUNNING DB JOBS:
# ############################################
VAL410=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set pages 0 feedback off echo off;
--SELECT count(*) from dba_scheduler_running_jobs where extract(day FROM elapsed_time) > ${JOBSRUNSINCENDAY} and SESSION_ID is not null;
SELECT count(*) from dba_scheduler_running_jobs where extract(day FROM elapsed_time) > ${JOBSRUNSINCENDAY};
exit;
EOF
)
VAL510=`echo ${VAL410} | awk '{print $NF}'`
                if [ ${VAL510} -ge 1 ]
                 then
VAL610=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set linesize ${SQLLINESIZE} pages 1000

-- Enable HTML color format:
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

spool ${LOGFILE}

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Long Running Jobs [${ORACLE_SID}]
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT Long Running Jobs: [${ORACLE_SID}]
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^

col INS for 999
col "JOB_NAME|OWNER|SPID|SID" for a55
col ELAPSED_TIME for a17
col CPU_USED for a17
col "WAIT_SEC"  for 9999999999
col WAIT_CLASS for a15
col "BLKD_BY" for 9999999
col "WAITED|WCLASS|EVENT"       for a45
select j.RUNNING_INSTANCE INS,j.JOB_NAME ||' | '|| j.OWNER||' |'||SLAVE_OS_PROCESS_ID||'|'||j.SESSION_ID"JOB_NAME|OWNER|SPID|SID"
,s.FINAL_BLOCKING_SESSION "BLKD_BY",ELAPSED_TIME,CPU_USED
,substr(s.SECONDS_IN_WAIT||'|'||s.WAIT_CLASS||'|'||s.EVENT,1,45) "WAITED|WCLASS|EVENT",S.SQL_ID
from dba_scheduler_running_jobs j, gv\$session s
where   j.RUNNING_INSTANCE=S.INST_ID(+)
and     j.SESSION_ID=S.SID(+)
and     extract(day FROM elapsed_time) > ${JOBSRUNSINCENDAY}
order by "JOB_NAME|OWNER|SPID|SID",ELAPSED_TIME;

spool off
exit;
EOF
)

#mail -s "WARNING: JOBS running for more than ${JOBSRUNSINCENDAY} day detected on database [${DB_NAME_UPPER}] on Server [${SRV_NAME}]" ${MAIL_LIST} < ${LOG_DIR}/long_running_jobs.log
export MSGSUBJECT="WARNING: JOBS running for more than ${JOBSRUNSINCENDAY} day detected on database [${DB_NAME_UPPER}] on Server [${SRV_NAME}]"

#SENDMAILARGS=$(
#echo "To:           ${EMAIL};"
#echo "Subject:      ${MSGSUBJECT} ;"
#echo "Content-Type: text/html;"
#echo "MIME-Version: 1.0;"
#cat ${LOGFILE}
#)

${MAILEXEC} "${MSGSUBJECT}" ${MAIL_LIST} < ${LOGFILE}
#echo ${SENDMAILARGS} | tr \; '\n' |awk 'length == 1 || NR == 1 {print $0} length && NR > 1 { print substr($0,2) }'| ${SENDMAIL}

(
echo "To: ${EMAIL};"
echo "MIME-Version: 1.0"
echo "Content-Type: text/html;"
echo "Subject: ${MSGSUBJECT}"
cat ${LOGFILE}
) | ${SENDMAIL}

cat /dev/null > ${LOGFILE}
                fi



# ############################################
# LOGFILE SETTINGS:
# ############################################

# Logfile path variable:
DB_HEALTHCHK_RPT=${LOG_DIR}/${DB_NAME_UPPER}_HEALTH_CHECK_REPORT.log
OS_HEALTHCHK_RPT=${LOG_DIR}/OS_HEALTH_CHECK_REPORT.log
export DB_HEALTHCHK_RPT

# Flush the logfile:
export LOGDATE=`date +%d-%b-%y`
echo "HEALTH_CHECK_REPORT_FOR_DATABASE_[${DB_NAME_UPPER}]_ON_{${LOGDATE}}"    > ${DB_HEALTHCHK_RPT}
cat /dev/null > ${OS_HEALTHCHK_RPT}


# ###########################
# Checking Memory Utilization:
# ###########################

case ${CHECK_MEMORY} in
y|Y|yes|YES|Yes|ON|On|on)

# Check the Linux OS version:
export PATH=${PATH}:/usr/local/bin
FILE_NAME=/etc/redhat-release
export FILE_NAME
        if [ -f ${FILE_NAME} ]
        then
LNXVER=`cat /etc/redhat-release | grep -o '[0-9]'|head -1`
export LNXVER
                # IF LINUX VERSION IS 6 OR LOWER:
                if [ ${LNXVER} -le 6 ]
                then
                MEMTOTAL=`cat /proc/meminfo|grep MemTotal|awk '{print $(NF-1)}'`
                MEMUSEDRAW=`free -k|grep 'Mem:'|awk '{print $(3)}'`
                MEMCACHED=`cat /proc/meminfo|grep '^Cached:'|awk '{print $(NF-1)}'`
                MEMFREE=$(awk "BEGIN {print ${MEMTOTAL} - ${MEMUSEDRAW} + ${MEMCACHED}}")
                MEMUSED=$(awk "BEGIN {print ${MEMTOTAL} - ${MEMFREE}}")
                MEMUSEDPCTFLOAT=$(awk "BEGIN {print ${MEMUSED} * 100 / ${MEMTOTAL}}")
                MEMUSEDPCT=${MEMUSEDPCTFLOAT%.*}
                SWAPTOTAL=`cat /proc/meminfo|grep SwapTotal|awk '{print $(NF-1)}'`
                SWAPFREE=`cat /proc/meminfo|grep SwapFree|awk '{print $(NF-1)}'`
                SWAPUSED=$(awk "BEGIN {print ${SWAPTOTAL} - ${SWAPFREE}}")
                SWAPUSEDPCTFLOAT=$(awk "BEGIN {print ${SWAPUSED} * 100 / ${SWAPTOTAL}}")
                SWAPUSEDPCT=${SWAPUSEDPCTFLOAT%.*}
                fi

                # IF LINUX VERSION IS 7 OR HIGHER:
                if [ ${LNXVER} -ge 7 ]
                then
                MEMTOTAL=`cat /proc/meminfo|grep MemTotal|awk '{print $(NF-1)}'`
                MEMUSEDRAW=`free -k|grep 'Mem:'|awk '{print $(3)}'`
                MEMCACHED=`cat /proc/meminfo|grep '^Cached:'|awk '{print $(NF-1)}'`
                MEMFREE=`cat /proc/meminfo|grep MemAvailable|awk '{print $(NF-1)}'`
                MEMUSED=$(awk "BEGIN {print ${MEMTOTAL} - ${MEMFREE}}")
                MEMUSEDPCTFLOAT=$(awk "BEGIN {print ${MEMUSED} * 100 / ${MEMTOTAL}}")
                MEMUSEDPCT=${MEMUSEDPCTFLOAT%.*}
                SWAPTOTAL=`cat /proc/meminfo|grep SwapTotal|awk '{print $(NF-1)}'`
                SWAPFREE=`cat /proc/meminfo|grep SwapFree|awk '{print $(NF-1)}'`
                SWAPUSED=$(awk "BEGIN {print ${SWAPTOTAL} - ${SWAPFREE}}")
                SWAPUSEDPCTFLOAT=$(awk "BEGIN {print ${SWAPUSED} * 100 / ${SWAPTOTAL}}")
                SWAPUSEDPCT=${SWAPUSEDPCTFLOAT%.*}
                fi

                # Show MEMORY ALERT if both MEMUSEDPCT and SWAPUSEDPCT are below their defined thresholds:
                if [ ${MEMUSEDPCT} -ge ${USEDPHYSICALMEM_PCT} ] && [ ${SWAPUSEDPCT} -ge ${USEDSWAPMEM_PCT} ]
                then
                echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
                echo "^^^^^^^^^^^^^^^^^"                                                >> ${OS_HEALTHCHK_RPT}
                echo "MEMORY_WARNING:  "                                                >> ${OS_HEALTHCHK_RPT}
                echo "^^^^^^^^^^^^^^^^^"                                                >> ${OS_HEALTHCHK_RPT}
                echo "Looks_The_Server_Is_Running_Out_of_Memory!."                      >> ${OS_HEALTHCHK_RPT}
                echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
                echo "%USED_PHYSICAL_RAM:${MEMUSEDPCT}%"                                >> ${OS_HEALTHCHK_RPT}
                echo "%USED_SWAP_SPACE:${SWAPUSEDPCT}%"                                 >> ${OS_HEALTHCHK_RPT}
                echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
		echo "Memory_Details:"							>> ${OS_HEALTHCHK_RPT}
		echo "^^^^^^^^^^^^^^"                                                   >> ${OS_HEALTHCHK_RPT}
                echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
		free -g 								>> ${OS_HEALTHCHK_RPT}
                echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
mail -s "ALARM: OUT OF MEMORY Scenario is Imminent on Server [${SRV_NAME}]" ${MAIL_LIST} < ${OS_HEALTHCHK_RPT}
                fi
        fi
;;
esac

# Show yesterday's hardware stats if crossed threshold:

        case ${SHOW_YESTERDAY_STATS} in
        Y|y|YES|Yes|yes|ON|On|on)

# Yesterday's High CPU Utilization:
# #################################
# If CPU IDLE is below 5% or CPU Utilization is higher than 95%:
HIGH_CPU_CNT=`sar -f /var/log/sa/sa$(date +%d -d yesterday) | sed -r '/^\s*$/d' | awk '{ if ( $NF < 5 ) print $NF,$1,$2 }'|wc -l`
        if [ ${HIGH_CPU_CNT} -gt 1 ]
         then
         echo ""                                                                                                           >> ${OS_HEALTHCHK_RPT}
         echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                                                              >> ${OS_HEALTHCHK_RPT}
         echo "Yesterday's_High_CPU_Periods:"                                                                              >> ${OS_HEALTHCHK_RPT}
         echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                                                              >> ${OS_HEALTHCHK_RPT}
         sar -f /var/log/sa/sa$(date +%d -d yesterday) | sed -r '/^\s*$/d' | grep -v Linux | awk '{ if ( $NF < 5 ) print $NF,$1,$2 }'  >> ${OS_HEALTHCHK_RPT}
        fi

# Yesterday's High Memory Utilization:
# ####################################
# If Memory utilization cross 95%:
HIGH_MEM_CNT=`sar -r -f /var/log/sa/sa$(date +%d -d yesterday) | grep -Ev 'Average|Linux' | awk '{ if ( $5 > 95 ) print $5,$1,$2 }'|wc -l`
        if [ ${HIGH_MEM_CNT} -ge 1 ]
         then
         echo ""                                                                                                            >> ${OS_HEALTHCHK_RPT}
         echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                                                            >> ${OS_HEALTHCHK_RPT}
         echo "Yesterday's_High_Memory_Periods:"                                                                            >> ${OS_HEALTHCHK_RPT}
         echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                                                            >> ${OS_HEALTHCHK_RPT}
         sar -r -f /var/log/sa/sa$(date +%d -d yesterday) | grep -Ev 'Average|Linux' | awk '{ if ( $5 > 95 ) print $5,$1,$2 }'   >> ${OS_HEALTHCHK_RPT}
        fi

        ;;
        esac


# Filesystem Utilization:
# #######################
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^"                                                >> ${OS_HEALTHCHK_RPT}
echo "Local_Filesystem:"                                                >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^"                                                >> ${OS_HEALTHCHK_RPT}
${DF}                                                                   >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}

sed -i 's/Mounted on/Mounted_on/g' ${OS_HEALTHCHK_RPT}

# ############################################
# Checking RAC/ORACLE_RESTART Services:
# ############################################

case ${CHECK_CLUSTER} in
y|Y|yes|YES|Yes|ON|On|on)

# Check for ocssd clusterware process:
CHECK_OCSSD=`ps -ef|grep 'ocssd.bin'|grep -v grep|wc -l`
CHECK_CRSD=`ps -ef|grep 'crsd.bin'|grep -v grep|wc -l`

if [ ${CHECK_CRSD} -gt 0 ]
then
 CLS_STR=crs
 export CLS_STR
 CLUSTER_TYPE=CLUSTERWARE
 export CLUSTER_TYPE
else
 CLS_STR=has
 export CLS_STR
 CLUSTER_TYPE=ORACLE_RESTART
 export CLUSTER_TYPE
fi

	if [ ${CHECK_CRSD} -gt 0 ]
	 then

GRID_HOME=`ps -ef|grep 'ocssd.bin'|grep -v grep|awk '{print $NF}'|sed -e 's/\/bin\/ocssd.bin//g'|grep -v sed|grep -v "//g"`
export GRID_HOME

echo "^^^^^^^^^^^^^^^^^^^"                                              >> ${OS_HEALTHCHK_RPT}
echo "CLUSTERWARE CHECKS:"                                              >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^"                                              >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}

FILE_NAME=${GRID_HOME}/bin/ocrcheck
export FILE_NAME
if [ -x ${FILE_NAME} ]
then
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^"                                              >> ${OS_HEALTHCHK_RPT}
echo "OCR DISKS CHECKING:"                                              >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^"                                              >> ${OS_HEALTHCHK_RPT}
${GRID_HOME}/bin/ocrcheck                                               >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
fi

FILE_NAME=${GRID_HOME}/bin/crsctl
export FILE_NAME
if [ -x ${FILE_NAME} ]
then
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^"                                             >> ${OS_HEALTHCHK_RPT}
echo "VOTE DISKS CHECKING:"                                             >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^"                                             >> ${OS_HEALTHCHK_RPT}
${GRID_HOME}/bin/crsctl query css votedisk                              >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
fi
	fi

	if [ ${CHECK_OCSSD} -gt 0 ]
	 then

GRID_HOME=`ps -ef|grep 'ocssd.bin'|grep -v grep|awk '{print $NF}'|sed -e 's/\/bin\/ocssd.bin//g'|grep -v sed|grep -v "//g"`
export GRID_HOME

FILE_NAME=${GRID_HOME}/bin/crsctl
export FILE_NAME
if [ -x ${FILE_NAME} ]
then
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^"                                          >> ${OS_HEALTHCHK_RPT}
echo "${CLUSTER_TYPE}_SERVICES:"                                        >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^"                                          >> ${OS_HEALTHCHK_RPT}

EXCLUDED_SERVICES="ora.proxy_advm|ora.asmgroup|ora.diskmon|ora.ons"
$GRID_HOME/bin/crsctl status res |grep -v "^$"|awk -F "=" 'BEGIN {print " "} {printf("%s",NR%4 ? $2"|" : $2"\n")}'|sed -e 's/ *, /,/g' -e 's/, /,/g'|\
awk -F "|" 'BEGIN { printf "%-50s%-50s\n","Resource_Name","State";printf "%-50s%-50s\n", "-------------------------------------","---------------------"; }{ split ($3,trg,",") split ($4,st,",")} {for (i in trg) {printf "%-50s%-50s\n",$1,st[i]}}'|egrep -v "${EXCLUDED_SERVICES}"        >> ${OS_HEALTHCHK_RPT}

fi 

FILE_NAME=${ORACLE_HOME}/bin/srvctl
export FILE_NAME
if [ -x ${FILE_NAME} ]
then
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^^"                                         >> ${OS_HEALTHCHK_RPT}
echo "DATABASE_SERVICES_STATUS:"                                        >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^^"                                         >> ${OS_HEALTHCHK_RPT}
${ORACLE_HOME}/bin/srvctl status service -d ${DB_UNQ_NAME}              >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
fi

	fi
;;
esac


echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                   >> ${OS_HEALTHCHK_RPT}
echo "List_of_All_Running_Instances:"                                   >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                   >> ${OS_HEALTHCHK_RPT}
ps -ef|grep pmon|grep -v grep                                           >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}

echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                   >> ${OS_HEALTHCHK_RPT}
echo "List_of_All_Running_Listeners:"                                   >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"                                   >> ${OS_HEALTHCHK_RPT}
ps -ef|grep tnslsnr|grep -v grep                                        >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}

# https://superuser.com/questions/529830/get-a-list-of-open-ports-in-linux [datashaman]
FILE_NAME=/bin/netstat
export FILE_NAME
if [ -x ${FILE_NAME} ]
then
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^"                                          >> ${OS_HEALTHCHK_RPT}
echo "List_of_All_Open_Ports:"                                          >> ${OS_HEALTHCHK_RPT}
echo "^^^^^^^^^^^^^^^^^^^^^^^"                                          >> ${OS_HEALTHCHK_RPT}
netstat -lnt | awk 'NR>2{print $4}' | grep -E '(0.0.0.0:|:::)' | sed 's/.*://' | sort -n | uniq          >> ${OS_HEALTHCHK_RPT}
echo ""                                                                 >> ${OS_HEALTHCHK_RPT}
fi


# Convert OS Checks into HTML format:
#${HASHHTMLOS} awk 'BEGIN { print "<table borader=1>"} {print "<tr>"; for(i=1;i<=NF;i++)print "<td><FONT COLOR=BROWN FACE="Times New Roman" SIZE=${FONTSIZE}>" $i"</FONT></td>"; print "</tr>"} END{print "</table>" }' ${OS_HEALTHCHK_RPT} >> ${DB_HEALTHCHK_RPT}

   	case ${HASHHTMLOS} in
   	'echo #')
cat ${OS_HEALTHCHK_RPT} >> ${DB_HEALTHCHK_RPT};;
	*)
${HASHHTMLOS} awk 'BEGIN { print "<table borader=1>"} {print "<tr>"; for(i=1;i<=NF;i++)print "<td><FONT COLOR=BROWN FACE="Times New Roman" SIZE=${FONTSIZE}>" $i"</FONT></td>"; print "</tr>"} END{print "</table>" }' ${OS_HEALTHCHK_RPT} >> ${DB_HEALTHCHK_RPT};;
	esac

# ############################################
# REPORT UNRECOVERABLE DATABASE FILES: [RMAN]
# ############################################
        case ${REPORTUNRECOVERABLE} in
        Y|y|YES|Yes|yes|ON|On|on)

VAL37=$(${ORACLE_HOME}/bin/rman target / << EOF
spool log to ${LOG_DIR}/unrecoverable_DBfiles.log;
REPORT UNRECOVERABLE;
spool log off;
exit;
EOF
)

#${HASHHTMLOS} echo ""							>  ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log
#${HASHHTMLOS} echo ""							>  ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log
#${HASHHTMLOS} echo "UNRECOVERABLE_DATABASE_FILES:RMAN"		>> ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log
#${HASHHTMLOS} echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"			>> ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log
#${HASHHTMLOS} sed '/Spooling \|Recovery Manager\|RMAN>\|using \|Report \|^$/d' ${LOG_DIR}/unrecoverable_DBfiles.log >> ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log
#${HASHHTMLOS} awk 'BEGIN { print "<table borader=1>"} {print "<tr>"; for(i=1;i<=NF;i++)print "<td><FONT COLOR=BROWN FACE="Times New Roman" SIZE=${FONTSIZE}>" $i"</FONT></td>"; print "</tr>"} END{print "</table>" }' ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log >> ${DB_HEALTHCHK_RPT}

        ;;
        esac


# ############################################
# Checking Advisors:
# ############################################
# Checking if the Advisors should be enabled in the report:

        case ${SHOWSQLTUNINGADVISOR} in
        Y|y|YES|Yes|yes|ON|On|on)
	export HASHSTA="";;
	*)
	export HASHSTA="--";;
	esac

        case ${SHOWMEMORYADVISORS} in
        Y|y|YES|Yes|yes|ON|On|on)
	export HASHMA="";;
	*)
	export HASHMA="--";;
	esac

        case ${SHOWSEGMENTADVVISOR} in
        Y|y|YES|Yes|yes|ON|On|on)
	export HASHSA="";;
	*)
	export HASHSA="--";;
	esac

        case ${REPORTUNRECOVERABLE} in
        Y|y|YES|Yes|yes|ON|On|on)
        export HASHU="";;
        *)
        export HASHU="--";;
        esac

        case ${SHOWJOBS} in
        Y|y|YES|Yes|yes|ON|On|on)
	export HASHJ="";;
	*)
	export HASHJ="--";;
	esac

	case ${SHOWHASHEDCRED} in
        Y|y|YES|Yes|yes|ON|On|on)
        export HASHCRD="";;
        *)
        export HASHCRD="--";;
        esac

        case ${SHOWDORMANTACCOUNTS} in
        Y|y|YES|Yes|yes|ON|On|on)
        export HASHDORM="";;
        *)
        export HASHDORM="--";;
        esac


# If the database version is 10g onward collect the advisors recommendations:
        if [ ${DB_VER} -gt 9 ]
         then

VAL611=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set linesize ${SQLLINESIZE} pages 100
-- Enable HTML color format:
--${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { background: #E67E22; font-size: 80%; } th { font:bold 9pt Arial,Helvetica,sans-serif; align: left; color: #FFFFFF; background: #AF601A; } td { font:9pt; background: #FFFFFF; padding: 0px; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

spool ${DB_HEALTHCHK_RPT} app

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Tablespaces Size
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT Tablespaces Size:  [Based on Datafiles MAXSIZE]
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^

set pages 1000 linesize ${SQLLINESIZE} tab off
col tablespace_name for A25
col Total_MB for 999999999999
col Used_MB for 999999999999
col '%Used' for 999.99
comp sum of Total_MB on report
comp sum of Used_MB   on report
bre on report
select tablespace_name,
       (tablespace_size*$blksize)/(1024*1024) Total_MB,
       (used_space*$blksize)/(1024*1024) Used_MB,
      -- used_percent "%Used"
${HASHHTML} case when used_percent > 90 then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(used_percent,999.99) || '</span>' else to_char(used_percent,999.99) end as "%Used"
${HASHNONHTML} to_char(used_percent,999.99) "%Used"
from dba_tablespace_usage_metrics;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT ASM STATISTICS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT ASM STATISTICS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^

select name,state,OFFLINE_DISKS,total_mb,free_mb,
${HASHHTML} case when ROUND((1-(free_mb / total_mb))*100, 2) > 90 then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(ROUND((1-(free_mb / total_mb))*100, 2),999.99) || '</span>' else to_char(ROUND((1-(free_mb / total_mb))*100, 2),999.99) end as "%FULL"
${HASHNONHTML} to_char(ROUND((1-(free_mb / total_mb))*100, 2),999.99) "%FULL"
from v\$asm_diskgroup;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT FRA STATISTICS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT FRA STATISTICS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='1' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT FRA SIZE
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT FRA_SIZE:
${HASHNONHTML} PROMPT ^^^^^^^^^

col name for a35
SELECT NAME,NUMBER_OF_FILES,SPACE_LIMIT/1024/1024/1024 AS TOTAL_SIZE_GB,SPACE_USED/1024/1024/1024 SPACE_USED_GB,
SPACE_RECLAIMABLE/1024/1024/1024 SPACE_RECLAIMABLE_GB,ROUND((SPACE_USED-SPACE_RECLAIMABLE)/SPACE_LIMIT * 100, 1) AS "%FULL_AFTER_CLAIM",
${HASHHTML} case when ROUND((SPACE_USED)/SPACE_LIMIT * 100, 1) > 90 then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(ROUND((SPACE_USED)/SPACE_LIMIT * 100, 1),999.99) || '</span>' else to_char(ROUND((SPACE_USED)/SPACE_LIMIT * 100, 1),999.99) end as "%FULL_NOW"
${HASHNONHTML} to_char(ROUND((SPACE_USED)/SPACE_LIMIT * 100, 1),999.99) "%FULL_NOW"
FROM V\$RECOVERY_FILE_DEST;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='1' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT FRA COMPONENTS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT FRA_COMPONENTS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^

select * from v\$flash_recovery_area_usage;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT DATABASE GROWTH
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT DATABASE GROWTH: [In the Last ~8 days]
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

set serveroutput on

col SNAP_TIME for a45
col "Database Size(GB)" for 99999999999999999
Declare 
    v_BaselineSize    number(20); 
    v_CurrentSize    number(20); 
    v_TotalGrowth    number(20); 
    v_Space        number(20); 
    cursor usageHist is 
            select a.snap_id, 
            SNAP_TIME, 
            sum(TOTAL_SPACE_ALLOCATED_DELTA) over ( order by a.SNAP_ID) ProgSum 
        from 
            (select SNAP_ID, 
                sum(SPACE_ALLOCATED_DELTA) TOTAL_SPACE_ALLOCATED_DELTA 
            from DBA_HIST_SEG_STAT 
            group by SNAP_ID 
            having sum(SPACE_ALLOCATED_TOTAL) <> 0 
            order by 1 ) a, 
            (select distinct SNAP_ID, 
                to_char(END_INTERVAL_TIME,'DD-Mon-YYYY HH24:Mi') SNAP_TIME 
            from DBA_HIST_SNAPSHOT) b 
        where a.snap_id=b.snap_id; 
Begin 
    select sum(SPACE_ALLOCATED_DELTA) into v_TotalGrowth from DBA_HIST_SEG_STAT; 
    select sum(bytes) into v_CurrentSize from dba_segments; 
    v_BaselineSize := (v_CurrentSize - v_TotalGrowth) ;
    dbms_output.put_line('SNAP_TIME           Database Size(GB)');
    for row in usageHist loop 
            v_Space := (v_BaselineSize + row.ProgSum)/(1024*1024*1024); 
        dbms_output.put_line(row.SNAP_TIME || '           ' || to_char(v_Space) ); 
    end loop; 
end;
/


${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Active Incidents
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT Active Incidents:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^

set linesize ${SQLLINESIZE}
col RECENT_PROBLEMS_1_WEEK_BACK for a45
select PROBLEM_KEY RECENT_PROBLEMS_1_WEEK_BACK,to_char(FIRSTINC_TIME,'DD-MON-YY HH24:mi:ss') FIRST_OCCURENCE,to_char(LASTINC_TIME,'DD-MON-YY HH24:mi:ss')
LAST_OCCURENCE FROM V\$DIAG_PROBLEM WHERE LASTINC_TIME > SYSDATE -10;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT OUTSTANDING ALERTS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT OUTSTANDING ALERTS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^

col CREATION_TIME for a40
col REASON for a80
select REASON,CREATION_TIME,METRIC_VALUE from DBA_OUTSTANDING_ALERTS;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT CORRUPTED BLOCKS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT CORRUPTED BLOCKS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^

select * from V\$DATABASE_BLOCK_CORRUPTION;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT BLOCKED SESSIONS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT BLOCKED SESSIONS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^

col module for a27
col event for a24
col MACHINE for a27
col "WA_ST|WAITD|ACT_SINC|LOG_T" for a38
col "INST|USER|SID,SERIAL#" for a30
col "INS|USER|SID,SER|MACHIN|MODUL" for a65
col "PREV|CURR SQLID" for a27
col "I|BLKD_BY" for a12
select /*+RULE*/
substr(s.INST_ID||'|'||s.USERNAME||'| '||s.sid||','||s.serial#||' |'||substr(s.MACHINE,1,22)||'|'||substr(s.MODULE,1,18),1,65)"INS|USER|SID,SER|MACHIN|MODUL"
,substr(w.state||'|'||round(w.WAIT_TIME_MICRO/1000000)||'|'||LAST_CALL_ET||'|'||to_char(LOGON_TIME,'ddMon'),1,38) "WA_ST|WAITD|ACT_SINC|LOG_T"
,substr(w.event,1,24) "EVENT"
,s.FINAL_BLOCKING_INSTANCE||'|'||s.FINAL_BLOCKING_SESSION "I|BLKD_BY"
from    gv\$session s, gv\$session_wait w
where   s.USERNAME is not null
and     s.FINAL_BLOCKING_SESSION is not null
and     s.sid=w.sid
and     s.STATUS='ACTIVE'
order by "I|BLKD_BY" desc,w.event,"INS|USER|SID,SER|MACHIN|MODUL","WA_ST|WAITD|ACT_SINC|LOG_T" desc;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT UN-USABLE INDEXES
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000


${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT UN-USABLE INDEXES:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^
                
PROMPT 
col REBUILD_UNUSABLE_INDEXES for a190
${HASHNONHTML} set echo on feedback on pages 1000
${HASHNONHTML} select 'ALTER INDEX '||OWNER||'.'||INDEX_NAME||' REBUILD ONLINE;' REBUILD_UNUSABLE_INDEXES from dba_indexes where status='UNUSABLE';
${HASHHTML} select OWNER,INDEX_NAME from dba_indexes where status='UNUSABLE';

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT INVALID OBJECTS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT INVALID OBJECTS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT
set pages 0
select 'alter package '||owner||'.'||object_name||' compile;' from dba_objects where status <> 'VALID' and object_type like '%PACKAGE%' union
select 'alter type '||owner||'.'||object_name||' compile specification;' from dba_objects where status <> 'VALID' and object_type like '%TYPE%'union
select 'alter '||object_type||' '||owner||'.'||object_name||' compile;' from dba_objects where status <> 'VALID' and object_type not in ('PACKAGE','PACKAGE BODY','SYNONYM','TYPE','TYPE BODY') union
select 'alter public synonym '||object_name||' compile;' from dba_objects where status <> 'VALID' and object_type ='SYNONYM';
set pages 1000

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT RMAN BACKUP OPERATIONS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000


${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT RMAN BACKUP OPERATIONS: [LAST 24H]
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^

col START_TIME for a15
col END_TIME for a15
col TIME_TAKEN_DISPLAY for a10
col INPUT_BYTES_DISPLAY heading "DATA SIZE" for a10
col OUTPUT_BYTES_DISPLAY heading "Backup Size" for a11
col OUTPUT_BYTES_PER_SEC_DISPLAY heading "Speed/s" for a10
col output_device_type heading "Device_TYPE" for a11
SELECT to_char (start_time,'DD-MON-YY HH24:MI') START_TIME, to_char(end_time,'DD-MON-YY HH24:MI') END_TIME, time_taken_display,
${HASHHTML} case when status not in ('COMPLETED','RUNNING') then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(status) || '</span>' else to_char(status) end as "status",
${HASHNONHTML} status
input_type, output_device_type,input_bytes_display, output_bytes_display, output_bytes_per_sec_display ,COMPRESSION_RATIO
FROM v\$rman_backup_job_details
WHERE end_time > sysdate -1;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHU}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHU}PROMPT REPORT UNRECOVERABLE DATAFILES
${HASHHTML} ${HASHU}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHU}PROMPT
${HASHNONHTML} ${HASHU}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} ${HASHU}PROMPT REPORT UNRECOVERABLE DATAFILES:
${HASHNONHTML} ${HASHU}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHU}spool off
--${HASHU}host sed '/Spooling \|Recovery Manager\|RMAN>\|^$/d' ${LOG_DIR}/unrecoverable_DBfiles.log >> ${DB_HEALTHCHK_RPT}
${HASHU}host sed '/Spooling \|Recovery Manager\|RMAN>\|using \|Report \|^$/d' ${LOG_DIR}/unrecoverable_DBfiles.log >> ${DB_HEALTHCHK_RPT}
--${HASHU}host ${HASHNOHTMLOS} sed '/Spooling \|Recovery Manager\|RMAN>\|^$/d' ${LOG_DIR}/unrecoverable_DBfiles.log >> ${DB_HEALTHCHK_RPT}
--${HASHU}host ${HASHHTMLOS} sed '/Spooling \|Recovery Manager\|RMAN>\|using \|Report \|^$/d' ${LOG_DIR}/unrecoverable_DBfiles.log > ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log
--${HASHU}host ${HASHHTMLOS} awk 'BEGIN { print "<table borader=1>"} {print "<tr>"; for(i=1;i<=NF;i++)print "<td><FONT COLOR=BROWN FACE="Times New Roman" SIZE=${FONTSIZE}>" $i"</FONT></td>"; print "</tr>"} END{print "</table>" }' ${LOG_DIR}/unrecoverable_DBfiles_FORMATTED.log > ${LOG_DIR}/unrecoverable_DBfiles_HTML.log
--${HASHU}host ${HASHHTMLOS} cat ${LOG_DIR}/unrecoverable_DBfiles_HTML.log >> ${DB_HEALTHCHK_RPT}

${HASHU}spool ${DB_HEALTHCHK_RPT} app

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHJ}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHJ}PROMPT SCHEDULED JOBS STATUS
${HASHHTML} ${HASHJ}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} ${HASHJ}PROMPT <p> <table border='1' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHJ}PROMPT DBMS_JOBS
${HASHHTML} ${HASHJ}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHJ}PROMPT
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} ${HASHJ}PROMPT SCHEDULED JOBS STATUS:
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} ${HASHJ}PROMPT
${HASHNONHTML} ${HASHJ}PROMPT DBMS_JOBS:
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^

${HASHJ}set linesize ${SQLLINESIZE}
${HASHJ}col LAST_RUN for a25
${HASHJ}col NEXT_RUN for a25
${HASHJ}select job,schema_user,failures,to_char(LAST_DATE,'DD-Mon-YYYY hh24:mi:ss')LAST_RUN,to_char(NEXT_DATE,'DD-Mon-YYYY hh24:mi:ss')NEXT_RUN from dba_jobs;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHJ}PROMPT <br> <p> <table border='1' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHJ}PROMPT DBMS_SCHEDULER
${HASHHTML} ${HASHJ}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHJ}PROMPT 
${HASHNONHTML} ${HASHJ}PROMPT DBMS_SCHEDULER:
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^^^^^^

${HASHJ}col OWNER 				for a15
${HASHJ}col JOB_NAME 				for a30
${HASHJ}col STATE 				for a15
${HASHJ}col FAILURE_COUNT 			for 9999 heading 'Fail'
${HASHJ}col "DURATION(d:hh:mm:ss)" 		for a22
${HASHJ}col REPEAT_INTERVAL 			for a70
${HASHJ}col "LAST_RUN || REPEAT_INTERVAL" 	for a65
${HASHJ}col "DURATION(d:hh:mm:ss)" 		for a12
${HASHJ}select JOB_NAME,OWNER,ENABLED,STATE,
${HASHJ} ${HASHHTML} case when FAILURE_COUNT > 0 then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(FAILURE_COUNT,99999) || '</span>' else to_char(FAILURE_COUNT,99999) end as "FAILURE_COUNT",
${HASHJ} ${HASHNONHTML} FAILURE_COUNT,
${HASHJ}to_char(LAST_START_DATE,'DD-Mon-YYYY hh24:mi:ss')||' || '||REPEAT_INTERVAL "LAST_RUN || REPEAT_INTERVAL",
${HASHJ}extract(day from last_run_duration) ||':'||
${HASHJ}lpad(extract(hour from last_run_duration),2,'0')||':'||
${HASHJ}lpad(extract(minute from last_run_duration),2,'0')||':'||
${HASHJ}lpad(round(extract(second from last_run_duration)),2,'0') "DURATION(d:hh:mm:ss)"
${HASHJ}from dba_scheduler_jobs order by ENABLED,STATE;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHJ}PROMPT <p> <table border='1' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHJ}PROMPT AUTOTASK INTERNAL MAINTENANCE WINDOWS
${HASHHTML} ${HASHJ}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHJ}PROMPT
${HASHNONHTML} ${HASHJ}PROMPT AUTOTASK INTERNAL MAINTENANCE WINDOWS:
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHJ}col WINDOW_NAME for a17
${HASHJ}col NEXT_RUN for a20
${HASHJ}col ACTIVE for a6
${HASHJ}col OPTIMIZER_STATS for a15
${HASHJ}col SEGMENT_ADVISOR for a15
${HASHJ}col SQL_TUNE_ADVISOR for a16
${HASHJ}SELECT WINDOW_NAME,TO_CHAR(WINDOW_NEXT_TIME,'DD-MM-YYYY HH24:MI:SS') NEXT_RUN,AUTOTASK_STATUS STATUS,WINDOW_ACTIVE ACTIVE,OPTIMIZER_STATS,SEGMENT_ADVISOR,SQL_TUNE_ADVISOR FROM DBA_AUTOTASK_WINDOW_CLIENTS;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHJ}PROMPT <br> <p> <table border='1' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHJ}PROMPT Current Running Jobs
${HASHHTML} ${HASHJ}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHJ}PROMPT 
${HASHNONHTML} ${HASHJ}PROMPT Current Running Jobs:
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^^^^^^^^^^^

${HASHJ}col INS				for 999
${HASHJ}col "JOB_NAME|OWNER|SPID|SID"	for a55
${HASHJ}col ELAPSED_TIME		for a17
${HASHJ}col CPU_USED 			for a17
${HASHJ}col "WAIT_SEC"  		for 9999999999
${HASHJ}col WAIT_CLASS 			for a15
${HASHJ}col "BLKD_BY" 			for 9999999
${HASHJ}col "WAITED|WCLASS|EVENT" 	for a45
${HASHJ}select j.RUNNING_INSTANCE INS,j.JOB_NAME ||' | '|| j.OWNER||' |'||SLAVE_OS_PROCESS_ID||'|'||j.SESSION_ID"JOB_NAME|OWNER|SPID|SID"
${HASHJ},s.FINAL_BLOCKING_SESSION "BLKD_BY",ELAPSED_TIME,CPU_USED
${HASHJ},substr(s.SECONDS_IN_WAIT||'|'||s.WAIT_CLASS||'|'||s.EVENT,1,45) "WAITED|WCLASS|EVENT",S.SQL_ID
${HASHJ}from dba_scheduler_running_jobs j, gv\$session s
${HASHJ}where   j.RUNNING_INSTANCE=S.INST_ID(+)
${HASHJ}and     j.SESSION_ID=S.SID(+)
${HASHJ}order by "JOB_NAME|OWNER|SPID|SID",ELAPSED_TIME;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHJ}PROMPT <br> <p> <table border='1' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHJ}PROMPT FAILED DBMS_SCHEDULER JOBS IN THE LAST 24H
${HASHHTML} ${HASHJ}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHJ}PROMPT
${HASHNONHTML} ${HASHJ}PROMPT FAILED DBMS_SCHEDULER JOBS IN THE LAST 24H:
${HASHNONHTML} ${HASHJ}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHJ}col LOG_DATE for a36
${HASHJ}col OWNER for a15
${HASHJ}col JOB_NAME for a35
${HASHJ}col STATUS for a11
${HASHJ}col RUN_DURATION for a20
${HASHJ}col ID for 99
${HASHJ}select INSTANCE_ID ID,JOB_NAME,OWNER,LOG_DATE,STATUS,ERROR#,RUN_DURATION from DBA_SCHEDULER_JOB_RUN_DETAILS where LOG_DATE > sysdate-1 and STATUS='FAILED' order by JOB_NAME,LOG_DATE;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Queries Running For More Than [${LONG_RUN_QUR_HOURS}] Hours
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT Queries Running For More Than [${LONG_RUN_QUR_HOURS}] Hour:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

col module for a30
col DURATION_HOURS for 99999.9
col STARTED_AT for a13
col "USERNAME| SID,SERIAL#" for a30
${HASHNONHTML} col "SQL_ID | SQL_TEXT" for a120
select username||'| '||sid ||','|| serial# "USERNAME| SID,SERIAL#",substr(MODULE,1,30) "MODULE", to_char(sysdate-last_call_et/24/60/60,'DD-MON HH24:MI') STARTED_AT,
last_call_et/60/60 "DURATION_HOURS"
--||' | '|| (select SQL_FULLTEXT from v\$sql where address=sql_address) "SQL_ID | SQL_TEXT"
,SQL_ID
from v\$session where
username is not null 
and module is not null
and module not in (${EXCLUDED_MODULES})
and last_call_et > 60*60*${LONG_RUN_QUR_HOURS}
and status = 'ACTIVE';

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHSTA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHSTA}PROMPT ADVISORS STATUS
${HASHHTML} ${HASHSTA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000


${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT ADVISORS STATUS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^

col ADVISOR_NAME for a60
col STATUS for a15
${HASHSTA}SELECT client_name ADVISOR_NAME, status FROM dba_autotask_client ORDER BY client_name;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHSTA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHSTA}PROMPT SQL TUNING ADVISOR
${HASHHTML} ${HASHSTA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHSTA}PROMPT
${HASHNONHTML} ${HASHSTA}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} ${HASHSTA}PROMPT SQL TUNING ADVISOR:
${HASHNONHTML} ${HASHSTA}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHSTA}PROMPT <br> <p> <table border='1' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHSTA}PROMPT Last Execution of SQL TUNING ADVISOR
${HASHHTML} ${HASHSTA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHSTA}PROMPT
${HASHNONHTML} ${HASHSTA}PROMPT Last Execution of SQL TUNING ADVISOR:
${HASHNONHTML} ${HASHSTA}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHSTA}col TASK_NAME for a60
${HASHSTA}set long 2000000000
${HASHSTA}SELECT task_name, status, TO_CHAR(execution_end,'DD-MON-YY HH24:MI') Last_Execution FROM dba_advisor_executions where TASK_NAME='SYS_AUTO_SQL_TUNING_TASK' and execution_end>sysdate-1;


${HASHSTA}variable Findings_Report CLOB;
${HASHSTA}	BEGIN
${HASHSTA}	:Findings_Report :=DBMS_SQLTUNE.REPORT_AUTO_TUNING_TASK(
${HASHSTA}	begin_exec => NULL,
${HASHSTA}	end_exec => NULL,
${HASHSTA}	type => 'TEXT',
${HASHSTA}	level => 'TYPICAL',
${HASHSTA}	section => 'ALL',
${HASHSTA}	object_id => NULL,
${HASHSTA}	result_limit => NULL);
${HASHSTA}	END;
${HASHSTA}	/
${HASHSTA}	print :Findings_Report

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHMA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHMA}PROMPT MEMORY ADVISORS
${HASHHTML} ${HASHMA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT ORACLE MEMORY UTILIZATION:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT ORACLE MEMORY UTILIZATION
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000


col inst_id heading ins for 999
col COMPONENT           for a35
col CURRENT_SIZE_MB     for 99999999999
col MAX_SIZE_MB         for 99999999999
select INST_ID,COMPONENT,USER_SPECIFIED_SIZE/1024/1024 USER_SPECIFIED_SIZE_MB,CURRENT_SIZE/1024/1024 CURRENT_SIZE_MB,MAX_SIZE/1024/1024 MAX_SIZE_MB from gv\$memory_dynamic_components where COMPONENT not like '%K buffer%' and COMPONENT not in ('ASM Buffer Cache','KEEP buffer cache','RECYCLE buffer cache','unified pga pool','Data Transfer Cache') order by COMPONENT,INST_ID;



${HASHNONHTML} ${HASHMA}PROMPT
${HASHNONHTML} ${HASHMA}PROMPT
${HASHNONHTML} ${HASHMA}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} ${HASHMA}PROMPT MEMORY ADVISORS:
${HASHNONHTML} ${HASHMA}PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHMA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHMA}PROMPT SGA ADVISOR
${HASHHTML} ${HASHMA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHMA}PROMPT
${HASHNONHTML} ${HASHMA}PROMPT SGA ADVISOR:
${HASHNONHTML} ${HASHMA}PROMPT ^^^^^^^^^^^^

${HASHMA}col ESTD_DB_TIME for 99999999999999999
${HASHMA}col ESTD_DB_TIME_FACTOR for 9999999999999999999999999999
${HASHMA}select * from V\$SGA_TARGET_ADVICE where SGA_SIZE_FACTOR > .6 and SGA_SIZE_FACTOR < 1.6;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHMA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHMA}PROMPT Buffer Cache ADVISOR
${HASHHTML} ${HASHMA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHMA}PROMPT
${HASHNONHTML} ${HASHMA}PROMPT Buffer Cache ADVISOR:
${HASHNONHTML} ${HASHMA}PROMPT ^^^^^^^^^^^^^^^^^^^^^

${HASHMA}col ESTD_SIZE_MB for 9999999999999
${HASHMA}col ESTD_PHYSICAL_READS for 99999999999999999999
${HASHMA}col ESTD_PHYSICAL_READ_TIME for 99999999999999999999
${HASHMA}select SIZE_FACTOR "%SIZE",SIZE_FOR_ESTIMATE ESTD_SIZE_MB,ESTD_PHYSICAL_READS,ESTD_PHYSICAL_READ_TIME,ESTD_PCT_OF_DB_TIME_FOR_READS
${HASHMA}from V\$DB_CACHE_ADVICE where SIZE_FACTOR >.8 and SIZE_FACTOR<1.3;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHMA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHMA}PROMPT Shared Pool ADVISOR
${HASHHTML} ${HASHMA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000


${HASHNONHTML} ${HASHMA}PROMPT
${HASHNONHTML} ${HASHMA}PROMPT Shared Pool ADVISOR:
${HASHNONHTML} ${HASHMA}PROMPT ^^^^^^^^^^^^^^^^^^^^

${HASHMA}col SIZE_MB for 99999999999
${HASHMA}col SIZE_FACTOR for 99999999
${HASHMA}col ESTD_SIZE_MB for 99999999999999999999
${HASHMA}col LIB_CACHE_SAVED_TIME for 99999999999999999999999999
${HASHMA}select SHARED_POOL_SIZE_FOR_ESTIMATE SIZE_MB,SHARED_POOL_SIZE_FACTOR "%SIZE",SHARED_POOL_SIZE_FOR_ESTIMATE/1024/1024 ESTD_SIZE_MB,ESTD_LC_TIME_SAVED LIB_CACHE_SAVED_TIME,
${HASHMA}ESTD_LC_LOAD_TIME PARSING_TIME from V\$SHARED_POOL_ADVICE
${HASHMA}where SHARED_POOL_SIZE_FACTOR > .9 and SHARED_POOL_SIZE_FACTOR  < 1.6;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHMA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHMA}PROMPT PGA ADVISOR
${HASHHTML} ${HASHMA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHMA}PROMPT
${HASHNONHTML} ${HASHMA}PROMPT PGA ADVISOR:
${HASHNONHTML} ${HASHMA}PROMPT ^^^^^^^^^^^^

${HASHMA}col SIZE_FACTOR  for 999999999
${HASHMA}col ESTD_SIZE_MB for 99999999999999999999
${HASHMA}col MB_PROCESSED for 99999999999999999999
${HASHMA}col ESTD_TIME for 99999999999999999999
${HASHMA}select PGA_TARGET_FACTOR "%SIZE",PGA_TARGET_FOR_ESTIMATE/1024/1024 ESTD_SIZE_MB,BYTES_PROCESSED/1024/1024 MB_PROCESSED,
${HASHMA}ESTD_TIME,ESTD_PGA_CACHE_HIT_PERCENTAGE PGA_HIT,ESTD_OVERALLOC_COUNT PGA_SHORTAGE
${HASHMA}from V\$PGA_TARGET_ADVICE where PGA_TARGET_FACTOR > .7 and PGA_TARGET_FACTOR < 1.6;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHSA}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHSA}PROMPT SEGMENT ADVISOR
${HASHHTML} ${HASHSA}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHSA}PROMPT
${HASHNONHTML} ${HASHSA}PROMPT SEGMENT ADVISOR:
${HASHNONHTML} ${HASHSA}PROMPT ^^^^^^^^^^^^^^^^

${HASHSA}select'Task Name : ' || f.task_name || chr(10) ||
${HASHSA}'Start Run Time : ' || TO_CHAR(execution_start, 'dd-mon-yy hh24:mi') || chr (10) ||
${HASHSA}'Segment Name : ' || o.attr2 || chr(10) ||
${HASHSA}'Segment Type : ' || o.type || chr(10) ||
${HASHSA}'Partition Name : ' || o.attr3 || chr(10) ||
${HASHSA}'Message : ' || f.message || chr(10) ||
${HASHSA}'More Info : ' || f.more_info || chr(10) ||
${HASHSA}'-------------------------------------------' Advice
${HASHSA}FROM dba_advisor_findings f
${HASHSA},dba_advisor_objects o
${HASHSA},dba_advisor_executions e
${HASHSA}WHERE o.task_id = f.task_id
${HASHSA}AND o.object_id = f.object_id
${HASHSA}AND f.task_id = e.task_id
${HASHSA}AND e. execution_start > sysdate - 1
${HASHSA}AND e.advisor_name = 'Segment Advisor'
${HASHSA}ORDER BY f.task_name;

${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT TOP FRAGMENTED TABLES:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT TOP FRAGMENTED TABLES
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000
col "%RECLAIMABLE_SPACE" for 99
col owner                for a30
col "%FRAGMENTED_SPACE"  for a17
col LAST_ANALYZED for a13

select * from (select owner,table_name,to_char(LAST_ANALYZED, 'DD-MON-YYYY') LAST_ANALYZED,
round(blocks * ${blksize}/1024/1024)     "FULL_SIZE_MB",
round(num_rows * avg_row_len/1024/1024)  "ACTUAL_SIZE_MB",
round(blocks * ${blksize}/1024/1024) - round(num_rows * avg_row_len/1024/1024) "FRAGMENTED_SPACE_MB",
round(((round((blocks * ${blksize}/1024/1024)) - round((num_rows * avg_row_len/1024/1024))) / round((blocks * ${blksize}/1024/1024))) * 100)||'%' "%FRAGMENTED_SPACE"
from dba_tables
where blocks>10
-- Exclude SYS objects:
and owner <> 'SYS'
and round(blocks * ${blksize}/1024/1024) > 10
-- Fragmented Space must be > 30%:
and ((round((blocks * ${blksize}/1024/1024)) - round((num_rows * avg_row_len/1024/1024))) / round((blocks * ${blksize}/1024/1024))) * 100 > 30
order by "FRAGMENTED_SPACE_MB" desc) where rownum<11;

PROMPT Hint: The accuracy of the FRAGMENTED TABLES list depends on having a recent STATISTICS.

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT CURRENT OS / HARDWARE STATISTICS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000


${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT CURRENT OS / HARDWARE STATISTICS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

select stat_name,value from v\$osstat;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT RESOURCE LIMIT
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT RESOURCE LIMIT:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^

col INITIAL_ALLOCATION for a20
col LIMIT_VALUE for a20
select * from gv\$resource_limit order by RESOURCE_NAME;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT RECYCLEBIN OBJECTS#
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT RECYCLEBIN OBJECTS#: [Purging DBA_RECYCLEBIN can boost the performance of X$ tables]
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^

col "RECYCLED_OBJECTS#" for 999999999999999999
col "TOTAL_SIZE_MB"     for 99999999999999
set feedback off
select
${HASHHTML} case when count(*) > 1000 then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(count(*)) || '</span>' else to_char(count(*)) end as "RECYCLED_OBJECTS#",
${HASHNONHTML} count(*) "RECYCLED_OBJECTS#",
${HASHHTML} case when sum(space)*${blksize}/1024/1024  > 1024 then '<span style="background-color:#E67E22;display:block;overflow:auto">' || to_char(sum(space)*${blksize}/1024/1024) || '</span>' else to_char(sum(space)*${blksize}/1024/1024) end as "TOTAL_SIZE_MB"
${HASHNONHTML} sum(space)*${blksize}/1024/1024 "TOTAL_SIZE_MB"
from dba_recyclebin group by 1;

set feedback on

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT FLASHBACK RESTORE POINTS
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT FLASHBACK RESTORE POINTS:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^

col SCN                for 999999999999999999
col time               for a35 
col RESTORE_POINT_TIME for a35
col name               for a40
select NAME,SCN,TIME,STORAGE_SIZE/1024/1024/1024 STORAGE_SIZE_GB from v\$restore_point;


${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT HEALTH MONITOR
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT HEALTH MONITOR:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^

col DESCRIPTION for a80
col repair_script for a80
select name,type,status,description,repair_script from V\$HM_RECOMMENDATION where time_detected > sysdate -1;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Monitored INDEXES
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT Monitored INDEXES:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^

set linesize ${SQLLINESIZE} pages 1000
col Index_NAME for a40
col TABLE_NAME for a40
        select io.name Index_NAME, t.name TABLE_NAME,decode(bitand(i.flags, 65536),0,'NO','YES') Monitoring,
        decode(bitand(ou.flags, 1),0,'NO','YES') USED,ou.start_monitoring,ou.end_monitoring
        from sys.obj$ io,sys.obj$ t,sys.ind$ i,sys.object_usage ou where i.obj# = ou.obj# and io.obj# = ou.obj# and t.obj# = i.bo#;

--PROMPT
--PROMPT To stop monitoring USED indexes use this command:
--prompt select 'ALTER INDEX RA.'||io.name||' NOMONITORING USAGE;' from sys.obj$ io,sys.obj$ t,sys.ind$ i,sys.object_usage ou where i.obj# = ou.obj# and io.obj# = ou.obj# and t.obj# = i.bo#
--prompt and decode(bitand(i.flags, 65536),0,'NO','YES')='YES' and decode(bitand(ou.flags, 1),0,'NO','YES')='YES' order by 1
--prompt /

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT REDO LOG SWITCHES
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT REDO LOG SWITCHES:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^

set linesize ${SQLLINESIZE}
col day for a11
SELECT to_char(first_time,'YYYY-MON-DD') day,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'9999') "00",
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'9999') "01",
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'9999') "02",
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'9999') "03",
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'9999') "04",
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'9999') "05",
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'9999') "06",
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'9999') "07",
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'9999') "08",
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'9999') "09",
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'9999') "10",
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'9999') "11",
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'9999') "12",
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'9999') "13",
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'9999') "14",
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'9999') "15",
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'9999') "16",
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'9999') "17",
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'9999') "18",
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'9999') "19",
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'9999') "20",
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'9999') "21",
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'9999') "22",
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'9999') "23"
from v\$log_history where first_time > sysdate-1
GROUP by to_char(first_time,'YYYY-MON-DD') order by 1 asc;

${HASHHTML} PROMPT <br>
${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='35%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Modified Parameters Since The Instance Startup
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} PROMPT
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} PROMPT Modified Parameters Since The Instance Startup:
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

col name for a45
col VALUE for a80
col DEPRECATED for a10
select NAME,VALUE,ISDEFAULT "DEFAULT",ISDEPRECATED "DEPRECATED" from v\$parameter where ISMODIFIED = 'SYSTEM_MOD' order by 1;

${HASHHTML} PROMPT <br>
${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} ${HASHCRD}PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='20%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} ${HASHCRD}PROMPT Cred Backup
${HASHHTML} ${HASHCRD}PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} ${HASHCRD}PROMPT
${HASHNONHTML} ${HASHCRD}PROMPT ^^^^^^^^^^^^

${HASHNONHTML} ${HASHCRD}PROMPT Cred Backup:
${HASHNONHTML} ${HASHCRD}PROMPT ^^^^^^^^^^^^

${HASHCRD}col name for a35
${HASHCRD}col HASH for a35
${HASHCRD}col CREATION_DATE for a20
${HASHCRD}col PASSWORD_LAST_CHANGED for a30
${HASHCRD}col "CREATE_DATE||PASS_LAST_CHANGE" for a60
${HASHNONHTML} ${HASHCRD}select name,PASSWORD HASH,CTIME ||' || '||PTIME "CREATE_DATE||PASS_LAST_CHANGE" from user\$ where PASSWORD is not null order by 1;
${HASHHTML} ${HASHCRD}select name,PASSWORD HASH,CTIME "CREATION_DATE",PTIME "PASSWORD_LAST_CHANGED" from user\$ where PASSWORD is not null order by 1;

spool off
exit;
EOF
)

        fi

# #################################################
# Reporting New Created Objects in the last 24Hours:
# #################################################
NEWOBJCONTRAW=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set pages 0 feedback off echo off;
select count(*) from dba_objects
where created > sysdate-1
and owner <> 'SYS';
exit;
EOF
)
NEWOBJCONT=`echo ${NEWOBJCONTRAW} | awk '{print $NF}'`
                if [ ${NEWOBJCONT} -ge ${NEWOBJCONTTHRESHOLD} ]
                 then
VALNEWOBJCONT=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set linesize ${SQLLINESIZE} pages 1000
-- Enable HTML color format:
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

spool ${DB_HEALTHCHK_RPT} app

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT New Created objects [Last 24H]
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} prompt
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt New Created objects [Last 24H] ...
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt
col owner for a30
col object_name for a30
col object_type for a19
col created for a20
select object_type,owner,object_name,to_char(created, 'DD-Mon-YYYY HH24:MI:SS') CREATED from dba_objects
where created > sysdate-1
and owner <> 'SYS'
order by owner,object_type;

spool off
exit;
EOF
) 
		fi

# ###############################################
# Reporting Modified Objects in the last 24Hours:
# ###############################################
MODOBJCONTRAW=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set pages 0 feedback off echo off;
select count(*) from dba_objects
where LAST_DDL_TIME > sysdate-1
and owner <> 'SYS';
exit;
EOF
)
MODOBJCONT=`echo ${MODOBJCONTRAW} | awk '{print $NF}'`
                if [ ${MODOBJCONT} -ge ${MODOBJCONTTHRESHOLD} ]
                 then
VALMODOBJCONT=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set linesize ${SQLLINESIZE} pages 1000
-- Enable HTML color format:
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

spool ${DB_HEALTHCHK_RPT} app

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Modified objects in the Last 24H
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} prompt
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt Modified objects in the Last 24H ...
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt
col owner for a30
col object_name for a30
col object_type for a19
col LAST_DDL_TIME for a20
select object_type,owner,object_name,to_char(LAST_DDL_TIME, 'DD-Mon-YYYY HH24:MI:SS') LAST_DDL_TIME from dba_objects
where LAST_DDL_TIME > sysdate-1
and owner <> 'SYS'
order by owner,object_type;

spool off
exit;
EOF
) 
                fi

# ###############################################
# Checking AUDIT RECORDS ON THE DATABASE:
# ###############################################
# Check if Checking Audit Records is ENABLED:
	case ${CHKAUDITRECORDS} in
	Y|y|YES|Yes|yes|ON|On|on)
VAL70=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set pages 0 feedback off echo off;
SELECT (SELECT COUNT(*) FROM dba_audit_trail
where ACTION_NAME not like 'LOGO%' and ACTION_NAME not in ('SELECT','SET ROLE') and timestamp > SYSDATE-1)
+
(SELECT COUNT(*) FROM DBA_AUDIT_SESSION WHERE timestamp > SYSDATE-1 and returncode = 1017)
+
(SELECT COUNT(*) FROM dba_fga_audit_trail WHERE timestamp > SYSDATE-1)
+
(SELECT COUNT(*) FROM dba_objects where created > sysdate-1 and owner <> 'SYS') AUD_REC_COUNT FROM dual;
exit;
EOF
)
VAL80=`echo ${VAL70} | awk '{print $NF}'`
                if [ ${VAL80} -ge ${AUDITRECOTHRESHOLD} ]
                 then
VAL90=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" << EOF
set linesize ${SQLLINESIZE} pages 1000
-- Enable HTML color format:
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF

spool ${LOG_DIR}/audit_records.log
SET TIMING ON
col OS_USERNAME for a20
col EXTENDED_TIMESTAMP for a36
col OWNER for a25
col OBJ_NAME for a25
col OS_USERNAME for a20
col USERNAME for a25
col USERHOST for a35
col ACTION_NAME for a25
col ACTION_OWNER_OBJECT for a55
col TERMINAL for a30
col ACTION_NAME for a20
col TIMESTAMP for a21

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Failed Login Attempts in the last 24Hours
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} prompt
${HASHNONHTML} prompt
${HASHNONHTML} prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt Failed Login Attempts in the last 24Hours ...
${HASHNONHTML} prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt
select to_char (EXTENDED_TIMESTAMP,'DD-MON-YYYY HH24:MI:SS') TIMESTAMP,OS_USERNAME,USERNAME,TERMINAL,USERHOST,ACTION_NAME
from DBA_AUDIT_SESSION
where timestamp > (sysdate -1)
and returncode = 1017
order by 1;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Audit records in the last 24Hours AUD$
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} prompt
${HASHNONHTML} prompt
${HASHNONHTML} prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt Audit records in the last 24Hours AUD$...
${HASHNONHTML} prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt
select extended_timestamp,OS_USERNAME,USERNAME,USERHOST,ACTION_NAME||'  '||OWNER||' . '||OBJ_NAME ACTION_OWNER_OBJECT
from dba_audit_trail 
where
timestamp > SYSDATE-1
and ACTION_NAME not like 'LOGO%'
and ACTION_NAME not in ('SELECT','SET ROLE')
-- and USERNAME not in ('CRS_ADMIN','DBSNMP')
-- and OS_USERNAME not in ('workflow')
-- and OBJ_NAME not like '%TMP_%'
-- and OBJ_NAME not like 'WRKDETA%'
-- and OBJ_NAME not in ('PBCATTBL','SETUP','WRKIB','REMWORK')
order by EXTENDED_TIMESTAMP;

${HASHHTML} SET PAGES 0
${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHHTML} PROMPT Fine Grained Auditing Data
${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHHTML} set pages 1000

${HASHNONHTML} prompt
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt Fine Grained Auditing Data ...
${HASHNONHTML} PROMPT ^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHNONHTML} prompt
col sql_text for a70
col time for a36
col USERHOST for a21
col db_user for a15
select to_char(timestamp,'DD-MM-YYYY HH24:MI:SS') as time,db_user,userhost,sql_text,SQL_BIND
from dba_fga_audit_trail
where
timestamp > SYSDATE-1
-- and policy_name='PAYROLL_TABLE'
order by EXTENDED_TIMESTAMP;

${HASHDORM} ${HASHHTML} SET PAGES 0
${HASHDORM} ${HASHHTML} SET MARKUP HTML OFF SPOOL OFF
${HASHDORM} ${HASHHTML} PROMPT <br> <p> <table border='3' bordercolor='#E67E22' width='30%' align='left' summary='Script output'> <tr> <th scope="col">
${HASHDORM} ${HASHHTML} PROMPT Dormant Accounts: [Accounts that did not login in the last ${DORMANT_INACTIVE_DAYS} days]
${HASHDORM} ${HASHHTML} PROMPT </td> </tr> </table> <p> <br>
${HASHDORM} ${HASHHTML} SET WRAP OFF ECHO OFF FEEDBACK OFF MARKUP HTML ON SPOOL ON HEAD '<title></title> <style type="text/css"> table { font-size: 80%; } th { background: #AF601A; } </style>' TABLE "border='2' bordercolor='#E67E22'" ENTMAP OFF
${HASHDORM} ${HASHHTML} set pages 1000

${HASHDORM} ${HASHNONHTML} prompt
${HASHDORM} ${HASHNONHTML} prompt
${HASHDORM} ${HASHNONHTML} prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHDORM} ${HASHNONHTML} prompt Dormant Accounts: [Accounts that did not login in the last ${DORMANT_INACTIVE_DAYS} days] ...
${HASHDORM} ${HASHNONHTML} prompt ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

${HASHDORM} ${HASHNONHTML} prompt

${HASHDORM} select userid,max(ntimestamp#) LAST_LOGIN_DATE from aud$ where ntimestamp# < (sysdate - ${DORMANT_INACTIVE_DAYS}) group by userid order by LAST_LOGIN_DATE;


spool off
exit;
EOF
)
cat ${LOG_DIR}/audit_records.log >>  ${DB_HEALTHCHK_RPT}
                fi
	;;
	esac

# Remove odd lines from the report:
sed -i 's/^rows will be truncated//g' ${DB_HEALTHCHK_RPT}

export LOGFILE=${DB_HEALTHCHK_RPT}
export MSGSUBJECT="HEALTH CHECK REPORT: For Database [${DB_NAME_UPPER}] on Server [${SRV_NAME}]"
echo ${MSGSUBJECT}

${MAILEXEC} "${MSGSUBJECT}" ${MAIL_LIST} < ${LOGFILE}

(
echo "To: ${EMAIL};"
echo "MIME-Version: 1.0"
echo "Content-Type: text/html;"
echo "Subject: ${MSGSUBJECT}"
cat ${LOGFILE}
) | ${SENDMAIL}



echo "HEALTH CHECK REPORT FOR DATABASE [${DB_NAME_UPPER}] WAS SAVED TO: ${DB_HEALTHCHK_RPT}"
        done

echo ""

# #############################
# De-Neutralize login.sql file: [Bug Fix]
# #############################
# If login.sql was renamed during the execution of the script revert it back to its original name:
        if [ -f ${USR_ORA_HOME}/login.sql_NeutralizedBy${SCRIPT_NAME} ]
         then
mv ${USR_ORA_HOME}/login.sql_NeutralizedBy${SCRIPT_NAME}  ${USR_ORA_HOME}/login.sql
        fi

# #############
# END OF SCRIPT
# #############
# REPORT BUGS to: mahmmoudadel@hotmail.com
# DOWNLOAD THE LATEST VERSION OF DATABASE ADMINISTRATION BUNDLE FROM:
# http://dba-tips.blogspot.com/2014/02/oracle-database-administration-scripts.html
# DISCLAIMER: THIS SCRIPT IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT WITHOUT ANY WARRANTY. IT IS PROVIDED "AS IS".