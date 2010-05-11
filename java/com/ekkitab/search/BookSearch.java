package com.ekkitab.search;

import java.util.*;
import java.io.*;


import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;


public class BookSearch {

    private static Set<String> searchfields = null; 
    private static long allInstances = 0;
    private static Logger logger = null; 
    private static EkkitabCategoryTree catTree = null;
    private static Properties properties = null;

    private String indexDir;
    private long instanceId = 0; 

    private static final String PROP_XMLFILE   = "categoriesfile.path";
    private static final String PROP_INDEXFILE = "searchdir.path";
    private static final String PROPERTIESFILE = "search.properties";

    private static EkkitabSearch searcher = null;


    static {
        logger = LogManager.getLogger("BookSearch.class");

        properties = new Properties(); 
        try { 
            InputStream is = BookSearch.class.getClassLoader().getResourceAsStream(PROPERTIESFILE);
            properties.load(is); 
        } 
        catch (IOException e) { 
            logger.fatal("Failed to load properties. "+e.getMessage());
            properties = null;
        } 

        searchfields = new HashSet<String>();
        searchfields.add("title");
        searchfields.add("author");
        searchfields.add("isbn");

        try {
            catTree = new EkkitabCategoryTree(properties.getProperty(PROP_XMLFILE));
        }
        catch (EkkitabSearchException e) {
            logger.fatal("Failed category initialization. "+e.getMessage());
            catTree = null;
        }

        try {
            searcher = new EkkitabSearch(properties.getProperty(PROP_INDEXFILE));
        }
        catch (EkkitabSearchException e) {
            logger.fatal("Failed Lucene Initialization. "+e.getMessage());
            searcher = null;
        }
    }
    
    public BookSearch(String indexDir) throws EkkitabSearchException {

    	if ((catTree == null) || (searcher == null) || (properties == null)) {
    		throw new EkkitabSearchException("Ekkitab Search was not initialized correctly. Cannot continue.");
    	}
        // Ignore the indexDir value that is supplied.
        //if (indexDir != null) 
        //   this.indexDir = indexDir;
        //else
        //   this.indexDir = properties.getProperty(PROP_INDEXFILE);

        synchronized (BookSearch.class) {
            instanceId = ++allInstances;
            //if (allInstances >= 10000000)
            //    allInstances = 0;
        }
        
    }

    public SearchResult searchBook(String categoryPath, String query, int pageSz, int page) throws Exception {

       String[] categories = null;
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
       if ((categoryPath != null) && (!categoryPath.equals(""))) {
          categories = categoryPath.split("/");
       }

       int startIndex = (page - 1) * pageSz;
       int endIndex   = startIndex + pageSz;

       // escape all non alpha numeric characters since they may interfere with the lucene 
       // parse function.
       query = query.replaceAll("([^a-zA-Z0-9 ])", "\\\\$1");

       SearchResult result = searcher.searchInCategory(instanceId, query, usesearchfield, categories, startIndex, endIndex);
       Set<String> cats = catTree.getSearchCategories(null);
       int searchlevel = 1;
       if (categories != null) {
          cats = catTree.getSearchCategories(categories);
          searchlevel = categories.length+1;
       }
       if (result.getHitCount() > 0) {
    	   result.setResultCategories(searcher.getValidCategories(instanceId, result.getSearchQuery(), searchlevel, cats));
       }

       return result;
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
              if ((page == null) || page.equals("")) {
                 page = "1";
              }
              SearchResult result = booksearch.searchBook(category, query, 10, Integer.parseInt(page));
              
              String suggest = result.getSuggestQuery();
              if ((suggest != null) && (!suggest.equals(""))) {
                 System.out.println("Your search query returned zero results.");
                 System.out.println("Did you mean: \"" + suggest.trim() + "\" ?");
              }

              Integer numberofhits = result.getHitCount(); 
              System.out.println(numberofhits +" hits overall.");

              List<String> books = result.getBookIds();
              if (books != null) {
                Iterator iter = books.iterator();
                while (iter.hasNext()) {
                    String bookId = (String)iter.next();
                    System.out.println("--------------------------------------");
                    System.out.println("Book Id: "+bookId);
                    System.out.println("--------------------------------------");
                }
                System.out.println("The number of books returned is: "+books.size());
              }

              Map<String, Integer> catcount = result.getResultCategories();
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
       }
       finally {
            super.finalize();
       }
    }
}
