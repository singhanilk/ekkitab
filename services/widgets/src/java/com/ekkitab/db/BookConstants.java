package com.ekkitab.db;

import java.util.Arrays;
import java.util.List;

public class BookConstants {

	//index attribute names for the books
	public final static String AUTHOR = "author";
	public final static String CATEGORY = "category";
	public final static String ISBN = "isbn";
	public final static String DISCOUNT = "discount";
	public final static String IMAGE = "image";
	public final static String LINK  = "link";
	public final static String PRICE = "price";
	public final static String MRP   = "mrp";
	public final static String TITLE = "title";
	
	public static List<String> INDEXED_ATTRIBUTES = Arrays.asList(AUTHOR,CATEGORY,DISCOUNT);
	
}
