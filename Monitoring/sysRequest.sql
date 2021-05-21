SELECT R.session_id, R.status, R.command, R.plan_handle, d.name DBName, R.user_id, R.blocking_session_id, R.wait_type, R.cpu_time, R.total_elapsed_time
    , S.login_name, s.language
FROM sys.dm_exec_requests R
    JOIN sys.databases D            ON R.database_id = d.database_id
    JOIN sys.dm_exec_sessions S     ON S.session_id = R.session_id
WHERE R.status NOT IN ('sleeping')
    AND R.session_id >= 50