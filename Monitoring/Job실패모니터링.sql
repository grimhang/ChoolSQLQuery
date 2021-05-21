SELECT 
    --[J].[job_id] AS [JobID]
    [J].[name] AS [JobName]
    , CASE 
        WHEN [H].[run_date] IS NULL OR [H].[run_time] IS NULL THEN NULL
        ELSE CAST(
                CAST([H].[run_date] AS CHAR(8))
                + ' ' 
                + STUFF(
                    STUFF(RIGHT('000000' + CAST([H].[run_time] AS VARCHAR(6)),  6)
                        , 3, 0, ':')
                    , 6, 0, ':')
                AS DATETIME)
      END AS [LastRunDateTime]
    , CASE [H].[run_status]
        WHEN 0 THEN 'Failed'
        WHEN 1 THEN 'Succeeded'
        WHEN 2 THEN 'Retry'
        WHEN 3 THEN 'Canceled'
        WHEN 4 THEN 'Running' -- In Progress
      END AS [LastRunStatus]
    , STUFF(
            STUFF(RIGHT('000000' + CAST([H].[run_duration] AS VARCHAR(6)),  6)
                , 3, 0, ':')
            , 6, 0, ':') 
        AS [LastRunDuration (HH:MM:SS)]
    , [H].[message] AS [LastRunStatusMessage]
FROM 
    [msdb].[dbo].[sysjobs] AS J
    JOIN [msdb].[dbo].[sysjobhistory] H         ON [J].[job_id] = [H].[job_id]
WHERE j.name not in ('syspolicy_purge_history')
    and H.step_id = 0
    AND H.run_date > convert(varchar(8), getdate() - 1, 112)    -- 하루전부터.
    AND H.run_status <> 1 -- 성공이 아닌것만
ORDER BY [JobName]