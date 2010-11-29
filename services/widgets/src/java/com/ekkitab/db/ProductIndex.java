/**
 * 
 */
package com.ekkitab.db;

import java.util.Collection;
import java.util.Map;
import java.util.SortedSet;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentSkipListSet;

/**
 * @author venki
 * Indexes the list of products using their handles
 * The maps a given attribute value to SortedSet of product handles
 *
 */
public class ProductIndex implements Index<Object, Long>{

	private static int INIT_CAPACITY = 100;
	private Map<Object, SortedSet<Long>> index = null;
	private String attributeName = null;
	
	public ProductIndex(String attribute,int initCapacity) {
		index = new ConcurrentHashMap<Object, SortedSet<Long>>(initCapacity);
		attributeName = attribute;
	}
	public ProductIndex(String attribute) {
		this(attribute,INIT_CAPACITY);
	}
	private SortedSet<Long> getSet(Object attrValue) {
		SortedSet<Long> s = index.get(attrValue);
		if(s == null) {
			s = new ConcurrentSkipListSet<Long>();
			index.put(attrValue, s);
		}
		return s;
	}
	@Override
	public void put(Object key, Long val) {
		SortedSet<Long> valSet = getSet(key);
		valSet.add(val);
	}

	@Override
	public void putAll(Object key, Collection<Long> values) {
		SortedSet<Long> valSet = getSet(key);
		valSet.addAll(values);
	}

	@Override
	public SortedSet<Long> get(Object key) {
		return index.get(key);
	}
	
	public void putProduct(Product p) {
		Object val = p.getValue(attributeName);
		Long handle = p.getHandle();
		put(val,handle);
		
	}

	public void putAllProducts(Collection<Product> products) {
		if(products != null) {
			for(Product p : products)
			putProduct(p);
		}		
	}
}
