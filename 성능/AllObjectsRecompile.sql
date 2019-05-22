-- Ver1
DECLARE C CURSOR FOR (SELECT [name] FROM sys.objects WHERE [type] IN ('P', 'FN', 'IF'));
DECLARE @name SYSNAME;
OPEN C;
FETCH NEXT FROM C INTO @name;
WHILE @@FETCH_STATUS=0
BEGIN
    EXEC sp_recompile @name;
    FETCH NEXT FROM C INTO @name;
END;
CLOSE C;
DEALLOCATE C;


-- Ver2
EXEC sp_MSforeachdb'
    use [?]

    DECLARE C CURSOR FOR (SELECT [name] FROM sys.objects WHERE [type] IN ('P', 'FN', 'IF'));
    DECLARE @name SYSNAME;
    OPEN C;
    FETCH NEXT FROM C INTO @name;
    
    WHILE @@FETCH_STATUS=0
    BEGIN
        EXEC sp_recompile @name;
        FETCH NEXT FROM C INTO @name;
    END;
    CLOSE C;
    DEALLOCATE C;
'