package com.ekkitab.search;
import java.io.*;
import java.util.*;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.document.Field;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.spell.Dictionary;
import org.apache.lucene.search.spell.LuceneDictionary;
import org.apache.lucene.search.spell.SpellChecker;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMSource;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;

public class BookIndex {
    private Document d = null;
    private Connection connection = null; 
    private String user = "";
    private String password = "";
	private String jdbcUrl = "jdbc:mysql://localhost:3306/reference";
    private static final int  LEVELS = 7;
    private IndexWriter indexWriter = null;
    private CategoryLevel rootcategory = new CategoryLevel();

    private static final int MAXDESC_SIZE = 100;
    private String xmlfile = null;
    private int startId = 0;
    private boolean newIndex;

    public BookIndex(String indexDir, String xmlfile, boolean newIndex, String db, String user, String password, int startId) throws Exception {
        this.user = user;
        this.password = password;
        this.xmlfile = xmlfile;
        this.newIndex = newIndex;
        if (startId > 0)
            this.startId = startId;
        Directory d  = FSDirectory.getDirectory(indexDir);
        indexWriter = new IndexWriter(d,new StandardAnalyzer(),newIndex, IndexWriter.MaxFieldLength.LIMITED);
        indexWriter.setUseCompoundFile(true);
        jdbcUrl = "jdbc:mysql://"+db+":3306/reference";
        open();
    }

    public void open() throws Exception {
       Class.forName("com.mysql.jdbc.Driver").newInstance();
       connection = DriverManager.getConnection(jdbcUrl, user, password);
    }

	public void close() throws Exception {
		if(connection == null) {
			return;
		}
		connection.close();
		connection = null;
	}

    private String[] getFullCategoryForCode(String code) throws Exception {
	    String sql = "select level1, level2, level3, level4, level5, level6, level7 from ek_bisac_category_map where bisac_code = '" + code + "'";
        Statement stmt = connection.createStatement();
        ResultSet result = stmt.executeQuery(sql);
        String[] levels = new String[LEVELS];
        if (result.next()) {
           for (int i=0; i<LEVELS; i++) {
              int index = i+1;
              String label = "level" + index;
              String tmp = result.getString(label);
              tmp = tmp == null ? "" : tmp;
              levels[i] = tmp;
           }
        }
        else 
           levels = null;

        result.close();
        stmt.close();
        return levels;
    }

    private class CategoryLevel {
       private Map<String, CategoryLevel> map = null;
       public CategoryLevel() {
           map = new HashMap<String, CategoryLevel>(); 
       }
       public CategoryLevel put(String key, String value) {
           if ((value == null) || (value.length() == 0)) {
              putKey(key);
              return null;
           }
           if (map.containsKey(key)) {
                CategoryLevel nextvalue = map.get(key);
                nextvalue.putKey(value);
                return nextvalue;
           }                        
           else {
               CategoryLevel nextvalue = new CategoryLevel(); 
               nextvalue.putKey(value); 
               map.put(key, nextvalue);
               return nextvalue;
           }
       }                
       private void putKey(String key) {
           if (!map.containsKey(key)) {
              CategoryLevel nextvalue = new CategoryLevel(); 
              map.put(key, nextvalue);
           }
       }        

       public Set<String> getKeys() {
           return map.keySet();
       }

       public CategoryLevel get(String key) {
           if (map.containsKey(key))
               return map.get(key);
           else
               return null;
       }
    }

    private void saveCategories(String[] categories) {

        if (categories != null) {
            CategoryLevel node = rootcategory;
            for (int i = 0; (i < categories.length) && (node != null); i++) {
                String parent = categories[i];
                String child = ((i + 1) >= categories.length ? null : categories[i+1]);
                node = node.put(parent, child);
            } 
        }
    }

    private void saveFileCategory(Element node, CategoryLevel cat, int level) {
        String name = node.getAttribute("name");
        NodeList nodelist = node.getElementsByTagName("Level"+(level+1));
        for (int i = 0; i < nodelist.getLength(); i++) {
            Node nextnode = nodelist.item(i);
            if (nextnode.getNodeType() == Node.ELEMENT_NODE) {
                CategoryLevel nextcat = cat.put(name, ((Element)nextnode).getAttribute("name")); 
                saveFileCategory((Element)nextnode, nextcat, level+1);
            }
        }
    }

    private CategoryLevel initCategories() throws Exception {

        CategoryLevel rootcategory = new CategoryLevel();

        if (xmlfile != null) {
            File file = new File(xmlfile);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            org.w3c.dom.Document dom = db.parse(file);
            dom.getDocumentElement().normalize();
            NodeList nodelist = dom.getElementsByTagName("Level1");
            for (int i = 0; i < nodelist.getLength(); i++) {
                Node node = nodelist.item(i);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    saveFileCategory((Element)node, rootcategory, 1);
                }
            }
        }
        
