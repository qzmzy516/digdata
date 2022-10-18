--
-- -- step1:关联表
-- with tmp as
-- (select
-- -- 字段抽取
-- --将能够支撑本主题的指标字段 维度字段抽取出来  精准抽取
--         o.dt,
--         s.city_id,
--         s.city_name,
--         s.trade_area_id,
--         s.trade_area_name,
--         s.id as store_id,
--         s.store_name,
--         g.brand_id,
--         g.brand_name,
--         g.max_class_id,
--         g.max_class_name,
--         g.mid_class_id,
--         g.mid_class_name,
--         g.min_class_id,
--         g.min_class_name,
--
--         -- 订单量
--         o.order_id,
--         o.goods_id,
--         -- 金融相关指标
--         o.order_amount,-- 订单总价
--         o.total_price, --商品总价
--         o.plat_fee, --平台收入
--         o.dispatcher_money,--配送收入
--
--         --判断条件
--         o.order_from,-- 订单来源渠道，iOS，ps，miniapp等
--         o.evaluation_id,--评价单的id，如果不为空，表示有评价
--         o.geval_scores , --订单综合评分
--         o.delievery_id,--配送单id，如果不为空
--         o.refund_id,--退款单id，如不为空，有退款
--         row_number() over(partition by order_id) as order_rn,
--         row_number() over(partition by order_id,g.brand_id) as brand_rn,
--         row_number() over(partition by order_id,g.max_class_name) as maxclass_rn,
--         row_number() over(partition by order_id,g.max_class_name,g.mid_class_name) as midclass_rn,
--         row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,g.min_class_name) as minclass_rn,
--
--         --下面分组加入goods_id
--         row_number() over(partition by order_id,g.brand_id,o.goods_id) as brand_goods_rn,
--         row_number() over(partition by order_id,g.max_class_name,o.goods_id) as maxclass_goods_rn,
--         row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,o.goods_id) as midclass_goods_rn,
--         row_number() over(partition by order_id,g.max_class_name,g.mid_class_name,g.min_class_name,o.goods_id) as minclass_goods_rn
-- from hive.yp_dwb.dwb_order_detail o-- 订单宽表
-- left join hive.yp_dwb.dwb_shop_detail s on o.store_id =s.id-- 店铺宽表
-- left join hive.yp_dwb.dwb_goods_detail g on g.id=o.goods_id)-- 商品宽表
-- select
--         -- 查询返回的维度 指标计算的结果
--         city_id,
--         city_name,
--         trade_area_id,
--         trade_area_name,
--         store_id,
--         store_name,
--         brand_id,
--         brand_name,
--         max_class_id,
--         max_class_name,
--         mid_class_id,
--         mid_class_name,
--         min_class_id,
--         min_class_name,
--         -- 分组标记字段 ，维度过多需要有意识的在表中增加标记的字段，便于后续过滤取值
-- --         case grouping (dt,city_id,trade_area_id,store_id,brand_id,max_class_id,mid_class_name,min_class_id)
-- --         when 127
-- --         then 'bt'
-- --         when 63
-- --         then 'city'
-- --         when 31
-- --         then 'trade'
-- --         when 15
-- --         then 'store'
-- --         when 119
-- --         then 'brand_id'
-- --         when 123
-- --         then 'max_class'
-- --         when 121
-- --         then 'mid_class'
-- --         when 120
-- --         then 'min_class'
-- --         else 'others'
-- --         end as group_type
--         --方式2：case when 方式
--         case when grouping (store_id) = 0
--              then 'store'
--              when grouping (trade_area_id) = 0
--              then 'trade_area'
--              when grouping (city_id) = 0
--              then 'city'
--              when grouping (brand_id) = 0
--              then 'brand'
--              when grouping (min_class_id) = 0
--              then 'min_class'
--              when grouping (mid_class_id) = 0
--              then 'mid_class'
--              when grouping (max_class_id) = 0
--              then 'max_class'
--              when grouping (dt) = 0
--              then 'all' -- 表示的是0维的意思，由于dt每个分组都有
--              else 'others'
--              end as group_type,
--         -- 指标计算
--         -- no.1销售收入
--         -- 有的维度销售收入是根据订单金额，有的更具商品金额
--         case when grouping (store_id) = 0
--              then sum(if(order_rn = 1 and store_id is not null,coalesce (order_amount,0),0))
--              when grouping (trade_area_id) = 0
--              then sum(if(order_rn = 1 and trade_area_id is not null,coalesce (order_amount,0),0))
--              when grouping (city_id) = 0
--              then sum(if(order_rn = 1 and city_id is not null,coalesce (order_amount,0),0))
--              when grouping (brand_id) = 0
--              then sum(if(brand_goods_rn = 1 and brand_id is not null,coalesce (total_price,0),0))
--              when grouping (min_class_id) = 0
--              then sum(if(minclass_goods_rn = 1 and min_class_id is not null,coalesce (total_price,0),0))
--              when grouping (mid_class_id) = 0
--              then sum(if(midclass_goods_rn = 1 and mid_class_id is not null,coalesce (total_price,0),0))
--              when grouping (max_class_id) = 0
--              then sum(if(maxclass_goods_rn = 1 and max_class_id is not null,coalesce (total_price,0),0))
--              when grouping (dt) = 0
--              then sum(if(order_rn = 1 and dt is not null,coalesce (order_amount,0),0))
--              else null
--              end as sale_amt,
--         case when grouping (store_id) = 0
--              then sum(if(order_rn = 1 and store_id is not null,coalesce (plat_fee,0),0))
--              when grouping (trade_area_id) = 0
--              then sum(if(order_rn = 1 and trade_area_id is not null,coalesce (plat_fee,0),0))
--              when grouping (city_id) = 0
--              then sum(if(order_rn = 1 and city_id is not null,coalesce (plat_fee,0),0))
--              when grouping (brand_id) = 0
--              then null
--              when grouping (min_class_id) = 0
--              then null
--              when grouping (mid_class_id) = 0
--              then null
--              when grouping (max_class_id) = 0
--              then null
--              when grouping (dt) = 0
--              then sum(if(order_rn = 1 and dt is not null,coalesce (plat_fee,0),0))
--              else null
--              end as plat_amt
-- from tmp group by
-- grouping sets ((dt),--日期
--                (dt,city_id,city_name),--日期+城市
--                (dt,city_id,city_name,trade_area_id,trade_area_name),--日期+城市+商圈
--                (dt,city_id,city_name,trade_area_id,trade_area_name,store_id,store_name),--日期+城市+商圈+店铺
--                (dt,brand_id,brand_name),--日期+品牌
--                (dt,max_class_id,max_class_name),--日期+大类
--                (dt,max_class_id,max_class_name,mid_class_id,mid_class_name),--日期+大类+中类
--                (dt,max_class_id,max_class_name,mid_class_id,mid_class_name,min_class_id,min_class_name)-- 日期+大类+中类+小类
-- )

