package com.ekkitab.search;
import java.util.*;
import java.io.*;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;


import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;

public class EkkitabCategoryTree {

    private CategoryLevel root = null;
    private String xmlfile = null;
    private static Logger logger = LogManager.getLogger("EkkitabCategoryTree.class");

    public EkkitabCategoryTree(String xmlfile) throws EkkitabSearchException {
        this.xmlfile = xmlfile;
        this.root = initCategories();
    }

    public void saveCategory(Element node, CategoryLevel cat, int level) {
        String name = node.getAttribute("name");
        cat.putKey(name);
        NodeList nodelist = node.getElementsByTagName("Level"+(level+1));
        for (int i = 0; i < nodelist.getLength(); i++) {
            Node nextnode = nodelist.item(i);
            if (nextnode.getNodeType() == Node.ELEMENT_NODE) {
                CategoryLevel nextcat = cat.put(name, ((Element)nextnode).getAttribute("name")); 
                saveCategory((Element)nextnode, nextcat, level+1);
            }
        }
    }

    private CategoryLevel initCategories() throws EkkitabSearchException {
        if (xmlfile == null) {
            throw new EkkitabSearchException("Missing property: category information file.");
        }
        File file = new File(xmlfile);
        org.w3c.dom.Document dom;
        try {
        	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        	DocumentBuilder db = dbf.newDocumentBuilder();
        	dom = db.parse(file);
        }
        catch(Exception e) {
        	logger.fatal("Error parsing XML category document");
        	throw new EkkitabSearchException(e);
        }
        dom.getDocumentElement().normalize();
        NodeList nodelist = dom.getElementsByTagName("Level1");
        CategoryLevel rootcategory = new CategoryLevel();
        for (int i = 0; i < nodelist.getLength(); i++) {
            Node node = nodelist.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                saveCategory((Element)node, rootcategory, 1);
            }
       }
       return rootcategory;
    }

    public Set<String> getSearchCategories(String[] categories) {
        CategoryLevel node = root;
        if (categories != null) {
            for(int i = 0; (i < categories.length) && (node != null); i++) {
                node = node.get(categories[i]);
            }
        }
        if (node != null)
            return node.getKeys();
        return null;
    }
}
