package com.ekkitab.db;

import static org.junit.Assert.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.SortedSet;

import org.junit.Before;
import org.junit.Test;

public class TestProductDB {
	
	private ProductDB pdb = null;
	@Before
	public void buildProductDB() throws Throwable {
		String fname = "/Users/venki/.grails/widgets/books.xml";
		FileInputStream fi = new FileInputStream(fname);
		try {
			ProductProvider prov = new XMLProductProvider(fi);
			List<String> indexes = Arrays.asList("author","category","isbn","discount");			
			pdb = new ProductDB();
			pdb.setProductProvider(prov);
		}
		finally {
			fi.close();
		}		
	}
	@Test
	public void testGetProduct() throws Throwable {
		Product p = pdb.getProduct(9780446554961L);
		//System.out.println(p);
		assertTrue(p.getHandle() == 9780446554961L);
	}
	@Test
	public void testAuthorIndex() throws Throwable {
		ProductIndex pi = pdb.getIndex("author");
		SortedSet<Long> books = pi.get("J.K.Rowling");
		for(Long h : books) {
			Product b = pdb.getProduct(h);
			String au = (String)b.getValue("author");
			assertTrue(au.equals("J.K.Rowling"));
			//System.out.println(b);
		}
	}
	@Test
	public void testAuthorIndex1() throws Throwable {
		ProductIndex pi = pdb.getIndex("author");
		SortedSet<Long> books = pi.get("R. K. Narayan");
		for(Long h : books) {
			Product b = pdb.getProduct(h);
			String au = (String)b.getValue("author");
			assertTrue(au.equals("R. K. Narayan"));
			//System.out.println(b);
		}
	}
	@Test
	public void testCategoryIndex() throws Throwable {
		ProductIndex pi = pdb.getIndex("category");
		SortedSet<Long> books = pi.get("Cooking");
		for(Long h : books) {
			Product b = pdb.getProduct(h);
			String v = (String)b.getValue("category");
			assertTrue(v.equals("Cooking"));
			//System.out.println(b);
		}
	}
	@Test
	public void testAndQuery() throws Throwable {
		//get me Cooking books with discount of 20%
		ProductIndex catIndex = pdb.getIndex("category");
		SortedSet<Long> books = catIndex.get("Cooking");
		ProductIndex discountIndex = pdb.getIndex("discount");
		SortedSet<Long> books1 = discountIndex.get("fsu20");
		List<SortedSet<Long>> list = new ArrayList<SortedSet<Long>>();
		list.add(books);
		list.add(books1);
		INTERSECT<Long> result = new INTERSECT<Long>(list);
		for(Long h : result) {
			Product b = pdb.getProduct(h);
			System.out.println(b);
		}
		System.out.println("----------------------");
	}
	@Test
	public void testAndQuery1() throws Throwable {
		//get me R. K. Narayan books in Fiction Category
		ProductIndex catIndex = pdb.getIndex("category");
		SortedSet<Long> books = catIndex.get("Fiction");
		ProductIndex authorIndex = pdb.getIndex("author");
		SortedSet<Long> books1 = authorIndex.get("R. K. Narayan");
		List<SortedSet<Long>> list = new ArrayList<SortedSet<Long>>();
		list.add(books);
		list.add(books1);
		INTERSECT<Long> result = new INTERSECT<Long>(list);
		for(Long h : result) {
			Product b = pdb.getProduct(h);
			System.out.println(b);
		}
		System.out.println("----------------------");
	}
	@Test
	public void testAndQuery2() throws Throwable {
		//get me R. K. Narayan books in Fiction Category
		ProductIndex catIndex = pdb.getIndex("category");
		SortedSet<Long> books = catIndex.get("Mythology");
		ProductIndex authorIndex = pdb.getIndex("author");
		SortedSet<Long> books1 = authorIndex.get("R. K. Narayan");
		ProductIndex discountIndex = pdb.getIndex("discount");
		SortedSet<Long> books2 = discountIndex.get("fsu21");
		
		List<SortedSet<Long>> list = new ArrayList<SortedSet<Long>>();
		list.add(books);
		list.add(books1);
		list.add(books2);
		INTERSECT<Long> result = new INTERSECT<Long>(list);
		for(Long h : result) {
			Product b = pdb.getProduct(h);
			System.out.println(b);
		}
		System.out.println("----------------------");
	}
	@Test
	public void testQuery() throws Throwable {
		Query query = new Query();
		//query.setRandom(false);
		//query.setLimit(10);
		query.setValue("category", "Fiction");
		query.setValue("author", "J.K.Rowling");
		List<Product> plist = pdb.execute(query);
		for(Product p : plist) {
			System.out.println(p);
		}
		System.out.println("----------------------");
	}
	//new releases with 26% percent discount
	@Test
	public void testQuery1() throws Throwable {
		Query query = new Query();
		query.setValue("category", "New Releases");
		query.setValue("discount","fsu26");
		List<Product> plist = pdb.execute(query);
		for(Product p : plist) {
			System.out.println(p);
		}
		System.out.println("----------------------");
	}
	//anything in category fiction
	@Test
	public void testQuery2() throws Throwable {
		Query query = new Query();
		query.setValue("category","Fiction");
		List<Product> plist = pdb.execute(query);
		for(Product p : plist) {
			System.out.println(p);
		}
		System.out.println("----------------------");
	}
	//anything by R.K.Narayan
	@Test
	public void testQuery3() throws Throwable {
		Query query = new Query();
		query.setValue("author","R. K. Narayan");
		List<Product> plist = pdb.execute(query);
		for(Product p : plist) {
			System.out.println(p);
		}
		System.out.println("----------------------");
	}
}
