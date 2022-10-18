--DM层商品主题的上卷操作
    --基于dws的日统计  上卷出 每个指标的总累积值 和 近30天累积值（月累积值）
--表关系梳理
    --dws  sku日统计

--todo 首次执行
--step1: 计算商品的总累积值
select
       sku_id,  --商品
       sum(order_count) as order_count,
       sum(order_num) as order_num,
       sum(order_amount) as order_amount,
       sum(payment_count) as payment_count,
       sum(payment_num) as payment_num,
       sum(payment_amount) as payment_amount,
       sum(refund_count) as refund_count,
       sum(refund_num) as refund_num,
       sum(refund_amount) as refund_amount,
       sum(cart_count) as cart_count,
       sum(cart_num) as cart_num,
       sum(favor_count) as favor_count,
       sum(evaluation_good_count) as evaluation_good_count,
       sum(evaluation_mid_count) as evaluation_mid_count,
       sum(evaluation_bad_count) as evaluation_bad_count
from hive.yp_dws.dws_sku_daycount
group by sku_id;

--step2: 计算商品的近30天累积值
select
       sku_id,  --商品
       sum(order_count) as order_last_30d_count,
       sum(order_num) as order_last_30d_num,
       sum(order_amount) as order_last_30d_amount,
       sum(payment_count) as payment_last_30d_count,
       sum(payment_num) as payment_last_30d_num,
       sum(payment_amount) as payment_last_30d_amount,
       sum(refund_count) as refund_last_30d_count,
       sum(refund_num) as refund_last_30d_num,
       sum(refund_amount) as refund_last_30d_amount,
       sum(cart_count) as cart_last_30d_count,
       sum(cart_num) as cart_last_30d_num,
       sum(favor_count) as favor_last_30d_count,
       sum(evaluation_good_count) as evaluation_last_30d_good_count,
       sum(evaluation_mid_count) as evaluation_last_30d_mid_count,
       sum(evaluation_bad_count) as evaluation_last_30d_bad_count
from hive.yp_dws.dws_sku_daycount
where dt >= cast(date_add('day',-30,date'2020-05-08') as varchar)
group by sku_id;

--step3 将上述两步的结果合并 共同插入到dm层目标表中
    --方式1： 祖传union all
    --方式2： join合并
            --join的方式   left join
            --join的字段   sku_id
--step4 插入到目标表
insert into hive.yp_dm.dm_sku
with total as (select
       sku_id,  --商品
       sum(order_count) as order_count,
       sum(order_num) as order_num,
       sum(order_amount) as order_amount,
       sum(payment_count) as payment_count,
       sum(payment_num) as payment_num,
       sum(payment_amount) as payment_amount,
       sum(refund_count) as refund_count,
       sum(refund_num) as refund_num,
       sum(refund_amount) as refund_amount,
       sum(cart_count) as cart_count,
       sum(cart_num) as cart_num,
       sum(favor_count) as favor_count,
       sum(evaluation_good_count) as evaluation_good_count,
       sum(evaluation_mid_count) as evaluation_mid_count,
       sum(evaluation_bad_count) as evaluation_bad_count
from hive.yp_dws.dws_sku_daycount
group by sku_id),
last_30d as (select
       sku_id,  --商品
       sum(order_count) as order_last_30d_count,
       sum(order_num) as order_last_30d_num,
       sum(order_amount) as order_last_30d_amount,
       sum(payment_count) as payment_last_30d_count,
       sum(payment_num) as payment_last_30d_num,
       sum(payment_amount) as payment_last_30d_amount,
       sum(refund_count) as refund_last_30d_count,
       sum(refund_num) as refund_last_30d_num,
       sum(refund_amount) as refund_last_30d_amount,
       sum(cart_count) as cart_last_30d_count,
       sum(cart_num) as cart_last_30d_num,
       sum(favor_count) as favor_last_30d_count,
       sum(evaluation_good_count) as evaluation_last_30d_good_count,
       sum(evaluation_mid_count) as evaluation_last_30d_mid_count,
       sum(evaluation_bad_count) as evaluation_last_30d_bad_count
from hive.yp_dws.dws_sku_daycount
where dt >= cast(date_add('day',-30,date'2020-05-08') as varchar)
group by sku_id)
select
        t.sku_id,
        l3.order_last_30d_count,
        l3.order_last_30d_num,
        l3.order_last_30d_amount,
        t.order_count,
        t.order_num,
        t.order_amount,
        l3.payment_last_30d_count,
        l3.payment_last_30d_num,
        l3.payment_last_30d_amount,
        t.payment_count,
        t.payment_num,
        t.payment_amount,
        l3.refund_last_30d_count,
        l3.refund_last_30d_num,
        l3.refund_last_30d_amount,
        t.refund_count,
        t.refund_num,
        t.refund_amount,
        l3.cart_last_30d_count,
        l3.cart_last_30d_num,
        t.cart_count,
        t.cart_num,
        l3.favor_last_30d_count,
        t.favor_count,
        l3.evaluation_last_30d_good_count,
        l3.evaluation_last_30d_mid_count,
        l3.evaluation_last_30d_bad_count,
        t.evaluation_good_count,
        t.evaluation_mid_count,
        t.evaluation_bad_count
