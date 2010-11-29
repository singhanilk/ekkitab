/**
 * 
 */
package com.ekkitab.db;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 * @author venki
 *
 */
public class Product  {
	
	private Map<String, Object> _map = null;
	private long _handle = -1L;
	
	public Product() {
		
	}
	public Product(long handle, Map<String,Object> map) {
		setValues(handle, map);
	}
	public Set<String> getAttributes() {
		return _map.keySet();
	}
	public long getHandle() {
		return _handle;
	}
	public Object getValue(String attribute) {
		return _map.get(attribute);
	}
	public List<Object> getValues(List<String> attributes) {
		if((attributes != null) &&(attributes.size() > 0)) {
			List<Object> vals = new ArrayList<Object>(attributes.size());
			int i = 0;
			for (String attr:attributes) {
				vals.add(_map.get(attr));
			}
			return vals;
		} else {
			if(_map == null) {
				return null;
			} else {
				return new ArrayList<Object>(_map.values());
			}
		}
	}
	public void setValues(long handle, Map<String,Object> values) {
		_handle = handle;
		_map = new TreeMap<String, Object>();
		_map.putAll(values);
	}
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append('[');
		for(String attr : _map.keySet()) {
			Object val = getValue(attr);
			sb.append(attr).append('=').append(val).append(',');
		}
		sb.append(']');
		return sb.toString();
	}
}
