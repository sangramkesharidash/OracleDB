Set lines 400
col LIMIT_VALUE for a10
sho parameter process

select inst_id, status , count(*) from gv$session group by inst_id, status;

select 
  INST_ID,resource_name, 
  current_utilization, 
  max_utilization, 
  limit_value, TRUNC(current_utilization/limit_value*100) "Used %"
from 
  gv$resource_limit
where 
  resource_name in ( 'sessions', 'processes');