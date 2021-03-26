-- in Test 2014
SELECT LEFT(name, 20) AS [FunctionName]
    , type_desc
    , OBJECTPROPERTY(object_id, 'IsDeterministic') As IsDeter
    , OBJECTPROPERTY(object_id, 'IsSchemaBound') As IsSchemaBound
FROM sys.objects
WHERE type in ('IF', 'TF', 'FN')
ORDER BY name
