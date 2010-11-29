/**
 * 
 */
package com.ekkitab.alog

import java.util.Calendar;

import org.apache.log4j.Logger;
import org.codehaus.groovy.grails.commons.ConfigurationHolder;

import com.ekkitab.db.BookConstants;
import com.ekkitab.ui.ViewConstants;

/**
 * @author venki
 *
 */
class AffilateLogger {
	private static config = ConfigurationHolder.config;
	private static Logger impressionLog = Logger.getLogger(config.products.affiliate.impressionLog);
	private static Logger clickLog = Logger.getLogger(config.products.affiliate.clickLog);
	
	private static LOGGING_PARAMS = [BookConstants.ISBN, BookConstants.TITLE, BookConstants.AUTHOR, BookConstants.CATEGORY];
	
	private static String getQueryString(request) {
		return request.getQueryString();
	}
	private static String getIPAddress(request) {
		return request.getRemoteAddr();
	}
	private static String getProductString(products) {
		StringBuilder sb = new StringBuilder();
		products.each { product ->
			LOGGING_PARAMS.each {
				sb.append('[');
				sb.append(it).append('=').append(product.getValue(it)).append(',');
				sb.append(']');
			}
		}
		return sb.toString();
	}
	public static logImpression(params,request,products) {
		StringBuilder sb = new StringBuilder();
		sb.append(System.currentTimeMillis()).append('\t');
		sb.append(getIPAddress(request)).append('\t');
		sb.append(params[ViewConstants.AFFILIATE_ID]).append('\t');
		sb.append(getQueryString(request)).append('\t');
		sb.append(getProductString(products));
		
		impressionLog.info(sb.toString());
	}
	public static logClick(params,request) {
		StringBuilder sb = new StringBuilder();
		sb.append(System.currentTimeMillis()).append('\t');
		sb.append(getIPAddress(request)).append('\t');
		sb.append(params[ViewConstants.AFFILIATE_ID]).append('\t');
		sb.append(getQueryString(request)).append('\t');
		//sb.append(params[ViewConstants.URL]);
		
		clickLog.info(sb.toString());
	}
}
