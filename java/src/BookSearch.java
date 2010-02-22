import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.Hit;
import org.apache.lucene.search.HitCollector;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.HitIterator;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopFieldDocCollector;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.Directory;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.log4j.Logger;
import org.apache.log4j.RollingFileAppender;
import org.apache.log4j.LogManager;
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

import java.util.*;
import java.io.*;

public class BookSearch {

    private static Set<String> discardwords = null;
    private static Set<String> searchfields = null;
    private static int allInstances = 0;
    private static Logger logger = null; 
    private static final int MAXHITS = 1000;
    private static CategoryLevel rootcategory = null;
    private static Properties properties = null;

    private String indexDir;
    private IndexSearcher searcher = null;
    private IndexReader reader = null;
    private Sort sorter = new Sort();
    private int instanceId = 0; 
    private Map<String, Integer> catMap = null;

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

    private void saveCategory(Element node, CategoryLevel cat, int level) {
        String name = node.getAttribute("name");
        NodeList nodelist = node.getElementsByTagName("Level"+(level+1));
        for (int i = 0; i < nodelist.getLength(); i++) {
            Node nextnode = nodelist.item(i);
            if (nextnode.getNodeType() == Node.ELEMENT_NODE) {
                CategoryLevel nextcat = cat.put(name, ((Element)nextnode).getAttribute("name")); 
                saveCategory((Element)nextnode, nextcat, level+1);
            }
        }
    }

