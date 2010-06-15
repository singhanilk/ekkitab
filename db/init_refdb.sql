use reference;

--
-- Seed data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 50.0), ('INR', 1.0), ('BRI', 80.0), ('CAN', 40);

--
-- Seed data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 20), ('1ktestdata', 30), 
                                                                           ('Penguin', 25), ('Unknown', 25),
                                                                           ('Amit', 25), ('Dolphin', 25),
                                                                           ('HarperCollins', 25), ('Hachette', 25),
                                                                           ('Jaico', 25), ('MediaStar', 25),
                                                                           ('NewIndiaBookSource', 25), ('OrientBlackSwan', 25),
                                                                           ('Oxford', 25), ('PearsonEducation', 25),
                                                                           ('PopularPrakasham', 25), ('Prakash', 25),
                                                                           ('Prism', 25), ('RandomHouse', 25),
                                                                           ('ResearchPress', 25), ('Rupa', 25),
                                                                           ('Sage', 25);

--
-- Seed data for table `ek_supplier_params`
--

insert into ek_supplier_params (`info_source`, `publisher`, `supplier_discount`, `delivery_period`) values 
                               ('Penguin', 'Any', 20, 5),
                               ('Jaico', 'Any', 20, 5),
                               ('Amit', 'Any', 20, 5),
                               ('Dolphin', 'Any', 20, 5),
                               ('HarperCollins', 'Any', 20, 5),
                               ('Hachette', 'Any', 20, 5),
                               ('MediaStar', 'Any', 20, 5),
                               ('NewIndiaBookSource', 'Any', 20, 5),
                               ('OrientBlackSwan', 'Any', 20, 5),
                               ('Oxford', 'Any', 20, 5),
                               ('PearsonEducation', 'Any', 20, 5),
                               ('PopularPrakasham', 'Any', 20, 5),
                               ('Prakash', 'Any', 20, 5),
                               ('Prism', 'Any', 20, 5),
                               ('RandomHouse', 'Any', 20, 5),
                               ('ResearchPress', 'Any', 20, 5),
                               ('Rupa', 'Any', 20, 5),
                               ('Sage', 'Any', 20, 5),
                               ('Unknown', 'Any', 20, 5);
