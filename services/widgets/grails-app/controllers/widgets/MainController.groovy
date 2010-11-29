package widgets
import java.io.FileInputStream;
import java.util.List;
import java.util.logging.Logger;

import org.codehaus.groovy.grails.commons.ConfigurationHolder;

import com.ekkitab.alog.AffilateLogger;
import com.ekkitab.db.BookConstants;
import com.ekkitab.db.Product;
import com.ekkitab.db.Query;
import com.ekkitab.ui.Book;
import com.ekkitab.ui.ISNBQueryHelper;
import com.ekkitab.ui.ViewConstants;

class MainController {
	def productProvider;
	def productDB;
    def index = {	
		def products = [];
		//if isbn is specified as a comma separated list no index query will be performed rest will be ignored
		def isbns = params[BookConstants.ISBN];
		if((isbns != null) && (isbns != "")) {
			ISNBQueryHelper isbnQuery = new ISNBQueryHelper(isbns,productDB);
			products = isbnQuery.getProducts();
		} else {
			def slimit = params[ViewConstants.LIMIT];
			def int limit = ViewConstants.DEFAULT_LIMIT;
			if((slimit != null) || (slimit != "")) {
				try {
					limit = Integer.valueOf(slimit);	
				}
				catch(Throwable t) {
					//nothing to do
				}
			}
			Query query = new Query();	
			query.setLimit(limit);	
			BookConstants.INDEXED_ATTRIBUTES.each {
				def val = params[it];
				if((val != null) && (val != "")) {
					log.debug("Setting query " + it + "=" + val);
					query.setValue(it,val);
				}	
			}
			products = productDB.execute(query);
		}
		def aid = params[ViewConstants.AFFILIATE_ID];
		def books = [];
		products.each { b -> books.add(new Book(b,aid));}
		def pmap = [ productList : books];
		def wtype = params[ViewConstants.WIDGET_TYPE];
		if((wtype == null) || (wtype == "")) {
			//for now use default type
			wtype = ViewConstants.DEFAULT_TYPE;
		}
		def design = params[ViewConstants.DESIGN];
		if((design == null) || (design == "")) {
			design = ViewConstants.DEFAULT_DESIGN;
		}
		def vname = "widgets/" + wtype + "/" + design;
		//log information
		params[ViewConstants.BOOKS] = books;
		params[ViewConstants.REQUEST] = request;
		AffilateLogger.logImpression(params,request,products);
		
		render(view:vname, model:pmap);
	}
}
