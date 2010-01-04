use `ekkitab_books`;
--
-- Dumping data for table `cms_page`
--

update `cms_page` set `content`='<div class="quick-search">\r\n	{{block type="ekkitab_catalog/category_popular" name="popular.categories" as="popular_categories" template="catalog/category/popular.phtml" }}\r\n        {{block type="ekkitab_catalog/author_topAuthors" name="top.authors" as="top_authors" template="catalog/author/popular.phtml" }}\r\n</div><br class="clear">\r\n<div class="col-left sidebar">\r\n	{{block type="catalog/navigation"  template="catalog/navigation/left_nav.phtml"}}\r\n</div>\r\n<div class="col-main" id="main">\r\n        {{block type="ekkitab_catalog/product_bestsellers" name="bestsellers"  template="catalog/product/bestsellers.phtml" }}\r\n        {{block type="ekkitab_catalog/product_newreleases" name="newreleases"  template="catalog/product/newreleases.phtml" }}\r\n        {{block type="ekkitab_catalog/product_bestboxedsets" name="best.boxed.sets"  template="catalog/product/bestboxedsets.phtml" }}\r\n       \r\n</div>\r\n' where page_id =2;

