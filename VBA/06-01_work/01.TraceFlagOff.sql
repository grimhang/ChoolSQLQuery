dbcc tracestatus()
TraceFlag	Status	Global	Session
1222	    1	    1	    0

dbcc traceoff(1222, -1);
go


dbcc tracestatus()
TraceFlag	Status	Global	Session

/*
    Active Standby ¸ðµÎ
*/