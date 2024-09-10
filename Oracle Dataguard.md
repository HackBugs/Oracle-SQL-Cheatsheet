## Oracle Data Gurad

Bilkul, main aapko Oracle Data Guard ke setup ke process ko ek beginner ke liye step-by-step batata hoon. Oracle Data Guard aapke primary database ka ek standby copy banata hai jo disaster recovery aur high availability ke liye use hota hai.

### 1. Prerequisites

**1.1 Hardware aur Software Requirements**
- Do servers chahiye: ek primary database ke liye aur ek standby database ke liye.
- Oracle Database ka same version dono servers par install hona chahiye.
- Network connectivity dono servers ke beech.
- Disk space aur memory requirements ko check kar lein.

**1.2 Initial Setup**
- Oracle Database dono servers par install karein.
- Dono servers par same Oracle software version aur patch level hona chahiye.

### 2. Setup Primary Database

**2.1 Primary Database Configuration**

1. **Initialization Parameter File Update:**
   - `init.ora` file mein kuch parameters update karna hota hai.
   - File ko edit karein aur following parameters add/update karein:
     ```sql
     LOG_ARCHIVE_DEST_1='LOCATION=/path/to/archive'
     LOG_ARCHIVE_DEST_2='SERVICE=standby_db CONNECT= (SERVICE=standby_db)'
     FAL_SERVER=standby_db
     FAL_CLIENT=primary_db
     ```

2. **Enable Forced Logging:**
   - Oracle database ko force logging enable karna hota hai taaki sab data changes log ho:
     ```sql
     ALTER DATABASE FORCE LOGGING;
     ```

3. **Create a Backup of the Primary Database:**
   - Standby database create karne se pehle primary database ka full backup lena zaroori hai.
   - Backup tools jaise RMAN ka use karein.

### 3. Setup Standby Database

**3.1 Create a Standby Database**

1. **Copy Database Files:**
   - Primary database ka backup copy karke standby server par transfer karein.

2. **Restore the Backup:**
   - Standby server par Oracle database ko restore karein using RMAN or manual methods.

3. **Create Standby Control File:**
   - Primary database se standby control file create karein:
     ```sql
     ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/path/to/standby_control.ctl';
     ```

4. **Copy Control File:**
   - Standby control file ko standby server par transfer karein.

5. **Create Standby Initialization Parameter File:**
   - Standby server ke `init.ora` file ko configure karein. Example:
     ```sql
     DB_NAME='your_db'
     DB_UNIQUE_NAME='standby_db'
     LOG_ARCHIVE_DEST_1='LOCATION=/path/to/archive'
     LOG_ARCHIVE_DEST_2='SERVICE=primary_db'
     FAL_SERVER=primary_db
     FAL_CLIENT=standby_db
     ```

6. **Start the Standby Database:**
   - Standby database ko mount mode mein start karein:
     ```sql
     SQL> STARTUP MOUNT;
     ```

7. **Configure Data Guard Broker (Optional):**
   - Data Guard Broker ko configure karne se configuration aur monitoring simple hoti hai.
   - Use `drc` commands or Oracle Enterprise Manager.

### 4. Verification and Monitoring

**4.1 Verify Data Guard Configuration:**

1. **Check Data Guard Status:**
   - Oracle Enterprise Manager ya SQL*Plus ka use karke Data Guard status check karein.
   - SQL*Plus se:
     ```sql
     SQL> SELECT * FROM V$DATAGUARD_STATS;
     ```

2. **Test Data Guard:**
   - Primary database par kuch data changes karein aur ensure karein ki woh standby database par bhi reflect ho raha hai.

**4.2 Monitor Data Guard:**
   - Regularly monitor Data Guard status to ensure replication is working fine.

### 5. Troubleshooting

**5.1 Common Issues:**

1. **Network Connectivity Issues:**
   - Network issues ki wajah se standby database connect nahi ho raha ho sakta hai. Network configuration check karein.

2. **Log File Issues:**
   - Ensure that log files properly generated aur archived ho rahe hain.

3. **Database Errors:**
   - Oracle documentation ya support resources ka use karke specific errors troubleshoot karein.

Ye basic steps hain Oracle Data Guard setup ke liye. Advanced configurations aur monitoring ke liye Oracle ki documentation ya training materials ka refer karna useful hoga.

<hr>

Data Guard setup mein redo log files ka ek important role hota hai, kyunki ye database transactions ke records ko maintain karte hain aur standby database ke synchronization mein madad karte hain. Yahan par Data Guard setup ke dauran redo log files ka role detail mein explain kiya gaya hai:

### Data Guard Setup mein Redo Log Files ka Role

**1. Redo Log Files ki Basic Understanding:**

- **Redo Log Files** database transactions ko record karte hain, jaise INSERT, UPDATE, DELETE operations.
- In logs ko recovery ke liye use kiya jata hai agar database crash ya failure hota hai.

**2. Data Guard mein Redo Log Files ka Use:**

1. **Redo Log Shipping:**
   - **Primary Database** se redo log files standby database tak ship ki jati hain.
   - Jab primary database par koi transaction hota hai, to uska redo log record primary database ke redo log files mein likha jata hai.

   **Example:**
   - Primary database par ek INSERT operation kiya. Ye operation redo log file mein record hota hai.
   - Ye redo log file automatic standby database ko ship ki jati hai, jahan par ye operations apply kiye jate hain.

2. **Synchronization:**
   - **Standby Database** redo log records ko receive karta hai aur apply karta hai, jisse standby database primary database ke state ke saath synchronize rehta hai.
   - Standby database ke redo logs ko regularly update kiya jata hai primary database ke redo logs ke basis par.

   **Example:**
   - Primary database par ek record add kiya. Standby database ko is record ki details redo log file ke through receive hoti hain aur apply hoti hain.

3. **Redo Log Files ke Types:**
   - **Online Redo Logs:** Ye active logs hote hain jo primary database par current transactions ko record karte hain.
   - **Archived Redo Logs:** Ye logs primary database se archive hote hain aur standby database ko ship kiye jate hain.

4. **Data Guard Modes:**
   - **Maximum Performance:** Standby database redo log records ko asynchronously receive karta hai. Thoda lag time ho sakta hai primary aur standby databases ke beech.
   - **Maximum Protection:** Standby database ko synchronously update kiya jata hai. Primary database tabhi commit hota hai jab standby database ke redo logs apply ho jate hain.
   - **Maximum Availability:** Ye balance provide karta hai protection aur performance ke beech.

**3. Data Guard Setup mein Redo Log Configuration:**

1. **Initialization Parameters:**
   - `LOG_ARCHIVE_DEST_n` parameter ko setup karna hota hai taaki redo logs ko archive aur ship kiya ja sake.
   - Example:
     ```sql
     LOG_ARCHIVE_DEST_1='LOCATION=/u01/app/oracle/archivelog'
     LOG_ARCHIVE_DEST_2='SERVICE=standby_db'
     ```

2. **Standby Redo Log Files:**
   - Standby database par bhi redo log files ki zaroorat hoti hai, jisse transactions ko correctly apply kiya ja sake.
   - Example configuration:
     ```sql
     ALTER DATABASE ADD STANDBY LOGFILE GROUP 4 ('/u01/app/oracle/oradata/standby/redo04.log') SIZE 50M;
     ```

### Summary

Data Guard setup ke dauran redo log files primary aur standby databases ke beech transactions ko synchronize karne mein crucial role play karte hain. Ye ensure karte hain ki primary database aur standby database ke records consistent aur up-to-date rahen, jo disaster recovery aur high availability ke liye essential hai.

<hr>

Oracle Data Guard setup ke dauran, primary aur standby databases ke beech communication ke liye connection information ko configure karna padta hai. Is configuration ko typically `listener.ora`, `tnsnames.ora`, aur `spfile`/`init.ora` files mein kiya jata hai. 

### Connection Configuration for Data Guard

**1. `listener.ora` File:**

- **Purpose:** Listener service ko configure karne ke liye, jo client requests aur database connections handle karta hai.
- **Location:** `$ORACLE_HOME/network/admin/listener.ora`

**Example Configuration:**

Primary aur standby databases ke liye listener setup kiya jata hai. 

**Primary Database:**
```plaintext
LISTENER =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = primary_db_host)(PORT = 1521))
  )
```

**Standby Database:**
```plaintext
LISTENER =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = standby_db_host)(PORT = 1521))
  )
```

**2. `tnsnames.ora` File:**

- **Purpose:** Oracle database services ko describe karne ke liye, jisse clients aur databases ke beech connection establish hota hai.
- **Location:** `$ORACLE_HOME/network/admin/tnsnames.ora`

**Example Configuration:**

