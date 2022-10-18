insert into hive.zx_dm.dm_signup
select
        '2022-10-16' as date_time,
        "year",
        year_month,
        year_month_day,
        case when grouping(year) = 0
                  then 'year'
             when grouping(year_month) = 0
                  then 'month'
             when grouping(year_month_day ) = 0
                  then 'day'
             else null
        end
        as time_type,
        itcast_school_id,
        school_name,
        origin_type,
        itcast_subject_id,
        subject_name,
        origin_channel,
        department_name,
        case when grouping(school_name) = 0
             then '校区'
             when grouping(subject_name) = 0
             then '学科'
             when grouping(school_name,subject_name) = 0
             then '各个校区各个学科'
             when grouping(origin_channel) = 0
             then '来源渠道'
             when grouping(department_name) = 0
             then '咨询中心'
             else null
             end
        as group_type,
        sum(if(payment_state='已支付',1,0)) as signup_count,
        count(distinct id) as relationship_count,
        sum(if(appeal_status='1',1,0)) as valid_club_count
from zx_dwb.dwb_relationship_wide
group by
grouping sets(
-- 年
--     校区
    (year,itcast_school_id,school_name),
    (year,origin_type,itcast_school_id,school_name),
--     学科
    (year,origin_type,itcast_subject_id,subject_name),
--     校区学科
    (year,origin_type,itcast_school_id,school_name,itcast_subject_id,subject_name),
--   来源渠道
    (year,origin_type,origin_channel),
-- 咨询中心
    (year,origin_type,department_name),
-- 月
 --     校区
    (year_month,itcast_school_id,school_name),
    (year_month,origin_type,itcast_school_id,school_name),
--     学科
    (year_month,origin_type,itcast_subject_id,subject_name),
--     校区学科
    (year_month,origin_type,itcast_school_id,school_name,itcast_subject_id,subject_name),
--   来源渠道
    (year_month,origin_type,origin_channel),
-- 咨询中心
    (year_month,origin_type,department_name),
-- 日
--     校区
    (year_month_day,itcast_school_id,school_name),
    (year_month_day,origin_type,itcast_school_id,school_name),
--     学科
    (year_month_day,origin_type,itcast_subject_id,subject_name),
--     校区学科
    (year_month_day,origin_type,itcast_school_id,school_name,itcast_subject_id,subject_name),
--   来源渠道
    (year_month_day,origin_type,origin_channel),
-- 咨询中心
    (year_month_day,origin_type,department_name));
