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
import java.util.*;
import java.io.*;

public class BookSearch {

    private String indexDir;
    private IndexSearcher searcher;
    
    public BookSearch(String indexDir) throws Exception {
        this.indexDir = indexDir;
        searcher = new IndexSearcher(FSDirectory.getDirectory(indexDir));
    }

    private String getFieldValue(Field fd) {
        return (fd == null ? null : fd.stringValue());
    }

    private List<Map<String, String>> getBooks(Hits hits, List<Map<String,String>> books, int start, int end) 
                        throws Exception {
        HitIterator iter = (HitIterator)hits.iterator(); 
        int i = 0;
        try {
            while (iter.hasNext()) {
			    Hit hit = (Hit)iter.next();
                if (i++ < start) 
                    continue;
                if (i > end)
                    break;
			    Document doc = hit.getDocument();
                Map<String,String> book = new HashMap<String, String>();
                book.put("author", getFieldValue(doc.getField("author")));
                book.put("title", getFieldValue(doc.getField("title")));
                book.put("image", getFieldValue(doc.getField("image")));
                book.put("url", getFieldValue(doc.getField("url")));
                book.put("entityId", getFieldValue(doc.getField("entityId")));
                books.add(book);
            }
        }
        catch (Exception e) {
            throw new Exception(e.getMessage());
        }
        System.out.println("Book Size: "+books.size());
        return books;
    }

    public Map<String, Object> searchBook(String query, int pageSz, int page) throws Exception {

       Map<String, Object> result = new HashMap<String, Object>();
       List<Map<String, String>> books = new ArrayList<Map<String, String>>();

       int startIndex = (page - 1) * pageSz;
       int endIndex   = startIndex + pageSz;

       Query termQuery = new TermQuery(new Term("author",query));
       Hits hits = searcher.search(termQuery);
       result.put("hitcount-author", new Integer(hits.length()));

       System.out.println("Start: "+startIndex+"  End: "+endIndex);
       if (hits.length() > 0)
            getBooks(hits, books, startIndex, endIndex);

       if ((books.size() > 0) && (books.size() < pageSz)) {
            startIndex = 0;
            endIndex   = (pageSz - books.size());
       }

       termQuery = new TermQuery(new Term("title",query));
       hits = searcher.search(termQuery);
       result.put("hitcount-title", new Integer(hits.length()));

       if (books.size() < pageSz) {
            System.out.println("Again: Start: "+startIndex+"  End: "+endIndex);
            if (hits.length() > 0)
               getBooks(hits, books, startIndex, endIndex);
       }

       result.put("books", books);
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
              if ((query == null) || (query.equals("")))
                  break; 
              Map<String, Object> results = booksearch.searchBook(query,10,5);
              System.out.println((Integer)results.get("hitcount-author")+" hits in author");
              System.out.println((Integer)results.get("hitcount-title")+" hits in author");
              List<Map<String, String>> books = (List<Map<String, String>>)results.get("books");
              Iterator iter = books.iterator();
              while (iter.hasNext()) {
                  Map<String, String> book = (Map<String, String>)iter.next();
                  System.out.println("Author: "+book.get("author"));
                  System.out.println("Title: "+book.get("title"));
                  System.out.println("Url: "+book.get("url"));
                  System.out.println("Image: "+book.get("image"));
                  System.out.println("Id: "+book.get("entityId"));
                  System.out.println("--------------------------------------");
              }
              System.out.println("The number of books returned is: "+books.size());
          }
        
       } catch (Exception e) {
         e.printStackTrace();
         System.exit(1);
       }
    }
}
