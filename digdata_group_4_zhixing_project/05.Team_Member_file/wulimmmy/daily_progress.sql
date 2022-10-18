create database if not exists zx_ods;
create database if not exists zx_dwd;
create database if not exists zx_dwb;
create database if not exists zx_dm;

drop table if exists zx_ods.t_customer_relationship;
CREATE TABLE zx_ods.t_customer_relationship
(
    id                          INT                                     COMMENT '意向id',
    create_date_time            STRING                                  COMMENT '创建时间',
    update_date_time            STRING                                  COMMENT '最后更新时间',
    deleted                     STRING                                  COMMENT '是否被删除（禁用）',
    customer_id                 INT                                     COMMENT '所属客户id',
    first_id                    INT                                     COMMENT '第一条客户关系id',
    belonger                    INT                                     COMMENT '归属人',
    belonger_name               STRING                                  COMMENT '归属人姓名',
    initial_belonger            INT                                     COMMENT '初始归属人',
    distribution_handler        INT                                     COMMENT '分配处理人',
    business_scrm_department_id INT                                     COMMENT '归属部门',
    last_visit_time             STRING                                  COMMENT '最后回访时间',
    next_visit_time             STRING                                  COMMENT '下次回访时间',
    origin_type                 STRING                                  COMMENT '数据来源',
    itcast_school_id            INT                                     COMMENT '校区Id',
    itcast_subject_id           INT                                     COMMENT '学科Id',
    intention_study_type        STRING                                  COMMENT '意向学习方式',
    anticipat_signup_date       STRING                                  COMMENT '预计报名时间',
    level                       STRING                                  COMMENT '客户级别',
    creator                     INT                                     COMMENT '创建人',
    current_creator             INT                                     COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                STRING                                  COMMENT '创建者姓名',
    origin_channel              STRING                                  COMMENT '来源渠道',
    COMMENT                     STRING                                  ,
    first_customer_clue_id      INT                                     COMMENT '第一条线索id',
    last_customer_clue_id       INT                                     COMMENT '最后一条线索id',
    process_state               STRING                                  COMMENT '处理状态',
    process_time                STRING                                  COMMENT '处理状态变动时间',
    payment_state               STRING                                  COMMENT '支付状态',
    payment_time                STRING                                  COMMENT '支付状态变动时间',
    signup_state                STRING                                  COMMENT '报名状态',
    signup_time                 STRING                                  COMMENT '报名时间',
    notice_state                STRING                                  COMMENT '通知状态',
    notice_time                 STRING                                  COMMENT '通知状态变动时间',
    lock_state                  STRING                                  COMMENT '锁定状态',
    lock_time                   STRING                                  COMMENT '锁定状态修改时间',
    itcast_clazz_id             INT                                     COMMENT '所属ems班级id',
    itcast_clazz_time           STRING                                  COMMENT '报班时间',
    payment_url                 STRING                                  COMMENT '付款链接',
    payment_url_time            STRING                                  COMMENT '支付链接生成时间',
    ems_student_id              INT                                     COMMENT 'ems的学生id',
    delete_reason               STRING                                  COMMENT '删除原因',
    deleter                     INT                                     COMMENT '删除人',
    deleter_name                STRING                                  COMMENT '删除人姓名',
    delete_time                 STRING                                  COMMENT '删除时间',
    course_id                   INT                                     COMMENT '课程ID',
    course_name                 STRING                                  COMMENT '课程名称',
    delete_comment              STRING                                  COMMENT '删除原因说明',
    close_state                 STRING                                  COMMENT '关闭装填',
    close_time                  STRING                                  COMMENT '关闭状态变动时间',
    appeal_id                   INT                                     COMMENT '申诉id',
    tenant                      INT                                     COMMENT '租户',
    total_fee                   STRING                                  COMMENT '报名费总金额',
    belonged                    INT                                     COMMENT '小周期归属人',
    belonged_time               STRING                                  COMMENT '归属时间',
    belonger_time               STRING                                  COMMENT '归属时间',
    transfer                    INT                                     COMMENT '转移人',
    transfer_time               STRING                                  COMMENT '转移时间',
    follow_type                 INT                                     COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account     STRING                                  COMMENT '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  STRING                                  COMMENT '转移到博学谷归属人OA姓名'
) COMMENT '客户意向表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='ZLIB');