-- sku表
--下单次数，下单件数，下单金额
--表 order——detail
-- 字段：
--order——id
--buy_num
--total_price
-- 被支付次数，被支付件数，被支付金额
--表 order——detail
-- 字段：
-- order——state
--is_pay 1表示已支付
--
--order_id 被支付次数
--buy_num 被支付件数
--total_price 被支付金额
-- 被退款次数，被退款件数，被退款金额
--表 order——detail
-- 字段：
--refund_id 不为空表示有退款
-- refund_state 为5表示退款完成
-- 字段
--order_id 退款次数
--buy_num 退款件数
--total_price 退款金额
-- 加入购物车次数，加入购物车件数
-- 表：dwd.fact_shop_cart
--字段：
--id的次数
--buy_num 件数
--create_time
--被收藏数
--表dwd.fact_goods_collect
--字段：id
-- 好评数，中评数，差评数
--表，dwd.fact_goods_evaluation_detail
--geval_scores_goods
-- >9 好评
-- >6 <9 中评
-- <6 差评
-- with order_tmp as
--          (select dt,
--                  order_id,   --订单id
--                  goods_id,   --商品id
--                  goods_name,--商品名称
--                  buy_num,--购买商品数量
--                  total_price,--商品总金额（数量*单价）
--                  is_pay,
--                  refund_id,--支付状态（1表示已经支付）
--                  row_number () over(partition by order_id,goods_id) as rn
--           from hive.yp_dwb.dwb_order_detail),
-- -- 下单次数，下单件数，下单金额
-- order_count as (select
--     dt,
--     goods_id ,
--     goods_name ,
--     count(order_id) as order_count,
--     sum(buy_num) as order_num,
--     sum(total_price) as order_amount
-- from order_tmp
-- where rn = 1
-- group by dt,goods_id,goods_name),
-- -- 支付次数，支付件数，支付金额
-- payment_count_tmp as (select
--     dt,
--     goods_id ,
--     goods_name ,
--     count(order_id) as payment_count,
--     sum(buy_num) as payment_num,
--     sum(total_price) as payment_amount
-- from order_tmp
-- where rn = 1 and is_pay = 1
-- group by dt,goods_id,goods_name),
-- -- 退款次数，退款件数，退款金额
-- refund_count as (select
--     dt,
--     goods_id as sku_id,
--     goods_name as sku_name,
--     count(order_id) as refund_count,
--     sum(buy_num) as refund_num,
--     sum(total_price) as refund_amount
-- from order_tmp
-- where rn = 1 and refund_id is not null
-- group by dt,goods_id,goods_name),
-- -- 加入购物车次数，件数
-- cart_count_tmp as (select
--         substring (create_time,1,10) as dt,
--         goods_id,
--         count(id) as cart_count,
--         sum(buy_num) as cart_num
-- from hive.yp_dwd.fact_shop_cart
-- where end_date = '9999-99-99'
-- group by substring (create_time,1,10),goods_id),
-- -- 被收藏次数
-- favor_count_tmp as (select
--         substring (create_time,1,10) as dt,
--         goods_id,
--         count(id) as favor_count
-- from hive.yp_dwd.fact_goods_collect
-- where end_date = '9999-99-99'
-- group by substring (create_time,1,10),goods_id),
-- -- 好中差指标
-- evaluation_count as (select
--         substring (create_time,1,10) as dt,
--         goods_id,
--         sum(if (geval_scores_goods >= 9,1,0)) as evaluation_good_count,
--         sum(if (geval_scores_goods < 9 and 6 <= geval_scores_goods,1,0)) as evaluation_mid_count,
--         sum(if (geval_scores_goods < 6,1,0)) as evaluation_bad_count
-- from yp_dwd.fact_goods_evaluation_detail
-- group by substring (create_time,1,10),goods_id)


