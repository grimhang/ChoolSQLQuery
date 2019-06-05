-- OS 정보
SELECT *
FROM sys.dm_os_sys_INFO

-- OS Memory
select total_physical_memory_kb / 1024		AS total_physical_memory_MB
	, available_physical_memory_kb / 1024	AS available_physical_memory_MB
	, total_page_file_kb / 1024				AS total_page_file_MB
	, available_page_file_kb / 1024			AS available_page_file_MB
	, system_cache_kb / 1024				AS system_cache_MB
	, kernel_paged_pool_kb / 1024			AS kernel_paged_pool_MB
	, kernel_nonpaged_pool_kb / 1024		AS kernel_nonpaged_pool_MB
	, system_high_memory_signal_state
	, system_low_memory_signal_state
	, system_memory_state_desc
from sys.dm_os_sys_memory

-- SQL Server 엔진 Process 정보
SELECT
	physical_memory_in_use_kb / 1024		AS physical_memory_in_use_MB		--작업관리자에서 보이는 메모리
	, large_page_allocations_kb / 1024		AS large_page_allocations_MB
	, locked_page_allocations_kb / 1024		AS locked_page_allocations_MB
	, total_virtual_address_space_kb, virtual_address_space_reserved_kb, virtual_address_space_committed_kb, virtual_address_space_available_kb, page_fault_count, memory_utilization_percentage, available_commit_limit_kb, process_physical_memory_low, process_virtual_memory_low
FROM sys.dm_os_process_memory