use reference;
update books b, book_stock_and_prices bs set b.list_price = bs.list_price,  b.discount_price = bs.discount_price, b.stock_updated = '1', b.price_updated = '1', bs.updated = '0' where b.isbn = bs.isbn and bs.updated = '1'; 