-- #登录次数
-- yp_dwd.fact_user_login
-- 	id
-- 	login_user
--登录次数

insert into yp_dws.dws_user_daycount
with login_count1 as (select dt,
                             login_user as user_id,
                             count(id)  as login_count
                      from yp_dwd.fact_user_login
                      group by dt, login_user),


-- #收藏店铺数、收藏商品数
-- yp_dwd.fact_store_collect
-- 	id
-- 	user_id
-- 店铺收藏次数
     store_collect_count1 as (select count(id)                     as store_collect_count,
                                     user_id,
                                     substring(create_time, 1, 10) as dt
                              from yp_dwd.fact_store_collect
                              where end_date = '9999-99-99'
                              group by user_id, substring(create_time, 1, 10)
     ),
-- 商品收藏次数
     goods_collect_count1 as (
         select
         user_id,
                substring(create_time, 1, 10) as dt,
                count(id)as goods_collect_count
                from yp_dwd.fact_goods_collect
         where end_date = '9999-99-99'
         group by user_id, substring(create_time, 1, 10)
     ),

-- #加入购物车次数、加入购物车金额
-- yp_dwd.fact_shop_cart
-- yp_dwb.dwb_goods_detail
-- 	#因为购物车中没有金额，因此需要和商品详情表进行关联
-- 	goods_promotion_price: 商品促销价格(售价)

     cart_count1 as (select substring(c.create_time, 1, 10) as dt,
                            c.buyer_id                      as user_id,
                            count(c.id)                     as cart_count,
                            sum(d.goods_promotion_price)    as cart_price_count
                     from yp_dwd.fact_shop_cart c,
                          yp_dwb.dwb_goods_detail d
                     where end_date = '9999-99-99'
                       and c.goods_id = d.id
                     group by c.buyer_id, substring(c.create_time, 1, 10)),