drop table if exists zx_ods.t_itcast_clazz;
CREATE TABLE zx_ods.t_itcast_clazz
(
    id                  INT                                    COMMENT '班级ID',
    create_date_time    STRING                                 COMMENT '创建时间',
    update_date_time    STRING                                 COMMENT '最后更新时间',
    deleted             STRING                                 COMMENT '是否被删除（禁用）',
    itcast_school_id    STRING                                 COMMENT 'ems校区ID',
    itcast_school_name  STRING                                 COMMENT 'ems校区名称',
    itcast_subject_id   STRING                                 COMMENT 'ems学科ID',
    itcast_subject_name STRING                                 COMMENT 'ems学科名称',
    itcast_brand        STRING                                 COMMENT 'ems品牌',
    clazz_type_state    STRING                                 COMMENT '班级类型状态',
    clazz_type_name     STRING                                 COMMENT '班级类型名称',
    teaching_mode       STRING                                 COMMENT '授课模式',
    start_time          STRING                                 COMMENT '开班时间',
    end_time            STRING                                 COMMENT '毕业时间',
    comment             STRING                                 COMMENT '备注',
    detail              STRING                                 COMMENT '详情(比如：27期)',
    uncertain           STRING                                 COMMENT '待定班(0:否,1:是)',
    tenant              INT
) COMMENT '班级信息表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='ZLIB');

drop table if exists zx_ods.t_employee;
CREATE TABLE zx_ods.t_employee
(
    id                  INT                                   COMMENT '员工id',
    email               STRING                                COMMENT '公司邮箱，OA登录账号',
    real_name           STRING                                COMMENT '员工的真实姓名',
    phone               STRING                                COMMENT '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id       STRING                                COMMENT 'OA中的部门编号，有负值',
    department_name     STRING                                COMMENT 'OA中的部门名',
    remote_login        STRING                                COMMENT '员工是否可以远程登录',
    job_number          STRING                                COMMENT '员工工号',
    cross_school        STRING                                COMMENT '是否有跨校区权限',
    last_login_date     STRING                                COMMENT '最后登录日期',
    creator             INT                                   COMMENT '创建人',
    create_date_time    STRING                                COMMENT '创建时间',
    update_date_time    STRING                                COMMENT '最后更新时间',
    deleted             STRING                                COMMENT '是否被删除（禁用）',
    scrm_department_id  INT                                   COMMENT 'SCRM内部部门id',
    leave_office        STRING                                COMMENT '离职状态',
    leave_office_time   STRING                                COMMENT '离职时间',
    reinstated_time     STRING                                COMMENT '复职时间',
    superior_leaders_id INT                                   COMMENT '上级领导ID',
    tdepart_id          INT                                   COMMENT '直属部门',
    tenant              INT                                   ,
    ems_user_name       STRING
) COMMENT '员工信息表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='ZLIB');


drop table if exists zx_ods.t_scrm_department;
CREATE TABLE zx_ods.t_scrm_department
(
    id               INT                                   COMMENT '部门id',
    name             STRING                                COMMENT '部门名称',
    parent_id        INT                                   COMMENT '父部门id',
    create_date_time STRING                                COMMENT '创建时间',
    update_date_time STRING                                COMMENT '更新时间',
    deleted          STRING                                COMMENT '删除标志',
    id_path          STRING                                COMMENT '编码全路径',
    tdepart_code     INT                                   COMMENT '直属部门',
    creator          STRING                                COMMENT '创建者',
    depart_level     INT                                   COMMENT '部门层级',
    depart_sign      INT                                   COMMENT '部门标志，暂时默认1',
    depart_line      INT                                   COMMENT '业务线，存储业务线编码',
    depart_sort      INT                                   COMMENT '排序字段',
    disable_flag     INT                                   COMMENT '禁用标志',
    tenant           INT
) COMMENT '部门信息表'
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='ZLIB');



drop table if exists zx_ods.t_customer_appeal;
CREATE TABLE zx_ods.t_customer_appeal
(
    id                             INT                                 COMMENT '主键',
    customer_relationship_first_id INT                                 COMMENT '第一条客户关系id',
    employee_id                    INT                                 COMMENT '申诉人',
    employee_name                  STRING                              COMMENT '申诉人姓名',
    employee_department_id         INT                                 COMMENT '申诉人部门',
    employee_tdepart_id            INT                                 COMMENT '申诉人所属部门',
    appeal_status                  INT                                 COMMENT '申诉状态，0:待稽核 1:无效 2：有效',
    audit_id                       INT                                 COMMENT '稽核人id',
    audit_name                     STRING                              COMMENT '稽核人姓名',
    audit_department_id            INT                                 COMMENT '稽核人所在部门',
    audit_department_name          STRING                              COMMENT '稽核人部门名称',
    audit_date_time                STRING                              COMMENT '稽核时间',
    create_date_time               STRING                              COMMENT '创建时间（申诉时间）',
    update_date_time               STRING                              COMMENT '更新时间',
    deleted                        STRING                              COMMENT '删除标志位',
    tenant                         INT
) COMMENT '线索申诉信息表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='ZLIB');