Ye file mein primary aur standby databases ke connection details specify kiye jate hain.

**Primary Database:**
```plaintext
PRIMARY_DB =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = primary_db_host)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = primary_db_service)
    )
  )
```

**Standby Database:**
```plaintext
STANDBY_DB =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = standby_db_host)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = standby_db_service)
    )
  )
```

**3. `spfile` / `init.ora` File:**

- **Purpose:** Database initialization parameters ko configure karne ke liye, jo database startup aur operation settings specify karte hain.
- **Location:** `$ORACLE_HOME/dbs/spfile` ya `$ORACLE_HOME/dbs/init.ora`

**Example Configuration:**

**Primary Database:**
```sql
LOG_ARCHIVE_DEST_1='LOCATION=/u01/app/oracle/archivelog'
LOG_ARCHIVE_DEST_2='SERVICE=STANDBY_DB ASYNC'
FAL_SERVER=STANDBY_DB
FAL_CLIENT=PRIMARY_DB
```

**Standby Database:**
```sql
LOG_ARCHIVE_DEST_1='LOCATION=/u01/app/oracle/archivelog'
LOG_ARCHIVE_DEST_2='SERVICE=PRIMARY_DB'
FAL_SERVER=PRIMARY_DB
FAL_CLIENT=STANDBY_DB
```

**Key Parameters:**
- `LOG_ARCHIVE_DEST_n`: Redo logs ko archive aur ship karne ke liye specify karta hai.
- `FAL_SERVER` aur `FAL_CLIENT`: Failed Archive Log (FAL) service settings jo redo log files ki recovery ko facilitate karte hain.

### Summary

- **`listener.ora`** file listener services ko configure karti hai jo database connections handle karte hain.
- **`tnsnames.ora`** file databases ke connection details ko define karti hai.
- **`spfile` / `init.ora`** file database initialization parameters ko set karti hai jo Data Guard replication aur archiving ke liye zaroori hain.

In files ko properly configure karke, aap primary aur standby databases ke beech proper communication aur synchronization ensure kar sakte hain.

<hr>

Agar aapne Oracle Data Guard ka setup kar liya hai aur VirtualBox pe machines chal rahi hain, to aapko kuch steps follow karne honge taaki check kar sakein ki Data Guard properly kaam kar raha hai ya nahi. Data Guard do machines ke beech mein ek Primary Database aur ek Standby Database ka synchronization manage karta hai.

Yeh raha step-by-step process:

### 1. **Virtual Machines Check**
   Sabse pehle, ensure karein ki dono virtual machines (Primary aur Standby) properly run kar rahe hain:
   - Open VirtualBox aur verify karein ki dono machines running state mein hain.

### 2. **Oracle Database Status Check**
   **Primary aur Standby machine** par jaake Oracle Database ke status ko check karein.

   **Primary Machine par:**
   ```bash
   sqlplus / as sysdba
   SQL> SELECT database_role, protection_mode FROM v$database;
   ```
   Isse aapko `PRIMARY` database ka role aur protection mode dekhne ko mil jayega.

   **Standby Machine par:**
   ```bash
   sqlplus / as sysdba
   SQL> SELECT database_role, protection_mode FROM v$database;
   ```
   Standby database ka role yahan `PHYSICAL STANDBY` hona chahiye.

### 3. **Check Log Transport Service**
   Yeh confirm karega ki Primary se Standby database tak redo logs sahi tarike se transport ho rahe hain.

   **Primary Machine par:**
   ```bash
   sqlplus / as sysdba
   SQL> SELECT DEST_NAME, STATUS, DESTINATION, ERROR FROM v$archive_dest WHERE TARGET = 'STANDBY';
   ```

   Is output mein status `VALID` hona chahiye, jo batata hai ki logs properly transfer ho rahe hain.

### 4. **Check Log Apply Service**
   Yeh confirm karega ki Standby machine par logs sahi tarike se apply ho rahe hain.

   **Standby Machine par:**
   ```bash
   sqlplus / as sysdba
   SQL> SELECT process, status FROM v$managed_standby WHERE process='MRP0';
   ```

   Agar `MRP0` process ka status `RUNNING` hai, to Standby database properly apply kar raha hai redo logs.

### 5. **Failover/Switchover Check (Optional)**
   Aap yeh bhi test kar sakte hain ki failover ya switchover kaam kar raha hai ya nahi, lekin isko production environment mein directly nahi karna chahiye bina planning ke.

### 6. **Alert Logs Check**
   Dono machines pe Oracle Alert Logs ko dekhkar aap errors ko trace kar sakte hain.

   - **Primary aur Standby Machines pe:**
     ```bash
     tail -f $ORACLE_BASE/diag/rdbms/your_db_name/alert_log.log
     ```

### Extra Tips:
   - Ensure karein ki networking configuration sahi hai.
   - Sync timings check karein taaki koi clock skew na ho.

Isse aapka Data Guard properly kaam kar raha hai ya nahi, yeh confirm kar paoge. Agar koi error aaye to uska log check karke troubleshoot karna padega.

<hr>

Agar aapko Oracle Data Guard ki configuration check karni hai taaki pata chale ki sahi se configure hui hai ya nahi, to aap kuch key configurations aur settings ko verify kar sakte hain. Yeh steps aapko confirm karne mein madad karenge ki Primary aur Standby database sahi se configured hain aur properly sync ho rahe hain.

### Step-by-Step Configuration Check:

#### 1. **Primary Database Configuration Check**

   **Primary Database par login karke yeh commands chalayein:**
   ```bash
   sqlplus / as sysdba
   ```

   **a. Archive Log Mode Check:**
   Oracle Data Guard ke liye Archive Log mode enabled hona zaroori hai. Iska status check karne ke liye:
   ```sql
   SQL> archive log list;
   ```
   Output mein agar "Database log mode" `ARCHIVELOG` hai, to archive log mode enabled hai.

   **b. Force Logging Check:**
   Force logging ka feature ensure karta hai ki sab changes log ho rahe hain. Check karne ke liye:
   ```sql
   SQL> SELECT force_logging FROM v$database;
   ```
   Iska output `YES` hona chahiye. Agar `NO` ho to enable karne ke liye yeh command chalayein:
   ```sql
   SQL> ALTER DATABASE FORCE LOGGING;
   ```

   **c. Redo Log Configuration:**
   Check karne ke liye ki redo logs sahi se configure hain:
   ```sql
   SQL> SELECT GROUP#, STATUS, THREAD#, BYTES/1024/1024 AS SIZE_MB FROM v$log;
   ```

   **d. Remote Archive Log Configuration:**
   Yeh check karta hai ki Primary machine redo logs ko Standby machine par bhej raha hai ya nahi.
   ```sql
   SQL> SELECT DEST_ID, STATUS, DEST_NAME, DESTINATION FROM v$archive_dest WHERE TARGET = 'STANDBY';
   ```
   - Status `VALID` aur `ONLINE` hona chahiye.
   - Destination Standby server ka address hona chahiye.

#### 2. **Standby Database Configuration Check**

   **Standby Machine par login karke yeh commands chalayein:**
   ```bash
   sqlplus / as sysdba
   ```

   **a. Database Role Check:**
   Ensure karein ki Standby database ka role properly configured hai:
   ```sql
   SQL> SELECT database_role FROM v$database;
   ```
   Iska output `PHYSICAL STANDBY` hona chahiye.

   **b. Managed Recovery Process Check:**
   Managed recovery process (MRP) Standby par redo logs apply karta hai. Iska status check karne ke liye:
   ```sql
   SQL> SELECT process, status FROM v$managed_standby WHERE process='MRP0';
   ```
   - Process `MRP0` hona chahiye aur status `RUNNING` hona chahiye.

#### 3. **Network Configuration Check**

   **Primary Database par:**
   ```sql
   SQL> SHOW PARAMETER log_archive_dest_2;
   ```
   - `log_archive_dest_2` parameter ko check karein, ismein Standby database ka hostname ya IP address hona chahiye.
   
   **Standby Database par:**
   ```sql
   SQL> SHOW PARAMETER log_archive_config;
   ```
   - `log_archive_config` ka parameter `DG_CONFIG` ke saath configure hona chahiye, jisme dono databases (Primary aur Standby) ke names included honge.

#### 4. **Listener aur TNS Configuration Check**

   Aapke Primary aur Standby databases ke listener aur TNS configuration ko verify karna zaroori hai:

   - **Primary aur Standby Machine par `tnsnames.ora` file ko check karein:**
     - Ensure karein ki Primary aur Standby ke entries properly defined hain.

   - **Listener status check karne ke liye:**
     ```bash
     lsnrctl status
     ```