-- #下单次数、下单金额
-- yp_dwd.fact_shop_order
-- yp_dwd.fact_shop_order_address_detail
-- 	#通过订单主副表可以提供
     order_count1 as (select substring(s.create_time, 1, 10) as dt,
                             s.buyer_id                      as user_id,
                             count(s.id)                     as order_count,
                             sum(d.order_amount)             as order_amount
                      from yp_dwd.fact_shop_order s,
                           yp_dwd.fact_shop_order_address_detail d
                      where s.end_date = '9999-99-99'
                        and s.id = d.id
                        and d.end_date = '9999-99-99'
                        and s.is_valid = 1
                      group by substring(s.create_time, 1, 10), s.buyer_id),
-- #支付次数、支付金额
-- yp_dwd.fact_trade_record
     payment_count1 as (select substring(create_time, 1, 10) as dt,
                               user_id,
                               count(id)                     as payment_count,
                               sum(trade_true_amount)        as payment_amount
                        from yp_dwd.fact_trade_record
                        where status = 1
                          and is_valid = 1
                          and trade_type in (1, 11)
                        group by user_id, substring(create_time, 1, 10)),

     unionall as (
         select lc.login_count,
                0 as store_collect_count,
                0 as goods_collect_count,
                0 as cart_count,
                0 as cart_amount,
                0 as order_count,
                0 as order_amount,
                0 as payment_count,
                0 as payment_amount,
                user_id,
                dt
         from login_count1 lc
         union all
         select 0 as login_count,
                scc.store_collect_count,
                0 as goods_collect_count,
                0 as cart_count,
                0 as cart_amount,
                0 as order_count,
                0 as order_amount,
                0 as payment_count,
                0 as payment_amount,
                user_id,
                dt
         from store_collect_count1 scc
         union all
         select 0 as login_count,
                0 as store_collect_count,
                gcc.goods_collect_count,
                0 as cart_count,
                0 as cart_amount,
                0 as order_count,
                0 as order_amount,
                0 as payment_count,
                0 as payment_amount,
                user_id,
                dt
         from goods_collect_count1 gcc
         union all
         select 0                   as login_count,
                0                   as store_collect_count,
                0                   as goods_collect_count,
                cc.cart_count,
                cc.cart_price_count as cart_amount,
                0                   as order_count,
                0                   as order_amount,
                0                   as payment_count,
                0                   as payment_amount,
                user_id,
                dt
         from cart_count1 cc
         union all
         select 0 as login_count,
                0 as store_collect_count,
                0 as goods_collect_count,
                0 as cart_count,
                0 as cart_amount,
                oc.order_count,
                oc.order_amount,
                0 as payment_count,
                0 as payment_amount,
                user_id,
                dt
         from order_count1 oc
         union all
         select 0 as login_count,
                0 as store_collect_count,
                0 as goods_collect_count,
                0 as cart_count,
                0 as cart_amount,
                0 as order_count,
                0 as order_amount,
                pc.payment_count,
                pc.payment_amount,
                user_id,
                dt
         from payment_count1 pc)

select user_id,
       sum(login_count)         as
           login_count,
       sum(store_collect_count) as
           store_collect_count,
       sum(goods_collect_count) as
           goods_collect_count,
       sum(cart_count)          as
           cart_count,
       sum(cart_amount)         as
           cart_amount,
       sum(order_count)         as
           order_count,
       sum(order_amount)        as
           order_amount,
       sum(payment_count)       as
           payment_count,
       sum(payment_amount)      as
           payment_amount,
       dt
from unionall
group by dt, user_id;





