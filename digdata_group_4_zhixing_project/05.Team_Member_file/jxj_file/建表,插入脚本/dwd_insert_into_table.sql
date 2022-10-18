SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


insert into table zx_dwd.fact_web_chat_ems_2019_07 partition (dt)
select
       id,
       create_date_time,
       session_id,
       sid,
       create_time,
       year(create_time) as year_code,
       quarter(create_time) as quarter_code,
       month(create_time) as month_code,
       substring(create_time, 1, 10) as day_code,
       hour(create_time) as hour_code,
       seo_source,
       seo_keywords,
       ip,
       area,
       country,
       province,
       city,
       origin_channel,
       `user`,
       manual_time,
       begin_time,
       end_time,
       last_customer_msg_time_stamp,
       last_agent_msg_time_stamp,
       reply_msg_count,
       msg_count,
       browser_name,
       os_info,
       dt
from zx_ods.t_web_chat_ems_2019_07;



insert into table zx_dwd.fact_web_chat_text_ems_2019_07 partition (dt)
select
       id,
       referrer,
       from_url,
       landing_page_url,
       url_title,
       platform_description,
       other_params,
       history,
       dt
from zx_ods.t_web_chat_text_ems_2019_07;
