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
insert into table yp_dwb.dwb_order_detail partition (dt)
select
    -- 订单主表
    fso.id,
    fso.order_num,
    fso.buyer_id,
    fso.store_id,
    fso.order_from,
    fso.order_state,
    fso.create_date,
    fso.finnshed_time,
    fso.is_settlement,
    fso.is_delete,
    fso.evaluation_state,
    fso.way,
    fso.is_stock_up,
    -- 订单附表
    fsoad.order_amount,
    fsoad.discount_amount,
    fsoad.goods_amount,
    fsoad.is_delivery,
    fsoad.buyer_notes,
    fsoad.pay_time,
    fsoad.receive_time,
    fsoad.delivery_begin_time,
    fsoad.arrive_store_time,
    fsoad.arrive_time,
    fsoad.create_user,
    fsoad.create_time,
    fsoad.update_user,
    fsoad.update_time,
    fsoad.is_valid,
    -- 订单组
    fsog.group_id,
    fsog.is_pay,
    -- 订单支付金额
    fop.order_pay_amount           as group_pay_amount,
    -- 退款表
    fro.id                         as refund_id,
    fro.apply_date,
    fro.refund_reason,
    fro.refund_amount,
    fro.refund_state,
    --结算 分润
    fos.id                         as settle_id,
    fos.settlement_amount,
    fos.dispatcher_user_id,
    fos.dispatcher_money,
    fos.circle_master_user_id,
    fos.circle_master_money,
    fos.plat_fee,
    fos.store_money,
    fos.status,
    fos.settle_time,
    -- 订单评价
    fge.id                         as evaluation_id,
    fge.user_id                    as evaluation_user_id,
    fge.geval_scores,
    fge.geval_scores_speed,
    fge.geval_scores_service,
    fge.geval_isanony,
    fge.create_time                as evaluation_time,
    --订单配送
    fodi.id                        as delievery_id,
    fodi.dispatcher_order_state,
    fodi.delivery_fee,
    fodi.distance,
    fodi.dispatcher_code,
    fodi.receiver_name,
    fodi.receiver_phone,
    fodi.sender_name,
    fodi.sender_phone,
    fodi.create_time               as delievery_create_time,
    -- 商品快照
    fsogd.id                       as order_goods_id,
    fsogd.goods_id,
    fsogd.buy_num,
    fsogd.goods_price,
    fsogd.total_price,
    fsogd.goods_name,
    fsogd.goods_specification,
    fsogd.goods_type,
    fsogd.goods_brokerage,
    fsogd.is_refund                as is_goods_refund,
    substr(fso.create_time, 1, 10) as dt
from (select * from yp_dwd.fact_shop_order where end_date = '9999-99-99') fso
         left join yp_dwd.fact_shop_order_address_detail fsoad
                   on fso.id = fsoad.id and fsoad.end_date = '9999-99-99'
         left join yp_dwd.fact_shop_order_group fsog
                   on fsog.order_id = fso.id and fsog.end_date = '9999-99-99'
         left join yp_dwd.fact_order_pay fop
                   on fop.group_id = fsog.id and fop.end_date = '9999-99-99'
         left join yp_dwd.fact_refund_order fro
                   on fro.order_id = fso.id and fro.end_date = '9999-99-99'
         left join yp_dwd.fact_order_settle fos
                   on fos.order_id == fso.id and fos.end_date = '9999-99-99'
         left join yp_dwd.fact_shop_order_goods_details fsogd
                   on fsogd.order_id == fso.id and fsogd.end_date = '9999-99-99'
         left join yp_dwd.fact_goods_evaluation fge
                   on fge.order_id == fso.id and fge.is_valid = 1
         left join yp_dwd.fact_order_delievery_item fodi
                   on fodi.shop_order_id = fso.id and fodi.is_valid = 1;


insert overwrite table yp_dwb.dwb_shop_detail partition (dt)
select ds.id,
       ds.address_info,
       ds.name                       as store_name,
       ds.is_pay_bond,
       ds.trade_area_id,
       ds.delivery_method,
       ds.store_type,
       ds.is_primary,
       ds.parent_store_id,

       dta.name                      as trade_area_name,

       d3.code                       as province_id,
       d2.code                       as city_id,
       d1.code                       as area_id,
       d3.name                       as province_name,
       d2.name                       as city_name,
       d1.name                       as area_name,
       substr(ds.create_time, 1, 10) as dt
from (select * from yp_dwd.dim_store where end_date = '9999-99-99') ds
         left join yp_dwd.dim_trade_area dta
                   on ds.trade_area_id = dta.id and dta.end_date = '9999-99-99'
         left join yp_dwd.dim_location dl
                   on dl.correlation_id = ds.id and dl.end_date = '9999-99-99'
                       and dl.type = 2
         left join yp_dwd.dim_district d1 on d1.code = dl.adcode
         left join yp_dwd.dim_district d2 on d2.id = d1.pid
         left join yp_dwd.dim_district d3 on d3.id = d2.pid;
insert into table  yp_dwb.dwb_goods_detail partition (dt)
select dg.id,
       dg.store_id,
       dg.class_id,
       dg.store_class_id,
       dg.brand_id,
       dg.goods_name,
       dg.goods_specification,
       dg.search_name,
       dg.goods_sort,
       dg.goods_market_price,
       dg.goods_price,
       dg.goods_promotion_price,
       dg.goods_storage,
       dg.goods_limit_num,
       dg.goods_unit,
       dg.goods_state,
       dg.goods_verify,
       dg.activity_type,
       dg.discount,
       dg.seckill_begin_time,
       dg.seckill_end_time,
       dg.seckill_total_pay_num,
       dg.seckill_total_num,
       dg.seckill_price,
       dg.top_it,
       dg.create_user,
       dg.create_time,
       dg.update_user,
       dg.update_time,
       dg.is_valid,
       case
           when dgc1.level = 3
               then dgc1.id
           else null
           end
                                     as min_class_id,
       case
           when dgc1.level = 3
               then dgc1.name
           else null
           end
                                     as min_class_name,
       case
           when dgc1.level = 2
               then dgc1.id
           when dgc2.level = 2
               then dgc2.id
           else null
           end
                                     as mid_class_id,
       case
           when dgc1.level = 2
               then dgc1.name
           when dgc2.level = 2
               then dgc2.name
           else null
           end
                                     as mid_class_name,
       case
           when dgc1.level = 1
               then dgc1.id
           when dgc2.level = 1
               then dgc2.id
           when dgc3.level = 1
               then dgc3.id
           else null
           end
                                     as max_class_id,
       case
           when dgc1.level = 1
               then dgc1.name
           when dgc2.level = 1
               then dgc2.name
           when dgc3.level = 1
               then dgc3.name
           else null
           end
                                     as max_class_name,
       db.brand_name,
       substr(dg.create_time, 1, 10) as dt
from (select * from yp_dwd.dim_goods where end_date = '9999-99-99') dg
         left join yp_dwd.dim_brand db
                   on dg.brand_id = db.id and db.end_date = '9999-99-99'
         left join yp_dwd.dim_goods_class dgc1
                   on dg.store_class_id = dgc1.id and dgc1.end_date = '9999-99-99'
         left join yp_dwd.dim_goods_class dgc2
                   on dgc1.parent_id = dgc2.id and dgc2.end_date = '9999-99-99'
         left join yp_dwd.dim_goods_class dgc3
                   on dgc2.parent_id = dgc3.id and dgc3.end_date = '9999-99-99';