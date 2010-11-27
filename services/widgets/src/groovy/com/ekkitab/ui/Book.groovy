/**
 * 
 */
package com.ekkitab.ui

import org.apache.log4j.Logger;
import org.codehaus.groovy.grails.commons.ConfigurationHolder;

import com.ekkitab.db.BookConstants;
import com.ekkitab.db.Product;

/**
 * @author venki
 * A conveience wrapper around product which stand for a book
 */
public class Book {
	private static Logger log = Logger.getLogger(Book.class);
	def Product product;
	def config = ConfigurationHolder.config;
	def aid = "-1";
	public Book(Product p) {
		product = p;
	}
	public Book(Product p, String afid) {
		product = p;
		aid=afid;
	}

	public getTitle() {
		return product.getValue(BookConstants.TITLE);	
	}
	public getDisplayTitle() {
		def stitle = this.title;
		return (stitle.length() > 25 ? stitle.substring(0, 25) : stitle);
	}
	public getAuthor() {
		return product.getValue(BookConstants.AUTHOR);
	}
	private String makeWindowOpenLink(String link) {
		String forwardLink = "forward?aid=" + aid + "&url=";
		forwardLink = forwardLink + link; 
		log.debug("Link sent to : " + link);
		String ret = "javascript:window.open('" + forwardLink + "');" 		
		return  ret;
	}
	public getAuthorLink()  {
		def authName = this.author;
		String link = authName.encodeAsURL();
		String l = config.products.authorBase.toString() + link;
		return makeWindowOpenLink(l); 
	}
	//raw links
	public getRawAuthorLink()  {
		def authName = this.author;
		String link = authName.encodeAsURL();
		String l = config.products.authorBase.toString() + link;
		return l;
	}
	public getRawBookLink() {
		String link = product.getValue(BookConstants.LINK);
		String l = config.products.linkBase.toString() + link;
		return l;
	}
	public getBookLink() {
		String link = product.getValue(BookConstants.LINK);
		String l = config.products.linkBase.toString() + link;
		return makeWindowOpenLink(l);
	}
	public getImageLink() {
		String link = product.getValue(BookConstants.IMAGE);
		return config.products.imageBase.toString() + link;
	}
	public getDiscount() {
		return product.getValue(BookConstants.DISCOUNT);
	}
	public getMrp(){
		return product.getValue(BookConstants.MRP);
	}
	public getPrice() {
		return product.getValue(BookConstants.PRICE);
	}
	public getIsbn() {
		return product.getValue(BookConstants.ISBN);
	}
	public String toString() {
		return product.toString();
	}
}
