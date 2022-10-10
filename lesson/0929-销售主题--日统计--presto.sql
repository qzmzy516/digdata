--销售主题的日统计

--step1: 需求分析  理清主题需求中的维度 、指标的业务含义。

--step2: 建模主题表
    --表名  dws_xxxxx主题_daycount
    --字段包含：维度 维度分组标记 指标

--step3: 梳理表关系 抽取字段来支撑本主题的计算
    --哪些表可以来支撑我们这个主题的计算，哪些字段可以支持指标和维度。
    --优先到前一层dwb层去梳理·
--通过梳理发现  dwb层3张宽表都需要参与本主题的计算。
    --以订单宽表为准 去关联的店铺宽表 商品宽表
with tmp as (select
    --step4: 字段的抽取
        --将能够支撑本主题的指标字段 维度字段抽取出来  精准抽取
    --维度字段
    o.dt,--日期
    s.city_id,
    s.city_name, --城市
    s.trade_area_id,
    s.trade_area_name, --商圈
    s.id as store_id,
    s.store_name, --店铺
    g.brand_id,
    g.brand_name, --品牌
    g.max_class_id,
    g.max_class_name, --大类
    g.mid_class_id,
    g.mid_class_name,--中类
    g.min_class_id,
    g.min_class_name, --小类

    --订单量
    o.order_id,
    o.goods_id, --订单编号 商品编号

    --金融相关的指标
    o.order_amount, --订单总价
    o.total_price, --商品总价：商品单价*商品数量
    o.plat_fee, --平台收入
    o.dispatcher_money,--配送收入

    --判断条件
    o.order_from, --订单来源渠道：ios pc miniapp等
    o.evaluation_id, --评价单id  如果不为空 表示该订单有评价
    o.geval_scores, --订单综合评分 根据业务需求判断好中差
    o.delievery_id, --配送单id 如果不为空 表示该订单有配送  其他可选方式（商家配送、用户自提）
    o.refund_id,  --退款单id 如果不为空 表示该订单有退款发生

    --step5: (可选)如果想对数据进行去重 可以使用row_number在这里进行判断
    row_number() over(partition by order_id) as order_rn,
    row_number() over(partition by order_id,g.brand_id) as brand_rn,
    row_number() over(partition by order_id,g.max_class_name) as maxclass_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name) as midclass_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,g.min_class_name) as minclass_rn,

    --下面分组加入goods_id
    row_number() over(partition by order_id,g.brand_id,o.goods_id) as brand_goods_rn,
    row_number() over(partition by order_id,g.max_class_name,o.goods_id) as maxclass_goods_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,o.goods_id) as midclass_goods_rn,
    row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,g.min_class_name,o.goods_id) as minclass_goods_rn
from hive.yp_dwb.dwb_order_detail o  --订单宽表
    left join hive.yp_dwb.dwb_shop_detail s
        on o.store_id = s.id --店铺宽表
    left join hive.yp_dwb.dwb_goods_detail g
        on o.goods_id =g.id )--商品宽表
select
       --step7: 查询返回的维度 指标计算的结果
            --注意 这里返回的顺序个数类型 要和dws层建表保持一致 因为最终是需要将计算的结果插入到dws目标表中
       --维度字段返回
            --直接写 分组有就显示 没有就显示null
--        city_id,
--        city_name,
--        trade_area_id,
--        trade_area_name,
--        store_id,
--        store_name,
--        brand_id,
--        brand_name,
--        max_class_id,
--        max_class_name,
--        mid_class_id,
--        mid_class_name,
--        min_class_id,
--        min_class_name,

       --分组标记字段返回   当涉及两个及以上的不同维度计算 最好有意识的在表中增加上标记字段  便于后续过滤取值
       --方式1：通用的方法 也是大家必须掌握的方法
            --todo 将所有出现的字段都放在grouping中判断
            --怎么用呢？ 以119为例 --》转换成为2进制 0111 0111 --->表示dt和brand_id有 其他都没有
       case when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =127
            then 'dt'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =63
            then 'city'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =31
            then 'trade'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =15
            then 'store'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =119
            then 'brand'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =123
            then 'max_class'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =121
            then 'mid_class'
            when grouping(dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_id,min_class_id) =120
            then 'min_class'
            else 'others' end as group_type
from tmp
group by grouping sets(  --step6: 由于八个维度组合都是针对同一份数据的计算  可以使用grouping sets来增强聚合
    (dt), --日期
    (dt,city_id,city_name),--日期+城市
    (dt,city_id,city_name,trade_area_id,trade_area_name),--日期+商圈
    (dt,city_id,city_name,trade_area_id,trade_area_name,store_id,store_name),--日期+店铺
    (dt,brand_id,brand_name), --日期+品牌
    (dt,max_class_id,max_class_name), --日期+大类
    (dt,max_class_id,max_class_name,mid_class_id,mid_class_name), --日期+中类
    (dt,max_class_id,max_class_name,mid_class_id,mid_class_name,min_class_id,min_class_name) --日期+小类
);

