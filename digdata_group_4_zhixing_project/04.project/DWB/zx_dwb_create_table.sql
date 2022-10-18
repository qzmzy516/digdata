create database if not exists zx_dwb;

drop table if exists zx_dwb.dwb_user_ask_wide_table;
create table if not exists zx_dwb.dwb_user_ask_wide_table
(
    id                           int,
    create_date_time             string COMMENT '数据创建时间',
    session_id                   string COMMENT '七陌sessionId',
    sid                          string COMMENT '访客id',
    create_time                  string COMMENT '会话创建时间',
    year_code                         string COMMENT '年',
    quarter_code                     string COMMENT '季度',
    month_code                        string COMMENT '月',
    day_code                          string COMMENT '天',
    hour_code                         string COMMENT '小时',
    seo_source                   string COMMENT '搜索来源',
    seo_keywords                 string COMMENT '关键字',
    ip                           string COMMENT 'IP地址',
    area                         string COMMENT '地域',
    country                      string COMMENT '所在国家',
    province                     string COMMENT '省',
    city                         string COMMENT '城市',
    origin_channel               string COMMENT '投放渠道',
    `user`                       string,
    manual_time                  string COMMENT '人工开始时间',
    begin_time                   string COMMENT '坐席领取时间 ',
    end_time                     string COMMENT '会话结束时间',
    last_customer_msg_time_stamp string COMMENT '客户最后一条消息的时间',
    last_agent_msg_time_stamp    string COMMENT '坐席最后一下回复的时间',
    reply_msg_count              string COMMENT '客服回复消息数',
    msg_count                    string COMMENT '客户发送消息数',
    browser_name                 string COMMENT '浏览器名称',
    os_info                      string COMMENT '系统名称',
    referrer                     string COMMENT '上级来源页面',
    from_url                     string COMMENT '会话来源页面',
    landing_page_url             string COMMENT '访客着陆页面',
    url_title                    string COMMENT '咨询页面title',
    platform_description         string COMMENT '客户平台信息',
    other_params                 string COMMENT '扩展字段中数据',
    history                      string COMMENT '历史访问记录'
) comment '用户咨询主题宽表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress' = 'snappy');