use reference;
select "deleting books that have no author and title ...";
select "may take a few minutes on a large database ...";
delete from books where author is null and title is null;
select "deleting books that have no list price ...";
select "may take a few minutes on a large database ...";
delete from books where list_price is null;
use ekkitab_books;
drop table if exists books;
create table books like reference.books;
insert into books select * from reference.books;
