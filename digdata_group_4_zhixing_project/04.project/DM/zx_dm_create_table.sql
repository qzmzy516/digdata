
drop table if exists zx_dm.dm_user_ask;

create table if not exists zx_dm.dm_user_ask
(
group_type                   string   comment '分组类型',
year_code                         string   COMMENT '年',
quarter_code                      string   COMMENT '季度',
month_code                        string   COMMENT '月份',
day_code                          string   COMMENT '天',
hour_code                         string   COMMENT '小时',
time_type                    string   comment '时间分组类型',
province                     string   COMMENT '省',
origin_channel               string   COMMENT '来源渠道',
seo_source                   string   COMMENT '搜索来源',
from_url             		 string   COMMENT '来源页面',
user_cnt                     bigint      COMMENT '总访问用户量',
IP_cnt                       bigint      COMMENT '总访问IP个数',
session_cnt                  bigint      COMMENT '总访问session个数',
msg_user_cnt                 bigint      COMMENT '总咨询人数'
)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');