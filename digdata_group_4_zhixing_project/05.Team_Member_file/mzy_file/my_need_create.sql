with mon as (select
        class_id,
        class_date,
        count(distinct student_id) as morning_leave
from     (select
         *,
         row_number() over(partition by class_id) as rn
    FROM zx_dwb.dwb_leave_wide_table
-- 上课模式为非线上，审核通过，有效
    where (begin_time >= concat(class_date, ' ', morning_begin_time) AND
            begin_time <= concat(class_date, ' ', morning_end_time))
        OR (begin_time <= concat(class_date, ' ', morning_begin_time) and
            end_time >= concat(class_date, ' ', morning_end_time))
        OR (end_time >= concat(class_date, ' ', morning_begin_time) and
            end_time <= concat(class_date, ' ', morning_end_time)))
where rn = 1 and audit_state='1' and cancel_state=0
and class_mode is not null and class_mode != 2 and valid_state = '1'
group by class_id,class_date),

eve AS(select
        class_id,
        class_date,
        count(distinct student_id) as evening_leave
from (select
                -- 把字段找出来
                *,
         row_number() over(partition by class_id) as rn
FROM zx_dwb.dwb_leave_wide_table
-- 上课模式为非线上，审核通过，有效
where(begin_time > concat(class_date,' ',evening_begin_time) AND begin_time < concat(class_date,' ',evening_end_time)) OR
        (begin_time < concat(class_date,' ',evening_begin_time) and end_time > concat(class_date,' ',evening_end_time)) OR
        (end_time > concat(class_date,' ',evening_begin_time) and end_time < concat(class_date,' ',evening_end_time))
        ) as evening_leave
where rn = 1 and audit_state='1' and cancel_state=0 and class_mode is not null and class_mode != 1 and valid_state = '1'
group by class_id,class_date),

aft AS (select
        class_id,
        class_date,
        count(distinct student_id) as afternoon_leave
from     (select
         -- 把字段找出来
         *,
         row_number() over(partition by class_id) as rn
FROM zx_dwb.dwb_leave_wide_table
-- 上课模式为非线上，审核通过，有效
where (begin_time > concat(class_date,' ',afternoon_begin_time) AND begin_time < concat(class_date,' ',afternoon_end_time)) OR
        (begin_time < concat(class_date,' ',afternoon_begin_time) and end_time > concat(class_date,' ',afternoon_end_time)) OR
        (end_time > concat(class_date,' ',afternoon_begin_time) and end_time < concat(class_date,' ',afternoon_end_time))
        ) as afternoon_leave
where rn = 1 and audit_state='1' and cancel_state=0 and class_mode is not null and class_mode in (0,2)and valid_state = '1'
group by class_id,class_date),

temp as(
select
coalesce (mon.class_id,eve.class_id,aft.class_id) as class_id,
coalesce (mon.class_date,eve.class_date,aft.class_date) as class_date,
coalesce (mon.morning_leave,0) as morning_leave_count,
coalesce (eve.evening_leave,0) as evening_leave_count,
coalesce (aft.afternoon_leave,0) as afternoon_leave
from mon full join eve
        on mon.class_id=eve.class_id and mon.class_date=eve.class_date
        full join aft  on mon.class_id=aft.class_id and mon.class_date=aft.class_date),

number_count as (
select
class_id,
class_date,
sum(morning_leave_count) as morning_leave_count,
sum(evening_leave_count) as evening_leave_count,
sum(afternoon_leave) as afternoon_leave
from temp
group by class_id, class_date)

select
*
from number_count