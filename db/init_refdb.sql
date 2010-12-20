use reference;

--
-- Seed data for table `ek_currency_conversion`
--

insert into ek_currency_conversion (`currency`, `conversion`) values ('USD', 48.20), ('INR', 1.0), ('BRI', 71.20), ('CAN', 40);

--
-- Seed data for table `ek_discount_setting`
--

insert into ek_discount_setting (`info_source`, `discount_percent`) values ('Ingrams', 50), ('1ktestdata', 30), 
                                                                           ('Penguin', 33), ('Unknown', 50),
                                                                           ('Amit', 30), ('Dolphin', 35),
                                                                           ('HarperCollins', 35), ('Hachette', 33),
                                                                           ('Jaico', 25), ('MediaStar', 35),
                                                                           ('NewIndiaBookSource', 33), ('OrientBlackSwan', 25),
                                                                           ('Oxford', 30), ('PearsonEducation', 33),
                                                                           ('PopularPrakasham', 33), ('Prakash', 33),
                                                                           ('Prism', 33), ('RandomHouse', 33),
                                                                           ('ResearchPress', 30), ('Rupa', 33),
                                                                           ('Vinayaka', 30), ('Westland', 33),
                                                                           ('CambridgeUniversityPress', 33), ('IndiaBooks', 33),
                                                                           ('Sage', 33), ('EuroKids', 33),
                                                                           ('SChand', 30), ('ParagonBooks', 33),
                                                                           ('Wiley', 33), ('Harvard', 33),
                                                                           ('TBH', 33), ('BookWorldEnterprises', 33),
                                                                           ('PanMacmillan', 33),
                                                                           ('MacmillanIndia', 25),
                                                                           ('UBS', 25), ('Viva', 30), ('Cambridge', 33),
                                                                           ('CinnamonTeal', 35),
                                                                           ('Nari', 20),
                                                                           ('Prathambooks', 0),
                                                                           ('Navakarnataka', 15),
                                                                           ('Nbt', 25),
                                                                           ('Cbt', 15),
                                                                           ('Navneet', 0),
                                                                           ('Navajivan', 0),
                                                                           ('Ibn', 33),
                                                                           ('Tulika', 0),
                                                                           ('Roli', 30),
                                                                           ('Fortytwobookzgalaxy', 20),
                                                                           ('Anebooks', 33),
                                                                           ('Shroff', 30);

--
-- Seed data for table `ek_supplier_params`
--

insert into ek_supplier_params (`info_source`, `publisher`, `supplier_discount`, `delivery_period`) values 
                               ('Penguin', 'Any', 33, 5),
                               ('Jaico', 'Any', 25, 3),
                               ('Amit', 'Any', 30, 8),
                               ('Dolphin', 'Any', 35, 3),
                               ('HarperCollins', 'Any', 35, 3),
                               ('Hachette', 'Any', 33, 3),
                               ('MediaStar', 'Any', 35, 3),
                               ('NewIndiaBookSource', 'Any', 33, 3),
                               ('OrientBlackSwan', 'Any', 25, 3),
                               ('Oxford', 'Any', 30, 3),
                               ('PearsonEducation', 'Any', 33, 3),
                               ('PopularPrakasham', 'Any', 33, 3),
                               ('Prakash', 'Any', 33, 3),
                               ('Prism', 'Any', 33, 3),
                               ('RandomHouse', 'Any', 33, 3),
                               ('ResearchPress', 'Any', 30, 8),
                               ('Rupa', 'Any', 33, 3),
                               ('Sage', 'Any', 33, 3),
                               ('Vinayaka', 'Any', 30, 3),
                               ('Vinayaka', 'Sanjay', 0, 3),
                               ('Westland', 'Any', 33, 3),
                               ('CambridgeUniversityPress', 'Any', 33, 3),
                               ('IndiaBooks', 'Any', 33, 3),
                               ('EuroKids', 'Any', 33, 3),
                               ('BookWorldEnterprises', 'Any', 33, 3),
                               ('TBH', 'Any', 33, 3),
                               ('Wiley', 'Any', 33, 3),
                               ('ParagonBooks', 'Any', 33, 3),
                               ('SChand', 'Any', 30, 3),
                               ('Harvard', 'Any', 33, 3),
                               ('UBS', 'Any', 25, 3),
                               ('Viva', 'Any', 30, 3),
                               ('Cambridge', 'Any', 33, 3),
                               ('PanMacmillan', 'Any', 33, 3),
                               ('MacmillanIndia', 'Any', 25, 3),
                               ('CinnamonTeal', 'Any', 25, 3),
                               ('Nari', 'Any', 20, 3),
                               ('Prathambooks', 'Any', 0, 3),
                               ('Navakarnataka', 'Any', 15, 3),
                               ('Nbt', 'Any', 25, 3),
                               ('Cbt', 'Any', 15, 3),
                               ('Navneet', 'Any', 0, 8),
                               ('Navajivan', 'Any', 0, 8),
                               ('Ibn', 'Any', 0, 8),
                               ('Tulika', 'Any', 0, 8),
                               ('Roli', 'Any', 30, 3),
                               ('Fortytwobookzgalaxy', 'Any', 20, 3),
                               ('Anebooks', 'Any', 33, 3),
                               ('Shroff', 'Any', 30, 3),
                               ('Unknown', 'Any', 25, 5);
