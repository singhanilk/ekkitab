use reference;

--
-- Seed data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 50.0), ('INR', 1.0), ('BRI', 80.0), ('CAN', 40);

--
-- Seed data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 20), ('1ktestdata', 30), 
                                                                           ('Penguin', 25), ('Unknown', 25);

--
-- Seed data for table `ek_supplier_params`
--

insert into ek_supplier_params (`info_source`, `publisher`, `supplier_discount`, `delivery_period`) values 
                               ('Penguin', 'Any', 20, 5),
                               ('Jaico', 'Any', 20, 5),
                               ('Roli', 'Any', 20, 5),
                               ('Unknown', 'Any', 20, 5);
