
package com.ekkitab.db;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.SortedSet;

import static org.junit.Assert.*;

import org.junit.BeforeClass;
import org.junit.Test;

/**
 * @author venki
 *
 */
class TestProductIndex {

	private static Map<Long,Product> books = new HashMap<Long,Product>();
	
	@BeforeClass
	public static void buildBookDB() {
		
		Product p = new Product();
		
		Map<String, Object> vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56788");
		vals.put("category","Fiction");
		vals.put("title","Swami and Friends");
		vals.put("author", "R.K.Narayan");
		p = new Product();
		p.setValues(100, vals);
		books.put(p.getHandle(), p);
		
		vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56789");
		vals.put("category","Fiction");
		vals.put("title","Malgudi Days");
		vals.put("author", "R.K.Narayan");
		p = new Product();
		p.setValues(101, vals);
		books.put(p.getHandle(), p);
		
		vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56790");
		vals.put("category","Fiction");
		vals.put("title","Financial Expert");
		vals.put("author", "R.K.Narayan");
		p = new Product();
		p.setValues(102, vals);
		books.put(p.getHandle(), p);

		vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56800");
		vals.put("category","Mythology");
		vals.put("title","Ramayana Retold");
		vals.put("author", "R.K.Narayan");
		p = new Product();
		p.setValues(103, vals);
		books.put(p.getHandle(), p);

		vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56800");
		vals.put("category","Mythology");
		vals.put("title","Demons and Other Stories");
		vals.put("author", "R.K.Narayan");
		p = new Product();
		p.setValues(104, vals);
		books.put(p.getHandle(), p);
		
		//other mythology authors
		vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-76800");
		vals.put("category","Mythology");
		vals.put("title","Kuru Princes");
		vals.put("author", "Amar Chitra Katha");
		p = new Product();
		p.setValues(105, vals);
		books.put(p.getHandle(), p);
		
		vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-76800");
		vals.put("category","Mythology");
		vals.put("title","Krishna in Vrindhavan");
		vals.put("author", "Amar Chitra Katha");
		p = new Product();
		p.setValues(106, vals);
		books.put(p.getHandle(), p);
		
	}
	/**
	 * Test method for {@link com.ekkitab.db.ProductIndex#get(java.lang.Object)}.
	 */
	@Test
	public void testGet() {
		Map<String,Object> vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-76800");
		vals.put("category","Mythology");
		vals.put("title","Krishna in Vrindhavan");
		vals.put("author", "Amar Chitra Katha");
		Product p = new Product();
		p.setValues(106, vals);
		ProductIndex authorIndex = new ProductIndex("author");
		authorIndex.putProduct(p);
		SortedSet<Long> hds = authorIndex.get("Amar Chitra Katha");
		Long h = 0L;
		if(hds != null) {
			h = hds.first();
		}
		assertTrue(h == 106);
	}
	/**
	 * Test method for {@link com.ekkitab.db.ProductIndex#putAllProducts(java.util.Collection)}.
	 */
	@Test
	public void testPutAllProducts(){
		ProductIndex catIndex = new ProductIndex("category");
		catIndex.putAllProducts(books.values());
		//now get mythology books
		SortedSet<Long> hds = catIndex.get("Mythology");
		List resList = new ArrayList<Long>(hds);
		List myList = [103,104,105,106];
		assertTrue(myList == resList);
	}
}
