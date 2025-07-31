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
