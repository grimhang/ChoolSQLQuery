-- by execution count
select T.cnt
    , F.Seq, F.session_id, f.event_name, F.event_date, F.cpu_time_ms, F.duration_ms, F.logical_reads, F.physical_reads, F.writes, F.row_count
    , F.database_name, F.username, F.client_hostname, F.client_app_name, F.sql_text, F.statement
from
(
    SELECT top 100 percent sql_text, count(*) cnt, min(seq) MinSeq
    FROM ForDBTuning_20210331
    group by sql_text
    order by cnt desc
) T
    join ForDBTuning_20210331 F      on T.MinSeq = F.Seq
order by T.cnt desc

--by duration
select T.cnt
    , F.Seq, F.session_id, f.event_name, F.event_date, F.cpu_time_ms, F.duration_ms, F.logical_reads, F.physical_reads, F.writes, F.row_count
    , F.database_name, F.username, F.client_hostname, F.client_app_name, F.sql_text, F.statement
from
(
    SELECT top 100 percent sql_text, count(*) cnt, min(seq) MinSeq
    FROM ForDBTuning_20210331
    group by sql_text
    order by cnt desc
) T
    join ForDBTuning_20210331 F      on T.MinSeq = F.Seq
order by F.duration_ms desc


-- by cpu
select T.cnt
    , F.Seq, F.session_id, f.event_name, F.event_date, F.cpu_time_ms, F.duration_ms, F.logical_reads, F.physical_reads, F.writes, F.row_count
    , F.database_name, F.username, F.client_hostname, F.client_app_name, F.sql_text, F.statement
from
(
    SELECT top 100 percent sql_text, count(*) cnt, min(seq) MinSeq
    FROM ForDBTuning_20210331
    group by sql_text
    order by cnt desc
) T
    join ForDBTuning_20210331 F      on T.MinSeq = F.Seq
order by F.cpu_time_ms desc


select isnull(statement, sql_text) SQls
from ForDBTuning_20210331
where seq = 1

--------------------------------------------------
-- top 10 per query max min
SELECT Min(B.Seq) Seq, A.sql_text, count(*) cnt
    , MIN(a.cpu_time_ms) Min_cpu_time_ms, AVG(a.cpu_time_ms) Avg_cpu_time_ms, MAX(a.cpu_time_ms) Max_cpu_time_ms
    , MIN(a.duration_ms) Min_duration_ms, AVG(a.duration_ms) Avg_duration_ms, MAX(a.duration_ms) Max_duration_ms
    , MIN(a.logical_reads) Min_logical_reads, AVG(a.logical_reads) Avg_logical_reads, MAX(a.logical_reads) Max_logical_reads
    , MIN(a.physical_reads) Min_physical_reads, AVG(a.physical_reads) Avg_physical_reads, MAX(a.physical_reads) Max_physical_reads
    , MIN(a.writes) Min_writes, AVG(a.writes) Avg_writes, MAX(a.writes) Max_writes
FROM ForDBTuning_20210331 A
    JOIN 
    (
        SELECT Seq, sql_text
        FROM ForDBTuning_20210331
        WHERE seq in (1, 2, 32, 11, 104, 13, 28, 31, 70, 25)
    ) B         ON A.sql_text = B.sql_text
GROUP BY A.sql_text
ORDER BY Seq



--------------------------------------------------
select *
from ForDBTuning_20210331
where seq in (32, 11, 104)


SELECT *
FROM sys.configurations
where name like '%memory%'