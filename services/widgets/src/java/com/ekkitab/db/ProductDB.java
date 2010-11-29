/**
 * 
 */
package com.ekkitab.db;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.SortedSet;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

/**
 * @author venki
 *
 */
public class ProductDB {

	private static Logger log = Logger.getLogger(ProductDB.class);
	private ProductProvider provider = null;
	private Map<Long,Product> pmap = new ConcurrentHashMap<Long, Product>();
	
	//list of indexes maintianed by this ProductDB
	private List<String> indexAttributes = null;
	private Map<String, ProductIndex> indexes = new ConcurrentHashMap<String, ProductIndex>();
	
	public ProductDB() {
		
	}
	public void init() {
		
	}
	public void setProductProvider(ProductProvider provider) {
		this.provider = provider; 
		List<Product> plist = provider.getProducts();
		for(Product p : plist) {
			pmap.put(p.getHandle(), p);
		}
		indexAttributes = provider.getIndexedAttributes();
		buildIndexes();
	}
	private void buildIndexes() {
		if(indexAttributes != null) {
			int psize = pmap.size();
			for(String attribute : indexAttributes) {
				ProductIndex pi = new ProductIndex(attribute, psize);
				pi.putAllProducts(pmap.values());
				indexes.put(attribute, pi);
			}
		}
	}
	public ProductIndex getIndex(String attribute) {
		return indexes.get(attribute);
	}
	public Product getProduct(long handle) {
		return pmap.get(handle);
	}
	public class ProductComparator implements Comparator<Product> {

		private String attribute = null;
		public ProductComparator(String attr) {
			attribute = attr;
		}
		@Override
		public int compare(Product p1, Product p2) {
			Object v1 = p1.getValue(attribute);
			Object v2 = p2.getValue(attribute);
			return ((Comparable)v1).compareTo((Comparable)v2);
		}
	}
	public List<Product> getProducts(String sortColumn) {
		List<Product> list = new ArrayList<Product>(pmap.values()); 
		Collections.sort(list, new ProductComparator(sortColumn));
		return list;
	}
	/**
	 * Execute and return a list of products
	 * Fairly dump and will enumerate all the matches to decide if any possible match can be
	 * found. INTERSECT.isEmpty needs to be tested to make it efficient
	 * 
	 * @param query
	 * @return
	 */
	public List<Product> execute(Query query) {
		Set<String> lvals = query.getLValues();
		List<SortedSet<Long>> productHandleLists = new ArrayList<SortedSet<Long>>();
		for(String lval : lvals) {
			String rightVal = query.getValue(lval);
			ProductIndex idx = indexes.get(lval);
			if(idx != null) {
				SortedSet<Long> matches = idx.get(rightVal);
				if(matches == null) {
					log.warn("No matches found for : " + lval + "=" + rightVal + " constraint ignored.");					
				} else {
					productHandleLists.add(matches);
				}
			} else {
				log.error("No index found for attribute : " + lval +" Can not run query");
				throw new DbException("No index found for attribute : " + lval +" Can not run query");
			}
		}
		//new set-up an intersection
		if(productHandleLists.size() == 0) {
			log.warn("None of the constraints on lvalues : " + query.getLValues() + " resulting in valid products");
			return null;
		}
		INTERSECT<Long> products = new INTERSECT<Long>(productHandleLists);
		List<Product> plist = new ArrayList<Product>();
		for(Long handle : products) {
			Product p = getProduct(handle);
			plist.add(p);
		}
		if(plist.size() == 0) {
			log.warn("intersection of the constrains is resulting in empty products. sets");
			return null;			
		}
		int ubound = plist.size() < query.getLimit() ? plist.size() : query.getLimit();
		int sz = plist.size();
		List<Product> toReturn = new ArrayList<Product>();
		if(query.isRandom()) {
			Random rd = new Random();
			int idx = rd.nextInt(10000);
			int start = idx % sz;
			while (ubound > 0) {				
				toReturn.add(plist.get(++start % sz));
				ubound--;
			}
		} else {
			for(int i = 0 ; i < ubound ; i++) {
				toReturn.add(plist.get(i));
			}
		}
		return toReturn;
	}
}
