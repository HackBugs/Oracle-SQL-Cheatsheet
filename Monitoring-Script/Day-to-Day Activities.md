> ##  **Oracle DBA Checklist**, Daily, Weekly, Monthly, Quarterly, and One-Time activities: - [Link](https://www.scribd.com/document/329510232/Day-to-Day-Activities-of-Oracle-DBA-Checklist)

- `Ctrl+Shift+i` use javascript code to unblock data copy text from this website
```
// 1. Har element pe user-select allow karo
document.querySelectorAll('*').forEach(el => {
  el.style.userSelect = 'text';
  el.style.webkitUserSelect = 'text';
  el.style.msUserSelect = 'text';
});

// 2. Overlay ya block karne wale elements ko hatao ya invisible karo
document.querySelectorAll('div, span, section').forEach(el => {
  const style = getComputedStyle(el);
  if (
    (style.pointerEvents === 'none' || style.zIndex > 999) &&
    style.position === 'fixed'
  ) {
    el.style.display = 'none';
  }
});

// 3. Context menu (right click) aur copy block events hatao
['copy', 'cut', 'contextmenu', 'selectstart', 'mousedown', 'mouseup'].forEach(event => {
  document.body.addEventListener(event, e => e.stopPropagation(), true);
});
```

---

## ✅ **Day-to-Day Activities of Oracle DBA – Full Checklist**

---

### 🔹 **Daily DBA Checklist**

1. **Health Check** of Database Instance and Listener.
2. Review **Alert Log File** for ORA errors.
3. Check for **Session Blocking** and Oracle Locks; clear them.
4. Monitor **Long-Running RMAN/SQL Jobs**.
5. Verify no **DBMS\_JOBS** are in *failed* or *broken* state.
6. Ensure all **running jobs are refreshed** and up-to-date.
7. Check **Cron Job/Housekeeping Script Logs**.
8. Monitor **Tablespace Utilization** (especially TEMP and UNDO).
9. Rebuild **Indexes** if there's been bulk data insertion.
10. Monitor **TEMP Tablespace files**.
11. Check **UNDO Tablespace** and retention settings.
12. Monitor:

    * **Unix Filesystem Space**
    * **/tmp and /var** directories
    * **DB File System Usage**
    * **Archive Log Location**
13. Confirm **Successful Archiving** of Database Logs.
14. Verify **Database Backups**:

    * Check logs and success status
    * Look for backup completion (RMAN: incremental/cumulative)
15. Monitor **System Resources** and **Space Usage**.
16. Review **Production DB Performance**.
17. Trace high **CPU/Memory/I/O-consuming processes**; report if needed.
18. Check **OEM Agent Status** on all nodes.
19. Verify **DBConsole/DBSNMP is running**.
20. Monitor and manage:

    * **Users and Roles**
    * **Profile Expiry Policies**
21. Check for **Invalid Objects**; recompile if needed.
22. Monitor **Audit Tables and Logs**.
23. Backup your **Crontab or Windows Scheduler** settings.
24. **Important**: Read Oracle Manuals for 1 hour daily.
25. **Important**: Ensure Oracle **License Compliance** – avoid unauthorized use.

---

### 🌙 **Daily Night DBA Checklist**

1. Identify objects that break rules (e.g., **huge NESTED tables** or **Materialized Views**).
2. Check for objects **reaching max extents**.
3. Ensure all tables have **Unique Primary Keys**.
4. Monitor for **block corruption**.

---

### 🔁 **Weekly DBA Checklist**

1. Compare **Database Growth** week-over-week.
2. Identify **Future Growth Projections**.
3. Perform **Full RMAN Backup** (Level 0).
4. Perform **Cold Backup** (during maintenance windows).
5. Run **DB and Schema Analysis** to gather statistics.
6. Monitor and clean **Unused/Invalid Indexes**.
7. Ensure:

   * All indexes are on **INDEX tablespace**, not DATA.
   * Index datafiles are **not on same FS** as data/undo/temp.
8. Check **tnsnames.ora / listener.ora logs** for client/server errors.
9. Archive:

   * **Alert Logs**
   * **Application Logs** to history.
10. Monitor **Redo Log Switches per Hour** and size generated.
11. Validate **User Quotas** on tablespaces.
12. Truncate or clear **listener.log** if >1GB (and reload listener).

---

### ⚙️ **Weekly Tuning Checklist**

1. Monitor **Chained and Migrated Rows**.
2. Identify large tables that may require **Partitioning**.
3. Detect objects with **Excessive Extents**.
4. Identify:

   * Tables with **% Used but No Index**
   * Tables with **No Indexes** or **Too Many Indexes**
5. Place **Frequently Accessed Objects** in CACHE or separate tablespaces.
6. Check **frequent object reloads** in memory.
7. Ensure **Open Cursors** are not hitting max limit.
8. Confirm **Locks** are under max thresholds.
9. Monitor **I/O on Datafiles**.

---

### 📅 **Monthly DBA Checklist**

1. Rebuild **Indexes**.
2. Reorganize **Tablespaces**.
3. **Bounce** critical databases (if cold backup is configured).
4. Watch for **Abnormal Growth Rates**.
5. Review **DB File Activities** and compare with previous month.
6. Check for **Fragmentation** (row chaining, free space).
7. Validate:

   * **Datafile Locations**
   * **Autoextend Settings**
8. Confirm:

   * **Default Tablespaces**
   * **Temporary Tablespaces** per user
9. Analyze object **extents** and tablespace override risks.
10. Coalesce fragmented **Tablespaces**.
11. Update **Database Statistics**.
12. Perform **Trend Analysis** on:

    * Object Growth
    * Rows Count
    * Tablespace Usage

---

### 📔 **Quarterly DBA Checklist**

1. Apply **Patches** (Security, PSU, CPU).
2. **Database Reorganization**.
3. Check **User Quotas** in system and non-system tablespaces.
4. Bounce most critical databases (if cold backup policy allows).
5. Review and tune:

   * **Buffer Cache Hit Ratio**
   * **Latch Contention**
   * **Memory Management Areas**

---

### 🧾 **One-Time DBA Activities**

1. **Create Users** with correct privileges and roles.
2. Build and maintain a **Portal of ORA Errors** with documented solutions.
3. Check **Startup Time of Database** (if not using auto-start).
4. Verify **Control File Locations** and multiplexing setup.

---
