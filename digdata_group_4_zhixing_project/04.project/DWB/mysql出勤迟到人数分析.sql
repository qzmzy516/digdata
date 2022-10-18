use teach;

select
       signin_date,
       class_id,

       早上出勤人数,
       concat(round(早上出勤人数/班级总人数,2)*100,'%') '早上出勤率',
       早上迟到人数,
       concat(round(早上迟到人数/班级总人数,2)*100,'%') '早上迟到率',
       早上请假人数,
       concat(round(早上请假人数/班级总人数,2)*100,'%') '早上请假率',
       (班级总人数-早上出勤人数-早上迟到人数-早上请假人数) '早上旷课人数',
       concat(round((班级总人数-早上出勤人数-早上迟到人数-早上请假人数)/班级总人数,2)*100,'%') '早上旷课率',

       中午出勤人数,
       concat(round(中午出勤人数/班级总人数,2)*100,'%') '中午出勤率',
       中午迟到人数,
       concat(round(中午迟到人数/班级总人数,2)*100,'%') '中午迟到率',
       中午请假人数,
       concat(round(中午迟到人数/班级总人数,2)*100,'%') '中午请假率',
       (班级总人数-中午出勤人数-中午迟到人数-中午请假人数) '中午旷课人数',
       concat(round((班级总人数-中午出勤人数-中午迟到人数-中午请假人数)/班级总人数,2)*100,'%') '中午旷课率',


       晚上出勤人数,
       concat(round(晚上出勤人数/班级总人数,2)*100,'%') '晚上出勤率',
       晚上迟到人数,
       concat(round(晚上迟到人数/班级总人数,2)*100,'%') '晚上迟到率',
       晚上请假人数,
       concat(round(晚上迟到人数/班级总人数,2)*100,'%') '晚上请假率',
       (班级总人数-晚上出勤人数-晚上迟到人数-晚上请假人数) '晚上旷课人数',
       concat(round((班级总人数-晚上出勤人数-晚上迟到人数-晚上请假人数)/班级总人数,2)*100,'%') '晚上旷课率',

       班级总人数
