import java.io.*;
import java.util.*;
import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.document.Field;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

public class BookIndex {
    private Document d = null;
    private Connection connection = null; 
    private String user = "";
    private String password = "";
	private String jdbcUrl = "jdbc:mysql://localhost:3306/reference";
    private static final int  LEVELS = 7;
    private IndexWriter indexWriter = null;
    private int  testcount = 0;
    private Map<String, Integer>  testcounthash = new HashMap<String, Integer>();

    private long timer[] = new long[3];

    public BookIndex(String indexDir, String db, String user, String password) throws Exception {
        this.user = user;
        this.password = password;
        Directory d  = FSDirectory.getDirectory(indexDir);
        indexWriter = new IndexWriter(d,new SimpleAnalyzer(),true);
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

        return levels;
    }

	private List<Map<String, String>> getBook(int bookId) throws Exception {

        List<Map<String, String>> books = new ArrayList<Map<String, String>>();

	    String sql = "select title, author, bisac_codes, sourced_from, isbn, image, list_price, discount_price from books where product_id = " + bookId;
        Statement stmt = connection.createStatement();
        ResultSet result = stmt.executeQuery(sql);

        String id;
        String title;
        String author;
        String discountprice;
        String listprice;
        String image;
        String url;
        String sourcedfrom;
        String bisac_codes;

        long fstart, fstop;

        id = Integer.toString(bookId);

        if (result.next()) {
            title = result.getString("title");
            title = title == null ? "" : title;

            author = result.getString("author");
            author = author == null ? "" : author;

            sourcedfrom = result.getString("sourced_from");
            sourcedfrom = sourcedfrom == null ? "" : sourcedfrom;

            listprice = result.getString("list_price");
            listprice = listprice == null ? "" : listprice;

            discountprice = result.getString("discount_price");
            discountprice = discountprice == null ? "" : discountprice;

            image = result.getString("image");
            image = image == null ? "" : image;
            image = "/" + image.charAt(0) + "/" + image.charAt(1) + "/" + image;

            url = result.getString("isbn");
            url = url == null ? "" : url;
            url = title + "-" + url;
            url = url.replaceAll("'", "");
            url = url.replaceAll(" ", "-");
        
            bisac_codes = result.getString("bisac_codes");
            bisac_codes = bisac_codes == null ? "" : bisac_codes;
            String[] codes = bisac_codes.split(",");
   
            if (!title.equals("")) {
                for (int i=0; i< codes.length; i++) {
                    Map<String, String> book = new HashMap<String, String>();
                    fstart = System.currentTimeMillis();
                    String[] categories = getFullCategoryForCode(codes[i]);
                    fstop = System.currentTimeMillis();
                    timer[0] += fstop - fstart;
                    if (categories != null) {
                        for (int j=0; j<categories.length; j++) {
                            int index = j+1;
                            String label = "level" + index; 
                            book.put(label, categories[j]);
                        }
                        book.put("title", title);
                        book.put("author", author);
                        book.put("discountprice", discountprice);
                        book.put("listprice", listprice);
                        book.put("image", image);
                        book.put("url", url);
                        book.put("id", id);
                        book.put("sourcedfrom", sourcedfrom);
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
	    String sql = "select min(product_id), max(product_id) from books";
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

        Iterator iter = books.iterator();
        while (iter.hasNext()) {
            Map<String, String> book = (Map<String, String>)iter.next();
            Document doc = new Document();
            doc.add(new Field("entityId", book.get("id"), Field.Store.YES, Field.Index.NO));
            doc.add(new Field("sourcedfrom", book.get("sourcedfrom"), Field.Store.NO, Field.Index.TOKENIZED));
            doc.add(new Field("author", book.get("author"), Field.Store.YES, Field.Index.TOKENIZED));
            doc.add(new Field("url", book.get("url"), Field.Store.YES, Field.Index.NO));
            doc.add(new Field("image", book.get("image"), Field.Store.YES, Field.Index.NO));
            doc.add(new Field("title", book.get("title"), Field.Store.YES, Field.Index.TOKENIZED));
            doc.add(new Field("discountprice", book.get("discountprice"), Field.Store.YES, Field.Index.NO));
            doc.add(new Field("listprice", book.get("listprice"), Field.Store.YES, Field.Index.NO));

            for (int i = 0; i < LEVELS; i++) {
                int index = i + 1;
                String label = "level" + index;
                String category = book.get(label);
                String real_name = category;
                String key = real_name.replaceAll("\\W+", "");
                doc.add(new Field(label, key, Field.Store.NO, Field.Index.UN_TOKENIZED));
                doc.add(new Field(label+"_real", real_name, Field.Store.YES, Field.Index.NO));
                if (label.equals("level1") && key.equals("antiquescollectibles")) {
                    testcount++;
                    String id = book.get("id");
                    if (testcounthash.containsKey(id)) 
                        testcounthash.put(id, new Integer((Integer)(testcounthash.get(id)) + 1));
                    else 
                        testcounthash.put(book.get("id"), new Integer(1));
                }
            }
            indexWriter.addDocument(doc);
        }
    }

    public void runIndex() throws Exception {

        long timer10kstart, timer10kend, fstart, fstop;

        timer[0] = timer[1] = timer[2] = 0;
        timer10kstart = System.currentTimeMillis();
        try {
            int range[] = getRange();

            for (int i = (range[0] == 0 ? 1 : range[0]); i <= range[1]; i++) {
                
                fstart = System.currentTimeMillis();
                List<Map<String, String>> books = getBook(i);
                fstop = System.currentTimeMillis();
                timer[1] += fstop - fstart;
                if (books != null) { 
                    fstart = System.currentTimeMillis();
                    addDocument(books);
                    fstop = System.currentTimeMillis();
                    timer[2] += fstop - fstart;
                }
                if ((i % 10000) == 0) {
                    timer10kend = System.currentTimeMillis();
                    System.out.println("Indexed: "+i+" books in "+(timer10kend - timer10kstart)/1000+" sec. ["+timer[0]/1000+"] ["+timer[1]/1000+"] ["+timer[2]/1000+"]");
                }
            }
            indexWriter.optimize();
            indexWriter.close();
            System.out.println("Testcount: "+testcount);
            Set keys = testcounthash.keySet();
            Iterator iter = keys.iterator();
            while (iter.hasNext()) {
                String key = (String)iter.next();
                System.out.println("Product Id: "+key+"  --  "+ testcounthash.get(key));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            close();
        }
    }

    public static void main(String[] args) {
        if (args.length < 4) {
            System.out.println("Insufficient arguments.");
            System.out.println("Usage: BookIndex <index_dir> <db_host> <user> <password>");
            return;
        }
        else {
            try {
                BookIndex bookIndex = new BookIndex(args[0], args[1], args[2], args[3]);
                bookIndex.runIndex();
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
    }
}