drop table if exists zx_ods.t_customer_clue;
CREATE TABLE zx_ods.t_customer_clue
(
    id                       INT                                     COMMENT '线索id',
    create_date_time         STRING                                  COMMENT '创建时间',
    update_date_time         STRING                                  COMMENT '最后更新时间',
    deleted                  STRING                                  COMMENT '是否被删除（禁用）',
    customer_id              INT                                     COMMENT '客户id',
    customer_relationship_id INT                                     COMMENT '客户关系id',
    session_id               STRING                                  COMMENT '七陌会话id',
    sid                      STRING                                  COMMENT '访客id',
    status                   STRING                                  COMMENT '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
    `user`                   STRING                                  COMMENT '所属坐席',
    create_time              STRING                                  COMMENT '七陌创建时间',
    platform                 STRING                                  COMMENT '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
    s_name                   STRING                                  COMMENT '用户名称',
    seo_source               STRING                                  COMMENT '搜索来源',
    seo_keywords             STRING                                  COMMENT '关键字',
    ip                       STRING                                  COMMENT 'IP地址',
    referrer                 STRING                                  COMMENT '上级来源页面',
    from_url                 STRING                                  COMMENT '会话来源页面',
    landing_page_url         STRING                                  COMMENT '访客着陆页面',
    url_title                STRING                                  COMMENT '咨询页面title',
    to_peer                  STRING                                  COMMENT '所属技能组',
    manual_time              STRING                                  COMMENT '人工开始时间',
    begin_time               STRING                                  COMMENT '坐席领取时间 ',
    reply_msg_count          INT                                     COMMENT '客服回复消息数',
    total_msg_count          INT                                     COMMENT '消息总数',
    msg_count                INT                                     COMMENT '客户发送消息数',
    comment                  STRING                                  COMMENT '备注',
    finish_reason            STRING                                  COMMENT '结束类型',
    finish_user              STRING                                  COMMENT '结束坐席',
    end_time                 STRING                                  COMMENT '会话结束时间',
    platform_description     STRING                                  COMMENT '客户平台信息',
    browser_name             STRING                                  COMMENT '浏览器名称',
    os_info                  STRING                                  COMMENT '系统名称',
    area                     STRING                                  COMMENT '区域',
    country                  STRING                                  COMMENT '所在国家',
    province                 STRING                                  COMMENT '省',
    city                     STRING                                  COMMENT '城市',
    creator                  INT                                     COMMENT '创建人',
    name                     STRING                                  COMMENT '客户姓名',
    idcard                   STRING                                  COMMENT '身份证号',
    phone                    STRING                                  COMMENT '手机号',
    itcast_school_id         INT                                     COMMENT '校区Id',
    itcast_school            STRING                                  COMMENT '校区',
    itcast_subject_id        INT                                     COMMENT '学科Id',
    itcast_subject           STRING                                  COMMENT '学科',
    wechat                   STRING                                  COMMENT '微信',
    qq                       STRING                                  COMMENT 'qq号',
    email                    STRING                                  COMMENT '邮箱',
    gender                   STRING                                  COMMENT '性别',
    level                    STRING                                  COMMENT '客户级别',
    origin_type              STRING                                  COMMENT '数据来源渠道',
    information_way          STRING                                  COMMENT '资讯方式',
    working_years            STRING                                  COMMENT '开始工作时间',
    technical_directions     STRING                                  COMMENT '技术方向',
    customer_state           STRING                                  COMMENT '当前客户状态',
    valid                    STRING                                  COMMENT '该线索是否是网资有效线索',
    anticipat_signup_date    STRING                                  COMMENT '预计报名时间',
    clue_state               STRING                                  COMMENT '线索状态',
    scrm_department_id       INT                                     COMMENT 'SCRM内部部门id',
    superior_url             STRING                                  COMMENT '诸葛获取上级页面URL',
    superior_source          STRING                                  COMMENT '诸葛获取上级页面URL标题',
    landing_url              STRING                                  COMMENT '诸葛获取着陆页面URL',
    landing_source           STRING                                  COMMENT '诸葛获取着陆页面URL来源',
    info_url                 STRING                                  COMMENT '诸葛获取留咨页URL',
    info_source              STRING                                  COMMENT '诸葛获取留咨页URL标题',
    origin_channel           STRING                                  COMMENT '投放渠道',
    course_id                INT                                     ,
    course_name              STRING                                  ,
    zhuge_session_id         STRING                                  ,
    is_repeat                INT                                     COMMENT '是否重复线索(手机号维度) 0:正常 1：重复',
    tenant                   INT                                     COMMENT '租户id',
    activity_id              STRING                                  COMMENT '活动id',
    activity_name            STRING                                  COMMENT '活动名称',
    follow_type              INT                                     COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    shunt_mode_id            INT                                     COMMENT '匹配到的技能组id',
    shunt_employee_group_id  INT                                     COMMENT '所属分流员工组'
) COMMENT '客户线索表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='ZLIB');



--分区
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








