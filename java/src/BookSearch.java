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
import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.ScoreDoc;

import java.util.*;
import java.io.*;

public class BookSearch {

    private String indexDir;
    private static IndexSearcher searcher = null;
    private static IndexReader reader = null;
    private static Sort sorter = new Sort();
    private static BookHitCollector collector = null;
    
    public BookSearch(String indexDir) throws Exception {
        if (searcher == null) {
            this.indexDir = indexDir;
            reader = IndexReader.open(FSDirectory.getDirectory(indexDir));
            searcher = new IndexSearcher(reader);
        }
    }

    private String getFieldValue(Field fd) {
        return (fd == null ? null : fd.stringValue());
    }

    private List<Map<String, String>> getBooks(ScoreDoc[] hits, int start, int end) 
                        throws Exception {

        List<Map<String, String>> result = new ArrayList<Map<String, String>>();
        Map<String, Integer> uniques = new HashMap<String, Integer>();
        int i = 0;
        int count = 0;
        try {
            while (i < hits.length) {
                Document doc = searcher.doc(hits[i].doc);
                String id = getFieldValue(doc.getField("entityId"));
                if ((id != null) && (!uniques.containsKey(id))) {
                    uniques.put(id, 1);
                    count++;
                    if ((count >= (start+1)) && (count <= (end+1))) {
                        Map<String,String> book = new HashMap<String, String>();
                        book.put("author", getFieldValue(doc.getField("author")));
                        book.put("title", getFieldValue(doc.getField("title")));
                        book.put("image", getFieldValue(doc.getField("image")));
                        book.put("url", getFieldValue(doc.getField("url")));
                        book.put("listprice", getFieldValue(doc.getField("listprice")));
                        book.put("discountprice", getFieldValue(doc.getField("discountprice")));
                        book.put("entityId", id);
                        result.add(book);
                    }
                }
                i++;
            }
        }
        catch (Exception e) {
            throw new Exception(e.getMessage());
        }
        return result;
    }

    public Map<String, Object> searchBook(String category, String query, int pageSz, int page) throws Exception {

       Map<String, Object> result = new HashMap<String, Object>();
       List<Map<String, String>> books = new ArrayList<Map<String, String>>();
       Map<String, Integer> counts = null;


       int startIndex = (page - 1) * pageSz;
       int endIndex   = startIndex + pageSz;

       QueryParser qpt = new QueryParser("title", new SimpleAnalyzer());

       String modquery = "";

       if (!query.equals("")) {

            String[] words = query.split(" ");
            if (words.length > 1)
                    query = "\"" + query + "\"";

            StringBuffer sb = new StringBuffer();
            sb.append("sourcedfrom: India^5 ");
            sb.append(query);
            sb.append(" author:" + query+ " ");
            for (String word: words) {
                sb.append(" " + word);
                sb.append(" author:" + word);
            }
            modquery = sb.toString();
       }

       if (!category.equals("")) {
            String[] levels = category.split("/");
            StringBuffer sb = new StringBuffer();
            String prelude = "";
            //if (!modquery.equals(""))
            //    sb.append("AND ");
            sb.append("( ");
            for (int i = 0; i<levels.length; i++) {
                int j = i+1;
                sb.append(prelude + "+level"+j+":"+levels[i].replaceAll("[& ]+", "")); 
                prelude = " AND ";
            }
            sb.append(" )");
            modquery = modquery + " " + sb.toString();
       }

       System.out.println("Query: "+modquery);

       if (modquery.equals("")) {
            result.put("books", null);
            result.put("counts", null);
            result.put("hits", new Integer(0));
       }
       else {

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
       }
       return (result);
    }

    public static void main (String[] args) {
       BookSearch booksearch;
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
                  System.out.println("--------------------------------------");
              }
              System.out.println("The number of books returned is: "+books.size());
              System.out.print("Finished? ");
              String response = br.readLine();
              if (response.equalsIgnoreCase("y")) 
                   break;
          }
        
       } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
       }
    }
}
