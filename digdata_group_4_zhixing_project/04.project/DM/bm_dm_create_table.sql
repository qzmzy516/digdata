-- dm
drop table if exists zx_dm.dm_signup;
create table zx_dm.dm_signup (
    date_time                   string comment '统计日期',
    year                        string comment '年',
    year_month                  string comment '年月',
    year_month_day              string comment '年月日',
    time_type                   string COMMENT '统计时间维度：year、year_month、month、year_month_day、day',
    itcast_school_id                   int comment '校区Id',
    school_name                 string comment '校区名称',
    origin_type                 string comment '上课方式:线上线下',
    itcast_subject_id                  int comment '学科Id',
    subject_name                string comment '学科名称',
    origin_channel              string comment '来源渠道',
    department_name             string comment '咨询中心名称',
    group_type                  string comment '分组类型：校区，学科，来源渠道，咨询中心，上课方式',
    signup_count                bigint comment '报名人数',
    relationship_count          bigint comment '意向人数',
    valid_club_count            bigint comment '有效线索数量'
)  comment '报名主题宽表'
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');