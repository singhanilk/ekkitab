use reference;

--
-- Seed data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 48.20), ('INR', 1.0), ('BRI', 71.20), ('CAN', 40);

--
-- Seed data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 50), ('1ktestdata', 30), 
                                                                           ('Penguin', 50), ('Unknown', 50),
                                                                           ('Amit', 70), ('Dolphin', 70),
                                                                           ('HarperCollins', 70), ('Hachette', 70),
                                                                           ('Jaico', 70), ('MediaStar', 70),
                                                                           ('NewIndiaBookSource', 70), ('OrientBlackSwan', 70),
                                                                           ('Oxford', 70), ('PearsonEducation', 70),
                                                                           ('PopularPrakasham', 70), ('Prakash', 70),
                                                                           ('Prism', 70), ('RandomHouse', 70),
                                                                           ('ResearchPress', 70), ('Rupa', 70),
                                                                           ('Vinayaka', 70), ('Westland', 70),
                                                                           ('CambridgeUniversityPress', 70), ('IndiaBooks', 70),
                                                                           ('Sage', 70);

--
-- Seed data for table `ek_supplier_params`
--

insert into ek_supplier_params (`info_source`, `publisher`, `supplier_discount`, `delivery_period`) values 
                               ('Penguin', 'Any', 33, 5),
                               ('Jaico', 'Any', 33, 5),
                               ('Amit', 'Any', 30, 5),
                               ('Dolphin', 'Any', 35, 5),
                               ('HarperCollins', 'Any', 35, 5),
                               ('Hachette', 'Any', 33, 5),
                               ('MediaStar', 'Any', 35, 5),
                               ('NewIndiaBookSource', 'Any', 33, 5),
                               ('OrientBlackSwan', 'Any', 33, 5),
                               ('Oxford', 'Any', 30, 5),
                               ('PearsonEducation', 'Any', 30, 5),
                               ('PopularPrakasham', 'Any', 20, 5),
                               ('Prakash', 'Any', 33, 5),
                               ('Prism', 'Any', 33, 5),
                               ('RandomHouse', 'Any', 30, 5),
                               ('ResearchPress', 'Any', 30, 5),
                               ('Rupa', 'Any', 30, 5),
                               ('Sage', 'Any', 30, 5),
                               ('Vinayaka', 'Any', 30, 5),
                               ('Westland', 'Any', 30, 5),
                               ('CambridgeUniversityPress', 'Any', 30, 5),
                               ('IndiaBooks', 'Any', 33, 5),
                               ('Unknown', 'Any', 25, 5);
