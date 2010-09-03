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
                                                                           ('Sage', 70), ('EuroKids', 70),
                                                                           ('SChand', 70), ('ParagonBooks', 70),
                                                                           ('Wiley', 70), ('Harvard', 70),
                                                                           ('TBH', 70), ('BookWorldEnterprises', 70),
                                                                           ('PanMacmillan', 70),
                                                                           ('UBS', 70), ('Viva', 70), ('Cambridge', 70);

--
-- Seed data for table `ek_supplier_params`
--

insert into ek_supplier_params (`info_source`, `publisher`, `supplier_discount`, `delivery_period`) values 
                               ('Penguin', 'Any', 33, 5),
                               ('Jaico', 'Any', 33, 3),
                               ('Amit', 'Any', 30, 3),
                               ('Dolphin', 'Any', 35, 3),
                               ('HarperCollins', 'Any', 35, 3),
                               ('Hachette', 'Any', 33, 3),
                               ('MediaStar', 'Any', 35, 3),
                               ('NewIndiaBookSource', 'Any', 33, 3),
                               ('OrientBlackSwan', 'Any', 33, 3),
                               ('Oxford', 'Any', 30, 3),
                               ('PearsonEducation', 'Any', 30, 3),
                               ('PopularPrakasham', 'Any', 20, 3),
                               ('Prakash', 'Any', 33, 3),
                               ('Prism', 'Any', 33, 3),
                               ('RandomHouse', 'Any', 30, 3),
                               ('ResearchPress', 'Any', 30, 3),
                               ('Rupa', 'Any', 30, 3),
                               ('Sage', 'Any', 30, 3),
                               ('Vinayaka', 'Any', 30, 3),
                               ('Westland', 'Any', 30, 3),
                               ('CambridgeUniversityPress', 'Any', 30, 3),
                               ('IndiaBooks', 'Any', 33, 3),
                               ('EuroKids', 'Any', 30, 3),
                               ('BookWorldEnterprises', 'Any', 30, 3),
                               ('TBH', 'Any', 30, 3),
                               ('Wiley', 'Any', 30, 3),
                               ('ParagonBooks', 'Any', 30, 3),
                               ('SChand', 'Any', 30, 3),
                               ('Harvard', 'Any', 30, 3),
                               ('UBS', 'Any', 30, 3),
                               ('Viva', 'Any', 30, 3),
                               ('Cambridge', 'Any', 30, 3),
                               ('PanMacmillan', 'Any', 25, 3),
                               ('Unknown', 'Any', 25, 5);
