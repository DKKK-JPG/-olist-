USE olist;
SET FOREIGN_KEY_CHECKS = 0;

-- 1) customers
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

-- 2) products
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, 
 @product_category_name,
 @product_name_length, 
 @product_description_length,
 @product_photos_qty, 
 @product_weight_g, 
 @product_length_cm, 
 @product_height_cm, 
 @product_width_cm,
 @product_category_name_english)
SET
product_category_name = NULLIF(@product_category_name, ''),
product_name_length = NULLIF(@product_name_length, ''),
product_description_length = NULLIF(@product_description_length, ''),
product_photos_qty = NULLIF(@product_photos_qty, ''),
product_weight_g = NULLIF(@product_weight_g, ''),
product_length_cm = NULLIF(@product_length_cm, ''),
product_height_cm = NULLIF(@product_height_cm, ''),
product_width_cm = NULLIF(@product_width_cm, ''),
product_category_name_english = NULLIF(@product_category_name_english, '');

-- 3) sellers
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/sellers.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(seller_id, seller_zip_code_prefix, seller_city, seller_state);

-- 4) orders
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, customer_id, order_status,
 @order_purchase_timestamp, @order_approved_at,
 @order_delivered_carrier_date, @order_delivered_customer_date,
 @order_estimated_delivery_date)
SET
	order_purchase_timestamp =
		CASE
			WHEN @order_purchase_timestamp IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@order_purchase_timestamp, '%m/%d/%Y %H:%i')
		END,
	order_approved_at =
		CASE
			WHEN @order_approved_at IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@order_approved_at, '%m/%d/%Y %H:%i')
		END,
	order_delivered_carrier_date =
		CASE
			WHEN @order_delivered_carrier_date IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@order_delivered_carrier_date, '%m/%d/%Y %H:%i')
		END,
	order_delivered_customer_date =
		CASE
			WHEN @order_delivered_customer_date IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@order_delivered_customer_date, '%m/%d/%Y %H:%i')
		END,
	order_estimated_delivery_date =
		CASE
			WHEN @order_estimated_delivery_date IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@order_estimated_delivery_date, '%m/%d/%Y %H:%i')
		END;
    
-- 5) order items
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, order_item_id, product_id, seller_id, @shipping_limit_date, price, freight_value)
SET shipping_limit_date = CASE
	WHEN @shipping_limit_date IN ('', 'NULL') THEN NULL
	ELSE STR_TO_DATE(@shipping_limit_date, '%m/%d/%Y %H:%i')
END;

-- 6) order payments
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/order_payments.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, payment_sequential, payment_type, payment_installments, payment_value);

-- 7) order reviews
LOAD DATA LOCAL INFILE 'D:/hkust/4020/assignment/3/raw_data/reviews.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(review_id, order_id, review_score, review_comment_title, review_comment_message,
 @review_creation_date, @review_answer_timestamp)
SET
	review_creation_date =
		CASE
			WHEN @review_creation_date IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@review_creation_date, '%m/%d/%Y %H:%i')
		END,
	review_answer_timestamp =
		CASE
			WHEN @review_answer_timestamp IN ('', 'NULL') THEN NULL
			ELSE STR_TO_DATE(@review_answer_timestamp, '%m/%d/%Y %H:%i')
		END,
	review_comment_title = NULLIF(review_comment_title, ''),
	review_comment_message = NULLIF(review_comment_message, '');	
SET FOREIGN_KEY_CHECKS = 1;