use test;

# no.1
with tmp as
         (select e.id,
                 e.name,
                 salary,
                 departmentId,
                 d.id                                              as departid,
                 d.name                                            as departname,
                 rank() over (partition by d.name order by salary) as ranking
          from employee e
                   join Department d on e.departmentId = d.id)
select departname,
       name,
       salary
from tmp
where ranking <= 3;

-- no.2
select request_at                                                 as DAY,
       round(sum(if(status != 'completed', 1, 0)) / count(id), 2) as 'Cancellation Rate'
from trips t
         join users u1 on t.client_id = u1.users_id and u1.banned = 'no'
         join users u2 on t.driver_id = u2.users_id and u2.banned = 'no'
group by request_at;

-- no.3
select *
from (select *,
             ntile(3) over (partition by company order by salary) as rn
      from emp) as tmp
where rn = 2;

-- no.4

