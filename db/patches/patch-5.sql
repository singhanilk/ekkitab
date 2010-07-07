-- Patch 5
-- Author: Anisha S.

UPDATE `core_config_data` set value='200' where path='carriers/flatrate/free_shipping_subtotal';

UPDATE `core_config_data` set value='200' where path='carriers/freeshipping/free_shipping_subtotal';

UPDATE `core_config_data`  set `value` =  '0' where `path` ='payment/billdesk/active';

UPDATE `core_config_data`  set `value` =  'Master / Visa / Debit Cards / NetBanking' where `path` ='payment/ccav/title';	

INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES
('default',0, 'carriers/freeshipping/specificcountry', 'IN');

UPDATE `core_config_data` set `value` ='&copy; 2009-10 Ekkitab Educational Services Pvt Ltd. All Rights Reserved.' where path='design/footer/copyright';