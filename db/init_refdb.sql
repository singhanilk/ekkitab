use reference;

--
-- Seed data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 50.0), ('INR', 1.0), ('BPS', 80.0);

--
-- Seed data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 20), ('1ktestdata', 30), ('Penguin', 25);

--
-- Seed data for table `ek_supplier_params`
--

insert into ek_supplier_params (`info_source`, `publisher`, `supplier_discount`, `delivery_period`) values 
                               ('Penguin', 'Dorling Kindersley', 21, 1),
                               ('Penguin', 'Penguin', 22, 2),
                               ('Penguin', 'Alistair Sawday', 23, 3),
                               ('Penguin', 'Allen Lane', 24, 4),
                               ('Penguin', 'Arkana', 35, 15),
                               ('Penguin', 'Claremont', 35, 15),
                               ('Penguin', 'Alpha', 35, 15),
                               ('Penguin', 'Daedalus Books', 35, 15),
                               ('Penguin', 'Fig Tree', 35, 15),
                               ('Penguin', 'Hamish Hamilton', 35, 15),
                               ('Penguin', 'HardWired', 35, 15),
                               ('Penguin', 'Helicon', 35, 15),
                               ('Penguin', 'LadyBird', 35, 15),
                               ('Penguin', 'Michael Joseph', 35, 15),
                               ('Penguin', 'Pelham', 35, 15),
                               ('Penguin', 'Peng Mod Classics', 35, 15),
                               ('Penguin', 'Peng Tcc Classics', 35, 15),
                               ('Penguin', 'BBC', 35, 15);
