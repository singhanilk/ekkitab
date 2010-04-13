use reference;
update books b, book_description bd set b.short_description = bd.short_description,  b.description = bd.description, bd.updated = '0' where b.isbn = bd.isbn and bd.updated = '1'; 