#### 5. **Redo Log Transport and Apply Lag Check**

   **Primary Database par:**
   ```sql
   SQL> SELECT DEST_ID, STATUS, ERROR FROM v$archive_dest_status WHERE STATUS = 'VALID';
   ```

   **Standby Database par:**
   ```sql
   SQL> SELECT NAME, VALUE FROM v$dataguard_stats WHERE NAME LIKE '%lag%';
   ```
   Iska output `0` hona chahiye ya bahut minimal hona chahiye, jo batata hai ki log transport aur apply lag nahi hai.

#### 6. **Data Guard Broker (If Configured)**
   Agar aapne Data Guard Broker configure kiya hai, to `dgmgrl` utility se Data Guard ka overall health check kar sakte hain:
   ```bash
   dgmgrl
   DGMGRL> SHOW CONFIGURATION;
   ```
   Iska output `SUCCESS` ya `ORA-00000: normal, successful completion` hona chahiye.

### Troubleshooting Tips:
   - Agar koi issue dikhe, to **Alert Log** files check karein dono databases ke diagnostic logs mein.
   - Logs location: `$ORACLE_BASE/diag/rdbms/your_db_name/alert_log.log`

Isse aapko ensure ho jayega ki Data Guard configuration sahi hai aur logs properly sync ho rahe hain.

<hr>

Agar aapko apne **Primary Database** ko Oracle Data Guard ke liye configure karna hai, to aapko kuch specific steps follow karne padenge taaki Primary database sahi tarike se Standby database ke saath sync ho sake. Yahaan main aapko **Primary Database** ko Data Guard setup ke liye configure karne ka pura process bataunga.

### **Primary Database Configuration Steps for Oracle Data Guard**

#### 1. **Primary Database ko ARCHIVELOG Mode mein Enable karna**
   Oracle Data Guard ke liye **ARCHIVELOG mode** zaroori hai taaki changes ko logs mein store kiya ja sake aur Standby database ke saath sync kiya ja sake.

   **ARCHIVELOG Mode Enable karne ke liye:**
   ```bash
   sqlplus / as sysdba
   SQL> shutdown immediate;
   SQL> startup mount;
   SQL> alter database archivelog;
   SQL> alter database open;
   ```

   **Confirm ARCHIVELOG Mode:**
   ```sql
   SQL> archive log list;
   ```
   - Iska output `ARCHIVELOG` hona chahiye.

#### 2. **Force Logging Enable Karna**
   Yeh ensure karta hai ki sabhi transactions log ho rahe hain, chahe unka nature kuch bhi ho (NOLOGGING transactions ko bhi force karke log kiya jata hai).

   **Force Logging ko Enable karne ke liye:**
   ```sql
   SQL> alter database force logging;
   ```

   **Check karne ke liye:**
   ```sql
   SQL> select force_logging from v$database;
   ```
   - Output mein `YES` hona chahiye.

#### 3. **Redo Log Configuration**
   Data Guard ke liye aapke redo log files ka configuration sahi hona chahiye.

   **Current Redo Log Configuration Check:**
   ```sql
   SQL> select group#, status, bytes/1024/1024 as size_mb from v$log;
   ```

   Agar aapko extra redo log files ki zarurat hai to aap nayi log groups create kar sakte hain.

   **Extra Redo Log Files Add karne ke liye (Optional):**
   ```sql
   SQL> alter database add logfile group 4 '/u01/app/oracle/oradata/redo04.log' size 50m;
   SQL> alter database add logfile group 5 '/u01/app/oracle/oradata/redo05.log' size 50m;
   ```

#### 4. **Standby Redo Logs Create Karna (Recommended)**
   Standby redo logs Primary par bhi configure karna zaroori hota hai taaki redo data ko Standby database tak bheja ja sake.

   **Standby Redo Log Groups Add karne ke liye:**
   - Redo log files ke har thread ke liye at least ek standby redo log hona chahiye.
   ```sql
   SQL> alter database add standby logfile group 6 '/u01/app/oracle/oradata/redo_standby01.log' size 50m;
   SQL> alter database add standby logfile group 7 '/u01/app/oracle/oradata/redo_standby02.log' size 50m;
   SQL> alter database add standby logfile group 8 '/u01/app/oracle/oradata/redo_standby03.log' size 50m;
   ```

#### 5. **Log Archive Destination Configure Karna**
   Data Guard mein aapko Primary database ko instruct karna hota hai ki woh apne redo logs ko Standby database tak kaise bheje.

   **Log Archive Destination Set karne ke liye:**
   ```sql
   SQL> alter system set log_archive_config='DG_CONFIG=(primary_db,standby_db)' scope=both;
   SQL> alter system set log_archive_dest_2='SERVICE=standby_db ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=standby_db' scope=both;
   ```

   - `primary_db` aur `standby_db` ke jagah aap apne database ke actual unique names dalenge.
   - Isme `ASYNC` ka matlab hai ki redo logs asynchronously Standby server ko bheje ja rahe hain. Agar synchronous chahiye to `SYNC` use kar sakte hain.

   **Log Archive Format Configure Karna:**
   ```sql
   SQL> alter system set log_archive_format='%t_%s_%r.arc' scope=spfile;
   ```

#### 6. **FAL Server aur Client Configure Karna**
   FAL (Fetch Archive Log) server aur client ka setup karna hota hai taaki jab bhi archive logs missing ho ya incomplete ho, woh fetch kiye ja sakein.

   **Primary par FAL Server Configure Karna:**
   ```sql
   SQL> alter system set fal_server='standby_db' scope=both;
   SQL> alter system set fal_client='primary_db' scope=both;
   ```

#### 7. **Static Service Configure Karna Listener mein (optional, agar Dynamic nahi)**
   Listener file mein static entries add karni hoti hain taaki redo transport properly kaam kare.

   **Listener.ora File mein:**
   ```plaintext
   (SID_DESC =
     (GLOBAL_DBNAME = primary_db_DGMGRL)
     (ORACLE_HOME = /u01/app/oracle/product/19.0.0/dbhome_1)
     (SID_NAME = primary_db)
   )
   ```

#### 8. **TNSNAMES.ORA File Update Karna**
   Primary aur Standby database ke TNS configuration ko properly define karna hota hai.

   **Primary Database ki `tnsnames.ora` file:**
   ```plaintext
   standby_db =
     (DESCRIPTION =
       (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host)(PORT = 1521))
       (CONNECT_DATA =
         (SERVER = DEDICATED)
         (SERVICE_NAME = standby_db)
       )
     )
   ```

#### 9. **Data Guard Broker (Optional but Recommended)**
   Oracle Data Guard broker use karke aap configuration aur monitoring ko simplify kar sakte hain.

   **Data Guard Broker Enable karne ke liye:**
   ```sql
   SQL> alter system set dg_broker_start=true scope=both;
   ```

   **Data Guard Broker ko Configure karne ke liye:**
   ```bash
   dgmgrl
   DGMGRL> CREATE CONFIGURATION 'DG_Config' AS PRIMARY DATABASE IS 'primary_db' CONNECT IDENTIFIER IS 'primary_db';
   DGMGRL> ADD DATABASE 'standby_db' AS CONNECT IDENTIFIER IS 'standby_db' MAINTAINED AS PHYSICAL;
   DGMGRL> ENABLE CONFIGURATION;
   ```

#### 10. **Verify Configuration**
   Sabhi changes ke baad, Oracle Data Guard ki configuration ko verify karein.

   **Primary Database par:**
   ```sql
   SQL> SELECT database_role, protection_mode FROM v$database;
   ```

   **Expected Output:**
   - `DATABASE_ROLE` = `PRIMARY`
   - `PROTECTION_MODE` = aapke setup ke hisaab se (e.g., `MAXIMUM PERFORMANCE` ya `MAXIMUM AVAILABILITY`)

### Final Notes:
   1. **Alert Logs** check karein kisi bhi error ya warnings ke liye.
   2. Ensure karein ki Standby database sahi se configure ho aur dono databases properly communicate kar rahe hain.

Yeh steps follow karne ke baad aapka Primary Database Data Guard ke liye configure ho jayega.

<hr>

**`listener.ora`** aur **`tnsnames.ora`** files Oracle database mein network configuration ke liye use hoti hain. Yeh dono files server aur client ke beech communication establish karti hain. Dono ka kaam aur edit karne ka process samjhte hain example ke sath.

### **listener.ora File**

**`listener.ora`** file server side par hoti hai, jo Oracle listener ko control karti hai. Listener ka kaam hai database requests ko listen karna aur unko sahi database instance tak forward karna.

#### **Example of listener.ora File**

```plaintext
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = your_host_name)(PORT = 1521))
    )
  )

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = primary_db)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0/dbhome_1)
      (SID_NAME = primary_db)
    )
    (SID_DESC =
      (GLOBAL_DBNAME = standby_db)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0/dbhome_1)
      (SID_NAME = standby_db)
    )
  )
```

