-- �ý�������(CPU, Memory)
SELECT cpu_count AS LogiclaCPUCount, hyperthread_ratio AS HyperthreadRatio, cpu_count / hyperthread_ratio AS PhysicalCPUCount
	, affinity_type, affinity_type_desc, virtual_machine_type, virtual_machine_type_desc
	, physical_memory_kb / 1024 physical_memory_MB, sql_memory_model, sql_memory_model_desc
FROM sys.dm_os_sys_INFO

-- Memory ����
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

-- SQL Server ���� Process ����
SELECT
	physical_memory_in_use_kb / 1024		AS physical_memory_in_use_MB	-- SQL Server���� �����ϰ� �ִ� �޸�
	, large_page_allocations_kb / 1024		AS large_page_allocations_MB
	, locked_page_allocations_kb / 1024		AS locked_page_allocations_MB
	, total_virtual_address_space_kb, virtual_address_space_reserved_kb, virtual_address_space_committed_kb, virtual_address_space_available_kb, page_fault_count, memory_utilization_percentage, available_commit_limit_kb, process_physical_memory_low, process_virtual_memory_low
FROM sys.dm_os_process_memory



-- �����ͺ��̽��� Buffer Pool ����
select db_name(database_id) as DB
	, Convert(decimal(20,0), count(row_count) * 8.00 / 1024.00) AS MB
	, Convert(decimal(10,2), count(row_count) * 8.00 / 1024.00 / 1024.00) AS GB
from sys.dm_os_buffer_descriptors
group by database_id
order by db_name(database_id)

--select cntr_value / 1024 / 1024.00
--from sys.dm_os_performance_counters
--where counter_name in ('Total Server Memory (KB)', 'Target Server Memory (KB)');