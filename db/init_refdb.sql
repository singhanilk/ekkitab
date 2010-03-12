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
                               ('Penguin', 'Dorling Kindersley', 20, 5),
                               ('Penguin', 'Penguin', 20, 5),
                               ('Penguin', 'Alistair Sawday', 20, 5),
                               ('Penguin', 'Allen Lane', 20, 5),
                               ('Penguin', 'Arkana', 20, 5),
                               ('Penguin', 'Claremont', 20, 5),
                               ('Penguin', 'Alpha', 20, 5),
                               ('Penguin', 'Daedalus Books', 20, 5),
                               ('Penguin', 'Fig Tree', 20, 5),
                               ('Penguin', 'Hamish Hamilton', 20, 5),
                               ('Penguin', 'HardWired', 20, 5),
                               ('Penguin', 'Helicon', 20, 5),
                               ('Penguin', 'LadyBird', 20, 5),
                               ('Penguin', 'Michael Joseph', 20, 5),
                               ('Penguin', 'Pelham', 20, 5),
                               ('Penguin', 'Peng Mod Classics', 20, 5),
                               ('Penguin', 'Peng Tcc Classics', 20, 5),
                               ('Penguin', 'BBC', 20, 5);
