use reference;

--
-- Dumping data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 50.0);
insert into ek_currency_conversion (`currency`, `conversion`) values ('INR', 1.0);

-- -------------------------------------------------------------------------------------

--
-- Dumping data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 20);
insert into ek_discount_setting (`info_source`, `discount_percent`) values ('1ktestdata', 30);
