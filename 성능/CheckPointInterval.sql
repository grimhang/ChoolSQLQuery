SELECT *
FROM sys.configurations
where name like 'recovery interval%'
GO
/*
    configuration_id  name                     value  minimum  maximum  value_in_use  description                           is_dynamic  is_advanced
    ----------------  -----------------------  -----  -------  -------  ------------  ------------------------------------  ----------  -----------
    101               recovery interval (min)  0      0        32767    0             Maximum recovery interval in minutes  1           1
*/


SELECT database_id, name AS DBName, target_recovery_time_in_seconds
FROM sys.databases
WHERE name = 'AdventureTime'
GO
/*
    database_id  DBName            target_recovery_time_in_seconds
    -----------  ----------------  -------------------------------
    6            AdventureTime     0
*/