drop table if exists zx_dwd.fact_customer_relationship;
create table zx_dwd.fact_customer_relationship
(
    id                          int comment '意向id',
    create_date_time            string comment '创建时间',
    update_date_time            string comment '最后更新时间',
    deleted                     string comment '是否被删除（禁用）',
    customer_id                 int comment '所属客户id',
    first_id                    int comment '第一条客户关系id',
    belonger                    int comment '归属人',
    belonger_name               string comment '归属人姓名',
    initial_belonger            int comment '初始归属人',
    distribution_handler        int comment '分配处理人',
    business_scrm_department_id int comment '归属部门',
    last_visit_time             string comment '最后回访时间',
    next_visit_time             string comment '下次回访时间',
    origin_type                 string comment '数据来源',
    itcast_school_id            int comment '校区Id',
    itcast_subject_id           int comment '学科Id',
    intention_study_type        string comment '意向学习方式',
    anticipat_signup_date       string comment '预计报名时间',
    level                       string comment '客户级别',
    creator                     int comment '创建人',
    current_creator             int comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                string comment '创建者姓名',
    origin_channel              string comment '来源渠道',
    comment                     string,
    first_customer_clue_id      int comment '第一条线索id',
    last_customer_clue_id       int comment '最后一条线索id',
    process_state               string comment '处理状态',
    process_time                string comment '处理状态变动时间',
    payment_state               string comment '支付状态',
    payment_time                string comment '支付状态变动时间',
    signup_state                string comment '报名状态',
    signup_time                 string comment '报名时间',
    notice_state                string comment '通知状态',
    notice_time                 string comment '通知状态变动时间',
    lock_state                  string comment '锁定状态',
    lock_time                   string comment '锁定状态修改时间',
    itcast_clazz_id             int comment '所属ems班级id',
    itcast_clazz_time           string comment '报班时间',
    payment_url                 string comment '付款链接',
    payment_url_time            string comment '支付链接生成时间',
    ems_student_id              int comment 'ems的学生id',
    delete_reason               string comment '删除原因',
    deleter                     int comment '删除人',
    deleter_name                string comment '删除人姓名',
    delete_time                 string comment '删除时间',
    course_id                   int comment '课程ID',
    course_name                 string comment '课程名称',
    delete_comment              string comment '删除原因说明',
    close_state                 string comment '关闭装填',
    close_time                  string comment '关闭状态变动时间',
    appeal_id                   int comment '申诉id',
    tenant                      int comment '租户',
    total_fee                   string comment '报名费总金额',
    belonged                    int comment '小周期归属人',
    belonged_time               string comment '归属时间',
    belonger_time               string comment '归属时间',
    transfer                    int comment '转移人',
    transfer_time               string comment '转移时间',
    follow_type                 int comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account     string comment '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  string comment '转移到博学谷归属人OA姓名',
    end_date                    string comment '拉链结束日期'
) comment '客户意向表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');





drop table if exists zx_dwd.dim_itcast_clazz;
create table zx_dwd.dim_itcast_clazz
(
    id                  INT                                    COMMENT '班级ID',
    create_date_time    STRING                                 COMMENT '创建时间',
    update_date_time    STRING                                 COMMENT '最后更新时间',
    deleted             STRING                                 COMMENT '是否被删除（禁用）',
    itcast_school_id    STRING                                 COMMENT 'ems校区ID',
    itcast_school_name  STRING                                 COMMENT 'ems校区名称',
    itcast_subject_id   STRING                                 COMMENT 'ems学科ID',
    itcast_subject_name STRING                                 COMMENT 'ems学科名称',
    itcast_brand        STRING                                 COMMENT 'ems品牌',
    clazz_type_state    STRING                                 COMMENT '班级类型状态',
    clazz_type_name     STRING                                 COMMENT '班级类型名称',
    teaching_mode       STRING                                 COMMENT '授课模式',
    start_time          STRING                                 COMMENT '开班时间',
    end_time            STRING                                 COMMENT '毕业时间',
    comment             STRING                                 COMMENT '备注',
    detail              STRING                                 COMMENT '详情(比如：27期)',
    uncertain           STRING                                 COMMENT '待定班(0:否,1:是)',
    tenant              INT                                    ,
    end_date            STRING                                 COMMENT '拉链结束日期'
) COMMENT '班级信息表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');




