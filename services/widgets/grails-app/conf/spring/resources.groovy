// Place your Spring DSL code here
beans = {
	productDB(com.ekkitab.db.ProductDB) { bean ->
		bean.singleton = true;
	}
	productProvider(com.ekkitab.db.XMLProductProvider) { bean ->
		bean.singleton = true;
	}	
}
