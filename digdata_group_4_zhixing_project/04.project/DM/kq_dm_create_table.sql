
drop table if  exists zx_dm.dm_attendence_subject;
create table if not exists zx_dm.dm_attendence_subject (
        class_id                      string  comment '班级id',
        class_date                    string  comment '上课日期',
        attendance_count              int comment  '正常出勤人数',
        late_count                    int comment  '迟到人数',
        leave_count                   int comment  '请假人数',
        truant_count                  int comment  '旷课人数',
        attendance_percentage         decimal(52) comment  '正常出勤人数',
        late_percentage               decimal(52) comment  '迟到人数',
        leave_percentage              decimal(52) comment  '请假人数',
        truant_percentage             decimal(52) comment  '旷课人数'

)
    comment '考勤主题报表'
    row format delimited
    fields terminated by '\t'
    stored as orc
    tblproperties ('orc.compress' = 'SNAPPY');