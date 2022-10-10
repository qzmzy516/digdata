create database if not exists yp_dws;

CREATE TABLE yp_dws.dws_sale_daycount(
  --维度
   city_id string COMMENT '城市id',
   city_name string COMMENT '城市name',
   trade_area_id string COMMENT '商圈id',
   trade_area_name string COMMENT '商圈名称',
   store_id string COMMENT '店铺的id',
   store_name string COMMENT '店铺名称',
   brand_id string COMMENT '品牌id',
   brand_name string COMMENT '品牌名称',
   max_class_id string COMMENT '商品大类id',
   max_class_name string COMMENT '大类名称',
   mid_class_id string COMMENT '中类id',
   mid_class_name string COMMENT '中类名称',
   min_class_id string COMMENT '小类id',
   min_class_name string COMMENT '小类名称',

   group_type string COMMENT '分组类型：store，trade_area，city，brand，min_class，mid_class，max_class，all',

   --   =======日统计=======
   --   销售收入
   sale_amt DECIMAL(38,2) COMMENT '销售收入',
   --   平台收入
   plat_amt DECIMAL(38,2) COMMENT '平台收入',
   -- 配送成交额
   deliver_sale_amt DECIMAL(38,2) COMMENT '配送成交额',
   -- 小程序成交额
   mini_app_sale_amt DECIMAL(38,2) COMMENT '小程序成交额',
   -- 安卓APP成交额
   android_sale_amt DECIMAL(38,2) COMMENT '安卓APP成交额',
   --  苹果APP成交额
   ios_sale_amt DECIMAL(38,2) COMMENT '苹果APP成交额',
   -- PC商城成交额
   pcweb_sale_amt DECIMAL(38,2) COMMENT 'PC商城成交额',
   -- 成交单量
   order_cnt BIGINT COMMENT '成交单量',
   -- 参评单量
   eva_order_cnt BIGINT COMMENT '参评单量comment=>cmt',
   -- 差评单量
   bad_eva_order_cnt BIGINT COMMENT '差评单量negtive-comment=>ncmt',
   -- 配送成交单量
   deliver_order_cnt BIGINT COMMENT '配送单量',
   -- 退款单量
   refund_order_cnt BIGINT COMMENT '退款单量',
   -- 小程序成交单量
   miniapp_order_cnt BIGINT COMMENT '小程序成交单量',
   -- 安卓APP订单量
   android_order_cnt BIGINT COMMENT '安卓APP订单量',
   -- 苹果APP订单量
   ios_order_cnt BIGINT COMMENT '苹果APP订单量',
   -- PC商城成交单量
   pcweb_order_cnt BIGINT COMMENT 'PC商城成交单量'
)
COMMENT '销售主题日统计宽表'
PARTITIONED BY(dt STRING)
ROW format delimited fields terminated BY '\t'
stored AS orc tblproperties ('orc.compress' = 'SNAPPY');


create table test.t_order_detail(
    oid string comment '订单ID',
    goods_id string comment '商品ID',
    o_price int comment '订单总金额',
    g_num int comment '商品数量',
    g_price int comment '商品单价',
    brand_id string comment '品牌ID',
    dt string comment '日期'
) comment '订单详情宽表_简易模型'
row format delimited fields terminated by ',';

select *
from test.t_order_detail;
create table test.t_order_detail_dup(
    oid string comment '订单ID',
    goods_id string comment '商品ID',
    o_price int comment '订单总金额',
    g_num int comment '商品数量',
    g_price int comment '商品单价',
    brand_id string comment '品牌ID',
    dt string comment '日期'
) comment '订单详情宽表_复杂模型'
row format delimited fields terminated by ',';


select
    dt as "日期",
    case when grouping (dt,brand_id) = 0
         then count(distinct oid)
         else null end as "品牌订单量",
    case when grouping (dt,brand_id) = 0
         then sum(g_price)
         else null end as "品牌订单金额",
    case when grouping (dt,brand_id) = 1
         then count(distinct oid)
         else null end as "总订单量",
    case when grouping (dt,brand_id) = 1
         then sum(g_price)
         else null end as "总订单金额",
    case when grouping(brand_id) = 1 --没有品牌 就是分组1 否则就是2
        then 1
        else 2 end as group_id
from test.t_order_detail
group by
grouping sets((dt),(dt,brand_id));

