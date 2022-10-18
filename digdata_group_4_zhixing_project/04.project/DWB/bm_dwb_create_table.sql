-- 意向客户宽表
drop table if exists zx_dwb.dwb_relationship_wide ;
create table zx_dwb.dwb_relationship_wide
   ( id                          int   comment '意向id',
    create_date_time            string comment '创建时间',
    update_date_time            string comment '最后更新时间',
    year                        string comment '年',
    month                       string comment '月',
    day                         string comment '日',
    year_month                  string comment '年月',
    year_month_day              string comment '年月日',
    deleted                     string comment '是否被删除（禁用）',
    origin_type                 string comment '学习方式：线上线下',
    --校区
    itcast_school_id            int comment '校区Id',
    school_name                 string comment '学校',
    --学科
    itcast_subject_id           int comment '学科Id',
    subject_name                string comment '学科',
    anticipat_signup_date       date comment '预计报名时间',
    level                       string comment '客户级别',
    --线上线下
--     online_study                string comment '线上',
--     offline_study               string comment '线下',
    --咨询
    creator                     int comment '创建人',
    current_creator             int comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                string comment '创建者姓名',
    department_name             string comment '咨询中心',
    origin_channel              string comment '来源渠道',
    comment                     string,
    first_customer_clue_id      int comment '第一条线索id',
    last_customer_clue_id       int comment '最后一条线索id',
    --报名
    payment_state               string comment '支付状态',
    payment_time                string comment '支付状态变动时间',
    itcast_clazz_id             int comment '所属ems班级id',
    itcast_clazz_time           string comment '报班时间',
    --有效线索人数
    appeal_status               string comment '申诉状态',
    appeal_id                      string comment '申诉id',
    customer_relationship_first_id string comment '第一条客户关系id'


   )
comment '（意向，有效，报名 ）降维宽表'
partitioned by (dt string)
row format delimited fields terminated by '\t'
 stored as orc tblproperties ('orc.compress'='SNAPPY');

