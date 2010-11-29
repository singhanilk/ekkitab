/**
 * 
 */
package com.ekkitab.db;

import java.util.Collection;
import java.util.SortedSet;

/**
 * @author venki
 *
 */
public interface Index<K,V> {
	/**
	 * given a value and its key put it into the index
	 * @param key
	 * @param val
	 */
	public void put(K key, V val);
	/**
	 * put all the values matching the given key into the index
	 * @param key
	 * @param values
	 */
	public void putAll(K key, Collection<V> values);
	/**
	 * Given a key get all the values matching the
	 * @param key
	 * @return
	 */
	public SortedSet<V> get(K key);
}