#### **Explanation:**
1. **LISTENER:** Yeh section listener ke address ko define karta hai jisme host (server ka naam ya IP address) aur port (default Oracle port 1521) hota hai.
   
   - `(HOST = your_host_name)` → Yeh aapke server ka hostname ya IP address hoga.
   - `(PORT = 1521)` → Default port jisme Oracle database run hota hai.

2. **SID_LIST:** Yeh section different databases (SID) ko define karta hai jo is listener ko use karenge. Har database instance ka SID yahan define hota hai.

   - **`(GLOBAL_DBNAME = primary_db)`**: Primary database ka global name define karta hai.
   - **`(ORACLE_HOME = /path/to/oracle/home)`**: Oracle database software ka location specify karta hai.
   - **`(SID_NAME = primary_db)`**: Isme database ka actual SID (System Identifier) mention hota hai.

#### **Why Edit this File?**
- Jab aapko nayi database instance (jaise Primary aur Standby) ko listener mein add karna hota hai.
- Isme aap hostname, port number, ya database instance ke SID ko configure kar sakte hain taaki proper communication ho sake.

### **tnsnames.ora File**

**`tnsnames.ora`** file client side par hoti hai aur yeh define karti hai ki client ko kaise Oracle server se connect karna hai. Is file mein har database service ka tnsnames ka entry hota hai jo client ko batata hai ki uska address kya hai.

#### **Example of tnsnames.ora File**

```plaintext
primary_db =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = primary_host_name)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = primary_db_service)
    )
  )

standby_db =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host_name)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = standby_db_service)
    )
  )
```

#### **Explanation:**
1. **primary_db:** Yeh section Primary database ka TNS entry define karta hai. Jab client Primary database ko access karna chahta hai, to yeh entry use hoti hai.
   
   - `(PROTOCOL = TCP)` → TCP protocol use hota hai communication ke liye.
   - `(HOST = primary_host_name)` → Primary server ka hostname ya IP address mention hota hai.
   - `(PORT = 1521)` → Default Oracle port.
   - `(SERVICE_NAME = primary_db_service)` → Yeh database ka service name define karta hai jo connection ke liye zaroori hota hai.

2. **standby_db:** Standby database ka TNS entry same structure follow karta hai jisme hostname, port, aur service name define hoti hai.

#### **Why Edit this File?**
- Jab aapko ek naya service connection add karna hota hai (jaise Primary aur Standby databases ke liye alag-alag entries).
- Is file ke zariye client ko bataya jata hai ki kaise aur kis service name se database connect karna hai.

### **Editing listener.ora and tnsnames.ora**

1. **listener.ora File** ko server machine par edit kiya jata hai taaki multiple databases ko listener ke through manage kiya ja sake.
2. **tnsnames.ora File** ko client machine par edit kiya jata hai taaki client ko bataya ja sake ki kaunse database se kaise connect hona hai.

#### **Common Commands to Edit Files:**
- **Open listener.ora or tnsnames.ora:**
   ```bash
   vi $ORACLE_HOME/network/admin/listener.ora
   vi $ORACLE_HOME/network/admin/tnsnames.ora
   ```

- **After Editing, Restart Listener:**
   ```bash
   lsnrctl stop
   lsnrctl start
   ```

### **Summary:**
- **listener.ora** server par listener ke configuration ke liye use hota hai.
- **tnsnames.ora** client aur server communication ko define karta hai.


<hr>

Primary aur Standby database ke beech **Data Guard** setup karne ke liye dono databases ke beech communication establish karna padta hai. Yeh communication **tnsnames.ora**, **listener.ora**, aur **password file** ke through hoti hai, aur kuch important parameters ko configure karna padta hai.

### **Step-by-Step Process to Establish Connection Between Primary and Standby Databases:**

#### 1. **Configure Listener on Both Primary and Standby**
Primary aur Standby databases ke listener files ko properly configure karna padta hai taaki listener dono taraf se requests ko listen kar sake.

- **Primary Database (listener.ora)**
```plaintext
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = primary_host)(PORT = 1521))
    )
  )
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = primary_db)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0/dbhome_1)
      (SID_NAME = primary_db)
    )
  )
```

- **Standby Database (listener.ora)**
```plaintext
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host)(PORT = 1521))
    )
  )
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (GLOBAL_DBNAME = standby_db)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0/dbhome_1)
      (SID_NAME = standby_db)
    )
  )
```

#### 2. **Configure tnsnames.ora on Both Primary and Standby**

tnsnames.ora ko aise configure karna padta hai taaki Primary aur Standby databases ek doosre se connect kar saken. Yeh configuration client aur server ke beech address mapping ka kaam karti hai.

- **Primary Database (tnsnames.ora)**
```plaintext
primary_db =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = primary_host)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = primary_db_service)
    )
  )

standby_db =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = standby_db_service)
    )
  )
```

- **Standby Database (tnsnames.ora)**
```plaintext
primary_db =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = primary_host)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = primary_db_service)
    )
  )

standby_db =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = standby_db_service)
    )
  )
```

#### 3. **Create Password File on Both Primary and Standby**

Oracle Data Guard setup ke liye **password file** ki zarurat hoti hai jo authentication ko ensure karta hai. Aapko dono databases pe password file create karna padta hai.

- **Primary Database:**
  ```bash
  orapwd file=$ORACLE_HOME/dbs/orapwprimary_db password=your_password entries=10
  ```

- **Standby Database:**
  ```bash
  orapwd file=$ORACLE_HOME/dbs/orapwstandby_db password=your_password entries=10
  ```

#### 4. **Configure Initialization Parameters on Primary Database**

Primary database ke initialization parameters ko configure karna hota hai. Yeh parameters Data Guard communication ke liye zaruri hain.

- **Primary Database (spfile/init.ora changes):**
  ```sql
  ALTER SYSTEM SET log_archive_config='DG_CONFIG=(primary_db,standby_db)' SCOPE=BOTH;
  ALTER SYSTEM SET log_archive_dest_1='LOCATION=/u01/app/oracle/oradata/archivelog VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=primary_db' SCOPE=BOTH;
  ALTER SYSTEM SET log_archive_dest_2='SERVICE=standby_db LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=standby_db' SCOPE=BOTH;
  ALTER SYSTEM SET log_archive_format='%t_%s_%r.arc' SCOPE=SPFILE;
  ALTER SYSTEM SET log_archive_max_processes=4 SCOPE=BOTH;
  ALTER SYSTEM SET remote_login_passwordfile='EXCLUSIVE' SCOPE=SPFILE;
  ALTER SYSTEM SET fal_server='standby_db' SCOPE=BOTH;
  ALTER SYSTEM SET fal_client='primary_db' SCOPE=BOTH;
  ALTER SYSTEM SET standby_file_management='AUTO' SCOPE=BOTH;
  ```

#### 5. **Configure Initialization Parameters on Standby Database**

Standby database ke bhi kuch initialization parameters set karne padte hain taaki Primary se sync ho sake.

- **Standby Database (spfile/init.ora changes):**
  ```sql
  ALTER SYSTEM SET log_archive_config='DG_CONFIG=(primary_db,standby_db)' SCOPE=BOTH;
  ALTER SYSTEM SET log_archive_dest_1='LOCATION=/u01/app/oracle/oradata/archivelog VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=standby_db' SCOPE=BOTH;
  ALTER SYSTEM SET log_archive_dest_2='SERVICE=primary_db LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,STANDBY_ROLE) DB_UNIQUE_NAME=primary_db' SCOPE=BOTH;
  ALTER SYSTEM SET log_archive_format='%t_%s_%r.arc' SCOPE=SPFILE;
  ALTER SYSTEM SET log_archive_max_processes=4 SCOPE=BOTH;
  ALTER SYSTEM SET remote_login_passwordfile='EXCLUSIVE' SCOPE=SPFILE;
  ALTER SYSTEM SET fal_server='primary_db' SCOPE=BOTH;
  ALTER SYSTEM SET fal_client='standby_db' SCOPE=BOTH;
  ALTER SYSTEM SET standby_file_management='AUTO' SCOPE=BOTH;
  ```

#### 6. **Start the Listener on Both Databases**

Listener ko start karna hota hai taaki network ke through Primary aur Standby databases communicate kar saken.

```bash
lsnrctl start
```

#### 7. **Test Connection from Primary to Standby**

Aap **tnsping** ya **sqlplus** commands ka use karke connection check kar sakte hain.

- **tnsping Standby Database:**
  ```bash
  tnsping standby_db
  ```

