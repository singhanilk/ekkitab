use ekkitab_books;
drop table if exists books;
create table books like reference.books;
insert into books select * from reference.books;
