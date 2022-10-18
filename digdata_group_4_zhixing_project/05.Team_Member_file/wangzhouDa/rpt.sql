select

 time_type,itcast_school_id,school_name,signup_count
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day' ;


select

 time_type,origin_type,itcast_school_id,school_name,signup_count
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day' ;


select

 time_type,origin_type,itcast_subject_id,subject_name,signup_count
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day';


select

 time_type,origin_type,itcast_school_id,school_name,itcast_subject_id,subject_name,signup_count
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day';


select

 time_type,origin_type,origin_channel,signup_count
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day';


select

 time_type,origin_type,department_name,signup_count
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day';


select
        time_type,
        origin_type,
        cast(signup_count*1.00 as decimal(10,5))/cast(relationship_count*1.00 as decimal(10,5))  as Application_rate
from zx_dm.dm_signup
where time_type = 'year' or time_type='month' or time_type = 'day';


select
        time_type,
       origin_type,
        cast(signup_count*1.00 as decimal(10,5))/cast(valid_club_count*1.00 as decimal(10,5)) as generated
from zx_dm.dm_signup;


















