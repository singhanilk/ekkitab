use reference;
--
-- Reset the list_price, discount_price and stock for all the books in the database before the prices are run.
--
update books set list_price = null, discount_price = null, in_stock = 0;
