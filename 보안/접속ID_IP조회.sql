
select p.spid, p.loginame, p.last_batch, p.program_name, p.cmd, c.client_net_address
from sys.sysprocesses P
    join sys.dm_exec_connections C on p.spid = C.session_id