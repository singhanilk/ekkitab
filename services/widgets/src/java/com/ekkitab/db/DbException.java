/**
 * 
 */
package com.ekkitab.db;

/**
 * @author venki
 *
 */
public class DbException extends RuntimeException {

	public DbException() {
		super();
	}

	public DbException(String message, Throwable cause) {
		super(message, cause);
	}

	public DbException(String message) {
		super(message);
	}

	public DbException(Throwable cause) {
		super(cause);
	}

}
