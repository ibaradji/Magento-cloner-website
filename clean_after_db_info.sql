#Script de mise a jour de la bd

SET SQL_SAFE_UPDATES = 0;
update mage_core_config_data SET value = 'http://siteinternet/' WHERE path = 'web/unsecure/base_url';
update mage_core_config_data SET value = 'https://siteinternet/' WHERE path = 'web/secure/base_url';
update mage_core_config_data SET value = 'siteinternet' WHERE path = 'sales_pdf/header/website';

#change the cookie domain
UPDATE mage_core_config_data SET value='siteinternet' where path = 'web/cookie/cookie_domain';

#Avoid the redirection when not in live site
update mage_core_config_data SET value = '0' WHERE path = 'web/secure/use_in_frontend';
update mage_core_config_data SET value = '0' WHERE path = 'web/secure/use_in_adminhtml';

#change the value of url for unsecure
update mage_core_config_data SET value = '{{unsecure_base_url}}skin/' WHERE path = 'web/unsecure/base_skin_url';
update mage_core_config_data SET value = '{{unsecure_base_url}}media/' WHERE path = 'web/unsecure/base_media_url';
update mage_core_config_data SET value = '{{unsecure_base_url}}js/' WHERE path = 'web/unsecure/base_js_url';

#change the value of url for secure
update mage_core_config_data SET value = '{{secure_base_url}}skin/' WHERE path = 'web/secure/base_skin_url';
update mage_core_config_data SET value = '{{secure_base_url}}/media/' WHERE path = 'web/secure/base_media_url';
update mage_core_config_data SET value = '{{unsecure_base_url}}js/' WHERE path = 'web/secure/base_js_url';

#change email  
update mage_core_config_data set value = 'ibaradji@company.re' where value ='satisfaction@company.com';
update mage_core_config_data set value = 'ibaradji@company.re' where value ='super@company.com';
update mage_pmc_shipment_origine set email='ibaradji@company.re' where status_code='d_125806';

#change user admin to testadmin
delete from mage_admin_user where username='admin';


# reset customers
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE mage_customer_address_entity;
TRUNCATE mage_customer_address_entity_datetime;
TRUNCATE mage_customer_address_entity_decimal;
TRUNCATE mage_customer_address_entity_int;
TRUNCATE mage_customer_address_entity_text;
TRUNCATE mage_customer_address_entity_varchar;
TRUNCATE mage_customer_entity;
TRUNCATE mage_customer_entity_datetime;
TRUNCATE mage_customer_entity_decimal;
TRUNCATE mage_customer_entity_int;
TRUNCATE mage_customer_entity_text;
TRUNCATE mage_customer_entity_varchar;
TRUNCATE mage_log_customer;
TRUNCATE mage_log_visitor;
TRUNCATE mage_log_visitor_info;

ALTER TABLE mage_customer_address_entity AUTO_INCREMENT=1;
ALTER TABLE mage_customer_address_entity_datetime AUTO_INCREMENT=1;
ALTER TABLE mage_customer_address_entity_decimal AUTO_INCREMENT=1;
ALTER TABLE mage_customer_address_entity_int AUTO_INCREMENT=1;
ALTER TABLE mage_customer_address_entity_text AUTO_INCREMENT=1;
ALTER TABLE mage_customer_address_entity_varchar AUTO_INCREMENT=1;
ALTER TABLE mage_customer_entity AUTO_INCREMENT=1;
ALTER TABLE mage_customer_entity_datetime AUTO_INCREMENT=1;
ALTER TABLE mage_customer_entity_decimal AUTO_INCREMENT=1;
ALTER TABLE mage_customer_entity_int AUTO_INCREMENT=1;
ALTER TABLE mage_customer_entity_text AUTO_INCREMENT=1;
ALTER TABLE mage_customer_entity_varchar AUTO_INCREMENT=1;
ALTER TABLE mage_log_customer AUTO_INCREMENT=1;
ALTER TABLE mage_log_visitor AUTO_INCREMENT=1;
ALTER TABLE mage_log_visitor_info AUTO_INCREMENT=1;

