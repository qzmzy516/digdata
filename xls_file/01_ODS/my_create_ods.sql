-- step1 导入表到hive中
drop table if exists yp_ods.t_brand;
create table yp_ods.t_brand
(
    id          string,
    store_id    string comment '店铺id',
    brand_pt_id string comment '平台品牌库品牌Id',
    brand_name  string comment '品牌名称',
    brand_image string comment '品牌图片',
    initial     string comment '品牌首字母',
    sort        int comment '排序',
    is_use      tinyint comment '0禁用1启用',
    goods_state tinyint comment '商品品牌审核状态 1 审核中,2 通过,3 拒绝',
    create_user string,
    create_time string,
    update_user string,
    update_time string,
    is_valid    tinyint comment '0 ：失效，1 ：开启'
) comment '品牌（店铺）'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as ORC tblproperties ('orc.compress'='ZLIB');


drop table if exists yp_ods.t_date;
create table yp_ods.t_date
(
    dim_date_id           string comment '日期',
    date_code             string comment '日期编码',
    lunar_calendar        string comment '农历',
    year_code             string comment '年code',
    year_name             string comment '年名称',
    month_code            string comment '月份编码',
    month_name            string comment '月份名称',
    quanter_code          string comment '季度编码',
    quanter_name          string comment '季度名称',
    `year_month`          string comment '年月',
    year_week_code        string comment '一年中第几周',
    year_week_name        string comment '一年中第几周名称',
    year_week_code_cn     string comment '一年中第几周（中国）',
    year_week_name_cn     string comment '一年中第几周名称（中国',
    week_day_code         string comment '周几code',
    week_day_name         string comment '周几名称',
    day_week              string comment '周',
    day_week_cn           string comment '周(中国)',
    day_week_num          string comment '一周第几天',
    day_week_num_cn       string comment '一周第几天（中国）',
    day_month_num         string comment '一月第几天',
    day_year_num          string comment '一年第几天',
    date_id_wow           string comment '与本周环比的上周日期',
    date_id_mom           string comment '与本月环比的上月日期',
    date_id_wyw           string comment '与本周同比的上年日期',
    date_id_mym           string comment '与本月同比的上年日期',
    first_date_id_month   string comment '本月第一天日期',
    last_date_id_month    string comment '本月最后一天日期',
    half_year_code        string comment '半年code',
    half_year_name        string comment '半年名称',
    season_code           string comment '季节编码',
    season_name           string comment '季节名称',
    is_weekend            string comment '是否周末（周六和周日）',
    official_holiday_code string comment '法定节假日编码',
    official_holiday_name string comment '法定节假日',
    festival_code         string comment '节日编码',
    festival_name         string comment '节日',
    custom_festival_code  string comment '自定义节日编码',
    custom_festival_name  string comment '自定义节日',
    update_time           string comment '更新时间'
)
row format delimited fields terminated by  '\t'
stored as ORC tblproperties ('orc.compress'='ZLIB');

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://192.168.88.80:3306/yipin?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username root \
--password 123456 \
--query "select * from yipin.t_date where 1=1 and  \$CONDITIONS" \
--hcatalog-database yp_ods \
--hcatalog-table t_date \
-m 1