from total t left join last_30d l3 on t.sku_id = l3.sku_id;



--todo 循环执行
--step5 将合并之后的结果覆盖插入到dm层sku主题表中  todo presto没有提供覆盖的插入操作  所以只能先删除再插入
truncate table hive.yp_dm.dm_sku;

insert into hive.yp_dm.dm_sku
select
    --step4: 合并数据  旧的总累积值+新的最后1天值= 新的总累积值
    coalesce(old.sku_id,new.sku_id) as sku_id,
    --新的近30天的累积值
    new.order_last_30d_count_new,
    new.order_last_30d_num_new,
    new.order_last_30d_amount_new,
    --新的总累积值
    old.order_count + coalesce(new.order_last_30d_count_new_one,0)as order_count,
    old.order_num + new.order_last_30d_num_new_one as order_num,
    old.order_amount + new.order_last_30d_amount_new_one as order_amount

from
--step1: 计算新的近30天累积值  和这30天中最后一天的值
--由于课程演示 上一次即首次计算是2020-05-08  所以经过T+1循环 这次是2020-05-09
(select
       sku_id,  --商品

       --新的近30天累积值中最后一天
       sum(if(dt = '2020-05-09',order_count,0)) as order_last_30d_count_new_one,
       sum(if(dt = '2020-05-09',order_num,0)) as order_last_30d_num_new_one,
       sum(if(dt = '2020-05-09',order_amount,0)) as order_last_30d_amount_new_one,
       sum(if(dt = '2020-05-09',payment_count,0)) as payment_last_30d_count_new_one,
       sum(if(dt = '2020-05-09',payment_num,0)) as payment_last_30d_num_new_one,
       sum(if(dt = '2020-05-09',payment_amount,0)) as payment_last_30d_amount_new_one,
       sum(if(dt = '2020-05-09',refund_count,0)) as refund_last_30d_count_new_one,
       sum(if(dt = '2020-05-09',refund_num,0)) as refund_last_30d_num_new_one,
       sum(if(dt = '2020-05-09',refund_amount,0)) as refund_last_30d_amount_new_one,
       sum(if(dt = '2020-05-09',cart_count,0)) as cart_last_30d_count_new_one,
       sum(if(dt = '2020-05-09',cart_num,0)) as cart_last_30d_num_new_one,
       sum(if(dt = '2020-05-09',favor_count,0)) as favor_last_30d_count_new_one,
       sum(if(dt = '2020-05-09',evaluation_good_count,0)) as evaluation_last_30d_good_count_new_one,
       sum(if(dt = '2020-05-09',evaluation_mid_count,0)) as evaluation_last_30d_mid_count_new_one,
       sum(if(dt = '2020-05-09',evaluation_bad_count,0)) as evaluation_last_30d_bad_count_new_one,

       --新的近30天的累积值
       sum(order_count) as order_last_30d_count_new,
       sum(order_num) as order_last_30d_num_new,
       sum(order_amount) as order_last_30d_amount_new,
       sum(payment_count) as payment_last_30d_count_new,
       sum(payment_num) as payment_last_30d_num_new,
       sum(payment_amount) as payment_last_30d_amount_new,
       sum(refund_count) as refund_last_30d_count_new,
       sum(refund_num) as refund_last_30d_num_new,
       sum(refund_amount) as refund_last_30d_amount_new,
       sum(cart_count) as cart_last_30d_count_new,
       sum(cart_num) as cart_last_30d_num_new,
       sum(favor_count) as favor_last_30d_count_new,
       sum(evaluation_good_count) as evaluation_last_30d_good_count_new,
       sum(evaluation_mid_count) as evaluation_last_30d_mid_count_new,
       sum(evaluation_bad_count) as evaluation_last_30d_bad_count_new
from hive.yp_dws.dws_sku_daycount
where dt >= cast(date_add('day',-30,date'2020-05-09') as varchar)
group by sku_id) new
--step3： 合并新旧数据
full outer join
--step2： 查询出旧的累积值
(select sku_id,
       order_last_30d_count,
       order_last_30d_num,
       order_last_30d_amount,
       order_count,
       order_num,
       order_amount,
       payment_last_30d_count,
       payment_last_30d_num,
       payment_last_30d_amount,
       payment_count,
       payment_num,
       payment_amount,
       refund_last_30d_count,
       refund_last_30d_num,
       refund_last_30d_amount,
       refund_count,
       refund_num,
       refund_amount,
       cart_last_30d_count,
       cart_last_30d_num,
       cart_count,
       cart_num,
       favor_last_30d_count,
       favor_count,
       evaluation_last_30d_good_count,
       evaluation_last_30d_mid_count,
       evaluation_last_30d_bad_count,
       evaluation_good_count,
       evaluation_mid_count,
       evaluation_bad_count
from hive.yp_dm.dm_sku) old
on new.sku_id = old.sku_id;
