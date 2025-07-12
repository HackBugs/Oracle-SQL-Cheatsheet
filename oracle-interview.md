बहुत बढ़िया! आपने Oracle Interview के लिए काफी practical बातें और real-life experience share किया है। अब मैं इसे अच्छी तरह **organize** कर देता हूँ ताकि आप इसे इंटरव्यू में confidently और professional तरीके से बता सको।

---

# ✅ **Oracle DBA Interview Preparation Notes (Hinglish Me)**

---

## 🔹 **1. Index Rebuilding & Tuning**

* Jab index rebuild karte hain aur koi issue aata hai (jaise performance down), to problematic SQL ko identify karte hain.
* AWR report ya V\$ views se top SQLs, high CPU consuming processes identify karte hain.
* Hard parsing zyada ho to indexing, bind variables, ya SQL tuning check karna padta hai.
* Full table scan detect karna hoga — iska matlab proper indexing nahi hai ya index use nahi ho raha.

**Tools:**

* AWR Report
* V\$SQL, V\$SESSION
* SQL Execution Plan (EXPLAIN PLAN, AUTO TRACE)

---

## 🔹 **2. AWR Report Usage**

* AWR se top 5 foreground processes dekhe jaate hain.
* Check hota hai:

  * CPU utilization
  * Disk I/O
  * Soft Parsing vs Hard Parsing
  * Redo generation
  * Transaction per second
* Buffer Cache Hit Ratio, Library Cache Hit Ratio, Soft Parse Ratio — sab 90–100% ke beech hone chahiye.

---

## 🔹 **3. SQL Performance Check**

* SQL queries ka Execution Plan nikal ke dekhte hain:

  * `EXPLAIN PLAN FOR <your query>`
  * `SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);`
* Check karte hain:

  * Full table scan to nahi ja raha?
  * Index use ho raha ya nahi?

---

## 🔹 **4. SQL Developer Connection Issues**

* SQL Developer se jab connection issue aaye:

  * Listener.ora, tnsnames.ora me port & service name check karo.
  * Listener up hai ya nahi ye check karo:

    * `lsnrctl status`
  * TNS ping test bhi kar sakte hain:

    * `tnsping service_name`

---

## 🔹 **5. Real-Life Example (Extraordinary Work)**

**Scenario:**
"Ek baar system slow ho gaya tha, user complain kar rahe the. Maine AWR report nikala, top processes dekhe, V\$session se problematic SQL dekhi, Execution Plan nikal ke dekha ki full table scan ho raha hai. Fir developer ko bola ki query rewrite karein ya index banayein. Performance improve ho gaya."

---

## 🔹 **6. Load Profile / Performance Parameters**

* Load profile se:

  * Redo Generated
  * Logical Reads
  * Physical Reads
  * DB Time
* Sab parameters ideally **optimized** hone chahiye.
* Example:

  * Hard Parsing zyada hai to Bind variables ka use karo.
  * Transactions/sec bahut zyada hai to proper commit/rollback use ho raha ya nahi wo check karo.

---

## 🔹 **7. Indexing**

* **Why Indexing?**
  Query speed badhane ke liye — agar index hoga to result faster milega.
* **Index Banana:**

```sql
CREATE INDEX idx_salary ON employee(salary);
```

* Example:
  Agar query hai:

  ```sql
  SELECT * FROM employee WHERE salary > 5000;
  ```

  To salary column pe index hona chahiye for better performance.

---

## 🔹 **8. EXPLAIN PLAN (Execution Plan)**

* 2 Methods:

  1. **EXPLAIN PLAN**

     ```sql
     EXPLAIN PLAN FOR <your_query>;
     SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
     ```
  2. **SET AUTOTRACE ON**
     SQL Developer ya SQL\*Plus me:

     ```sql
     SET AUTOTRACE ON;
     ```

---

## 🔹 **9. Developer ke saath kaam karte waqt**

* Agar query slow hai:

  * Execution plan nikaal kar dekhte hain.
  * Index hai ya nahi check karte hain.
  * Query developer ne likhi hoti hai, to unko suggest karte hain ki query ko tune karein.
  * Hum sirf backend performance monitor karte hain.

---

## 🔹 **10. V\$ Views ka Use**

* V\$SQL → Top SQLs
* V\$SESSION → Active sessions
* V\$PROCESS → Background & foreground processes
* V\$EVENT → Wait events

---

## 🔹 **11. Interview ke liye Tips**

* Jab apne kaam ka explanation do, confidently batao ki tumne kya identify kiya, kaise solve kiya.
* "Main AWR report banata hoon aur senior ko bhejta hoon" se better hai:

  > "Jab performance issue hota hai, main AWR ya V\$ views ke through root cause find karta hoon, jaise top SQLs, full table scans, ya indexing issues, fir senior ke sath discuss karke fix karte hain."

---

## ✅ Summary Cheat Sheet

| Area                    | Tools / Commands Used                          |
| ----------------------- | ---------------------------------------------- |
| Performance Tuning      | AWR, V\$SQL, V\$SESSION, V\$PROCESS, SQL Plan  |
| SQL Check               | EXPLAIN PLAN, SET AUTOTRACE ON                 |
| Index Creation          | CREATE INDEX                                   |
| Connection Troubleshoot | lsnrctl, listener.ora, tnsnames.ora            |
| Load Profile Monitoring | Redo, Logical/Physical Reads, Tx/sec           |
| Real-World Scenario     | Slow system → AWR → SQL tune → performance fix |

---