    private CategoryLevel initCategories() throws Exception {
        String categoryinfofile = properties.getProperty("categoriesfile.path");
        if (categoryinfofile == null) {
            System.out.println("Category Info file is NULL");
            throw new Exception("Missing property: category information file.");
        }
        
        File file = new File(categoryinfofile);
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        org.w3c.dom.Document dom = db.parse(file);
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

    static {
        logger = LogManager.getLogger("BookSearch.class");
        discardwords = new HashSet<String>();
        searchfields = new HashSet<String>();
        properties = new Properties(); 
        try { 
            InputStream is = BookSearch.class.getClassLoader().getResourceAsStream("search.properties");
            properties.load(is); 
        } 
        catch (IOException e) { 
            System.out.println("Caught Exception during load of properties...");
        } 
        //RollingFileAppender appndr=(RollingFileAppender)logger.getAppender("EKK");
        //appndr.setFile(properties.getProperty("logfile", "search.log"));
        //appndr.activateOptions();

        discardwords.add("the");
        discardwords.add("for");
        discardwords.add("and");

        searchfields.add("title");
        searchfields.add("author");
        searchfields.add("isbn");
        try {
            rootcategory = new BookSearch().initCategories();
        }
        catch (Exception e) {
            logger.fatal("Failed category initialization. "+e.getMessage());
            rootcategory = null;
        }
    }
    
    public BookSearch(String indexDir) throws Exception {
        if (rootcategory == null)
            throw new Exception("Initialization Failed in first check.");
        try {
            if (indexDir != null) 
                this.indexDir = indexDir;
            else
                this.indexDir = properties.getProperty("searchdir.path");
            Directory dir = FSDirectory.getDirectory(this.indexDir);
            if (IndexReader.isLocked(dir)) {
                IndexReader.unlock(dir);
                logger.debug("["+instanceId+"] Index Directory locked. Trying to unlock...");
            }
            reader = IndexReader.open(dir);
            searcher = new IndexSearcher(reader);
        }
        catch (Exception e) {
            logger.debug("["+instanceId+"] "+e.getMessage());
            throw new Exception("Initialization failed in second check.");
        }
        synchronized (BookSearch.class) {
            instanceId = ++allInstances;
            if (allInstances >= 1000000)
                allInstances = 0;
        }
    }

    private BookSearch() {
        System.out.println("In the initialization....");
    }

    private String getFieldValue(Field fd) {
        return (fd == null ? null : fd.stringValue());
    }

    private Map<String, String> getBook(Document doc) 
                        throws Exception {

        List<Map<String, String>> result = new ArrayList<Map<String, String>>();
        Map<String, String> book = new HashMap<String, String>();
        try {
           book.put("author", getFieldValue(doc.getField("author")));
           book.put("title", getFieldValue(doc.getField("title")));
           book.put("image", getFieldValue(doc.getField("image")));
           book.put("url", getFieldValue(doc.getField("url")));
           book.put("listprice", getFieldValue(doc.getField("listprice")));
           book.put("discountprice", getFieldValue(doc.getField("discountprice")));
           book.put("entityId", getFieldValue(doc.getField("entityId")));
           book.put("isbn", getFieldValue(doc.getField("isbn")));
           book.put("language", getFieldValue(doc.getField("language")));
           book.put("shortdesc", getFieldValue(doc.getField("shortdesc")));
           book.put("binding", getFieldValue(doc.getField("binding")));
           book.put("delivertime", getFieldValue(doc.getField("delivertime")));
           book.put("instock", getFieldValue(doc.getField("instock")));
        }
        catch (Exception e) {
            logger.debug("["+instanceId+"] "+e.getMessage());
            throw new Exception(e.getMessage());
        }
        return book;
    }

    private List<Map<String, String>> getBooks(ScoreDoc[] hits, int start, int end) 
                        throws Exception {

        int index = 0;
        Set<String> uniques = new HashSet<String>(); 
        catMap = new HashMap<String, Integer>();
        List<Map<String, String>> result = new ArrayList<Map<String, String>>();
        try {
           for (int i = 0; (i < hits.length) && (index < end); i++) {
               Document doc = searcher.doc(hits[i].doc);
               if (doc != null) {
                  String id = getFieldValue(doc.getField("entityId"));
                  if ((id != null) && (uniques.add(id))) {
                      if ((index++ >= start) && (index < end)) {
                        result.add(getBook(doc));
                      }
                  }
                  //String key = getFieldValue(doc.getField(nextcategorylabel));
                  //if (key != null) {
                   //   if (key.length() > 0) {
                    //      if (catMap.containsKey(key))
                     //         catMap.put(key, new Integer(((Integer)catMap.get(key)).intValue() + 1));
                      //    else 
                       //       catMap.put(key, new Integer("1"));
                     // }
                 // }
               }
            }
        }
        catch (Exception e) {
            logger.debug("["+instanceId+"] "+e.getMessage());
            throw new Exception(e.getMessage());
        }
        return result;
    }

    private CategoryLevel getSearchCategories(String[] categories) {
        CategoryLevel node = rootcategory;
        if (categories != null) {
            for(int i = 0; (i < categories.length) && (node != null); i++) {
                node = node.get(categories[i]);
            }
        }
        return node;
    }

    public Map<String, Object> searchBook(String category, String query, int pageSz, int page) throws Exception {

       Map<String, Object> result = new HashMap<String, Object>();
       List<Map<String, String>> books = new ArrayList<Map<String, String>>();
       Map<String, Integer> counts = null;
       CategoryLevel searchcats = rootcategory;
       int searchlevel = 1;


       String usesearchfield = null;

       if (query != null) {
            String[] tmp = query.split(":", 2);
            if (tmp.length >= 2) {
                tmp[0] = tmp[0].toLowerCase();
                if (searchfields.contains(tmp[0])) {
                    query = tmp[1];
                    usesearchfield = tmp[0];
                }
            }    
       }

       int startIndex = (page - 1) * pageSz;
       int endIndex   = startIndex + pageSz;

       QueryParser qpt = new QueryParser("title", new StandardAnalyzer());
       //QueryParser qpt = new QueryParser("title", new SimpleAnalyzer());

       String modquery = "";
       StringBuffer sb = new StringBuffer();

       if (!query.equals("")) {

            String phrase = "";
            String[] words = query.split(" ");
            if (words.length > 1)
                    phrase = "\"" + query + "\"";

            if (!phrase.equals("")) {
                if (usesearchfield != null) {
                    sb.append(usesearchfield+":"+phrase+"^3 ");
                }
                else {
                    sb.append(phrase+"^3 ");
                    sb.append("author:"+phrase+"^3 ");
                }
            }
            String conjunction = "";
            StringBuffer sbtmp = new StringBuffer();
            for (String word: words) {
                if ((word.length() > 2) && (!discardwords.contains(word))) {
                    sbtmp.append(conjunction);
                    conjunction = " OR ";
                    if (usesearchfield != null) {
                        sbtmp.append(usesearchfield+":"+word+" ");
                    }
                    else {
                        sbtmp.append(word+" ");
                        sbtmp.append(conjunction);
                        sbtmp.append("author:"+word+" ");
                    }
                }
            }
            if (sbtmp.length() > 0) {
                sb.append("+( ");
                sb.append(sbtmp.toString());
                sb.append(") ");
            }
       }

       if (!category.equals("")) {
            category = category.toLowerCase();
            String[] levels = category.split("/");
            searchcats = getSearchCategories(levels);
            searchlevel = levels.length+1;
            String prelude = "";
            sb.append(" ");
            for (int i = 0; i<levels.length; i++) {
                int j = i+1;
                sb.append(prelude + "+level"+j+":"+levels[i].replaceAll("\\W+", "")+" "); 
                prelude = " AND ";
            }
       }

       if (sb.length() > 0) 
            sb.append("sourcedfrom:India^5 ");

       modquery = sb.toString();

       logger.debug("["+instanceId+"] Query: "+modquery);

       if (modquery.equals("")) {
            logger.debug("["+instanceId+"] Query: is empty.");
            result.put("books", null);
            result.put("counts", null);
            result.put("hits", new Integer(0));
       }
       else {

            try {
                long fstart = System.currentTimeMillis();
                Query luceneQuery = qpt.parse(modquery);
                logger.debug("["+instanceId+"] Lucene Query: "+luceneQuery.toString());
        
                TopFieldDocCollector collector = new TopFieldDocCollector(reader, sorter, MAXHITS);
                searcher.search(luceneQuery, collector);
                
                long fstop = System.currentTimeMillis();
                logger.debug("["+instanceId+"] Search returned in: "+(fstop - fstart)/1000+" sec. with "+collector.getTotalHits()+" hits.");
                fstart = System.currentTimeMillis();

                ScoreDoc[] docs = null;
                if (collector.getTotalHits() > 0) {
                    docs = collector.topDocs().scoreDocs;
                }

                if ((docs != null) && (docs.length > 0)) {
                    books = getBooks(docs, startIndex, endIndex);
                }
                fstop = System.currentTimeMillis();
                logger.debug("["+instanceId+"] Books collected in: "+(fstop - fstart)/1000+" sec.");

                final BitSet hits = new BitSet(reader.maxDoc());
                int catsize = 0;

                fstart = System.currentTimeMillis();
                if (searchcats != null) {
                    Set<String> cats = searchcats.getKeys();
                    catsize = cats.size();
                    for (String catname: cats) {
                        hits.clear();
                        //logger.debug("["+instanceId+"] Hit count is: "+hits.cardinality());
                        String newquery = modquery + " +level"+searchlevel+":"+catname.replaceAll("\\W+", "");
                        //logger.debug("["+instanceId+"] New Query: "+newquery);
                        Query newLuceneQuery = qpt.parse(newquery);
                        //logger.debug("["+instanceId+"] New Lucene Query: "+newLuceneQuery.toString());
                        searcher.search(newLuceneQuery, new HitCollector() { 
                                                               public void collect(int doc, float score) {
                                                                   hits.set(doc);
                                                               }
                                                            });
                        if (hits.cardinality() > 0)
                            catMap.put(catname, hits.cardinality()); 
                    }
                }
                fstop = System.currentTimeMillis();
                logger.debug("["+instanceId+"] Hits counted in "+catsize+" categories in: "+(fstop - fstart)+" millisec.");

                result.put("books", books);
                result.put("counts", catMap);
                result.put("hits", new Integer(collector.getTotalHits()));
            }
            catch(Exception e) {
                logger.debug(e.getMessage());
                throw new Exception(e.getMessage());
            }
       }
       return (result);
    }

    public static void main (String[] args) {
       BookSearch booksearch = null;
       if (args.length < 1) {
           logger.debug("No index directory defined.");
           return;
       }
       try {
          booksearch = new BookSearch(args[0]);
          BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

          while (true) {
              System.out.print("Search for? ");
              String query = br.readLine();
              System.out.print("In category? ");
              String category = br.readLine();
              System.out.print("Page? ");
              String page = br.readLine();
              if ((page == null) || page.equals(""))
                 page = "1";
              Map<String, Object> results = booksearch.searchBook(category, query, 10, Integer.parseInt(page));
              Integer numberofhits = (Integer)results.get("hits"); 
              System.out.println(numberofhits +" hits overall.");
              List<Map<String, String>> books = (List<Map<String, String>>)results.get("books");
              if (books != null) {
                Iterator iter = books.iterator();
                while (iter.hasNext()) {
                    Map<String, String> book = (Map<String, String>)iter.next();
                    System.out.println("--------------------------------------");
                    System.out.println("Author: "+book.get("author"));
                    System.out.println("Title: "+book.get("title"));
                    //System.out.println("Url: "+book.get("url"));
                    //System.out.println("Image: "+book.get("image"));
                    //System.out.println("Price: "+book.get("listprice"));
                    //System.out.println("Discounted Price: "+book.get("discountprice"));
                    //System.out.println("Id: "+book.get("entityId"));
                    //System.out.println("ISBN: "+book.get("isbn"));
                    //System.out.println("Delivery Time: "+book.get("delivertime"));
                    //System.out.println("Binding: "+book.get("binding"));
                    //System.out.println("Language: "+book.get("language"));
                    //System.out.println("In Stock: "+book.get("instock"));
                    //System.out.println("Short Description: "+book.get("shortdesc"));
                    System.out.println("--------------------------------------");
                }
                System.out.println("The number of books returned is: "+books.size());
              }
              Map<String, Integer> catcount = (Map<String, Integer>)results.get("counts");
              if (catcount != null) {
                Set<String> keys = catcount.keySet();
                for (String key: keys) {
                    System.out.println("["+key+"] --> ["+catcount.get(key)+"]");
                } 
              }
              System.out.print("Finished? ");
              String response = br.readLine();
              if (response.equalsIgnoreCase("y")) 
                   break;
          }
        
       } catch (Exception e) {
         e.printStackTrace();
       }
       finally {
         System.exit(1);
       }
    }

    protected void finalize() throws Throwable {
       try {
            logger.debug("["+instanceId+"] Exiting...");
            searcher.close();
            reader.close();
       }
       finally {
            super.finalize();
       }
    }
}
