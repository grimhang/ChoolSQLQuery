-- VER 1 (total database). 대한항공은 VER 1만 씀
set nocount ON

DECLARE @DB_USers TABLE(DBName sysname, [type] varchar(500),  [type_desc] varchar(500), cnt int)
INSERT @DB_USers EXEC sp_MSforeachdb'
use [?];

WITH CTE_TABLE
AS
(
	SELECT ''AF'' AS [TYPE],  ''Agg Function(CLR)'' AS TYPE_NAME UNION
	SELECT ''C'' AS [TYPE],  ''CHECK Constraint'' AS TYPE_NAME UNION
	SELECT ''D'' AS [TYPE],  ''DEFAULT(Constraint OR Standalone)'' AS TYPE_NAME UNION
	SELECT ''F'' AS [TYPE],  ''FOREIGN KEY Constraint'' AS TYPE_NAME UNION
	SELECT ''FN'' AS [TYPE],  ''SQL scalar Function'' AS TYPE_NAME UNION
	SELECT ''FS'' AS [TYPE],  ''Assembly(CLR) scalar Function'' AS TYPE_NAME UNION
	SELECT ''FT'' AS [TYPE],  ''Assembly(CLR) Table return Function'' AS TYPE_NAME UNION
	SELECT ''IF'' AS [TYPE],  ''SQL inline Table return Function'' AS TYPE_NAME UNION
	SELECT ''IT'' AS [TYPE],  ''internal Table'' AS TYPE_NAME UNION
	SELECT ''P'' AS [TYPE],  ''SQL Stored Procedure'' AS TYPE_NAME UNION
	SELECT ''PC'' AS [TYPE],  ''Assembly(CLR) Stored Procedure'' AS TYPE_NAME UNION
	SELECT ''PG'' AS [TYPE],  ''plan'' AS TYPE_NAME UNION
	SELECT ''PK'' AS [TYPE],  ''PRIMARY KEY Constraint'' AS TYPE_NAME UNION
	SELECT ''R'' AS [TYPE],  ''rule (before style standalone)'' AS TYPE_NAME UNION
	SELECT ''RF'' AS [TYPE],  ''replication filter Procedure'' AS TYPE_NAME UNION
	SELECT ''S'' AS [TYPE],  ''system defautl Table'' AS TYPE_NAME UNION
	SELECT ''SN'' AS [TYPE],  ''Synonym'' AS TYPE_NAME UNION
	SELECT ''SO'' AS [TYPE],  ''Sequence'' AS TYPE_NAME UNION
	SELECT ''U'' AS [TYPE],  ''Table(USER Defined)'' AS TYPE_NAME UNION
	SELECT ''V'' AS [TYPE],  ''View'' AS TYPE_NAME UNION
	SELECT ''EC'' AS [TYPE],  ''Edge Constraint'' AS TYPE_NAME UNION
	SELECT ''SQ'' AS [TYPE],  ''service queue'' AS TYPE_NAME UNION
	SELECT ''TR'' AS [TYPE],  ''SQL DML trigger'' AS TYPE_NAME UNION
	SELECT ''TF'' AS [TYPE],  ''SQL Table return Function'' AS TYPE_NAME UNION
	SELECT ''UQ'' AS [TYPE],  ''UNIQUE Constraint''
)
SELECT ''?'' AS DB_Name, C.TYPE, C.TYPE_NAME, COUNT(*) CNT
FROM CTE_TABLE C
	LEFT JOIN sys.objects O	ON C.TYPE = O.type
GROUP BY C.TYPE, C.TYPE_NAME
ORDER BY C.TYPE, C.TYPE_NAME'
SELECT *
FROM @DB_USers
WHERE DBName NOT IN ('master', 'tempdb', 'model', 'msdb')
order by DBName, TYPE

-- VER 2 (one database)
WITH CTE_TABLE
AS
(
	SELECT 'AF' AS [TYPE],  'Agg Function(CLR)' AS TYPE_NAME UNION
	SELECT 'C' AS [TYPE],  'CHECK Constraint' AS TYPE_NAME UNION
	SELECT 'D' AS [TYPE],  'DEFAULT(Constraint OR Standalone)' AS TYPE_NAME UNION
	SELECT 'F' AS [TYPE],  'FOREIGN KEY Constraint' AS TYPE_NAME UNION
	SELECT 'FN' AS [TYPE],  'SQL scalar Function' AS TYPE_NAME UNION
	SELECT 'FS' AS [TYPE],  'Assembly(CLR) scalar Function' AS TYPE_NAME UNION
	SELECT 'FT' AS [TYPE],  'Assembly(CLR) Table return Function' AS TYPE_NAME UNION
	SELECT 'IF' AS [TYPE],  'SQL inline Table return Function' AS TYPE_NAME UNION
	SELECT 'IT' AS [TYPE],  'internal Table' AS TYPE_NAME UNION
	SELECT 'P' AS [TYPE],  'SQL Stored Procedure' AS TYPE_NAME UNION
	SELECT 'PC' AS [TYPE],  'Assembly(CLR) Stored Procedure' AS TYPE_NAME UNION
	SELECT 'PG' AS [TYPE],  'plan' AS TYPE_NAME UNION
	SELECT 'PK' AS [TYPE],  'PRIMARY KEY Constraint' AS TYPE_NAME UNION
	SELECT 'R' AS [TYPE],  'rule (before style standalone)' AS TYPE_NAME UNION
	SELECT 'RF' AS [TYPE],  'replication filter Procedure' AS TYPE_NAME UNION
	SELECT 'S' AS [TYPE],  'system defautl Table' AS TYPE_NAME UNION
	SELECT 'SN' AS [TYPE],  'Synonym' AS TYPE_NAME UNION
	SELECT 'SO' AS [TYPE],  'Sequence' AS TYPE_NAME UNION
	SELECT 'U' AS [TYPE],  'Table(USER Defined)' AS TYPE_NAME UNION
	SELECT 'V' AS [TYPE],  'View' AS TYPE_NAME UNION
	SELECT 'EC' AS [TYPE],  'Edge Constraint' AS TYPE_NAME UNION
	SELECT 'SQ' AS [TYPE],  'service queue' AS TYPE_NAME UNION
	SELECT 'TR' AS [TYPE],  'SQL DML trigger' AS TYPE_NAME UNION
	SELECT 'TF' AS [TYPE],  'SQL Table return Function' AS TYPE_NAME UNION
	SELECT 'UQ' AS [TYPE],  'UNIQUE Constraint'
)
SELECT C.TYPE, C.TYPE_NAME, COUNT(*) CNT
FROM CTE_TABLE C
	LEFT JOIN SYS.OBJECTS O	ON C.TYPE = O.type
GROUP BY C.TYPE, C.TYPE_NAME
ORDER BY C.TYPE, C.TYPE_NAME

-- VER 3 (simple)
SELECT TYPE_DESC, COUNT(*) 
FROM SYS.OBJECTS
GROUP BY TYPE_DESC
ORDER BY TYPE_DESC

