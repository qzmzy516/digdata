insert into  hive.dm.dm_intention_wide_table
select

'2022-10-15'as date_time,
  case
      when grouping(day_code ) = 0
      then 'day'
      when grouping(month_code) = 0
      then 'month'
      when grouping(year_code) = 0
      then 'year'
      end as time_type,
    year_code, -- 年
    day_code, -- 天
    month_code,-- 月
       CASE
         WHEN grouping(customer_area)=0
         THEN '地区'
         WHEN grouping(subject_name)=0
         THEN '学科'
         WHEN grouping(school_name)=0
         THEN '校区'
         WHEN grouping(origin_channel )=0
         THEN '来源渠道 '
         WHEN grouping( department_name)=0
         THEN '咨询中心'
         when grouping (clue_state) = 0
         then '新老学员'
         when grouping ( origin_type) = 0
         then '线上线下'
         ELSE 'all'
         END as group_type,
    origin_type, --线上线下
    customer_area as city_name,-- 地区
    clue_state, -- 新老学员
    subject_name,-- 学科名称
    school_name, -- 校区名称
    origin_channel as channel_type, -- 来源渠道
    department_name as consult_name, -- 各咨询中心
    count(distinct id) as count_user


from dwb.original_wide_table
group by
grouping sets ( (year_code, month_code, day_code, origin_type, clue_state),-- 天
                (year_code, month_code, day_code, origin_type, clue_state, customer_area),
                (year_code, month_code, day_code, origin_type, clue_state, subject_name),
                (year_code, month_code, day_code, origin_type, clue_state, school_name),
                (year_code, month_code, day_code, origin_type, clue_state, origin_channel),
                (year_code, month_code, day_code, origin_type, clue_state, department_name),
                (year_code, month_code, origin_type, clue_state),-- 月
                (year_code, month_code, origin_type, clue_state, customer_area),
                (year_code, month_code, origin_type, clue_state, subject_name),
                (year_code, month_code, origin_type, clue_state, school_name),
                (year_code, month_code, origin_type, clue_state, origin_channel),
                (year_code, month_code, origin_type, clue_state, department_name),
                (year_code, origin_type, clue_state),-- 年
                (year_code, origin_type, clue_state, customer_area),
                (year_code, origin_type, clue_state, subject_name),
                (year_code, origin_type, clue_state, school_name),
                (year_code, origin_type, clue_state, origin_channel),
                (year_code, origin_type, clue_state, department_name)
 );
