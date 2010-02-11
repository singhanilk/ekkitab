import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.Hit;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.HitIterator;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.Directory;
import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.ScoreDoc;

import java.util.*;
import java.io.*;

public class BookSearch {

    private String indexDir;
    private IndexSearcher searcher = null;
    private IndexReader reader = null;
    private Sort sorter = new Sort();
    private static Set<String> discardwords = new HashSet<String>();
    static {
        discardwords.add("the");
        discardwords.add("for");
        discardwords.add("and");
    }
    
    public BookSearch(String indexDir) throws Exception {
        if (searcher == null) {
            try {
                this.indexDir = indexDir;
                Directory dir = FSDirectory.getDirectory(indexDir);
                if (IndexReader.isLocked(dir)) {
                    IndexReader.unlock(dir);
                    System.out.println("Index Directory locked. Trying to unlock...");
                }
                reader = IndexReader.open(dir);
                searcher = new IndexSearcher(reader);
            }
            catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }

    private String getFieldValue(Field fd) {
        return (fd == null ? null : fd.stringValue());
    }

    private List<Map<String, String>> getBooks(ScoreDoc[] hits, int start, int end) 
                        throws Exception {

        List<Map<String, String>> result = new ArrayList<Map<String, String>>();
        try {
            for (int i = start; ((i<end) && (i < hits.length)); i++) {
                Document doc = searcher.doc(hits[i].doc);
                Map<String,String> book = new HashMap<String, String>();
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
                result.add(book);
             }
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
            throw new Exception(e.getMessage());
        }
        return result;
    }

    public Map<String, Object> searchBook(String category, String query, int pageSz, int page) throws Exception {

       Map<String, Object> result = new HashMap<String, Object>();
       List<Map<String, String>> books = new ArrayList<Map<String, String>>();
       Map<String, Integer> counts = null;
       BookHitCollector collector = null;

       int startIndex = (page - 1) * pageSz;
       int endIndex   = startIndex + pageSz;

       QueryParser qpt = new QueryParser("title", new SimpleAnalyzer());

       String modquery = "";
       StringBuffer sb = new StringBuffer();

       if (!query.equals("")) {

            String phrase = "";
            String[] words = query.split(" ");
            if (words.length > 1)
                    phrase = "\"" + query + "\"";

            if (!phrase.equals("")) {
                sb.append(phrase+"^3 ");
                sb.append("author:"+phrase+"^3 ");
            }
            String conjunction = "";
            StringBuffer sbtmp = new StringBuffer();
            for (String word: words) {
                if ((word.length() > 2) && (!discardwords.contains(word))) {
                    sbtmp.append(conjunction);
                    conjunction = " OR ";
                    sbtmp.append(word+" ");
                    sbtmp.append(conjunction);
                    sbtmp.append("author:"+word+" ");
                 }
            }
            if (sbtmp.length() > 0) {
                sb.append("+( ");
                sb.append(sbtmp.toString());
                sb.append(") ");
            }
       }

       if (!category.equals("")) {
            String[] levels = category.split("/");
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

       System.out.println("Query: "+modquery);

       if (modquery.equals("")) {
            System.out.println("Query: is empty.");
            result.put("books", null);
            result.put("counts", null);
            result.put("hits", new Integer(0));
       }
       else {

            try {
                long fstart = System.currentTimeMillis();
                Query luceneQuery = qpt.parse(modquery);
                System.out.println("Lucene Query: "+luceneQuery.toString());

                collector = new BookHitCollector(searcher, reader, sorter, 5000, category);

                searcher.search(luceneQuery, collector);
                ScoreDoc[] hits = collector.topDocs().scoreDocs;


                if (hits.length > 0) {
                    books = getBooks(hits, startIndex, endIndex);
                    counts = collector.getCounts();
                }

                result.put("books", books);
                result.put("counts", counts);
                result.put("hits", new Integer(hits.length));
                long fstop = System.currentTimeMillis();
                System.out.println("Returned "+hits.length+" hits in "+(fstop - fstart)/1000+" sec.");
            }
            catch(Exception e) {
                System.out.println(e.getMessage());
                throw new Exception(e.getMessage());
            }
       }
       return (result);
    }

    public static void main (String[] args) {
       BookSearch booksearch = null;
       if (args.length < 1) {
           System.out.println("No index directory defined.");
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
                    System.out.println("Author: "+book.get("author"));
                    System.out.println("Title: "+book.get("title"));
                    System.out.println("Url: "+book.get("url"));
                    System.out.println("Image: "+book.get("image"));
                    System.out.println("Price: "+book.get("listprice"));
                    System.out.println("Discounted Price: "+book.get("discountprice"));
                    System.out.println("Id: "+book.get("entityId"));
                    System.out.println("ISBN: "+book.get("isbn"));
                    System.out.println("Delivery Time: "+book.get("delivertime"));
                    System.out.println("Binding: "+book.get("binding"));
                    System.out.println("Language: "+book.get("language"));
                    System.out.println("In Stock: "+book.get("instock"));
                    System.out.println("Short Description: "+book.get("shortdesc"));
                    System.out.println("--------------------------------------");
                }
                System.out.println("The number of books returned is: "+books.size());
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
            searcher.close();
            reader.close();
       }
       finally {
            super.finalize();
       }
    }
}
