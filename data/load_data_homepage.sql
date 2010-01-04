use `ekkitab_books`;
--
-- Dumping data for table `cms_page`
--

update `cms_page` set `content`='<div class="quick-search">\r\n	{{block type="catalog/category_popular" name="popular.categories" as="popular_categories" template="catalog/category/popular.phtml" }}\r\n        {{block type="catalog/author_topAuthors" name="top.authors" as="top_authors" template="catalog/author/popular.phtml" }}\r\n</div><br class="clear">\r\n<div class="col-left sidebar">\r\n	{{block type="catalog/navigation"  template="catalog/navigation/left_nav.phtml"}}\r\n</div>\r\n<div class="col-main" id="main">\r\n        {{block type="page/html" name="static.block.1"  template="page/html/place_holder1.phtml" }}\r\n        {{block type="page/html" name="static.block.2"  template="page/html/place_holder2.phtml" }}\r\n        {{block type="page/html" name="static.block.3"  template="page/html/place_holder3.phtml" }}\r\n        {{block type="page/html" name="static.block.4"  template="page/html/place_holder4.phtml" }}\r\n</div>\r\n' where page_id =2;