#For Orders
TRUNCATE `mage_sales_flat_creditmemo`; 
TRUNCATE `mage_sales_flat_creditmemo_comment`; 
TRUNCATE `mage_sales_flat_creditmemo_grid`; 
TRUNCATE `mage_sales_flat_creditmemo_item`; 
TRUNCATE `mage_sales_flat_invoice`; 
TRUNCATE `mage_sales_flat_invoice_comment`; 
TRUNCATE `mage_sales_flat_invoice_grid`; 
TRUNCATE `mage_sales_flat_invoice_item`; 
TRUNCATE `mage_sales_flat_order`; 
TRUNCATE `mage_sales_flat_order_address`; 
TRUNCATE `mage_sales_flat_order_grid`; 
TRUNCATE `mage_sales_flat_order_item`; 
TRUNCATE `mage_sales_flat_order_payment`; 
TRUNCATE `mage_sales_flat_order_status_history`; 
TRUNCATE `mage_sales_flat_quote`; 
TRUNCATE `mage_sales_flat_quote_address`; 
TRUNCATE `mage_sales_flat_quote_address_item`; 
TRUNCATE `mage_sales_flat_quote_item`; 
TRUNCATE `mage_sales_flat_quote_item_option`; 
TRUNCATE `mage_sales_flat_quote_payment`; 
TRUNCATE `mage_sales_flat_quote_shipping_rate`; 
TRUNCATE `mage_sales_flat_shipment`; 
TRUNCATE `mage_sales_flat_shipment_comment`; 
TRUNCATE `mage_sales_flat_shipment_grid`; 
TRUNCATE `mage_sales_flat_shipment_item`; 
TRUNCATE `mage_sales_flat_shipment_track`; 
TRUNCATE `mage_sales_invoiced_aggregated`; 
TRUNCATE `mage_sales_invoiced_aggregated_order`; 
TRUNCATE `mage_sales_payment_transaction`;
TRUNCATE `mage_sales_order_aggregated_created`; 
TRUNCATE `mage_sendfriend_log`; 
TRUNCATE `mage_tag`; 
TRUNCATE `mage_tag_relation`; 
TRUNCATE `mage_tag_summary`; 
TRUNCATE `mage_wishlist`; 
TRUNCATE `mage_log_quote`; 
TRUNCATE `mage_report_event`; 
ALTER TABLE `mage_sales_flat_creditmemo` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_creditmemo_comment` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_creditmemo_grid` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_creditmemo_item` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_invoice` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_invoice_comment` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_invoice_grid` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_invoice_item` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_order` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_order_address` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_order_grid` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_order_item` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_order_payment` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_order_status_history` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote_address` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote_address_item` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote_item` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote_item_option` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote_payment` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_quote_shipping_rate` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_shipment` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_shipment_comment` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_shipment_grid` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_shipment_item` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_flat_shipment_track` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_invoiced_aggregated` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_invoiced_aggregated_order` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_payment_transaction` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sales_order_aggregated_created` AUTO_INCREMENT=1; 
ALTER TABLE `mage_sendfriend_log` AUTO_INCREMENT=1; 
ALTER TABLE `mage_tag` AUTO_INCREMENT=1; 
ALTER TABLE `mage_tag_relation` AUTO_INCREMENT=1; 
ALTER TABLE `mage_tag_summary` AUTO_INCREMENT=1; 
ALTER TABLE `mage_wishlist` AUTO_INCREMENT=1; 
ALTER TABLE `mage_log_quote` AUTO_INCREMENT=1; 
ALTER TABLE `mage_report_event` AUTO_INCREMENT=1; 

#clean cache
TRUNCATE `mage_core_session`; 

SET FOREIGN_KEY_CHECKS=1;


#recreate
CREATE TABLE `mage_catalog_product_index_price_tmp` (
  `entity_id` int(10) unsigned NOT NULL COMMENT 'Entity ID',
  `customer_group_id` smallint(5) unsigned NOT NULL COMMENT 'Customer Group ID',
  `website_id` smallint(5) unsigned NOT NULL COMMENT 'Website ID',
  `tax_class_id` smallint(5) unsigned DEFAULT '0' COMMENT 'Tax Class ID',
  `price` decimal(12,4) DEFAULT NULL COMMENT 'Price',
  `final_price` decimal(12,4) DEFAULT NULL COMMENT 'Final Price',
  `min_price` decimal(12,4) DEFAULT NULL COMMENT 'Min Price',
  `max_price` decimal(12,4) DEFAULT NULL COMMENT 'Max Price',
  `tier_price` decimal(12,4) DEFAULT NULL COMMENT 'Tier Price',
  `group_price` decimal(12,4) DEFAULT NULL COMMENT 'Group price',
  `zone_id` smallint(6) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entity_id`,`customer_group_id`,`website_id`,`zone_id`),
  KEY `IDX_OZSS_CATALOG_PRODUCT_INDEX_PRICE_TMP_CUSTOMER_GROUP_ID` (`customer_group_id`),
  KEY `IDX_OZSS_CATALOG_PRODUCT_INDEX_PRICE_TMP_WEBSITE_ID` (`website_id`),
  KEY `IDX_OZSS_CATALOG_PRODUCT_INDEX_PRICE_TMP_MIN_PRICE` (`min_price`),
  KEY `IDX_CATALOG_PRODUCT_INDEX_PRICE_TMP_ZONE_ID` (`zone_id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8 COMMENT='Catalog Product Price Indexer Temp Table';

