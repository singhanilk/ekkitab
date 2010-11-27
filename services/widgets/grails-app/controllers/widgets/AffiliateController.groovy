package widgets;

import java.io.File;

import com.ekkitab.db.BookConstants;
import com.ekkitab.ui.Book;
import com.ekkitab.ui.ViewConstants;
import org.apache.log4j.Logger;
import org.codehaus.groovy.grails.commons.ConfigurationHolder;

class AffiliateController {
	static defaultAction = "list"
	def config = ConfigurationHolder.config;
	private static Logger log = Logger.getLogger(AffiliateController.class);
	
	//beans to refresh the data files
	def productProvider;
	def productDB;

	def list = {
		return [aflist:Affiliate.list(sort:'name') , total:Affiliate.count()]; 
	}
	
	def create = {
		return [af:new Affiliate()];
	}
	def save = {
		def afInst = new Affiliate(params);
		def addr = new Address(params);
		afInst.address = addr;
		//save it
		afInst.save();
		flash.message = "Affilate : " + afInst.name + " created";
		redirect(action:list);
	}
	def edit = {
		def map = [ af : Affiliate.get( params.id )];
	}
	def update = {
		def afInst = Affiliate.get(params.id);
		def addr   = Address.get(params.aid);
		afInst.properties = params;
		addr.properties = params;
		afInst.address = addr;
		afInst.save();
		flash.message = "Affilate : " + afInst.name + " updated";
		redirect(action:list);
	}
	def delete = {
		def afInst = Affiliate.get(params.id);
		afInst.delete();
		flash.message = "Affilate : " + afInst.name + " deleted";
		redirect(action:list);
	}
	def show = {
		def map = [ af : Affiliate.get( params.id ) ]
	}
	def upload = {
		//goes to upload.gsp
	}
	private backUpXMLFile(newFile) {
		String filePath = config.products.location;
		def f = new File(filePath+".old");
		if(f.exists()) {
			f.delete();
		}
		File cfile = new File(filePath);
		cfile.renameTo(new File(filePath+".old"));
		newFile.transferTo( new File(filePath));
	}
	def refresh = {
		log.info("Refreshing Affiliate Products Catalog...");
		def ufile = request.getFile(ViewConstants.FILE);
		InputStream fi = ufile.inputStream;
		log.info("Opened the file input stream");
		productProvider.setInputStream(fi);
		log.info "Read products from  input stream, using product provider " + productProvider.class;
		productDB.setProductProvider(productProvider);
		log.info "Completed Product DB refresh and indexing. New Affiliate catalog is in force ";
		log.info "Backing up old catalog... and copying the uploaded on to : " + config.products.location;
		backUpXMLFile(ufile);
		log.info("Backup successful");
		//goes to refresh.gsp which will display sorted list of products
		def products = productDB.getProducts(BookConstants.AUTHOR);
		def books = [];
		products.each { b -> books.add(new Book(b));}
		def pmap = [ productList : books];
		render(view:'refresh',model:pmap);
	}
}
