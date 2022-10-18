-- test
selecT *
FROM test.dw_zipper; -- 旧数据

select *
from test.ods_zipper_update;
-- 新增数据

-- step1 新旧表left join
selecT a.userid,
       a.phone,
       a.nick,
       a.gender,
       a.addr,
       a.starttime,
       if(b.userid is null or a.endtime > '9999-12-31', a.endtime, b.starttime) as endtime
FROM test.dw_zipper a
         left join test.ods_zipper_update b
                   on a.userid = b.userid;
-- step2 join结果与新表union
select userid,
       phone,
       nick,
       gender,
       addr,
       starttime,
       endtime
from test.ods_zipper_update
union all
selecT a.userid,
       a.phone,
       a.nick,
       a.gender,
       a.addr,
       a.starttime,
       if(b.userid is null or a.endtime > '9999-12-31', a.endtime, date_sub(b.starttime, 1)) as endtime
FROM test.dw_zipper a
         left join test.ods_zipper_update b
                   on a.userid = b.userid;

-- step3 结果插入临时表
create table tmp_zipper
(
    userid    string,
    phone     string,
    nick      string,
    gender    int,
    addr      string,
    starttime string,
    endtime   string
)
row format delimited
fields terminated by '\t';

insert overwrite table tmp_zipper
    select userid,
            phone,
            nick,
            gender,
            addr,
            starttime,
            endtime
     from test.ods_zipper_update
     union all
     selecT a.userid,
            a.phone,
            a.nick,
            a.gender,
            a.addr,
            a.starttime,
            if(b.userid is null or a.endtime > '9999-12-31', a.endtime, date_sub(b.starttime, 1)) as endtime
     FROM test.dw_zipper a
              left join test.ods_zipper_update b
                        on a.userid = b.userid;

-- step4 确认结果后覆盖插入
insert overwrite table test.dw_zipper
select *
from test.tmp_zipper;


