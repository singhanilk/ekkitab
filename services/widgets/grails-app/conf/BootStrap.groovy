import java.io.FileInputStream;
import org.codehaus.groovy.grails.commons.ConfigurationHolder;

class BootStrap {
	def productProvider;
	def productDB;
    def init = { servletContext ->
		//set the product provider for the DB
		def config = ConfigurationHolder.config;
		String filePath = config.products.location;
		log.info "Products file location is : " + filePath;
		FileInputStream fi = new FileInputStream(filePath);
		log.info "Opened the file input stream";
		productProvider.setInputStream(fi);
		log.info "Read products from  input stream, using product provider " + productProvider.class;
		productDB.setProductProvider(productProvider);
		log.info "Completed Product DB initialization and indexing ";
    }
    def destroy = {
    }
}
