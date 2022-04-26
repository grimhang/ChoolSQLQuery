SELECT *
FROM
(
    SELECT J.name JobName, CASE J.enabled WHEN 1 THEN 'Y' ELSE 'N' END 'Job사용여부', JS.step_id JobStepId, JS.step_name JobStepName, JS.command JobStepCommand, JS.database_name DBName, T.ObjectName, T.TypeDesc, JS.last_run_duration '최근실행시간(초)'
        --, JSC.*
        , SC.name '스케줄이름', CASE SC.enabled WHEN 1 THEN 'Y' ELSE 'N' END '스케줄사용여부'
        , CASE SC.freq_type
            WHEN 1 THEN N'only one'
            WHEN 4 THEN N'Daily'
            WHEN 8 THEN N'Weekly'
            WHEN 16 THEN N'Monthly'
            WHEN 32 THEN N'매월,FreqInterval기준'
            WHEN 64 THEN N'SQLAgent시작시'
            WHEN 128 THEN N'컴퓨터유휴시'
            ELSE N'N/A'
            END '반복조건'
        , CASE WHEN SC.freq_interval in ( 0, 1) THEN 'N/A' ELSE CAST(SC.freq_interval as varchar(50)) End freq_interval
        , CASE SC.freq_subday_type
            WHEN 1 THEN N'지정시간'
            WHEN 2 THEN CAST(SC.freq_subday_interval AS NVARCHAR(50)) + N'? 초마다'
            when 4 THEN CAST(SC.freq_subday_interval AS NVARCHAR(50)) + N' 분마다'
            when 8 THEN CAST(SC.freq_subday_interval AS NVARCHAR(50)) + N' 시간마다'
            ELSE N'N/A'
        END '반복주기'
        --, SC.freq_subday_interval
        , CASE SC.freq_relative_interval
            when 1 THEN N'첫번째'
            WHEN 2 THEN N'초반'
            WHEN 4 THEN N'세번째'
            WHEN 8 THEN N'네번째'
            WHEN 16 THEN N'마지막'
            ELSE N'N/A'
        END N'몇주차'
    FROM
    (
	    SELECT top (100) percent object_name(M.object_id) ObjectName
		    --,O.type_desc
            , CASE o.TYPE WHEN 'FN' THEN 'Function' ELSE 'Procedure' END TypeDesc
	    FROM sys.sql_modules AS M
	    JOIN sys.objects AS O ON M.object_id = O.object_id
	    WHERE M.DEFINITION LIKE '%필터링할문구%'
		ORDER BY O.type_desc, ObjectName
    ) T
    LEFT JOIN msdb.dbo.sysjobsteps JS    on JS.command like '%' + T.objectName + '%'
    LEFT join msdb.dbo.sysjobs J        on JS.job_id = J.job_id
    LEFT join msdb.dbo.sysjobschedules JSC on J.job_id = JSC.job_id
    LEFT JOIN msdb.dbo.sysschedules SC ON JSC.schedule_id = SC.schedule_id
) T2
WHERE T2.Jobname is not null
ORDER BY T2.Jobname
;
