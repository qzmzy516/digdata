drop table dm.dm_intention_wide_table;
create table dm.dm_intention_wide_table(
    date_time string COMMENT '统计日期,用来标记你哪天干活的',
    time_type string COMMENT '统计时间维度',
    year_code string COMMENT '年',
    day_code   string COMMENT   '天',
    month_code string COMMENT '月份',

    group_type   string COMMENT '维度标记字段',
    origin_type   string comment  '线上线下',

    city_name     string comment    '地区名称',
    clue_state  string comment     '新老学员',
    subject_name  string comment   '学科',
    school_name string comment  '校区',
    channel_type   string comment  '来源渠道',
    consult_name    string comment '咨询中心',
    `count_user`    bigint  comment '用户个数'
)comment '最终宽表'

row format delimited fields terminated by '\t' stored as orc tblproperties ('orc.compress'='snappy');