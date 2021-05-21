SELECT *
FROM sys.availability_read_only_routing_lists

/*
    replica_id                           routing_priority read_only_replica_id
    ------------------------------------ ---------------- ------------------------------------
    7D23C5DF-9BD7-4D63-91B4-66E794057508 1                F377130B-4410-4F64-8E13-8E01EFFDFBC2
    7D23C5DF-9BD7-4D63-91B4-66E794057508 2                7D23C5DF-9BD7-4D63-91B4-66E794057508
    F377130B-4410-4F64-8E13-8E01EFFDFBC2 1                7D23C5DF-9BD7-4D63-91B4-66E794057508
    F377130B-4410-4F64-8E13-8E01EFFDFBC2 2                F377130B-4410-4F64-8E13-8E01EFFDFBC2
*/

SELECT replica_id, replica_metadata_id, replica_server_name, [endpoint_url], secondary_role_allow_connections_desc, [read_only_routing_url]
FROM sys.availability_replicas
/*
    replica_id                            replica_metadata_id  replica_server_name  endpoint_url                           secondary_role_allow_connections_desc  read_only_routing_url
    ------------------------------------  -------------------  -------------------  -------------------------------------  -------------------------------------  -------------------------
    7D23C5DF-9BD7-4D63-91B4-66E794057508  NULL                 SERVER_AAAAA1        TCP://SERVER_AAAAA1.myserver.net:5022  ALL                                    TCP://10.42.180.201:1433
    F377130B-4410-4F64-8E13-8E01EFFDFBC2  65536                SERVER_BBBBB2        TCP://SERVER_AAAAA2.myserver.net:5022  ALL                                    TCP://10.42.180.202:1433
*/



ALTER AVAILABILITY GROUP [LCHDFCS6_AVG]   
MODIFY REPLICA ON  
N'LCHDFCSN6PNB2' WITH   
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('SERVER_AAAAA1')));  
GO  
  

ALTER AVAILABILITY GROUP [LCHDFCS6_AVG]   
MODIFY REPLICA ON  
N'LCHDFCSN6PNB1' WITH   
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('SERVER_AAAAA2')));  
GO  
  
/*  
    클라이언트 연결 문자열
    APPLITION INTENT=READONLY 를 연결 문자열에 포함시켜야함    
    APPLITIONINTENT=READONLY        <--  ODBC와 예전 드라이버 문자열
*/