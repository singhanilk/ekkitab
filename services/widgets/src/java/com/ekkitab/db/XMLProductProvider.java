/**
 * 
 */
package com.ekkitab.db;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * @author venki
 *
 */
public class XMLProductProvider implements ProductProvider {

	private static Logger log = Logger.getLogger(XMLProductProvider.class);
	private InputStream stream = null;
	private Document document = null;
	private Element docElement = null;
	private static String BOOK = "book";
	private static String ISBN = "isbn";
	private List<Product> list = new ArrayList<Product>();
	private List<String> attributesToIndex = BookConstants.INDEXED_ATTRIBUTES;
	
	public XMLProductProvider(InputStream input) {
		setInputStream(input);
	}
	public XMLProductProvider() {
		
	}
	public void init() {
		
	}
	public void setInputStream(InputStream input) {
		try {
			stream = input;
			parseXml();
		}
		catch(Throwable t) {
			log.error("error parsing the input stream", t);
			throw new DbException(t.getMessage());
		}		
	}
	private void parseXml() throws ParserConfigurationException, SAXException, IOException {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		document = db.parse(stream);
		docElement = document.getDocumentElement();
		NodeList nl = docElement.getElementsByTagName(BOOK);
		if(nl != null) {
			for(int i = 0 ; i < nl.getLength() ; i++) {
				Node nd = nl.item(i);
				NodeList attNodes = nd.getChildNodes();
				Map<String, Object> amap = new HashMap<String, Object>();
				Long oval  = null;
				for(int j = 0 ; j < attNodes.getLength() ; j++) {
					Node anode = attNodes.item(j);
					String aname = anode.getNodeName();
					if(aname.equalsIgnoreCase("#text")) {
						continue; //ignore inner text node of book
					}
					String val = anode.getTextContent();
					val = val.trim();
					if(aname.equalsIgnoreCase(ISBN)) {
						oval  = new Long(val);
						amap.put(aname, oval);
					} else {
						amap.put(aname, val);
					}
				}
				Product pd = new Product(oval,amap);
				list.add(pd);
			}
		}
	}
	/* (non-Javadoc)
	 * @see com.ekkitab.db.ProductProvider#getProducts()
	 */
	@Override
	public List<Product> getProducts() {
		return list;
	}

	@Override
	public List<String> getIndexedAttributes() {
		return attributesToIndex;
	}
}
