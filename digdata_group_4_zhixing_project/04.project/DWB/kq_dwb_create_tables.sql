drop table if  exists zx_dwb.dwb_student_signin_wide_table;
create table zx_dwb.dwb_student_signin_wide_table
(
    --学生签到记录表--
    id                     int comment '主键id',
    normal_class_flag      int comment '是否正课 1 正课 2 自习',
    time_table_id          int comment '作息时间id 关联tbh_school_time_table 或者 tbh_class_time_table',
    class_id               int comment '班级id',
    student_id             int comment '学员id',
    signin_time            string comment '签到时间',
    signin_date            string comment '签到日期',
    inner_flag             int comment '内外网标志  0 外网 1 内网',
    signin_type            int comment '签到类型 1 心跳打卡 2 老师补卡',
    share_state            int comment '共享屏幕状态 0 否 1是  在上午或下午段有共屏记录，则该段所有记录该字段为1，内网默认为1 外网默认为0 ',
    inner_ip               string comment '内网ip地址',

    --班级课程表--
    morning_begin_time     string comment '上午开始时间',
    morning_end_time       string comment '上午结束时间',
    afternoon_begin_time   string comment '下午开始时间',
    afternoon_end_time     string comment '下午结束时间',
    evening_begin_time     string comment '晚上开始时间',
    evening_end_time       string comment '晚上结束时间',
    use_begin_date         string comment '使用开始日期',
    use_end_date           string comment '使用结束日期',

    --课程副表--
    class_date             string comment '上课日期',
    class_mode             int comment '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',

    --学生人数表--
    studying_student_count int comment '在读班级人数',
    studying_date          string comment '在读日期'
)
    comment '学生出勤信息宽表'
    PARTITIONED BY (dt string)
    row format delimited
    fields terminated by '\t'
    stored as orc
    tblproperties ('orc.compress' = 'SNAPPY');


drop table if  exists zx_dwb.dwb_leave_wide_table;
create table zx_dwb.dwb_leave_wide_table
(
-- 请假表
    class_id               int       comment '班级id',
    student_id      int               comment '学员id',
    audit_state     string            comment '审核状态 0 待审核 1 通过 2 不通过',
    begin_time_type int               comment '请假区间，1：上午 2：下午',
    begin_time      string comment '请假开始时间',
    end_time_type   int               comment '请假区间，1：上午 2：下午',
    end_time        string comment '请假结束时间',
    cancel_state    int               comment '撤销状态  0 未撤销 1 已撤销',
    valid_state     string            comment '是否有效（0：无效 1：有效）',
-- 上课细节表
    class_date             string comment '上课日期',
    class_mode             int comment '上课模式 0 传统全天 1 AB上午 2 AB下午 3 线上直播',
    content             string comment '课程内容',
-- 课程时间表
    morning_begin_time     string comment '上午开始时间',
    morning_end_time       string comment '上午结束时间',
    afternoon_begin_time   string comment '下午开始时间',
    afternoon_end_time     string comment '下午结束时间',
    evening_begin_time     string comment '晚上开始时间',
    evening_end_time       string comment '晚上结束时间',
    use_begin_date         string comment '使用开始日期',
    use_end_date           string comment '使用结束日期'
-- 人数表

)
    comment '学生请假信息宽表'
    PARTITIONED BY (dt string)
    row format delimited
    fields terminated by '\t'
    stored as orc
    tblproperties ('orc.compress' = 'SNAPPY');