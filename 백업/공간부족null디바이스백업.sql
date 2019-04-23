BACKUP LOG MyDB to disk = 'NUL'
-- https://www.overtop.co.kr/157

Q. 언제 사용할까?

A. 로그백업할 디스크 공간이 없을 때 사용하며, 로그파일의 크기가 너무 커서 로그 트랜잭션을 truncate 효과를 보기 위해서 사용해야 한다.

단, 주의해야한다. 해당 백업도 LSN 에 영향을 주기 때문에 해당 작업을 한 후 전체백업 및 로그백업을 반드시 수행해야 한다.



출처: https://www.overtop.co.kr/157 [SQLin]

