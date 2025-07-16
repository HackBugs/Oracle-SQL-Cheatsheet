Bilkul bhai! Yeh raha aapka poora content neatly packed **bash-style box** ke andar, taaki aap easily save ya share kar sako:

```
# ✅ Step 1: PERMANENT FIX — Add to PATH
1. Right click "This PC" → Properties
2. Advanced System Settings → Environment Variables
3. In "System Variables", edit `Path`
4. Click New → Add:
   C:\oracle\product\19.0.0\client_1\bin
5. OK → OK → Restart CMD

# ✅ Step 2: Test if it works
In CMD, run:
sqlplus

# Output should be:
SQL*Plus: Release 19.0.0.0.0 - Production
➡️ FIXED ✅

##############################################
# 💬 BONUS: Test via .bat file again
##############################################

@echo off
sqlplus system/admin@//192.168.1.124:1521/oradb.localdomain
pause

# ➕ Double-click the .bat file to connect
```


> # ✅ Step-by-Step Guide: Connect Oracle Client to Oracle Database via CMD

---

### 🧱 Step 1: Prerequisites Check

Make sure you have:

✅ Oracle Client installed (Basic or Full)
✅ TNS (connection info) configured — usually via `tnsnames.ora` file
✅ You know your:

* **Username**
* **Password**
* **Database Service Name / SID**
* **Host IP / Hostname**
* **Port** (usually 1521)

---

### 📂 Step 2: Locate `sqlplus` Utility

After Oracle Client install:

* Go to command prompt
* Navigate to Oracle Client `bin` directory:

Example (default path):

```cmd
cd C:\oracle\product\19.0.0\client_1\bin
```

Or just type in CMD anywhere:

```cmd
sqlplus
```

Agar path set nahi hai to `sqlplus` command nahi chalega → to `cd` karke us directory me jao jahan Oracle Client install hua.

---

### 🖥️ Step 3: Connect to Remote Database using SQL\*Plus

There are **two ways**:

---

### 🔹 OPTION 1: Easy Connect (Without TNSNAMES.ORA)

```cmd
sqlplus username/password@//host:port/service_name
```

🔸 Example:

```cmd
sqlplus system/Oracle123@//192.168.1.124:1521/orclpdb1
```

> ❗ `orclpdb1` = service name (check with your DBA or from `tnsnames.ora`)

---

### 🔹 OPTION 2: Using TNSNAMES.ORA entry

1. Go to your client:

   ```cmd
   cd C:\oracle\product\19.0.0\client_1\network\admin
   ```

2. Edit `tnsnames.ora` file and add entry like:

```ora
ORCLDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.1.124)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = orclpdb1)
    )
  )
```

3. Then connect using:

```cmd
sqlplus system/Oracle123@ORCLDB
```

<hr>

> # **`.bat` file banana**, jisko **double-click karte hi CMD open ho jaye aur Oracle SQL\*Plus se auto connect ho jaye**.

---

## ✅ Final `.bat` File (for Windows)

Yeh code copy karo aur **`connect_oracle.bat`** naam se save karo:

```bat
@echo off
REM Set Oracle Client bin path if not in PATH
SET ORACLE_HOME=C:\oracle\product\19.0.0\client_1
SET PATH=%ORACLE_HOME%\bin;%PATH%

REM Connect to Oracle database using SQL*Plus
sqlplus system/admin@//192.168.1.124:1521/oradb.localdomain

pause
```

---

### 📌 Important Notes:

1. **Replace this path** if Oracle Client installed somewhere else:

   ```
   C:\oracle\product\19.0.0\client_1
   ```

2. `pause` last line pe diya hai, taaki agar koi error aaye to window band na ho turant.

---

## ✅ Steps to Use:

1. Open **Notepad**
2. Paste above code
3. Save As ➝ `connect_oracle.bat`
4. File Type ➝ Select **All Files**
5. Double-click file ➝ ✅ Connected

---

## 🔐 BONUS: Password Prompt Version (Optional Security)

Agar aap nahi chahte password file me hardcoded ho, use ye version:

```bat
@echo off
SET /p USERPASS=Enter password for system: 
sqlplus system/%USERPASS%@//192.168.1.124:1521/oradb.localdomain
pause
```

<hr>

> # ✅ **Ek click ya shortcut se Oracle SQL\*Plus se turant connect ho jaye.**

---

## ✅ Option 1: Shortcut Desktop pe Lagao `.bat` ka

1. `.bat` file pe **right-click karo**
2. Click → **Send to → Desktop (create shortcut)**
3. Ab desktop pe shortcut aagaya — bas **double-click** karte hi connect ho jaoge 🎯

---

## ✅ Option 2: Add `.bat` file to Windows Taskbar or Start Menu

### 👉 Taskbar:

1. Desktop shortcut banne ke baad
2. Right-click on shortcut → **Pin to taskbar**

### 👉 Start Menu:

1. Right-click on `.bat` file → **Create shortcut**

2. Copy that shortcut to:

   ```plaintext
   C:\ProgramData\Microsoft\Windows\Start Menu\Programs
   ```

3. Ab aap **Start Menu me search karke bhi connect** kar sakte ho.

---

## ✅ Option 3: Auto Launch at Boot/Login (Advanced)

Agar aap chahte ho system start hote hi ya login karte hi SQL\*Plus connect ho:

1. Press `Win + R` → type:

   ```
   shell:startup
   ```
2. Paste your `.bat` shortcut there

👉 Isse aap jab bhi login karoge, SQL\*Plus launch ho jayega

---

## ✅ BONUS: CMD se Direct Run (Without Opening Folder)

Agar `.bat` file ka path yaad hai, to CMD me bas likho:

```cmd
"C:\Users\YourName\Documents\connect_oracle.bat"
```