from (select signin_date,
       tb1.class_id,
       ch_mor '早上出勤人数',
       ch_aft '中午出勤人数',
       ch_eve '晚上出勤人数',
       早上迟到人数,
       中午迟到人数,
       晚上迟到人数,
       早上请假人数,
       中午请假人数,
       晚上请假人数,
       studying_student_count '班级总人数'
from (select signin_date,class_id,sum(ch_mor) ch_mor,sum(ch_aft) ch_aft,sum(ch_eve) ch_eve
from (select signin_date,class_id,student_id,if(ch_mor=0,0,1) ch_mor,if(ch_aft=0,0,1) ch_aft,if(ch_eve=0,0,1) ch_eve
from (select signin_date,class_id,student_id,sum(ch_mor) ch_mor,sum(ch_aft) ch_aft,sum(ch_eve) ch_eve
from (select class_id,
       student_id,
       signin_date,

       if(cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and date_add(morning_begin_time,interval 10 minute),1,0) ch_mor,
       if(cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and date_add(afternoon_begin_time,interval 10 minute),1,0) ch_aft,
       if(cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and date_add(evening_begin_time,interval 10 minute),1,0) ch_eve

from (select
       tssr.class_id,
       student_id,
       signin_time,
       signin_date,

       class_date,
       content,
       class_mode,

       morning_begin_time,
       morning_end_time,
       afternoon_begin_time,
       afternoon_end_time,
       evening_begin_time,
       evening_end_time,
       use_begin_date,
       use_end_date
from tbh_student_signin_record tssr
left join course_table_upload_detail ctud
    on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
left join tbh_class_time_table tctd
    on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
where content is not null and content!='开班典礼' and  content!=''
    or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb) tb
group by signin_date,class_id,student_id) tb) tb
group by signin_date,class_id) tb1
join (select class_date,class_id,count(*) '早上迟到人数'
from (select class_date,class_id,student_id,min(signin_time) mor_min,min(morning_begin_time) morning_begin_time,min(morning_end_time) morning_end_time
from (select
       tssr.class_id,
       student_id,
       signin_time,
       signin_date,

       class_date,
       content,
       class_mode,

       morning_begin_time,
       morning_end_time,
       afternoon_begin_time,
       afternoon_end_time,
       evening_begin_time,
       evening_end_time,
       use_begin_date,
       use_end_date
from tbh_student_signin_record tssr
left join course_table_upload_detail ctud
    on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
left join tbh_class_time_table tctd
    on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
where content is not null and content!='开班典礼' and  content!=''
    or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb
where cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time
group by class_date,class_id,student_id) tb
where cast(substring(mor_min,11,8) as time) between date_add(morning_begin_time,interval 10 minute) and morning_end_time
group by class_date,class_id) tb2
on tb1.signin_date=tb2.class_date and tb1.class_id=tb2.class_id
join (select class_date,class_id,count(*) '中午迟到人数'
from (select class_date,class_id,student_id,min(signin_time) aft_min,min(afternoon_begin_time) afternoon_begin_time,min(afternoon_end_time) afternoon_end_time
from (select
       tssr.class_id,
       student_id,
       signin_time,
       signin_date,

       class_date,
       content,
       class_mode,

       morning_begin_time,
       morning_end_time,
       afternoon_begin_time,
       afternoon_end_time,
       evening_begin_time,
       evening_end_time,
       use_begin_date,
       use_end_date
from tbh_student_signin_record tssr
left join course_table_upload_detail ctud
    on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
left join tbh_class_time_table tctd
    on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
where content is not null and content!='开班典礼' and  content!=''
    or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb
where cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time
group by class_date,class_id,student_id) tb
where cast(substring(aft_min,11,8) as time) between date_add(afternoon_begin_time,interval 10 minute) and afternoon_end_time
group by class_date,class_id) tb3
on tb1.signin_date=tb3.class_date and tb1.class_id=tb3.class_id
join (select class_date,class_id,count(*) '晚上迟到人数'
from (select class_date,class_id,student_id,min(signin_time) eve_min,min(evening_begin_time) evening_begin_time,min(evening_end_time) evening_end_time
from (select
       tssr.class_id,
       student_id,
       signin_time,
       signin_date,

       class_date,
       content,
       class_mode,

       morning_begin_time,
       morning_end_time,
       afternoon_begin_time,
       afternoon_end_time,
       evening_begin_time,
       evening_end_time,
       use_begin_date,
       use_end_date
from tbh_student_signin_record tssr
left join course_table_upload_detail ctud
    on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
left join tbh_class_time_table tctd
    on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
where content is not null and content!='开班典礼' and  content!=''
    or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
    or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb
where cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time
group by class_date,class_id,student_id) tb
where cast(substring(eve_min,11,8) as time) between date_add(evening_begin_time,interval 10 minute) and evening_end_time
group by class_date,class_id) tb4
on tb1.signin_date=tb4.class_date and tb1.class_id=tb4.class_id
join class_studying_student_count tb5
on tb1.signin_date=tb5.studying_date and tb1.class_id=tb5.class_id
join (select class_id,class_date,sum(早上请假) '早上请假人数',sum(中午请假) '中午请假人数',sum(晚上请假) '晚上请假人数'
from (select * ,
       if((cast(concat(class_date,' ',morning_begin_time) as datetime) between begin_time and end_time) or (cast(concat(class_date,' ',morning_end_time) as datetime) between begin_time and end_time) or (begin_time>cast(concat(class_date,' ',morning_begin_time) as datetime) and end_time<cast(concat(class_date,' ',morning_end_time) as datetime)) ,1,0) '早上请假',
       if((cast(concat(class_date,' ',afternoon_begin_time) as datetime) between begin_time and end_time) or (cast(concat(class_date,' ',afternoon_end_time) as datetime) between begin_time and end_time) or (begin_time>cast(concat(class_date,' ',afternoon_begin_time) as datetime) and end_time<cast(concat(class_date,' ',afternoon_end_time) as datetime)) ,1,0) '中午请假',
       if((cast(concat(class_date,' ',evening_begin_time) as datetime) between begin_time and end_time) or (cast(concat(class_date,' ',evening_end_time) as datetime) between begin_time and end_time) or (begin_time>cast(concat(class_date,' ',evening_begin_time) as datetime) and end_time<cast(concat(class_date,' ',evening_end_time) as datetime)) ,1,0) '晚上请假'

from (select sla.class_id,sla.student_id,begin_time,end_time,morning_begin_time,morning_end_time,afternoon_begin_time,afternoon_end_time,evening_begin_time,evening_end_time,tctt.use_begin_date,tctt.use_end_date,class_date
from student_leave_apply sla
left join tbh_class_time_table tctt
on sla.class_id=tctt.class_id
left join course_table_upload_detail ctud
on sla.class_id=ctud.class_id and class_date between use_begin_date and use_end_date
where content is not null and content!='开班典礼' and  content!='') tb) tb
group by class_id,class_date) tb6
on tb1.signin_date=tb6.class_date and tb1.class_id=tb6.class_id) tb;





















-- select signin_date,
--        tb1.class_id,
--        ch_mor '早上出勤人数',
--        ch_aft '中午出勤人数',
--        ch_eve '晚上出勤人数',
--        早上迟到人数,
--        中午迟到人数,
--        晚上迟到人数,
--        早上请假人数,
--        中午请假人数,
--        晚上请假人数,
--        studying_student_count '班级总人数'
-- from (select signin_date,class_id,sum(ch_mor) ch_mor,sum(ch_aft) ch_aft,sum(ch_eve) ch_eve
-- from (select signin_date,class_id,student_id,if(ch_mor=0,0,1) ch_mor,if(ch_aft=0,0,1) ch_aft,if(ch_eve=0,0,1) ch_eve
-- from (select signin_date,class_id,student_id,sum(ch_mor) ch_mor,sum(ch_aft) ch_aft,sum(ch_eve) ch_eve
-- from (select class_id,
--        student_id,
--        signin_date,
--
--        if(cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and date_add(morning_begin_time,interval 10 minute),1,0) ch_mor,
--        if(cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and date_add(afternoon_begin_time,interval 10 minute),1,0) ch_aft,
--        if(cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and date_add(evening_begin_time,interval 10 minute),1,0) ch_eve
--
-- from (select
--        tssr.class_id,
--        student_id,
--        signin_time,
--        signin_date,
--
--        class_date,
--        content,
--        class_mode,
--
--        morning_begin_time,
--        morning_end_time,
--        afternoon_begin_time,
--        afternoon_end_time,
--        evening_begin_time,
--        evening_end_time,
--        use_begin_date,
--        use_end_date
-- from tbh_student_signin_record tssr
-- left join course_table_upload_detail ctud
--     on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
-- left join tbh_class_time_table tctd
--     on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
-- where content is not null and content!='开班典礼' and  content!=''
--     or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb) tb
-- group by signin_date,class_id,student_id) tb) tb
-- group by signin_date,class_id) tb1
-- join (select class_date,class_id,count(*) '早上迟到人数'
-- from (select class_date,class_id,student_id,min(signin_time) mor_min,min(morning_begin_time) morning_begin_time,min(morning_end_time) morning_end_time
-- from (select
--        tssr.class_id,
--        student_id,
--        signin_time,
--        signin_date,
--
--        class_date,
--        content,
--        class_mode,
--
--        morning_begin_time,
--        morning_end_time,
--        afternoon_begin_time,
--        afternoon_end_time,
--        evening_begin_time,
--        evening_end_time,
--        use_begin_date,
--        use_end_date
-- from tbh_student_signin_record tssr
-- left join course_table_upload_detail ctud
--     on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
-- left join tbh_class_time_table tctd
--     on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
-- where content is not null and content!='开班典礼' and  content!=''
--     or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb
-- where cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time
-- group by class_date,class_id,student_id) tb
-- where cast(substring(mor_min,11,8) as time) between date_add(morning_begin_time,interval 10 minute) and morning_end_time
-- group by class_date,class_id) tb2
-- on tb1.signin_date=tb2.class_date and tb1.class_id=tb2.class_id
-- join (select class_date,class_id,count(*) '中午迟到人数'
-- from (select class_date,class_id,student_id,min(signin_time) aft_min,min(afternoon_begin_time) afternoon_begin_time,min(afternoon_end_time) afternoon_end_time
-- from (select
--        tssr.class_id,
--        student_id,
--        signin_time,
--        signin_date,
--
--        class_date,
--        content,
--        class_mode,
--
--        morning_begin_time,
--        morning_end_time,
--        afternoon_begin_time,
--        afternoon_end_time,
--        evening_begin_time,
--        evening_end_time,
--        use_begin_date,
--        use_end_date
-- from tbh_student_signin_record tssr
-- left join course_table_upload_detail ctud
--     on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
-- left join tbh_class_time_table tctd
--     on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
-- where content is not null and content!='开班典礼' and  content!=''
--     or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb
-- where cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time
-- group by class_date,class_id,student_id) tb
-- where cast(substring(aft_min,11,8) as time) between date_add(afternoon_begin_time,interval 10 minute) and afternoon_end_time
-- group by class_date,class_id) tb3
-- on tb1.signin_date=tb3.class_date and tb1.class_id=tb3.class_id
-- join (select class_date,class_id,count(*) '晚上迟到人数'
-- from (select class_date,class_id,student_id,min(signin_time) eve_min,min(evening_begin_time) evening_begin_time,min(evening_end_time) evening_end_time
-- from (select
--        tssr.class_id,
--        student_id,
--        signin_time,
--        signin_date,
--
--        class_date,
--        content,
--        class_mode,
--
--        morning_begin_time,
--        morning_end_time,
--        afternoon_begin_time,
--        afternoon_end_time,
--        evening_begin_time,
--        evening_end_time,
--        use_begin_date,
--        use_end_date
-- from tbh_student_signin_record tssr
-- left join course_table_upload_detail ctud
--     on tssr.class_id=ctud.class_id and tssr.signin_date=ctud.class_date
-- left join tbh_class_time_table tctd
--     on tssr.time_table_id=tctd.id and (ctud.class_date between tctd.use_begin_date and tctd.use_end_date)
-- where content is not null and content!='开班典礼' and  content!=''
--     or (cast(substring(signin_time,11,8) as time) between date_sub(morning_begin_time,interval 40 minute) and morning_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(afternoon_begin_time,interval 40 minute) and afternoon_end_time)
--     or (cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time)) tb
-- where cast(substring(signin_time,11,8) as time) between date_sub(evening_begin_time,interval 40 minute) and evening_end_time
-- group by class_date,class_id,student_id) tb
-- where cast(substring(eve_min,11,8) as time) between date_add(evening_begin_time,interval 10 minute) and evening_end_time
-- group by class_date,class_id) tb4
-- on tb1.signin_date=tb4.class_date and tb1.class_id=tb4.class_id
-- join class_studying_student_count tb5
-- on tb1.signin_date=tb5.studying_date and tb1.class_id=tb5.class_id
-- join (select class_id,class_date,sum(早上请假) '早上请假人数',sum(中午请假) '中午请假人数',sum(晚上请假) '晚上请假人数'
-- from (select * ,
--        if((cast(concat(class_date,' ',morning_begin_time) as datetime) between begin_time and end_time) or (cast(concat(class_date,' ',morning_end_time) as datetime) between begin_time and end_time) or (begin_time>cast(concat(class_date,' ',morning_begin_time) as datetime) and end_time<cast(concat(class_date,' ',morning_end_time) as datetime)) ,1,0) '早上请假',
--        if((cast(concat(class_date,' ',afternoon_begin_time) as datetime) between begin_time and end_time) or (cast(concat(class_date,' ',afternoon_end_time) as datetime) between begin_time and end_time) or (begin_time>cast(concat(class_date,' ',afternoon_begin_time) as datetime) and end_time<cast(concat(class_date,' ',afternoon_end_time) as datetime)) ,1,0) '中午请假',
--        if((cast(concat(class_date,' ',evening_begin_time) as datetime) between begin_time and end_time) or (cast(concat(class_date,' ',evening_end_time) as datetime) between begin_time and end_time) or (begin_time>cast(concat(class_date,' ',evening_begin_time) as datetime) and end_time<cast(concat(class_date,' ',evening_end_time) as datetime)) ,1,0) '晚上请假'
--
-- from (select sla.class_id,sla.student_id,begin_time,end_time,morning_begin_time,morning_end_time,afternoon_begin_time,afternoon_end_time,evening_begin_time,evening_end_time,tctt.use_begin_date,tctt.use_end_date,class_date
-- from student_leave_apply sla
-- left join tbh_class_time_table tctt
-- on sla.class_id=tctt.class_id
-- left join course_table_upload_detail ctud
-- on sla.class_id=ctud.class_id and class_date between use_begin_date and use_end_date
-- where content is not null and content!='开班典礼' and  content!='') tb) tb
-- group by class_id,class_date) tb6
-- on tb1.signin_date=tb6.class_date and tb1.class_id=tb6.class_id;
