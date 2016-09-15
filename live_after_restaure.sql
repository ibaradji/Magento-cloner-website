#Script de mise a jour de la bd live

SET SQL_SAFE_UPDATES = 0;
update mage_core_config_data SET value = 'http://siteinternet/' WHERE path = 'web/unsecure/base_url';
update mage_core_config_data SET value = 'https://siteinternet/' WHERE path = 'web/secure/base_url';
update mage_core_config_data SET value = 'siteinternet' WHERE path = 'sales_pdf/header/website';

#change the cookie domain
UPDATE mage_core_config_data SET value='siteinternet' where path = 'web/cookie/cookie_domain';

#Avoid the redirection when not in live site
update mage_core_config_data SET value = '1' WHERE path = 'web/secure/use_in_frontend';
update mage_core_config_data SET value = '1' WHERE path = 'web/secure/use_in_adminhtml';

#change the value of url for unsecure
update mage_core_config_data set value='https://cdn.company.com/live-skin/' where path='web/unsecure/base_skin_url';
update mage_core_config_data set value='https://cdn.company.com/live-media/' where path='web/unsecure/base_media_url';
update mage_core_config_data set value='https://cdn.company.com/live-js/' where path='web/unsecure/base_js_url';

#change the value of url for secure
update mage_core_config_data set value='https://cdn.company.com/live-skin/' where path='web/secure/base_skin_url';
update mage_core_config_data set value='https://cdn.company.com/live-media/' where path='web/secure/base_media_url';
update mage_core_config_data set value='https://cdn.company.com/live-js/' where path='web/secure/base_js_url';

#restaure the prod emails  
update mage_core_config_data set value ='satisfaction@company.com' where path='trans_email/ident_general/email';
update mage_core_config_data set value ='satisfaction@company.com' where path='trans_email/ident_sales/email';
update mage_core_config_data set value ='satisfaction@company.com' where path='trans_email/ident_support/email';
update mage_core_config_data set value ='satisfaction@company.com' where path='trans_email/ident_custom1/email';
update mage_core_config_data set value ='satisfaction@company.com' where path='trans_email/ident_custom2/email';
update mage_core_config_data set value ='satisfaction@company.com' where path='contacts/email/recipient_email';
update mage_core_config_data set value ='satisfaction@company.com' where path='payment/authorizenet/merchant_email';
update mage_core_config_data set value ='tech@company.com' where path='sitemap/generate/error_email';
update mage_core_config_data set value ='satisfaction@company.com' where path='sales_pdf/header/email';
update mage_core_config_data set value ='order@company.com' where path='sales_email/order/copy_to';
update mage_core_config_data set value ='invoice@company.com' where path='sales_email/invoice/copy_to';
update mage_core_config_data set value ='ship@company.com' where path='sales_email/shipment/copy_to';
update mage_core_config_data set value ='ship@company.com' where path='sales_email/shipment_comment/copy_to';
update mage_core_config_data set value ='order@company.com' where path='sales_email/creditmemo/copy_to';
update mage_core_config_data set value ='satisfaction@company.com' where path='paypal/general/business_account';
update mage_core_config_data set value ='satisfaction@company.com' where path='system/log/error_email';
update mage_core_config_data set value ='satisfaction@company.com' where path='payment/optimal_hosted/merchant_email';
update mage_pmc_shipment_origine set email='entrepot@company.com , satisfaction@company.com' where status_code='d_125806';

#clean cache
TRUNCATE `mage_core_session`; 

SET FOREIGN_KEY_CHECKS=1;