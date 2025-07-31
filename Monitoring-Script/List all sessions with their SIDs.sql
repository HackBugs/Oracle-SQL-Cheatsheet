SELECT
    sid,
    serial#,
    username,
    status,
    osuser,
    machine,
    program
FROM
    v$session
ORDER BY
    sid;



ALTER SYSTEM KILL SESSION '<sid>,<serial#>' IMMEDIATE;