- **SQL*Plus se connect karna:**
  ```bash
  sqlplus sys@standby_db as sysdba
  ```

Agar connection successful hai, to iska matlab Primary aur Standby database ke beech communication establish ho chuka hai.

#### 8. **Put Standby Database in Managed Recovery Mode**

Aapko standby database ko recovery mode mein put karna hota hai taaki Primary se redo logs apply ho sake.

```sql
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
```

---

### **Summary:**

- **Listener aur tnsnames.ora ko configure karo:** Taaki Primary aur Standby database ke beech connection ho.
- **Password file banao:** Dono databases par password file ka hona zaruri hai for authentication.
- **Initialization parameters ko configure karo:** Primary aur Standby databases ke parameters ko sahi tarike se set karo.
- **Connection test karo:** tnsping ya sqlplus ke through connection ko validate karo.
- **Standby ko recovery mode mein daalo:** Taaki logs apply ho sake aur synchronization ho.

Is process ke baad aapke Primary aur Standby database ke beech proper Data Guard communication establish ho jata hai.

<hr>

Aap primary database pe changes create karke dekhna chahte hain aur standby database pe check karna chahte hain ki woh sync ho raha hai ya nahi. Yeh kaafi important step hai to ensure ki aapka Data Guard setup sahi se kaam kar raha hai.

Yeh process kaafi straightforward hai, aapko kuch steps follow karne padenge:

### **Steps to Test Primary and Standby Database Synchronization:**

1. **Primary Database Par Table Create Karo**
   Sabse pehle aapko primary database pe login karna hai aur ek test table create karna hai.

   - **Primary Database Par Login (SQL*Plus ke through):**
     ```bash
     sqlplus sys@primary_db as sysdba
     ```

   - **Test Table Create Karo:**
     ```sql
     CREATE TABLE test_table (
       id NUMBER PRIMARY KEY,
       name VARCHAR2(50)
     );
     ```

2. **Primary Database Pe Insert Operation Perform Karo**
   Ab aap test table mein data insert kar ke dekh sakte hain ki standby database pe woh reflect hota hai ya nahi.

   ```sql
   INSERT INTO test_table (id, name) VALUES (1, 'Oracle Data Guard Test');
   COMMIT;
   ```

3. **Standby Database Pe Sync Check Karo**
   Ab aap standby database pe check karenge ki yeh table aur data sync hua hai ya nahi.

   - **Standby Database Par Login (SQL*Plus ke through):**
     ```bash
     sqlplus sys@standby_db as sysdba
     ```

   - **Check Karo ki Table Aur Data Sync Hua Hai:**
     ```sql
     SELECT * FROM test_table;
     ```

   Agar aap standby database pe same data dekh rahe hain, to iska matlab synchronization sahi se kaam kar raha hai.

### **Common Commands to Check Synchronization:**

- **Redo Log Apply Status Check (Standby Database Pe):**
  Aap yeh check kar sakte hain ki redo logs standby database pe apply ho rahe hain ya nahi:

  ```sql
  SELECT process, status FROM v$managed_standby;
  ```

  Is command se aapko pata chalega ki `MRP0` (Managed Recovery Process) running hai ya nahi.

- **Check Data Guard Status (Primary Database Pe):**
  Primary database pe Data Guard ka status check karne ke liye:

  ```sql
  SELECT dest_id, status, error FROM v$archive_dest_status;
  ```

### **Important Points:**

1. **Log Archive Transfer:**
   Primary database se redo logs standby database pe transfer hone chahiye. Aap primary database pe **log switch** force kar sakte hain:

   ```sql
   ALTER SYSTEM SWITCH LOGFILE;
   ```

2. **Standby Database Pe Recovery Mode:**
   Make sure standby database recovery mode mein hai:

   ```sql
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
   ```

3. **Monitor Logs:**
   Standby database ke alert logs ko monitor karo taaki aapko pata chale ki logs apply ho rahe hain ya nahi. 

   - **Alert Log Path (standby side):**
     ```bash
     tail -f $ORACLE_BASE/diag/rdbms/standby_db/alert_standby_db.log
     ```

Yeh steps follow karke aap easily check kar sakte hain ki Primary aur Standby databases ke beech synchronization kaam kar raha hai ya nahi.

<ht>

Agar aap `sqlplus sys@primary_db as sysdba` run kar rahe hain aur password nahi pata, to sabse pehle aapko SYS user ka password reset karna hoga ya dekhna hoga ki `password file` bana hai ya nahi.

### **Steps to Reset SYS Password:**

1. **Login to the Database Server Using Operating System Authentication:**
   Agar aapne Oracle ko install kiya hai ya Oracle OS-level user ke through logged in hain (jaise `oracle` user), to aapko password enter nahi karna padega. Aap OS authentication ke through direct `SYSDBA` mode mein login kar sakte hain.

   - **Login Without Password:**
     ```bash
     sqlplus / as sysdba
     ```

   Is command se aap directly `SYSDBA` privileges ke saath login kar jaoge bina password maange.

2. **Reset SYS User Password:**
   Ab aap SYS user ka password reset kar sakte hain.

   - **Change SYS Password:**
     ```sql
     ALTER USER sys IDENTIFIED BY "new_password";
     ```

   - Example:
     ```sql
     ALTER USER sys IDENTIFIED BY "Oracle_123";
     ```

   Iske baad aap SYS user ke liye naya password set kar doge. Aapko yeh password yaad rakhna hoga future connections ke liye.

3. **Login with New Password:**
   Ab aap new password ke saath login kar sakte hain:

   ```bash
   sqlplus sys@primary_db as sysdba
   ```

   - Jab password pucha jaye, tab aap naya set kiya hua password daal dena:
     ```
     Enter password: Oracle_123
     ```

### **Check If Password File Exists:**
Agar aapne password file nahi banaya hai ya delete ho gaya hai, to aapko `orapwd` utility ke through nayi password file banana padega.

- **Create New Password File:**
  ```bash
  orapwd file=$ORACLE_HOME/dbs/orapwprimary_db password=Oracle_123 entries=10
  ```

- **For Standby Database (if needed):**
  ```bash
  orapwd file=$ORACLE_HOME/dbs/orapwstandby_db password=Oracle_123 entries=10
  ```

Iske baad, aap `sqlplus` ke through database pe access kar paoge with `SYS` user aur naya password.

---

### **Summary:**
1. Agar aapko password nahi pata, to OS authentication (`/ as sysdba`) use karke login karo.
2. SYS user ka password reset karo.
3. Login ke liye naya password use karo.
4. Agar password file nahi hai, to nayi password file create karo.

Yeh steps follow karne ke baad aap easily primary aur standby databases ko manage kar paoge.

<hr>

Aapke error ka matlab yeh hai ki aap currently **standby database** pe connected hain, aur standby database read-only mode mein hoti hai. Standby database mein aap direct DML (Data Manipulation Language) ya DDL (Data Definition Language) operations perform nahi kar sakte ho.

Aapko yeh ensure karna padega ki aap **primary database** pe ho jab aap SYS user ka password change kar rahe ho ya kisi bhi configuration ko modify kar rahe ho.

### **Steps to Resolve:**

1. **Confirm Whether You Are on Standby Database:**
   Pehle yeh confirm karo ki aap standby database pe ho ya primary database pe.

   - Run this query:
     ```sql
     SELECT DATABASE_ROLE FROM V$DATABASE;
     ```

     - Agar output `"PHYSICAL STANDBY"` hai, iska matlab aap standby database pe ho.
     - Agar output `"PRIMARY"` hai, to aap primary database pe ho.

2. **Switch to Primary Database:**
   Agar aap standby database pe ho, to aapko primary database pe switch karna padega aur waha pe password reset karna padega.

   - Primary database pe login karo:
     ```bash
     sqlplus sys@primary_db as sysdba
     ```

   - Agar password nahi pata hai to pehle OS authentication ke through login karne ka try karo:
     ```bash
     sqlplus / as sysdba
     ```

3. **Open Primary Database and Change Password:**
   Primary database pe login hone ke baad, aap SYS user ka password change kar sakte ho:

   ```sql
   ALTER USER sys IDENTIFIED BY "new_password";
   ```

4. **If Stuck in Standby Mode:**
   Agar aap standby database se changes karne ka try kar rahe ho, to ya to primary pe login karo ya phir standby mode ko disable karke primary mein convert karo (for testing purposes). **However, yeh production environments mein avoid karna chahiye.**

   Standby database ko primary mein switch karne ke liye:

   ```sql
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
   ALTER DATABASE ACTIVATE STANDBY DATABASE;
   ```

   **Note:** Yeh step dangerous ho sakta hai agar aap production environment mein ho. Make sure yeh test environment ho aur aapko iske consequences pata ho.

