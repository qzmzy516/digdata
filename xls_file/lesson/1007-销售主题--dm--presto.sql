--DM层销售主题的上卷操作
    --基于dws的日统计  上卷出周  月 年指标

--step1: 表关系梳理
    --dws 销售日统计表
    --dwd 时间维度表   通常由数仓平台统一集中维护
        --todo 如果公司没有提供时间维度表  如何基于年月日数据  计算出所属年月周季度等。

--step2: 基于关联的数据  分组计算出年月周的指标
    --课堂以年为例进行上卷  周月的操作一样
        --年
        --年+城市
        --年+商圈
        --年+店铺
        --年+品牌
        --年+大类
        --年+中类
        --年+小类

--为了大脑不紊乱  先一个维度卷起来 后面再使用grouping sets一起卷
    --  年
select
    *
from hive.yp_dws.dws_sale_daycount dc
left join hive.yp_dwd.dim_date d
on dc.dt = d.date_code
group by d.year_code,dc.group_type; --TODO 思考 这里仅根据年分组 结果是否正确？

with tmp as (select
*
from hive.yp_dws.dws_sale_daycount dc
left join hive.yp_dwd.dim_date d
on dc.dt = d.date_code
group by d.year_code,dc.group_type)
select * from tmp where group_type ='all'; --只把day的取出来 上卷 就是这一年的

---------------
--上述只是实现了每年的各个指标上卷操作  其他还有7个维度上卷操作
--基于分析发现 这几个维度都是基于同一份数据的上卷  因此可以使用增强聚合grouping sets
        --年                 all
        --年+城市   日+城市    city
        --年+商圈             trade_area
        --年+店铺             store
        --年+品牌             brand
        --年+大类             max_class
        --年+中类             mid_class
        --年+小类             min_class
insert into yp_dm.dm_sale
with tmp as (select
    --step3 查询返回的字段  和dm目标表一致
    '2022-10-07' as date_time, --统计干活日期

   case when grouping(d.year_code, d.month_code, d.day_month_num, d.dim_date_id) = 0
      then 'date'
       when grouping(d.year_code, d.year_week_name_cn) = 0
      then 'week'
      when grouping(d.year_code, d.month_code, d.year_month) = 0
      then 'month'
      when grouping(d.year_code) = 0
      then 'year'
   end
   as time_type,
    d.year_code,
    d.year_month,
    d.month_code,
    d.day_month_num,
    d.dim_date_id,
    d.year_week_name_cn,
    group_type as group_type_old,

    --新的分组标记
    case when grouping(store_id) =0
              then 'store'
              when grouping(trade_area_id) =0
              then 'trade_area'
              when grouping(city_id) =0
              then 'city'
              when grouping(brand_id) =0
              then 'brand'
              when grouping(min_class_id)= 0
              then 'min_class'
              when grouping(mid_class_id)= 0
              then 'mid_class'
              when grouping(max_class_id)= 0
              then 'max_class'
              when grouping(d.year_code)= 0
              then 'all'  --todo  all代表的就是不同粒度的日期
              else 'others' end as group_type_new,
    --维度字段
    city_id,
    city_name,
    trade_area_id,
    trade_area_name,
    store_id,
    store_name,
    brand_id,
    brand_name,
    max_class_id,
    max_class_name,
    mid_class_id,
    mid_class_name,
    min_class_id,
    min_class_name,

    --指标字段
    sum(sale_amt),
    sum(plat_amt),
    sum(deliver_sale_amt),
    sum(mini_app_sale_amt),
    sum(android_sale_amt),
    sum(ios_sale_amt),
    sum(pcweb_sale_amt),
    sum(order_cnt),
    sum(eva_order_cnt),
    sum(bad_eva_order_cnt),
    sum(deliver_order_cnt),
    sum(refund_order_cnt),
    sum(miniapp_order_cnt),
    sum(android_order_cnt),
    sum(ios_order_cnt),
    sum(pcweb_order_cnt)
from hive.yp_dws.dws_sale_daycount dc
left join hive.yp_dwd.dim_date d
on dc.dt = d.date_code
group by grouping sets (

    --年上卷
    (d.year_code, dc.group_type), --年
    (d.year_code, city_id, city_name,dc.group_type), --年+城市
    (d.year_code, city_id, city_name, trade_area_id, trade_area_name,dc.group_type), --年+商圈
    (d.year_code, city_id, city_name, trade_area_id, trade_area_name, store_id, store_name,dc.group_type), --年+店铺
    (d.year_code, brand_id, brand_name,dc.group_type), --年+品牌
    (d.year_code, max_class_id, max_class_name,dc.group_type), --年+大类
    (d.year_code, max_class_id, max_class_name,mid_class_id, mid_class_name,dc.group_type), --年+中类
    (d.year_code, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name,dc.group_type)), --年+小类

    --月上卷
    (d.month_code, dc.group_type), --月
    (d.month_code, city_id, city_name,dc.group_type), --月+城市
    (d.month_code, city_id, city_name, trade_area_id, trade_area_name,dc.group_type), --月+商圈
    (d.month_code, city_id, city_name, trade_area_id, trade_area_name, store_id, store_name,dc.group_type), --月+店铺
    (d.month_code, brand_id, brand_name,dc.group_type), --月+品牌
    (d.month_code, max_class_id, max_class_name,dc.group_type), --月+大类
    (d.month_code, max_class_id, max_class_name,mid_class_id, mid_class_name,dc.group_type), --月+中类
    (d.month_code, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name,dc.group_type),--月+小类

    --周上卷
    (d.year_week_code, dc.group_type), --周
    (d.year_week_code, city_id, city_name,dc.group_type), --周+城市
    (d.year_week_code, city_id, city_name, trade_area_id, trade_area_name,dc.group_type), --周+商圈
    (d.year_week_code, city_id, city_name, trade_area_id, trade_area_name, store_id, store_name,dc.group_type), --周+店铺
    (d.year_week_code, brand_id, brand_name,dc.group_type), --周+品牌
    (d.year_week_code, max_class_id, max_class_name,dc.group_type), --周+大类
    (d.year_week_code, max_class_id, max_class_name,mid_class_id, mid_class_name,dc.group_type), --周+中类
    (d.year_week_code, max_class_id, max_class_name,mid_class_id, mid_class_name,min_class_id, min_class_name,dc.group_type)--周+小类
    )
select * from tmp where group_type_old=group_type_new;