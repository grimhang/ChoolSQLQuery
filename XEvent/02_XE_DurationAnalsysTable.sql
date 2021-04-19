-- EXEC xp_dirtree 'D:\ForDBTuning', 1, 1;

CREATE TABLE ForDBTuning (
        Seq int identity(1,1) not null Primary key,
        [session_id] [bigint] NULL,
        [event_name] [nvarchar](200) NULL,
		[event_date] [datetime] NULL,
		[cpu_time_ms] [bigint] NULL,
		[duration_ms] [bigint] NULL,
		[physical_reads] [bigint] NULL,
		[logical_reads] [bigint] NULL,
		[writes] [bigint] NULL,
		[row_count] [bigint] NULL,
		[result] [nvarchar](256) NULL,
		[database_name] [nvarchar](128) NULL,
		[username] [nvarchar](256) NULL,
		[client_hostname] [nvarchar](256) NULL,
		[client_app_name] [nvarchar](256) NULL,
		[batch_text] [nvarchar](max) NULL,
		[sql_text] [nvarchar](max) NULL,
		[statement] [nvarchar](max) NULL
	)


INSERT INTO ForDBTuning (session_id, event_name, [event_date], [cpu_time_ms], [duration_ms], [physical_reads], [logical_reads], [writes], [row_count], [result], [database_name], [username], [client_hostname], [client_app_name], [batch_text], [sql_text], [statement])
SELECT 
      eventstats.value('(action[@name="session_id"])[1]', 'bigint') as session_id
    , eventstats.value('(/event/@name)[1]','nvarchar(200)') as event_name    
    , dateadd(hour,datediff(hour,getutcdate(),getdate()),eventstats.value('(/event/@timestamp)[1]','datetime')) as event_date
	, eventstats.value('(data[@name="cpu_time"])[1]', 'bigint') / 1000 as cpu_time_ms
	, eventstats.value('(data[@name="duration"])[1]', 'bigint') / 1000 as duration_ms
	, eventstats.value('(data[@name="physical_reads"])[1]', 'bigint') as physical_reads
	, eventstats.value('(data[@name="logical_reads"])[1]', 'bigint') as logical_reads
	, eventstats.value('(data[@name="writes"])[1]', 'bigint') as writes
	, eventstats.value('(data[@name="row_count"])[1]', 'bigint') as row_count
	, eventstats.value('(data[@name="result"]/text)[1]', 'nvarchar(256)') as result
    , eventstats.value('(action[@name="database_name"])[1]', 'nvarchar(200)') as database_name
	, eventstats.value('(action[@name="username"])[1]', 'nvarchar(256)') as username
	, eventstats.value('(action[@name="client_hostname"])[1]', 'nvarchar(256)') as client_hostname
	, eventstats.value('(action[@name="client_app_name"])[1]', 'nvarchar(256)') as client_app_name
	, eventstats.value('(data[@name="batch_text"])[1]', 'nvarchar(max)') as batch_text
	, eventstats.value('(action[@name="sql_text"])[1]', 'nvarchar(max)') as sql_text
	, eventstats.value('(data[@name="statement"])[1]', 'nvarchar(max)') as statement
FROM
(
    SELECT CAST(event_data AS XML) AS event_xml
    --FROM sys.fn_xe_file_target_read_file('D:\ForDBTuning\ForDBTune_Duration_0_132603372877890000.xel', null, null, null)
    --FROM sys.fn_xe_file_target_read_file('D:\ForDBTuning\ForDBTune_Duration_0_132603816518040000.xel', null, null, null)    
     FROM sys.fn_xe_file_target_read_file('D:\ForDBTuning\ForDBTune_Duration_0_132604233883270000.xel', null, null, null)    
)  T CROSS APPLY event_xml.nodes('//event') AS x(eventstats)
ORDER BY event_date


