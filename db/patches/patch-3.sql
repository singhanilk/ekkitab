-- Patch 3
-- Author: Anisha S.

UPDATE `core_config_data`  set `value` =  'American Express' where `path` ='payment/billdesk/title';

UPDATE `core_config_data`  set `value` =  '0' where `path` ='payment/paypal_standard/active';

