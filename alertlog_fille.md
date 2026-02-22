## Find alert log file 
---
```
SELECT value FROM v$diag_info WHERE name = 'Diag Trace';
```
```
find $ORACLE_BASE -name "alert_*.log"
```
```
locate alert_$(echo $ORACLE_SID).log
```
```
adrci
```
