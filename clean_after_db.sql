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

