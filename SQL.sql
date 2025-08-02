-- Original Records
CREATE TABLE employees (
    emp_id      NUMBER PRIMARY KEY,
    emp_name    VARCHAR2(50),
    department  VARCHAR2(30),
    salary      NUMBER(10, 2),
    hire_date   DATE,
    email       VARCHAR2(100) UNIQUE
);

INSERT INTO employees VALUES (101, 'Amit Sharma', 'IT',       60000, TO_DATE('2019-04-15', 'YYYY-MM-DD'), 'amit.sharma@abc.com');
INSERT INTO employees VALUES (102, 'Ravi Kumar',  'HR',       45000, TO_DATE('2020-06-20', 'YYYY-MM-DD'), 'ravi.kumar@abc.com');
INSERT INTO employees VALUES (103, 'Neha Singh', 'Finance',   55000, TO_DATE('2018-01-10', 'YYYY-MM-DD'), 'neha.singh@abc.com');
INSERT INTO employees VALUES (104, 'Preeti Jain','IT',        62000, TO_DATE('2021-03-05', 'YYYY-MM-DD'), 'preeti.jain@abc.com');
INSERT INTO employees VALUES (105, 'Suresh Mehta','Marketing',48000, TO_DATE('2017-11-23', 'YYYY-MM-DD'), 'suresh.mehta@abc.com');

-- Duplicates
INSERT INTO employees VALUES (106, 'Amit Sharma', 'IT',       61000, TO_DATE('2022-02-18', 'YYYY-MM-DD'), 'amit.sharma2@abc.com');
INSERT INTO employees VALUES (107, 'Ravi Kumar',  'HR',       46000, TO_DATE('2023-01-12', 'YYYY-MM-DD'), 'ravi.kumar2@abc.com');
INSERT INTO employees VALUES (108, 'Neha Singh',  'Finance',  56000, TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'neha.singh2@abc.com');

SELECT * from employees;

SELECT NAME, OPEN_MODE, CON_ID FROM V$PDBS;
SELECT NAME FROM V$PDBS;

ALTER PLUGGABLE DATABASE PDB1 OPEN;
ALTER SESSION SET CONTAINER = PDB1;
ALTER USER hr IDENTIFIED BY hr ACCOUNT UNLOCK;

CREATE USER hr IDENTIFIED BY hr;
GRANT CONNECT, RESOURCE TO hr;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO hr;

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'HR';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'HR';
SELECT username, account_status FROM dba_users WHERE username = 'HR';

SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;


SHOW CON_NAME;
SHOW PDBS;
ALTER SESSION SET CONTAINER = PDB1;

CREATE USER hr IDENTIFIED BY hr;
GRANT CONNECT, RESOURCE TO hr;
ALTER USER hr ACCOUNT UNLOCK;
