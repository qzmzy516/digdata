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

insert into table zx_dwb.dwb_user_ask_wide_table partition (dt)
select
fwce.id,
create_date_time,
session_id,
sid,
create_time,
year_code,
quarter_code,
month_code,
day_code,
hour_code,
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
referrer,
from_url,
landing_page_url,
url_title,
platform_description,
other_params,
history,
fwce.dt
from zx_dwd.fact_web_chat_ems_2019_07 fwce
left join zx_dwd.fact_web_chat_text_ems_2019_07 fwcte
on fwce.id = fwcte.id;