---

### **Summary:**
- Aap standby database pe ho isliye aapko error aa raha hai.
- Primary database pe login karo aur fir password change karo.
- Standby database pe read-only mode mein kuch DDL changes nahi kar sakte.

Isse aapka problem solve ho jana chahiye.

<hr>

Aapko jo errors mil rahe hain, unka connection issue aur password-related problems se sambandh ho sakta hai. Chaliye isko step-by-step solve karte hain:

### 1. **TNS Issue (ORA-12154: Could Not Resolve the Connect Identifier Specified)**

Ye error tab aata hai jab Oracle client ko `TNS alias` ya `connect string` resolve nahi kar pa raha. Isko resolve karne ke liye:

#### **Check `tnsnames.ora` File:**
- Aapke `tnsnames.ora` file mein jo alias define kiya gaya hai (`standby_db`) usko check karo.
- File ka path kuch is tarah hoga:
  ```bash
  $ORACLE_HOME/network/admin/tnsnames.ora
  ```
  
  Example `tnsnames.ora` entry:

  ```plaintext
  standby_db =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = <standby_host>)(PORT = 1521))
      (CONNECT_DATA =
        (SERVER = DEDICATED)
        (SERVICE_NAME = standby_db_service)
      )
    )
  ```

  - **Check karo ki `HOST`, `PORT`, aur `SERVICE_NAME` sahi hai ya nahi.** 
  - `tnsping standby_db` command run karke check karo ki TNS alias resolve ho raha hai ya nahi:
    ```bash
    tnsping standby_db
    ```

### 2. **Password Issue (ORA-28009: Connection as SYS Should Be As SYSDBA or SYSOPER)**

Yeh error tab aata hai jab aap SYS user ke saath SYSDBA ya SYSOPER privileges ke bina connect karne ka try kar rahe ho.

- Make sure aap correct syntax use kar rahe ho, jaise:
  ```bash
  sqlplus sys@standby_db as sysdba
  ```

  Ya phir agar aapko direct connect karna hai without specifying service:
  ```bash
  sqlplus / as sysdba
  ```

### 3. **Invalid Username/Password (ORA-01017: Invalid Username/Password)**

Yeh error tab aata hai jab username ya password galat hota hai. Aapko yeh ensure karna hoga ki SYS user ka password correct hai.

#### **SYS User Password Reset:**
Agar aap SYS user ka password bhool gaye ho ya invalid password de rahe ho, to aap SYS user ka password reset kar sakte ho:

1. **Login Without Password Using OS Authentication:**
   Agar aap Oracle server pe ho, to OS-level se SYSDBA privileges ke saath login kar sakte ho:
   ```bash
   sqlplus / as sysdba
   ```

2. **Reset SYS Password:**
   Once logged in, reset the password:
   ```sql
   ALTER USER sys IDENTIFIED BY "new_password";
   ```

   Example:
   ```sql
   ALTER USER sys IDENTIFIED BY "Oracle_123";
   ```

3. **Try Logging in Again:**
   Ab aap naya password use karke connect kar sakte ho:
   ```bash
   sqlplus sys@standby_db as sysdba
   ```

   - Jab password pucha jaye, to aap naya set kiya hua password daal do.

### **Troubleshooting Steps:**

1. **Check `tnsnames.ora` file** and ensure `standby_db` alias properly configured hai.
2. **Use the correct connection string**: `sqlplus sys@standby_db as sysdba`.
3. **Reset SYS password** using OS authentication if needed.
4. **Test TNS alias** with `tnsping standby_db`.

In steps ko follow karne ke baad aapka connection issue resolve ho jana chahiye.

<hr>

Aapke `tnsnames.ora` file ko dekh ke, yeh lag raha hai ki aapne jo TNS aliases configure kiye hain, unmein `ORADB` aur `ORADB_S2` hain. 

### **Troubleshooting and Fixes:**

1. **Check the Connect Identifiers:**

   Aapko yeh ensure karna hoga ki aap jo connect identifier use kar rahe hain (`standby_db`), woh file mein properly defined ho. Aapne file mein `ORADB` aur `ORADB_S2` aliases define kiye hain. 

   **Make sure you use one of these identifiers:** 
   
   - For the primary database, use `ORADB`
   - For the standby database, use `ORADB_S2`

2. **Connecting to the Database:**

   **For Primary Database (`ORADB`):**
   ```bash
   sqlplus sys@ORADB as sysdba
   ```

   **For Standby Database (`ORADB_S2`):**
   ```bash
   sqlplus sys@ORADB_S2 as sysdba
   ```

   **If you are on the standby database and want to connect to it:**
   ```bash
   sqlplus / as sysdba
   ```

   **Make sure to use the correct service names defined in `tnsnames.ora`.**

3. **Verify Service Names:**

   **Check Service Names in Database:**

   - **Login to the database (if possible) and run:**
     ```sql
     SELECT * FROM v$services;
     ```

   **This will list all the services and their current status. Ensure that `oradb.localdomain` and `oradb_s2.localdomain` are listed.**

4. **Check Listener Status:**

   **Ensure that your listener is running and listening on the specified ports:**
   ```bash
   lsnrctl status
   ```

   This command will show you if the listeners are up and running and the services they are handling.

5. **Verify the Connectivity:**

   **Try pinging the service names:**
   ```bash
   tnsping ORADB
   tnsping ORADB_S2
   ```

   **Ensure that the TNS alias resolves correctly and the network configuration is working.**

6. **Reset SYS Password (If Necessary):**

   **If you are still facing login issues, try resetting the SYS password using OS authentication:**
   ```bash
   sqlplus / as sysdba
   ```

   **Then reset the password:**
   ```sql
   ALTER USER sys IDENTIFIED BY "new_password";
   ```

   **Replace `new_password` with a secure password of your choice.**

### **Summary:**

1. **Use correct TNS alias** (`ORADB` for primary and `ORADB_S2` for standby).
2. **Verify the listener and service names** to ensure correct configuration.
3. **Reset SYS password if needed** and try logging in again.
4. **Check connectivity** using `tnsping` and `lsnrctl`.

Iske baad aapko connection aur configuration issues solve ho jana chahiye.

<hr>

Agar aap `sqlplus sys@ORADB as sysdba` command run kar rahe hain aur username aur password puchha ja raha hai, to aapko ensure karna hoga ki:

1. **Correct Password for SYS User:**
   - `sys` user ke liye jo bhi password aapne set kiya hai, woh enter karna hoga.

2. **If You Don't Know the Password:**

   Agar aapko SYS user ka password nahi pata, to aapko password reset karna padega. Aapko yeh steps follow karne honge:

### **Reset SYS Password (If You Are on the Same Server):**

1. **Login Using OS Authentication:**
   Agar aap `oracle` user ke saath logged in hain aur aapke paas OS-level access hai, to aap `sqlplus / as sysdba` command use karke SYSDBA privileges ke saath login kar sakte hain bina password ke.

   ```bash
   sqlplus / as sysdba
   ```

   Agar yeh command successfully execute hoti hai, to aap SYSDBA mode mein login kar jayenge.

2. **Change SYS Password:**
   Jab aap successfully login kar jayein, password reset command run karke SYS user ka password change karein.

   ```sql
   ALTER USER sys IDENTIFIED BY "new_password";
   ```

   Example:
   ```sql
   ALTER USER sys IDENTIFIED BY "Oracle_123";
   ```

3. **Retry Logging In:**
   Ab aap naye password ke saath login kar sakte hain:

   ```bash
   sqlplus sys@ORADB as sysdba
   ```

   - Enter username: `sys`
   - Enter password: `new_password` (jo aapne set kiya hai)

### **If You Don't Have OS Authentication Access:**

1. **Connect Using Another Privileged Account:**
   Agar aapke paas `SYSDBA` privileges ke saath koi aur account hai, to usse login karke password reset kar sakte hain.

   ```bash
   sqlplus other_user@ORADB as sysdba
   ```

2. **Reset Password from Another Account:**
   ```sql
   ALTER USER sys IDENTIFIED BY "new_password";
   ```

### **Troubleshooting:**

- **Ensure Database is Running:**
  - Verify that your database is up and running by using:
    ```bash
    lsnrctl status
    ```

- **Check Configuration Files:**
  - Ensure `tnsnames.ora` is correctly configured as discussed previously.

- **Verify Listener:**
  - Ensure that the listener is correctly configured and running.

### **Summary:**

1. **Login using OS authentication** if you have server-level access.
2. **Reset the SYS password** if you don't know it.
3. **Use the new password** to log in with `sqlplus sys@ORADB as sysdba`.

Agar aapko ab bhi issue aa raha hai, to aap mujhe bata sakte hain, main further assist kar dunga.

