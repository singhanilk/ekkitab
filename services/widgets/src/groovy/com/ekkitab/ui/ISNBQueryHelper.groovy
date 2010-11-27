package com.ekkitab.ui

import java.util.List;

import org.apache.log4j.Logger;

import com.ekkitab.db.Product;

class ISNBQueryHelper {
	def productDB;
	def isbnQuery = null;
	def log = Logger.getLogger(ISNBQueryHelper.class);
	public ISNBQueryHelper(isbn,pDb) {
		isbnQuery = isbn;
		productDB = pDb;
	}	
	public List<Product> getProducts() {
		def plist = [];
		def isbnList = isbnQuery.split(",");
		isbnList.each {
			def val = it.trim();
			if(val != null && (val != "")) {
				Long lg = new Long(val);
				Product p = productDB.getProduct(lg);
				log.debug("The product is : " + p);
				plist.add(p);
			} 
		}
		return plist;
	}
}
