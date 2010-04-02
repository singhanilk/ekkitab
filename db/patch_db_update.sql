use ekkitab_books;

ALTER Table `ek_catalog_popular_categories`drop column url_path;

UPDATE `ek_catalog_global_sections` set `is_homepage_display`='1' where `section_id`=3;

UPDATE `cms_page` set content = ' {{block type="page/html" name="donate_book_blurb_home"  template="page/html/donate_blurb_home.phtml" }}
{{block type="ekkitab_catalog/globalsection" name="homesection"  template="catalog/globalsection/home_page.phtml" }}', root_template='three_columns' where page_id =2;
