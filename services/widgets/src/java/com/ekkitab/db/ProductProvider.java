/**
 * 
 */
package com.ekkitab.db;

import java.io.InputStream;
import java.util.List;

/**
 * @author venki
 *
 */
public interface ProductProvider {

	public List<Product> getProducts();
	public List<String> getIndexedAttributes();
	public void setInputStream(InputStream stream);
}
