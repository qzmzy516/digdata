insert into zx_dm.dm_user_ask

-- 创建临时表截取20000条数据
with tmp as (
select * from hive.zx_dwb.dwb_user_ask_wide_table
limit 20000)

select
-- 分组类型
case when grouping (area)=0 then 'area'
     when grouping (origin_channel)=0 then 'origin_channel'
     when grouping (seo_source)=0 then 'seo_source'
     when grouping (from_url)=0 then 'from_url'
     else 'all' end as group_type,

case when grouping (year_code)=0 then year_code
else null end as year_code,  -- 年
case when grouping (quarter_code)=0 then quarter_code
else null end as quarter_code,  -- 季度
case when grouping (month_code)=0 then month_code
else null end as month_code,  -- 月
case when grouping (day_code)=0 then day_code
else null end as day_code,  -- 天
case when grouping (hour_code)=0 then hour_code
else null end as hour_code,  -- 小时

-- 分组时间类型
case
     when grouping (hour_code)=0 then 'hour'
     when grouping (day_code)=0  then 'day'
     when grouping (month_code)=0  then 'month'
     when grouping (quarter_code)=0  then 'quarter'
     when grouping (year_code)=0  then 'year'
else 'other' end as time_type,

case when grouping (area)=0 then area
else null end as area,  -- 地区
case when grouping (origin_channel)=0 then origin_channel
else null  end as origin_channel,  --来源渠道
case when grouping (seo_source)=0 then seo_source
else null end as seo_source,  -- 搜索来源
case when grouping (from_url)=0 then from_url
else null end as from_url,  -- 来源页面

count(distinct(coalesce(sid, null))) as user_cnt, -- 总访问用户数
count(distinct(coalesce(IP, null))) as ip_cnt, -- 总访问IP数
count(distinct(coalesce(session_id, null))) as session_cnt, -- 总访问Session数
count(msg_count) as msg_user_cnt -- 总咨询人数
from tmp

group by

grouping sets (
-- 年
    (year_code),
    (year_code, area),
    (year_code, origin_channel),
    (year_code, seo_source),
    (year_code, from_url),

-- 季度

    (year_code, quarter_code),
    (year_code, quarter_code, area),
    (year_code, quarter_code, origin_channel),
    (year_code, quarter_code, seo_source),
    (year_code, quarter_code, from_url),

-- 月
    (year_code, month_code),
    (year_code, month_code, area),
    (year_code, month_code, origin_channel),
    (year_code, month_code, seo_source),
    (year_code, month_code, from_url),

-- 天
    (day_code),
    (day_code, area),
    (day_code, origin_channel),
    (day_code, seo_source),
    (day_code, from_url),

-- 小时
    (day_code, hour_code),
    (day_code, hour_code, area),
    (day_code, hour_code, origin_channel),
    (day_code, hour_code, seo_source),
    (day_code, hour_code, from_url)
    );