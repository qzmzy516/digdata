--商品主题的日统计

--step1: 需求分析  理清主题需求中的维度 、指标的业务含义。

--step2: 建模主题表
    --表名  dws_xxxxx主题_daycount
    --字段包含：维度 维度分组标记 指标

--step3: 梳理表关系 抽取字段来支撑本主题的计算
    --哪些表可以来支撑我们这个主题的计算，哪些字段可以支持指标和维度。
    --优先到前一层dwb层去梳理·

--指标：
    -- 下单次数、下单件数、下单金额is_delivery
        --表：dwb_order_detail
            --字段：
                -- order_id  下单次数
                -- buy_num   下单件数
                -- total_price 下单金额

    -- 被支付次数、被支付件数、被支付金额
        --表：dwb_order_detail
            --todo 支付状态该如何判断呢？
                --order_state  除了1和7 剩下的都是已经支付的
                --is_pay  1表示已经支付
            --字段：
                -- order_id  被支付次数
                -- buy_num   被支付件数
                -- total_price 被支付金额


    -- 被退款次数、被退款件数、被退款金额
        --表：dwb_order_detail
            --todo 退款状态该如何判断呢？
                --refund_id    不为空表示有退款行为产生
                --refund_state  为5表示退款完成
            --字段：
                -- order_id  被退款次数
                -- buy_num   被退款件数
                -- total_price 被退款金额

    -- 被加入购物车次数、被加入购物车件数
        --表：dwd.fact_shop_cart
            --字段：id次数    buy_num件数
            -- create_time添加购物车的实际  goods_id

    -- 被收藏次数
        --表：dwd.fact_goods_collect
            --字段  id次数

    -- 好评数、中评数、差评数
        --表：fact_goods_evaluation_detail
            --字段：geval_scores_goods 商品评分
            --todo 至于何谓好中差 需要需求指定？
            --比如： >=9 好评  >=6 <9中评   <6 差评

--维度：
    --日期（day）+商品
------------------------------------------
--step4  由于下单 支付 退款指标来自于同一张表的数据 订单宽表 而这个表有很多
       --先使用列裁剪抽取核心字段出来  使用cte引导临时结果集 便于后续查询使用
with order_tmp as (select
    dt,
    goods_id,
    goods_name,
    order_id,
    buy_num,
    total_price,
    is_pay,
    refund_id,
--     refund_state  --这里由于测试数据原因 就不对退款状态进行判断了 直接根据id是否为空判断
    row_number() over(partition by order_id,goods_id) as rn
from yp_dwb.dwb_order_detail),
--第一组指标：下单次数 下单件数 下单金额
order_count_tmp as (select
       dt,goods_id,goods_name,
       count(order_id)  as order_count,
       sum(buy_num) as order_num,
       sum(total_price) as order_amount
from order_tmp
where rn =1 --去重操作
group by dt,goods_id,goods_name),
--第二组指标：被支付次数 被支付件数 被支付金额
payment_count_tmp as (select
       dt,goods_id,goods_name,
       count(order_id)  as payment_count,
       sum(buy_num) as payment_num,
       sum(total_price) as payment_amount
from order_tmp
where rn =1 and is_pay =1 --去重操作 支付判断操作
group by dt,goods_id,goods_name),
--第三组指标：退款次数 退款件数 退款金额
refund_count_tmp as (select
       dt,goods_id,goods_name,
       count(order_id)  as refund_count,
       sum(buy_num) as refund_num,
       sum(total_price) as refund_amount
from order_tmp
where rn =1 and refund_id is not null  --退款状态判断
group by dt,goods_id,goods_name),
--第四组指标：被加入购物车次数、被加入购物车件数
cart_count_tmp as (select
    substring(create_time,1,10) as dt,
    goods_id,
    count(id) as cart_count,
    sum(buy_num) as cart_num
from yp_dwd.fact_shop_cart
where end_date ='9999-99-99'
group by substring(create_time,1,10),goods_id),
--第五组指标：被收藏次数
favor_count_tmp as (select
    substring(create_time,1,10) as dt,
    goods_id,
    count(id) as favor_count
from yp_dwd.fact_goods_collect
where end_date ='9999-99-99'
group by substring(create_time,1,10),goods_id),
--第六组指标：好评、中评、差评
evaluation_count_tmp as (select
    substring(create_time,1,10) as dt,
    goods_id,
    --好评
    sum(if(geval_scores_goods >=9,1,0)) as evaluation_good_count,
    --中评
    sum(if(geval_scores_goods >=6 and geval_scores_goods<9,1,0)) as evaluation_mid_count,
    --差评
    sum(if(geval_scores_goods <6,1,0)) as evaluation_bad_count
from yp_dwd.fact_goods_evaluation_detail
group by substring(create_time,1,10),goods_id)






