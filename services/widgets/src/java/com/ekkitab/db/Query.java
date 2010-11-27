/**
 * 
 */
package com.ekkitab.db;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * @author venki
 *
 * A simple query of form (a == val1) & (b == val2) & (c == val3)
 * Supports only queries where values are strings.
 * No range queries supported
 * 
 *  Intended to be extended for more complex use cases later - CNF form etc.
 *  At this point, this is a simple wrapper over a HashMap
 *  
 *  ProductDB runs this query and returns a list of products.
 *  Number of products returned can be controlled.
 *  A simple random selection of the list of matches is supported
 *    
 */
public class Query {
	
	private Map<String,String> _map = new HashMap<String, String>();
	private int limit = 4;
	private boolean random = true;
	
	public Query(Map<String,String> conjuncts, int limit, boolean random) {
		if(conjuncts != null) {
			for(String key : conjuncts.keySet()) {
				setValue(key,conjuncts.get(key));
			}
		}
		this.limit = limit;
		this.random = random;
	}
	public Query(Map<String,String> conjuncts) {
		this(conjuncts,4,true);
	}
	public Query() {
		this(null,4,true);
	}
	public String getValue(String key) {
		return _map.get(key);
	}
	public void setValue(String key, String value) {
		_map.put(key, value);
	}
	public int getLimit() {
		return limit;
	}
	public void setLimit(int limit) {
		this.limit = limit;
	}
	public boolean isRandom() {
		return random;
	}
	public void setRandom(boolean random) {
		this.random = random;
	}
	public Set<String> getLValues() {
		return _map.keySet();
	}
}