<hr>

The output of the query `SELECT process, status FROM v$managed_standby;` shows the status of different processes involved in Data Guard configuration. Here’s a brief explanation of what each status indicates:

### **Explanation of the Processes and Their Statuses:**

1. **ARCH (Archive Process):**
   - **CONNECTED:** The ARCH process is currently connected to the primary database or another standby database, and it is actively receiving archived redo logs.
   - **CLOSING:** The ARCH process is in the process of closing an archived redo log file, which usually happens when a redo log file is being archived.

2. **DGRD (Data Guard Broker):**
   - **ALLOCATED:** This means the Data Guard Broker process is allocated and managing or handling the Data Guard configuration tasks.

3. **RFS (Remote File Server):**
   - **IDLE:** The RFS process is idle, which indicates that it is not currently receiving redo data. This could be due to various reasons, such as network issues or the standby being up-to-date with the primary.

### **Interpreting the Statuses:**

- **ARCH Process Statuses:**
  - If you see **"CLOSING"** frequently, it indicates that the ARCH process is in the process of closing the redo log files. This is a normal behavior, especially if there’s a high rate of redo log generation.

- **DGRD Process Statuses:**
  - The **"ALLOCATED"** status is expected when the Data Guard Broker is functioning and managing the standby configuration. 

- **RFS Process Statuses:**
  - The **"IDLE"** status of RFS might indicate that the standby database has already received all the redo data and is just waiting for more to come. If this status is persistent and no new data is being received, ensure that the network and Data Guard configuration are correct.

### **Steps to Verify Data Guard Configuration:**

1. **Check if Redo Logs are Being Transmitted:**
   - Ensure that redo logs are being transmitted from the primary to the standby. 

   **Query to Check Last Applied Redo Logs:**
   ```sql
   SELECT * FROM V$ARCHIVE_DEST_STATUS;
   ```

2. **Verify Data Guard Status:**
   - Check the status of the Data Guard configuration to ensure that everything is functioning properly:

   ```sql
   SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST;
   ```

   This will give you information about the archive destinations and any errors if present.

3. **Monitor Log Shipping:**
   - Confirm that logs are being shipped regularly from the primary to the standby. 

   **Query to Check Log Shipping Status:**
   ```sql
   SELECT * FROM V$LOGSHIP_STATUS;
   ```

4. **Check for Errors in Alert Logs:**
   - Check the alert logs on both the primary and standby databases for any errors or warnings related to Data Guard.

   - **Primary Database Alert Log Location:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

   - **Standby Database Alert Log Location:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

### **Summary:**

- Your `v$managed_standby` output indicates that Data Guard processes are functioning but there may be some tasks that are in progress (e.g., closing redo logs).
- Ensure that your Data Guard configuration is correctly set up by verifying archive destinations, log shipping, and checking for any errors in the alert logs.

If you encounter specific issues or see any errors, please provide those details for further assistance.

<hr>

Aapka table primary database par successfully create aur insert ho gaya hai, lekin standby database pe aapko `ORA-00942: table or view does not exist` error aa raha hai. Iska matlab hai ki standby database pe table available nahi hai. Is issue ko troubleshoot karne ke liye, aap ye steps follow kar sakte hain:

### **1. **Data Guard Configuration Check:**
   - **Ensure Data Guard Configuration:** Data Guard ko sahi se configure kiya hua hona chahiye taaki primary se redo data standby pe replicate ho sake.
   - **Check Data Guard Status:** Ensure karein ki Data Guard broker properly configured hai aur primary se logs standby pe transfer ho rahe hain.

   ```sql
   SELECT DATABASE_ROLE, PROTECTION_MODE, PROTECTION_LEVEL FROM V$DATABASE;
   ```

   **Database Role**: Ye `PRIMARY` ya `STANDBY` hona chahiye.

### **2. **Verify Redo Log Application:**
   - **Check if Redo Logs are Being Applied:** Standby database pe check karein ki redo logs apply ho rahe hain ya nahi.

   ```sql
   SELECT PROCESS, STATUS FROM V$MANAGED_STANDBY;
   ```

   **Status:** Ye `APPLYING_LOGS` hona chahiye agar logs apply ho rahe hain.

### **3. **Confirm Table Existence:**
   - **Verify Table on Standby Database:** Ensure karein ki table standby database pe create hua hai ya nahi.

   **Try Checking Table in All Schemas:**
   ```sql
   SELECT * FROM ALL_TABLES WHERE TABLE_NAME = 'TEST_TABLE';
   ```

   - **If Table is Not Found:** Agar table nahi milta, to ensure karein ki `primary` se logs standby pe replicate ho rahe hain.

### **4. **Check Archive Destinations:**
   - **Verify Archive Log Shipping:**

   ```sql
   SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST;
   ```

   - **Ensure Archive Log Destination is Active:** Archive logs primary se standby pe transfer ho rahe hain.

### **5. **Check for Errors:**
   - **Look at Alert Logs:**

   - **Primary Database Alert Log:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

   - **Standby Database Alert Log:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

   **Check Errors Related to Redo Application:**

### **6. **Perform Manual Refresh (If Needed):**
   - **If Automatic Synchronization is Not Working:**
     - **Consider Manual Synchronization:** You might need to manually apply the logs or refresh the standby database.

   ```sql
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE;
   ```

### **Summary:**

1. **Check Data Guard Configuration** to ensure everything is properly set up.
2. **Verify Redo Log Application** to make sure logs are being applied on the standby.
3. **Confirm Table Existence** on the standby database.
4. **Check Archive Destinations** to ensure logs are being transferred.
5. **Look at Alert Logs** for any errors.
6. **Manual Synchronization** may be needed if automatic processes are failing.

In steps ko follow karke aap issue ko diagnose aur resolve kar sakte hain. Agar specific errors ya issues aati hain to bataiye, main aur help kar dunga.

<hr>

Aapka `DATABASE_ROLE` **PHYSICAL STANDBY** dikhata hai, jo ki sahi hai agar aapka database standby mode mein hai. Protection mode **MAXIMUM PERFORMANCE** bhi sahi hai, jo ki ek typical setting hai. 

### **Next Steps:**

1. **Check Redo Log Application Status:**
   Aapko confirm karna hoga ki redo logs standby database pe apply ho rahe hain. Use the following query:

   ```sql
   SELECT PROCESS, STATUS FROM V$MANAGED_STANDBY;
   ```

   **Expected Statuses:**
   - `APPLYING_LOGS`: This indicates that logs are being applied.
   - `CONNECTED` or `IDLE`: May indicate that logs are being received but not applied.

2. **Check Archive Log Status:**
   Ensure that archive logs are being received and applied. Run the following query on the standby database:

   ```sql
   SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST;
   ```

   **Expected Statuses:**
   - The status should indicate that the logs are being applied.
   - Ensure there are no errors.

3. **Verify Table Creation:**
   Make sure the table exists on the standby database. Use:

   ```sql
   SELECT * FROM ALL_TABLES WHERE TABLE_NAME = 'TEST_TABLE';
   ```

   - **If Table Does Not Exist:**
     - Ensure that the table was created properly on the primary and logs are being applied.

4. **Verify Archive Log Shipping:**
   Ensure that archive logs from the primary database are being shipped to the standby:

   ```sql
   SELECT * FROM V$ARCHIVE_DEST_STATUS;
   ```

5. **Check Alert Logs:**
   Look for errors in the alert logs on both the primary and standby databases:

   - **Primary Database Alert Log Location:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

   - **Standby Database Alert Log Location:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

6. **Manual Synchronization (If Needed):**
   If automatic synchronization is not working, you may need to manually apply redo logs:

   ```sql
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE;
   ```

### **Summary:**

1. **Check the Redo Log Application Status** on standby.
2. **Verify Archive Log Shipping** and status.
3. **Confirm the Table Exists** on the standby database.
4. **Review Alert Logs** for any issues or errors.
5. **Consider Manual Synchronization** if automatic processes are not working.

Agar aapko kisi bhi step mein specific error milti hai ya aur koi details chahiye, toh zaroor batayein. Main aapki madad karne ke liye yahan hoon.

<hr>

Aapka `v$managed_standby` output jo hai, usmein `RFS` process `IDLE` dikh raha hai, jo ki stand by database ke redo log application status ko indicate karta hai. Agar `RFS` process `IDLE` hai, iska matlab ho sakta hai ki standby database ko primary se naye redo logs nahi mil rahe hain ya logs apply nahi ho rahe hain.

### **Possible Issues and Solutions:**

#### **1. Check if Redo Logs are Being Transmitted:**

1. **Verify Archive Log Destination on Primary:**
   Ensure that the primary database is properly shipping redo logs to the standby database.

   ```sql
   SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST;
   ```

   **Check if the destination for standby is active and not showing errors.**

