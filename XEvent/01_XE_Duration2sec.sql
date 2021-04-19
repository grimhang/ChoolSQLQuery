/*
    -- active Xevent session
    SELECT *
    FROM sys.dm_xe_sessions

    -- all Xevent session
    SELECT *
    FROM sys.server_event_sessions      -- 온프레미스만
    ORDER BY name
*/

CREATE EVENT SESSION [ForDBTune_Duration2sec] ON SERVER 
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
    WHERE (([package0].[equal_boolean]([sqlserver].[is_system],(0))) AND ([package0].[greater_than_equal_uint64]([duration],(2000000))))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
    WHERE (([package0].[equal_boolean]([sqlserver].[is_system],(0))) AND ([package0].[greater_than_equal_uint64]([duration],(2000000)))))
ADD TARGET package0.event_file(SET filename=N'D:\ForDBTuning\ForDBTune_Duration.xel',max_file_size=(100))
WITH (MAX_MEMORY=8192 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=PER_CPU,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO

ALTER EVENT SESSION [ForDBTune_Duration]       ON SERVER
STATE = START;
GO