drop table if exists zx_dwd.dim_employee;
CREATE TABLE zx_dwd.dim_employee
(
    id                  INT                                   COMMENT '员工id',
    email               STRING                                COMMENT '公司邮箱，OA登录账号',
    real_name           STRING                                COMMENT '员工的真实姓名',
    phone               STRING                                COMMENT '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id       STRING                                COMMENT 'OA中的部门编号，有负值',
    department_name     STRING                                COMMENT 'OA中的部门名',
    remote_login        STRING                                COMMENT '员工是否可以远程登录',
    job_number          STRING                                COMMENT '员工工号',
    cross_school        STRING                                COMMENT '是否有跨校区权限',
    last_login_date     STRING                                COMMENT '最后登录日期',
    creator             INT                                   COMMENT '创建人',
    create_date_time    STRING                                COMMENT '创建时间',
    update_date_time    STRING                                COMMENT '最后更新时间',
    deleted             STRING                                COMMENT '是否被删除（禁用）',
    scrm_department_id  INT                                   COMMENT 'SCRM内部部门id',
    leave_office        STRING                                COMMENT '离职状态',
    leave_office_time   STRING                                COMMENT '离职时间',
    reinstated_time     STRING                                COMMENT '复职时间',
    superior_leaders_id INT                                   COMMENT '上级领导ID',
    tdepart_id          INT                                   COMMENT '直属部门',
    tenant              INT                                   ,
    ems_user_name       STRING                                ,
    end_date            STRING                                COMMENT '拉链结束日期'
) COMMENT '员工信息表'
partitioned by (start_date string)
row format delimited fields terminated by '\t'
stored as orc
tblproperties ('orc.compress' = 'SNAPPY');






drop table if exists zx_dwd.dim_scrm_department;
CREATE TABLE zx_dwd.dim_scrm_department
(
    id               INT                                   COMMENT '部门id',
    name             STRING                                COMMENT '部门名称',
    parent_id        INT                                   COMMENT '父部门id',
    create_date_time STRING                                COMMENT '创建时间',
    update_date_time STRING                                COMMENT '更新时间',
    deleted          STRING                                COMMENT '删除标志',
    id_path          STRING                                COMMENT '编码全路径',
    tdepart_code     INT                                   COMMENT '直属部门',
    creator          STRING                                COMMENT '创建者',
    depart_level     INT                                   COMMENT '部门层级',
    depart_sign      INT                                   COMMENT '部门标志，暂时默认1',
    depart_line      INT                                   COMMENT '业务线，存储业务线编码',
    depart_sort      INT                                   COMMENT '排序字段',
    disable_flag     INT                                   COMMENT '禁用标志',
    tenant           INT
) COMMENT '部门信息表'
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');