        return rootcategory;
    }

	private List<Map<String, String>> getBook(int bookId) throws Exception {

        List<Map<String, String>> books = new ArrayList<Map<String, String>>();

	    String sql = "select title, author, bisac_codes, sourced_from, isbn from books where id = " + bookId;
        Statement stmt = connection.createStatement();
        ResultSet result = stmt.executeQuery(sql);

        String id;
        String title;
        String author;
        String sourcedfrom;
        String bisac_codes;
        String isbn;

        long fstart, fstop;

        id = Integer.toString(bookId);

        if (result.next()) {
            title = result.getString("title");
            title = title == null ? "" : title;

            author = result.getString("author");
            author = author == null ? "" : author;
            String[] authors = new String[0];
            if (!author.equals("")) {
            	authors = author.split("&");
            	for (int j =0; j< authors.length; j++) {
            		if (authors[j].matches(":[a-z]:.*")) {
            			authors[j] = authors[j].substring(3);
            		}
            	}
            }
            sourcedfrom = result.getString("sourced_from");
            sourcedfrom = sourcedfrom == null ? "" : sourcedfrom;

            isbn = result.getString("isbn");
            isbn = isbn == null ? "" : isbn;

            bisac_codes = result.getString("bisac_codes");
            bisac_codes = bisac_codes == null ? "" : bisac_codes;
            String[] codes = bisac_codes.split(",");
   
            if (!title.equals("")) {
                for (int i=0; i< codes.length; i++) {
                    Map<String, String> book = new HashMap<String, String>();
                    String[] categories = getFullCategoryForCode(codes[i]);
                    if (categories != null) {
                        saveCategories(categories);
                        for (int j=0; j<categories.length; j++) {
                            int index = j+1;
                            String label = "level" + index; 
                            book.put(label, categories[j]);
                        }
                        book.put("title", title);
                        for (int j=0; j<authors.length; j++) {
                        	book.put("author"+j, authors[j]);
                        }
                        book.put("id", id);
                        book.put("sourcedfrom", sourcedfrom);
                        book.put("isbn", isbn);
                        books.add(book);
                    }
                }
            }
        }
                
        result.close();
        stmt.close();

        return books;
    }

	private int[] getRange() throws Exception {
	    String sql = "select min(id), max(id) from books";
        Statement stmt = connection.createStatement();
        ResultSet result = stmt.executeQuery(sql);
        int range[] = new int[2];
        range[0] = 0;
        range[1] = -1;
        if (result.next()) {
            range[0] = result.getInt(1);
            range[1] = result.getInt(2);
        }
        System.out.println("Min: "+range[0]+" Max: "+range[1]);    
        result.close();
        stmt.close();
        return range;
    }

    public void addDocument(List<Map<String, String>> books) throws Exception {

        Iterator<Map<String, String>> iter = books.iterator();
        while (iter.hasNext()) {
            Map<String, String> book = iter.next();
            Document doc = new Document();
            doc.add(new Field("entityId", book.get("id"), Field.Store.YES, Field.Index.NOT_ANALYZED));
            doc.add(new Field("sourcedfrom", book.get("sourcedfrom"), Field.Store.NO, Field.Index.ANALYZED));
            String value = null;
            long j=0;
            while (book.containsKey("author"+j)) {
                value = book.get("author"+j);
                if (value != null) {
                	doc.add(new Field("author", value, Field.Store.YES, Field.Index.ANALYZED));
                	String[] words = value.split(" ");
                    for (String word: words) {
                        word = word.replaceAll("\\W+", "").toLowerCase();
                        doc.add(new Field("spell_author", word, Field.Store.YES, Field.Index.NOT_ANALYZED));
                    }
                	value = value.replaceAll("\\W+", "").toLowerCase();
                	doc.add(new Field("spell_author", value, Field.Store.YES, Field.Index.NOT_ANALYZED));
                }
                j++;
            }
            value = book.get("title");
            if (value != null) {
                doc.add(new Field("title", value, Field.Store.YES, Field.Index.ANALYZED));
                String[] words = value.split(" ");
                //StringBuffer alltogether = new StringBuffer();
                for (String word: words) {
                   if (word.length() > 3) {
                	   word = word.replaceAll("\\W+", "").toLowerCase();
                	   doc.add(new Field("spell_title", word, Field.Store.YES, Field.Index.NOT_ANALYZED));
                	   //alltogether.append(word);
                   }
                }
                //value = alltogether.toString();
                //if (!value.equals(""))
                	//doc.add(new Field("spell_title", value, Field.Store.YES, Field.Index.NOT_ANALYZED));
            }
            
            doc.add(new Field("isbn", book.get("isbn"), Field.Store.YES, Field.Index.NOT_ANALYZED));
            for (int i = 0; i < LEVELS; i++) {
                int index = i + 1;
                String label = "level" + index;
                String category = book.get(label);
                String real_name = category;
                String key = real_name.replaceAll("\\W+", "");
                doc.add(new Field(label, key, Field.Store.NO, Field.Index.NOT_ANALYZED));
                doc.add(new Field(label+"_real", real_name, Field.Store.YES, Field.Index.NO));
            }
            indexWriter.addDocument(doc);
        }
    }

    private Element[] buildDOM(CategoryLevel node, int level, org.w3c.dom.Document dom) {
        List<Element> result = new ArrayList<Element>();
        if (node == null)
           return null;
        Set<String> categories = node.getKeys();
        Iterator it = categories.iterator();
        while (it.hasNext()) {
              String name = (String)it.next();
              Element e = dom.createElement("Level"+level);
              e.setAttribute("name", name);
              Element[] newelements = buildDOM(node.get(name), level+1, dom);
              if (newelements != null) {
                for (Element element: newelements) {    
                    e.appendChild(element);
                }
              }
              result.add(e);
        }
        return result.toArray(new Element[0]); 
    }
    
    
    public void addReferenceDocument() throws Exception {

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        org.w3c.dom.Document dom = db.newDocument();

        Element root = dom.createElement("Categories");
        dom.appendChild(root);

        Element[] elements = buildDOM(rootcategory, 1, dom); 

        if (elements != null) {
            for (Element element: elements) {    
                root.appendChild(element);
            }
        }

        TransformerFactory transfac = TransformerFactory.newInstance();
        Transformer trans = transfac.newTransformer();
        trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        trans.setOutputProperty(OutputKeys.INDENT, "yes");

        FileWriter fw = new FileWriter(new File(xmlfile));
        StreamResult result = new StreamResult(fw);
        DOMSource source = new DOMSource(dom);

        trans.transform(source, result);
        fw.close();
    }

    public void runIndex() throws Exception {

        long timer10kstart, timer10kend;

        timer10kstart = System.currentTimeMillis();
        try {
            int range[] = getRange();

            if (startId > 0) { 
                range[0] = startId;
                System.out.println("Starting index from id: " + startId);
            }

            if (!newIndex) {
                rootcategory = initCategories();
            }

            for (int i = (range[0] == 0 ? 1 : range[0]); i <= range[1]; i++) {
                
                List<Map<String, String>> books = getBook(i);
                if (books != null) { 
                    addDocument(books);
                }
                if ((i % 1000000) == 0) {
                    timer10kend = System.currentTimeMillis();
                    System.out.println("Indexed: "+i+" books in "+(timer10kend - timer10kstart)/1000+" sec. ");
                }
            }
            System.out.println("Indexing Completed. Adding reference document.");
            addReferenceDocument();
            System.out.println("Completed adding reference document.");
            System.out.println("Optimizing Index. Will take a few minutes....");
            indexWriter.optimize();
            indexWriter.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            close();
        }
    }

    private void createAuthorSpellIndex(String indexDir) throws IOException {

        IndexReader indexReader = null;
        System.out.println("Creating spell dictionary and index for author names ...");
        try {
            Directory d  = FSDirectory.getDirectory(indexDir);
            Directory dspell  = FSDirectory.getDirectory(indexDir + "_spell_author");
            indexReader = IndexReader.open(d);
            SpellChecker spellChecker = new SpellChecker(dspell);
            Dictionary dict = new LuceneDictionary(indexReader, "spell_author");
            spellChecker.indexDictionary(dict);
        } finally {
            if (indexReader != null) {
                indexReader.close();
            }
        }
    }
    
    private void createTitleSpellIndex(String indexDir) throws IOException {

        IndexReader indexReader = null;
        System.out.println("Creating spell dictionary and index for book titles ...");
        try {
            Directory d  = FSDirectory.getDirectory(indexDir);
            Directory dspell  = FSDirectory.getDirectory(indexDir + "_spell_title");
            indexReader = IndexReader.open(d);
            SpellChecker spellChecker = new SpellChecker(dspell);
            Dictionary dict = new LuceneDictionary(indexReader, "spell_title");
            spellChecker.indexDictionary(dict);
        } finally {
            if (indexReader != null) {
                indexReader.close();
            }
        }
    }


    public static void main(String[] args) {
        if (args.length < 7) {
            System.out.println("Insufficient arguments.");
            System.out.println("Usage: BookIndex <index_dir> <categories.xml file> <newindex> <db_host> <user> <password> <startvalue>");
            return;
        }
        else {
            try {
                boolean newindex = args[2].equalsIgnoreCase("true") ? true : false;
                int startcount = Integer.parseInt(args[6]);
                BookIndex bookIndex = new BookIndex(args[0], args[1], newindex, args[3], args[4], args[5], startcount);
                bookIndex.runIndex();
                bookIndex.createAuthorSpellIndex(args[0]);
                bookIndex.createTitleSpellIndex(args[0]);
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
    }
}
