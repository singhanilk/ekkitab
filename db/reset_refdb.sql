-- @version 1.0     Sep 03, 2010
-- Changes: The drop database was removed as we should not drop some of the 
--          reference tables i.e. missing_isbns and ignore_isbns tables.

-- drop database if exists reference;
-- List all the tables that need to be dropped
USE `reference`;
-- drop table if exists books ;
drop table if exists ek_bisac_category_map ;
drop table if exists ek_currency_conversion ;
drop table if exists ek_discount_setting ;
drop table if exists ek_supplier_params ;
drop table if exists book_availability ;
drop table if exists books_promo ;
source create_reference_db.sql;
source ../data/refdb_categories.sql;
source init_refdb.sql;