drop table if exists zx_dwd.dim_customer_appeal;
CREATE TABLE zx_dwd.dim_customer_appeal
(
    id                             INT                                 COMMENT '主键',
    customer_relationship_first_id INT                                 COMMENT '第一条客户关系id',
    employee_id                    INT                                 COMMENT '申诉人',
    employee_name                  STRING                              COMMENT '申诉人姓名',
    employee_department_id         INT                                 COMMENT '申诉人部门',
    employee_tdepart_id            INT                                 COMMENT '申诉人所属部门',
    appeal_status                  INT                                 COMMENT '申诉状态，0:待稽核 1:无效 2：有效',
    audit_id                       INT                                 COMMENT '稽核人id',
    audit_name                     STRING                              COMMENT '稽核人姓名',
    audit_department_id            INT                                 COMMENT '稽核人所在部门',
    audit_department_name          STRING                              COMMENT '稽核人部门名称',
    audit_date_time                STRING                              COMMENT '稽核时间',
    create_date_time               STRING                              COMMENT '创建时间（申诉时间）',
    update_date_time               STRING                              COMMENT '更新时间',
    deleted                        STRING                              COMMENT '删除标志位',
    tenant                         INT                                 ,
    end_date                       STRING                              COMMENT '拉链结束日期'
) COMMENT '线索申诉信息表'
partitioned by (start_date string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');


drop table if exists zx_dwd.dim_customer_clue;
CREATE TABLE zx_dwd.dim_customer_clue
(
    id                       INT                                     COMMENT '线索id',
    create_date_time         STRING                                  COMMENT '创建时间',
    update_date_time         STRING                                  COMMENT '最后更新时间',
    deleted                  STRING                                  COMMENT '是否被删除（禁用）',
    customer_id              INT                                     COMMENT '客户id',
    customer_relationship_id INT                                     COMMENT '客户关系id',
    session_id               STRING                                  COMMENT '七陌会话id',
    sid                      STRING                                  COMMENT '访客id',
    status                   STRING                                  COMMENT '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
    `user`                   STRING                                  COMMENT '所属坐席',
    create_time              STRING                                  COMMENT '七陌创建时间',
    platform                 STRING                                  COMMENT '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
    s_name                   STRING                                  COMMENT '用户名称',
    seo_source               STRING                                  COMMENT '搜索来源',
    seo_keywords             STRING                                  COMMENT '关键字',
    ip                       STRING                                  COMMENT 'IP地址',
    referrer                 STRING                                  COMMENT '上级来源页面',
    from_url                 STRING                                  COMMENT '会话来源页面',
    landing_page_url         STRING                                  COMMENT '访客着陆页面',
    url_title                STRING                                  COMMENT '咨询页面title',
    to_peer                  STRING                                  COMMENT '所属技能组',
    manual_time              STRING                                  COMMENT '人工开始时间',
    begin_time               STRING                                  COMMENT '坐席领取时间 ',
    reply_msg_count          INT                                     COMMENT '客服回复消息数',
    total_msg_count          INT                                     COMMENT '消息总数',
    msg_count                INT                                     COMMENT '客户发送消息数',
    comment                  STRING                                  COMMENT '备注',
    finish_reason            STRING                                  COMMENT '结束类型',
    finish_user              STRING                                  COMMENT '结束坐席',
    end_time                 STRING                                  COMMENT '会话结束时间',
    platform_description     STRING                                  COMMENT '客户平台信息',
    browser_name             STRING                                  COMMENT '浏览器名称',
    os_info                  STRING                                  COMMENT '系统名称',
    area                     STRING                                  COMMENT '区域',
    country                  STRING                                  COMMENT '所在国家',
    province                 STRING                                  COMMENT '省',
    city                     STRING                                  COMMENT '城市',
    creator                  INT                                     COMMENT '创建人',
    name                     STRING                                  COMMENT '客户姓名',
    idcard                   STRING                                  COMMENT '身份证号',
    phone                    STRING                                  COMMENT '手机号',
    itcast_school_id         INT                                     COMMENT '校区Id',
    itcast_school            STRING                                  COMMENT '校区',
    itcast_subject_id        INT                                     COMMENT '学科Id',
    itcast_subject           STRING                                  COMMENT '学科',
    wechat                   STRING                                  COMMENT '微信',
    qq                       STRING                                  COMMENT 'qq号',
    email                    STRING                                  COMMENT '邮箱',
    gender                   STRING                                  COMMENT '性别',
    level                    STRING                                  COMMENT '客户级别',
    origin_type              STRING                                  COMMENT '数据来源渠道',
    information_way          STRING                                  COMMENT '资讯方式',
    working_years            STRING                                  COMMENT '开始工作时间',
    technical_directions     STRING                                  COMMENT '技术方向',
    customer_state           STRING                                  COMMENT '当前客户状态',
    valid                    STRING                                  COMMENT '该线索是否是网资有效线索',
    anticipat_signup_date    STRING                                  COMMENT '预计报名时间',
    clue_state               STRING                                  COMMENT '线索状态',
    scrm_department_id       INT                                     COMMENT 'SCRM内部部门id',
    superior_url             STRING                                  COMMENT '诸葛获取上级页面URL',
    superior_source          STRING                                  COMMENT '诸葛获取上级页面URL标题',
    landing_url              STRING                                  COMMENT '诸葛获取着陆页面URL',
    landing_source           STRING                                  COMMENT '诸葛获取着陆页面URL来源',
    info_url                 STRING                                  COMMENT '诸葛获取留咨页URL',
    info_source              STRING                                  COMMENT '诸葛获取留咨页URL标题',
    origin_channel           STRING                                  COMMENT '投放渠道',
    course_id                INT                                     ,
    course_name              STRING                                  ,
    zhuge_session_id         STRING                                  ,
    is_repeat                INT                                     COMMENT '是否重复线索(手机号维度) 0:正常 1：重复',
    tenant                   INT                                     COMMENT '租户id',
    activity_id              STRING                                  COMMENT '活动id',
    activity_name            STRING                                  COMMENT '活动名称',
    follow_type              INT                                     COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    shunt_mode_id            INT                                     COMMENT '匹配到的技能组id',
    shunt_employee_group_id  INT                                     COMMENT '所属分流员工组',
    end_date                 STRING                                  COMMENT '拉链结束日期'
) COMMENT '客户线索表'
partitioned by (start_date string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties ('orc.compress'='SNAPPY');





insert overwrite table zx_dwd.fact_customer_relationship partition (start_date)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    customer_id,
    first_id,
    belonger,
    belonger_name,
    initial_belonger,
    distribution_handler,
    business_scrm_department_id,
    last_visit_time,
    next_visit_time,
    origin_type,
    itcast_school_id,
    itcast_subject_id,
    intention_study_type,
    anticipat_signup_date,
    level,
    creator,
    current_creator,
    creator_name,
    origin_channel,
    comment,
    first_customer_clue_id,
    last_customer_clue_id,
    process_state,
    process_time,
    payment_state,
    payment_time,
    signup_state,
    signup_time,
    notice_state,
    notice_time,
    lock_state,
    lock_time,
    itcast_clazz_id,
    itcast_clazz_time,
    payment_url,
    payment_url_time,
    ems_student_id,
    delete_reason,
    deleter,
    deleter_name,
    delete_time,
    course_id,
    course_name,
    delete_comment,
    close_state,
    close_time,
    appeal_id,
    tenant,
    total_fee,
    belonged,
    belonged_time,
    belonger_time,
    transfer,
    transfer_time,
    follow_type,
    transfer_bxg_oa_account,
    transfer_bxg_belonger_name,
    '9999-99-99' end_date,
    dt start_date
from zx_ods.t_customer_relationship;




insert overwrite table zx_dwd.dim_itcast_clazz partition (start_date)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    itcast_school_id,
    itcast_school_name,
    itcast_subject_id,
    itcast_subject_name,
    itcast_brand,
    clazz_type_state,
    clazz_type_name,
    teaching_mode,
    start_time,
    end_time,
    comment,
    detail,
    uncertain,
    tenant,
    '9999-99-99' end_date,
    dt start_date
from zx_ods.t_itcast_clazz;



insert overwrite table zx_dwd.dim_employee partition (start_date)
select
    id,
    email,
    real_name,
    phone,
    department_id,
    department_name,
    remote_login,
    job_number,
    cross_school,
    last_login_date,
    creator,
    create_date_time,
    update_date_time,
    deleted,
    scrm_department_id,
    leave_office,
    leave_office_time,
    reinstated_time,
    superior_leaders_id,
    tdepart_id,
    tenant,
    ems_user_name,
    '9999-99-99' end_date,
    dt start_date
from zx_ods.t_employee;



insert overwrite table zx_dwd.dim_scrm_department
select * from zx_ods.t_scrm_department;


insert overwrite table zx_dwd.dim_customer_appeal partition (start_date)
select
    id,
    customer_relationship_first_id,
    employee_id,
    employee_name,
    employee_department_id,
    employee_tdepart_id,
    appeal_status,
    audit_id,
    audit_name,
    audit_department_id,
    audit_department_name,
    audit_date_time,
    create_date_time,
    update_date_time,
    deleted,
    tenant,
    '9999-99-99' end_date,
    dt start_date
from zx_ods.t_customer_appeal;


insert overwrite table zx_dwd.dim_customer_clue partition (start_date)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    customer_id,
    customer_relationship_id,
    session_id,
    sid,
    status,
    `user`,
    create_time,
    platform,
    s_name,
    seo_source,
    seo_keywords,
    ip,
    referrer,
    from_url,
    landing_page_url,
    url_title,
    to_peer,
    manual_time,
    begin_time,
    reply_msg_count,
    total_msg_count,
    msg_count,
    comment,
    finish_reason,
    finish_user,
    end_time,
    platform_description,
    browser_name,
    os_info,
    area,
    country,
    province,
    city,
    creator,
    name,
    idcard,
    phone,
    itcast_school_id,
    itcast_school,
    itcast_subject_id,
    itcast_subject,
    wechat,
    qq,
    email,
    gender,
    level,
    origin_type,
    information_way,
    working_years,
    technical_directions,
    customer_state,
    valid,
    anticipat_signup_date,
    clue_state,
    scrm_department_id,
    superior_url,
    superior_source,
    landing_url,
    landing_source,
    info_url,
    info_source,
    origin_channel,
    course_id,
    course_name,
    zhuge_session_id,
    is_repeat,
    tenant,
    activity_id,
    activity_name,
    follow_type,
    shunt_mode_id,
    shunt_employee_group_id,
    '9999-99-99' end_date,
    dt start_date
from zx_ods.t_customer_clue;





drop table if exists zx_dwb.dwb_wide_table;
create table zx_dwb.dwb_wide_table
(
    --意向表
    id                          int comment '意向id',
    create_date_time            string comment '创建时间',
    update_date_time            string comment '最后更新时间',
    deleted                     string comment '是否被删除（禁用）',
    customer_id                 int comment '所属客户id',
    first_id                    int comment '第一条客户关系id',
    belonger                    int comment '归属人',
    belonger_name               string comment '归属人姓名',
    initial_belonger            int comment '初始归属人',
    distribution_handler        int comment '分配处理人',
    business_scrm_department_id int comment '归属部门',
    last_visit_time             string comment '最后回访时间',
    next_visit_time             string comment '下次回访时间',
    origin_type                 string comment '数据来源',
    itcast_school_id            int comment '校区Id',
    itcast_subject_id           int comment '学科Id',
    intention_study_type        string comment '意向学习方式',
    anticipat_signup_date       string comment '预计报名时间',
    level                       string comment '客户级别',
    creator                     int comment '创建人',
    current_creator             int comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                string comment '创建者姓名',
    origin_channel              string comment '来源渠道',
    comment                     string,
    first_customer_clue_id      int comment '第一条线索id',
    last_customer_clue_id       int comment '最后一条线索id',
    process_state               string comment '处理状态',
    process_time                string comment '处理状态变动时间',
    payment_state               string comment '支付状态',
    payment_time                string comment '支付状态变动时间',
    signup_state                string comment '报名状态',
    signup_time                 string comment '报名时间',
    notice_state                string comment '通知状态',
    notice_time                 string comment '通知状态变动时间',
    lock_state                  string comment '锁定状态',
    lock_time                   string comment '锁定状态修改时间',
    itcast_clazz_id             int comment '所属ems班级id',
    itcast_clazz_time           string comment '报班时间',
    payment_url                 string comment '付款链接',
    payment_url_time            string comment '支付链接生成时间',
    ems_student_id              int comment 'ems的学生id',
    delete_reason               string comment '删除原因',
    deleter                     int comment '删除人',
    deleter_name                string comment '删除人姓名',
    delete_time                 string comment '删除时间',
    course_id                   int comment '课程ID',
    course_name                 string comment '课程名称',
    delete_comment              string comment '删除原因说明',
    close_state                 string comment '关闭装填',
    close_time                  string comment '关闭状态变动时间',
    appeal_id                   int comment '申诉id',
    tenant                      int comment '租户',
    total_fee                   string comment '报名费总金额',
    belonged                    int comment '小周期归属人',
    belonged_time               string comment '归属时间',
    belonger_time               string comment '归属时间',
    transfer                    int comment '转移人',
    transfer_time               string comment '转移时间',
    follow_type                 int comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account     string comment '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  string comment '转移到博学谷归属人OA姓名',
    --班级表
    banji_id                          int comment    '班级ID',
    itcast_school_name          string comment '校区名称',
    itcast_subject_name         string comment '学科名称',
    --线索表
    customer_relationship_id int    comment '客户关系id',
    clue_state               string comment '线索状态',
    --申诉表
    customer_relationship_first_id int comment '第一条客户关系id',
    appeal_status                  int comment '申诉状态，0:待稽核 1:无效 2：有效',
    --员工表
    yuangong_id                  int comment '员工id',
    tdepart_id          int comment '直属部门',
    --部门表
    bumen_id               int comment '部门id',
    name             string comment '部门名称'
)COMMENT '主题宽表'
PARTITIONED BY(dt STRING)
row format delimited fields terminated by '\t'
stored as textfile
tblproperties ('orc.compress' = 'SNAPPY');

insert into table zx_dwb.dwb_wide_table partition (dt)
select
    cr.id,
    cr.create_date_time,
    cr.update_date_time,
    cr.deleted,
    cr.customer_id,
    cr.first_id,
    cr.belonger,
    cr.belonger_name,
    cr.initial_belonger,
    cr.distribution_handler,
    cr.business_scrm_department_id,
    cr.last_visit_time,
    cr.next_visit_time,
    cr.origin_type,
    cr.itcast_school_id,
    cr.itcast_subject_id,
    cr.intention_study_type,
    cr.anticipat_signup_date,
    cr.level,
    cr.creator,
    cr.current_creator,
    cr.creator_name,
    cr.origin_channel,
    cr.comment,
    cr.first_customer_clue_id,
    cr.last_customer_clue_id,
    cr.process_state,
    cr.process_time,
    cr.payment_state,
    cr.payment_time,
    cr.signup_state,
    cr.signup_time,
    cr.notice_state,
    cr.notice_time,
    cr.lock_state,
    cr.lock_time,
    cr.itcast_clazz_id,
    cr.itcast_clazz_time,
    cr.payment_url,
    cr.payment_url_time,
    cr.ems_student_id,
    cr.delete_reason,
    cr.deleter,
    cr.deleter_name,
    cr.delete_time,
    cr.course_id,
    cr.course_name,
    cr.delete_comment,
    cr.close_state,
    cr.close_time,
    cr.appeal_id,
    cr.tenant,
    cr.total_fee,
    cr.belonged,
    cr.belonged_time,
    cr.belonger_time,
    cr.transfer,
    cr.transfer_time,
    cr.follow_type,
    cr.transfer_bxg_oa_account,
    cr.transfer_bxg_belonger_name,
    ic.id,
    ic.itcast_school_name,
    ic.itcast_subject_name,
    cc.customer_relationship_id,
    cc.clue_state,
    ca.customer_relationship_first_id,
    ca.appeal_status,
    e.id,
    e.tdepart_id,
    sd.id,
    sd.name,
    SUBSTR(cr.create_date_time,1,10) as dt --动态分区值
from zx_dwd.fact_customer_relationship cr
left join zx_dwd.dim_itcast_clazz ic on ic.id = cr.itcast_clazz_id and ic.end_date='9999-99-99'
left join zx_dwd.dim_customer_clue cc on cc.customer_relationship_id = cr.id and cc.end_date='9999-99-99'
left join zx_dwd.dim_customer_appeal ca on ca.customer_relationship_first_id = cr.id and ca.end_date='9999-99-99'
left join zx_dwd.dim_employee e on e.id = cr.creator and e.end_date='9999-99-99'
left join zx_dwd.dim_scrm_department sd on sd.id = e.tdepart_id
where cr.end_date='9999-99-99';

set hive.exec.mode.local.auto=false;
set hive.auto.convert.join=false;