2. **Verify Archive Log Shipping Status:**
   On the primary database, check the status of the archived logs:

   ```sql
   SELECT * FROM V$ARCHIVE_DEST_STATUS;
   ```

   **Ensure that logs are being shipped and there are no errors.**

#### **2. Verify Connectivity Between Primary and Standby:**

1. **Check Network Connectivity:**
   Ensure that the primary and standby databases can communicate over the network.

   ```bash
   tnsping ORADB
   ```

   Replace `ORADB` with the connect identifier for your primary database. Similarly, verify connectivity for the standby database.

2. **Check Listener Status:**
   Ensure that listeners on both primary and standby are up and running.

   ```bash
   lsnrctl status
   ```

#### **3. Check Standby Redo Logs:**

1. **Verify Standby Redo Logs:**
   Ensure that standby redo logs are properly configured and available.

   ```sql
   SELECT GROUP#, STATUS, THREAD# FROM V$STANDBY_LOG;
   ```

   **Make sure that standby redo logs exist and are not showing errors.**

#### **4. Manual Application of Logs (if needed):**

1. **Apply Redo Logs Manually:**
   If automatic application is not working, you might need to manually apply logs.

   ```sql
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE;
   ```

2. **Force a Log Apply:**
   If you want to force the apply, you can use:

   ```sql
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
   ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE;
   ```

#### **5. Check for Errors in Alert Logs:**

1. **Review Alert Logs:**
   Look at the alert logs on both primary and standby databases for any errors related to redo log shipping or application.

   - **Primary Database Alert Log:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

   - **Standby Database Alert Log:**
     ```plaintext
     $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
     ```

### **Summary:**

1. **Verify Archive Log Shipping Status** on primary and standby.
2. **Check Network and Listener Connectivity** between primary and standby.
3. **Ensure Standby Redo Logs** are available and correctly configured.
4. **Manually Apply Redo Logs** if automatic application is failing.
5. **Review Alert Logs** for any errors or issues.

Agar aapko specific error messages milte hain ya further issues hoti hain, to zaroor batayein, main aur help karne ke liye yahan hoon.

<hr>

**INACTIVE** archive destinations ko **ACTIVE** karne ke liye, aapko kuch configuration aur troubleshooting steps follow karne honge. Yeh steps aapki archive destinations ko validate karne aur correct configuration apply karne mein madad karenge. 

### **Steps to Activate INACTIVE Archive Destinations:**

#### **1. Check Archive Destination Configuration**

**Verify Archive Destination Configuration:**
Pehle ensure karein ki aapke archive destinations correctly configured hain.

```sql
SELECT DEST_ID, DEST_NAME, STATUS, ERROR FROM V$ARCHIVE_DEST;
```

**Check for errors or issues** related to the archive destinations.

#### **2. Review TNS Configuration**

**Verify `tnsnames.ora`:**
Ensure ki `tnsnames.ora` file primary aur standby databases ke liye correctly configured hai.

1. **Edit `tnsnames.ora`:**

   ```plaintext
   # Example tnsnames.ora entries

   PRIMARY_DB =
     (DESCRIPTION =
       (ADDRESS = (PROTOCOL = TCP)(HOST = primary_host)(PORT = 1521))
       (CONNECT_DATA =
         (SERVICE_NAME = primary_service)
       )
     )

   STANDBY_DB =
     (DESCRIPTION =
       (ADDRESS = (PROTOCOL = TCP)(HOST = standby_host)(PORT = 1521))
       (CONNECT_DATA =
         (SERVICE_NAME = standby_service)
       )
     )
   ```

   Ensure ki HOST aur PORT values sahi hain aur network connection ke through accessible hain.

#### **3. Check Listener Configuration**

**Verify Listener Status:**
Make sure ki primary aur standby databases ke listeners correctly running hain.

```bash
lsnrctl status
```

**Restart Listener** if necessary:

```bash
lsnrctl stop
lsnrctl start
```

#### **4. Enable Archive Destinations**

**Activate Archive Destinations:**
For destinations that are **INACTIVE**, you might need to activate them by updating the configuration.

1. **Update Archive Destination:**

   ```sql
   ALTER SYSTEM SET LOG_ARCHIVE_DEST_<dest_id>='your_destination_path';
   ```

   Replace `<dest_id>` with the appropriate destination ID, and `your_destination_path` with the actual path or connection string for the destination.

2. **Verify the Destination is Active:**

   ```sql
   ALTER SYSTEM ARCHIVE LOG CURRENT;
   ```

   This command forces the archiving of the current redo log file, which can help in activating the destination.

#### **5. Check Archive Log Shipping**

**Verify Log Shipping:**
Ensure ki logs primary se standby pe ship ho rahe hain.

```sql
SELECT * FROM V$ARCHIVE_DEST_STATUS;
```

**Check for any errors or status issues.**

#### **6. Review Alert Logs**

**Check Alert Logs:**
Examine the alert logs for any specific errors or issues related to archive destinations.

1. **Primary Database Alert Log:**

   ```plaintext
   $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
   ```

2. **Standby Database Alert Log:**

   ```plaintext
   $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
   ```

**Look for any error messages related to the archive destinations.**

#### **Summary:**

1. **Verify Archive Destination Configuration** for correctness.
2. **Check `tnsnames.ora`** for accurate network configuration.
3. **Ensure Listener** is running and properly configured.
4. **Update Archive Destinations** to activate them.
5. **Verify Archive Log Shipping** and resolve any issues.
6. **Review Alert Logs** for detailed errors.

Agar in steps ke baad bhi issues resolve nahi hote, ya agar koi specific error message milta hai, to mujhe zaroor batayein. Main aur help karne ke liye yahan hoon.

<hr>

Aapka listener **srv2** pe sahi se chal raha hai aur listening endpoints bhi correctly configured hain. Lekin, archive destinations ab bhi **INACTIVE** dikhaye ja rahe hain.

### **Steps to Address INACTIVE Archive Destinations:**

#### **1. Verify Archive Destination Settings**

Ensure ki aapke `log_archive_dest` settings sahi hain aur active hain:

1. **Check Current Archive Destinations:**
   ```sql
   SELECT DEST_ID, STATUS, DESTINATION FROM V$ARCHIVE_DEST;
   ```

2. **Verify Archive Destinations Configuration:**
   ```sql
   SHOW PARAMETER LOG_ARCHIVE_DEST
   ```

#### **2. Verify Network Connectivity**

Ensure ki network connectivity primary aur standby databases ke beech sahi hai.

1. **Test Connectivity to Standby from Primary:**
   ```bash
   tnsping ORADB_S2
   ```

   Replace `ORADB_S2` with the actual TNS entry for the standby database.

2. **Ensure Listener on Standby is Running and Correctly Configured:**
   ```bash
   lsnrctl status
   ```

   Check if the listener on the standby database is correctly configured and running.

#### **3. Update Archive Destinations**

**Activate or Reconfigure Archive Destinations:**

1. **Update Archive Destination:**
   ```sql
   ALTER SYSTEM SET LOG_ARCHIVE_DEST_<dest_id>='your_destination_path' SCOPE=BOTH;
   ```

   Replace `<dest_id>` with the appropriate destination ID and `your_destination_path` with the correct path or TNS entry.

2. **Force Archive Log Shipping:**
   ```sql
   ALTER SYSTEM ARCHIVE LOG CURRENT;
   ```

   This forces the archiving of the current redo log file and might help activate the destination.

#### **4. Check Archive Log Shipping Status**

1. **Verify Archive Log Shipping Status:**
   ```sql
   SELECT DEST_ID, STATUS, ERROR FROM V$ARCHIVE_DEST_STATUS;
   ```

2. **Check for Errors:**
   Look for any errors or issues related to log shipping.

#### **5. Review Alert Logs**

**Check Alert Logs for Errors:**

1. **Primary Database Alert Log:**
   ```plaintext
   $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
   ```

2. **Standby Database Alert Log:**
   ```plaintext
   $ORACLE_HOME/diag/rdbms/<dbname>/<dbname>/trace/alert_<dbname>.log
   ```

   Review the logs for any specific error messages related to archive destinations.

### **Summary:**

1. **Verify Archive Destination Settings** to ensure correct configuration.
2. **Check Network Connectivity** between primary and standby.
3. **Update and Force Archive Destinations** if necessary.
4. **Verify Archive Log Shipping Status** and resolve issues.
5. **Review Alert Logs** for detailed errors.

In steps ke baad bhi agar issue resolve nahi hota, ya koi specific error milta hai, to mujhe zaroor batayein. Main aur madad karne ke liye yahan hoon.
