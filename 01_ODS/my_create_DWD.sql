-- 目标订单事实表
-- 开启动态分区
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
-- 创建DWD表格
drop table if exists yp_dwd.fact_shop_order;
create table yp_dwd.fact_shop_order
(
    id               string comment '根据一定规则生成的订单编号',
    order_num        string comment '订单序号',
    buyer_id         string comment '买家的userId',
    store_id         string comment '店铺的id',
    order_from       string comment '是来自于app还是小程序,或者pc 1.安卓; 2.ios; 3.小程序H5 ; 4.PC',
    order_state      int comment '订单状态:1.已下单; 2.已付款, 3. 已确认 ;4.配送; 5.已完成; 6.退款;7.已取消',
    create_date      string comment '下单时间',
    finnshed_time    timestamp comment '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
    is_settlement    tinyint comment '是否结算;0.待结算订单; 1.已结算订单;',
    is_delete        tinyint comment '订单评价的状态:0.未删除;  1.已删除;(默认0)',
    evaluation_state tinyint comment '订单评价的状态:0.未评价;  1.已评价;(默认0)',
    way              string comment '取货方式:SELF自提;SHOP店铺负责配送',
    is_stock_up      int comment '是否需要备货 0：不需要    1：需要    2:平台确认备货  3:已完成备货 4平台已经将货物送至店铺 ',
    create_user      string,
    create_time      string,
    update_user      string,
    update_time      string,
    is_valid         tinyint comment '是否有效  0: false; 1: true;   订单是否有效的标志',
    end_date         string COMMENT '拉链结束日期'
) partitioned by (start_date string) --拉链起始时间 也是表分区字段
    row format delimited
        fields terminated by '\t'
    stored as ORC
    tblproperties ('orc.compress' = 'SNAPPY');

insert overwrite table yp_dwd.fact_shop_order partition (start_date)
select id,
       order_num,
       buyer_id,
       store_id,
       case order_from
           when 1
               then 'android'
           when 2
               then 'ios'
           when 3
               then 'miniapp'
           when 4
               then 'pcweb'
           else 'other'
           end
                    as order_from,
       order_state,
       create_date,
       finnshed_time,
       is_settlement,
       is_delete,
       evaluation_state,
       way,
       is_stock_up,
       create_user,
       create_time,
       update_user,
       update_time,
       is_valid,
       '9999-99-99' as end_date,
       dt           as start_date
from yp_ods.t_shop_order;

-- step1 创建临时出存储数据
drop table if exists yp_dwd.fact_shop_order_tmp;
create table if not exists yp_dwd.fact_shop_order_tmp
(
    id               string comment '根据一定规则生成的订单编号',
    order_num        string comment '订单序号',
    buyer_id         string comment '买家的userId',
    store_id         string comment '店铺的id',
    order_from       string comment '是来自于app还是小程序,或者pc 1.安卓; 2.ios; 3.小程序H5 ; 4.PC',
    order_state      int comment '订单状态:1.已下单; 2.已付款, 3. 已确认 ;4.配送; 5.已完成; 6.退款;7.已取消',
    create_date      string comment '下单时间',
    finnshed_time    timestamp comment '订单完成时间,当配送员点击确认送达时,进行更新订单完成时间,后期需要根据订单完成时间,进行自动收货以及自动评价',
    is_settlement    tinyint comment '是否结算;0.待结算订单; 1.已结算订单;',
    is_delete        tinyint comment '订单评价的状态:0.未删除;  1.已删除;(默认0)',
    evaluation_state tinyint comment '订单评价的状态:0.未评价;  1.已评价;(默认0)',
    way              string comment '取货方式:SELF自提;SHOP店铺负责配送',
    is_stock_up      int comment '是否需要备货 0：不需要    1：需要    2:平台确认备货  3:已完成备货 4平台已经将货物送至店铺 ',
    create_user      string,
    create_time      string,
    update_user      string,
    update_time      string,
    is_valid         tinyint comment '是否有效  0: false; 1: true;   订单是否有效的标志',
    end_date         string COMMENT '拉链结束日期'
) partitioned by (start_date string) --拉链起始时间 也是表分区字段
    row format delimited
        fields terminated by '\t'
    stored as ORC
    tblproperties ('orc.compress' = 'SNAPPY');

insert overwrite table yp_dwd.fact_shop_order_tmp partition (start_date)
select id,
       order_num,
       buyer_id,
       store_id,
       case order_from
           when 1
               then 'android'
           when 2
               then 'ios'
           when 3
               then 'miniapp'
           when 4
               then 'pcweb'
           else 'other'
           end
                    as order_from,
       order_state,
       create_date,
       finnshed_time,
       is_settlement,
       is_delete,
       evaluation_state,
       way,
       is_stock_up,
       create_user,
       create_time,
       update_user,
       update_time,
       is_valid,
       '9999-99-99' as end_date,
       dt as start_date
from yp_ods.t_shop_order
where dt='2021-11-30'
union all
select a.id,
       a.order_num,
       a.buyer_id,
       a.store_id,
       case a.order_from
           when 1
               then 'android'
           when 2
               then 'ios'
           when 3
               then 'miniapp'
           when 4
               then 'pcweb'
           else 'other'
           end
                    as order_from,
       a.order_state,
       a.create_date,
       a.finnshed_time,
       a.is_settlement,
       a.is_delete,
       a.evaluation_state,
       a.way,
       a.is_stock_up,
       a.create_user,
       a.create_time,
       a.update_user,
       a.update_time,
       a.is_valid,
       if (b.id is null or a.end_date < '9999-99-99',a.end_date,date_sub(b.dt,1)) as end_date,
       a.start_date
from yp_dwd.fact_shop_order a  left join
(select *
from yp_ods.t_shop_order
where dt = '2021-11-30') b
on a.id=b.id;

select *
from yp_dwd.fact_shop_order_tmp where id='dd1910223851672f32';

insert overwrite table yp_dwd.fact_shop_order partition (start_date)
select * from fact_shop_order_tmp;

create  table yp_dwd.dim_district
(
    id    string comment '主键ID',
    code  string comment '区域编码',
    name  string comment '区域名称',
    pid   int comment '父级ID',
    alias string comment '别名'
)
row format delimited
fields terminated by '\t'
stored as ORC
tblproperties ('orc.compress' = 'SNAPPY');

insert overwrite table yp_dwd.dim_district
select id,
       code,
       name,
       pid,
       alias
from yp_ods.t_district
where code is not null and name is not null ;