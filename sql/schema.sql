CREATE DATABASE IF NOT EXISTS olist;
USE olist;

-- Customers table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY, -- 作为下单顾客的唯一标识符，同一个账户可能有多个ID
    customer_unique_id VARCHAR(32) NOT NULL, -- 作为账户的唯一标识符，同一个账户所有下单时的ID都相同
    customer_zip_code_prefix INTEGER, -- 邮政编码
    customer_city VARCHAR(100), -- 城市
    customer_state CHAR(2) -- 州/省份
);

-- Products table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id VARCHAR(32) PRIMARY KEY, -- 商品ID
    product_category_name VARCHAR(100), -- 商品品类名（葡语）
    product_name_length INTEGER, -- 商品名称长度
    product_description_length INTEGER, -- 商品描述长度
    product_photos_qty INTEGER, -- 商品图片数量
    product_weight_g INTEGER, -- 商品重量（克）
    product_length_cm INTEGER, -- 商品长度（厘米）
    product_height_cm INTEGER, -- 商品高度（厘米）
    product_width_cm INTEGER, -- 商品宽度（厘米）
    product_category_name_english VARCHAR(100) -- 商品品类名（英语）
);

-- Sellers table
DROP TABLE IF EXISTS sellers;
CREATE TABLE sellers (
    seller_id VARCHAR(32) PRIMARY KEY, -- 卖家ID
    seller_zip_code_prefix INTEGER, -- 邮政编码
    seller_city VARCHAR(100), -- 城市
    seller_state CHAR(2) -- 州/省份
);

-- Orders table
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY, -- 订单ID
    customer_id VARCHAR(32), -- 顾客ID
    order_status VARCHAR(20), -- 订单状态
    order_purchase_timestamp TIMESTAMP, -- 下单时间
    order_approved_at TIMESTAMP, -- 支付审批通过时间
    order_delivered_carrier_date TIMESTAMP, -- 交付物流承运商时间
    order_delivered_customer_date TIMESTAMP, -- 实际送达顾客时间
    order_estimated_delivery_date TIMESTAMP, -- 预计送达日期

    CONSTRAINT fk_orders_customer 
    FOREIGN KEY (customer_id) 
    REFERENCES customers(customer_id)
);

-- Order Items table
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_id VARCHAR(32), -- 订单ID
    order_item_id INTEGER, -- 同一订单内商品项序号
    product_id VARCHAR(32), -- 商品ID
    seller_id VARCHAR(32), -- 卖家ID
    shipping_limit_date TIMESTAMP, -- 商家最晚发货时限
    price DECIMAL(10, 2), -- 商品价格
    freight_value DECIMAL(10, 2), -- 对于每一个订单，平摊到其中一件商品的运费金额
    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_order_items_orders 
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_products 
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_order_items_sellers 
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- Order Payments table
DROP TABLE IF EXISTS order_payments;
CREATE TABLE order_payments (
    order_id VARCHAR(32), -- 订单ID
    payment_sequential INTEGER, -- 同一订单的支付方式序号
    payment_type VARCHAR(20), -- 支付方式
    payment_installments INTEGER, -- 分期期数
    payment_value DECIMAL(10, 2), -- 支付金额
    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_order_payments_orders 
    FOREIGN KEY (order_id) 
    REFERENCES orders(order_id)
);

-- Order Reviews table
DROP TABLE IF EXISTS order_reviews;
CREATE TABLE order_reviews (
    review_id VARCHAR(32) PRIMARY KEY, -- 评价ID
    order_id VARCHAR(32), -- 订单ID
    review_score INTEGER, -- 评分（1-5）
    review_comment_title TEXT, -- 评价标题
    review_comment_message TEXT, -- 评价内容
    review_creation_date TIMESTAMP, -- 评价创建时间
    review_answer_timestamp TIMESTAMP, -- 评价记录时间

    CONSTRAINT fk_order_reviews_orders 
    FOREIGN KEY (order_id) 
    REFERENCES orders(order_id)
);
