import java.io.*;
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
	private String jdbcUrl = "jdbc:mysql://localhost:3306/ekkitab_books";

    private static final int AUTHOR_ATTR_ID = 496;
    private static final int URL_ATTR_ID    = 83;
    private static final int IMAGE_ATTR_ID  = 71;
    private static final int TITLE_ATTR_ID  = 56;
    private static final int PRICE_ATTR_ID  = 60;
    private static final int DISCOUNTED_PRICE_ATTR_ID  = 61;
    private static final int SOURCED_FROM_ATTR_ID  = 512;
    private static final String QUERY_EACH_BOOK_VARCHAR = "select value from catalog_product_entity_varchar where attribute_id in (" +
                                 " ?, ?, ?, ?, ?) and entity_id = ? order by attribute_id desc"; 
    private static final String QUERY_EACH_BOOK_DECIMAL = "select value from catalog_product_entity_decimal where attribute_id in (" +
                                 " ?, ?) and entity_id = ? order by attribute_id desc"; 

    IndexWriter indexWriter = null;

    public BookIndex(String indexDir, String db, String user, String password) throws Exception {
        this.user = user;
        this.password = password;
        Directory d  = FSDirectory.getDirectory(indexDir);
        indexWriter = new IndexWriter(d,new SimpleAnalyzer(),true);
        indexWriter.setUseCompoundFile(true);
        jdbcUrl = "jdbc:mysql://"+db+":3306/ekkitab_books";
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

	private String[] getBook(int bookId) throws Exception {
        PreparedStatement stmt = connection.prepareStatement(QUERY_EACH_BOOK_VARCHAR);
        stmt.setInt(1, TITLE_ATTR_ID);
        stmt.setInt(2, IMAGE_ATTR_ID);
        stmt.setInt(3, URL_ATTR_ID);
        stmt.setInt(4, AUTHOR_ATTR_ID);
        stmt.setInt(5, SOURCED_FROM_ATTR_ID);
        stmt.setInt(6, bookId);

        ResultSet result = stmt.executeQuery();
        String[] book = new String[8];
        book[0] = Integer.toString(bookId);
        int i  = 1;
        while (result.next()) {
            book[i++] = result.getString("value");
        }
        result.close();
        stmt.close();

        stmt = connection.prepareStatement(QUERY_EACH_BOOK_DECIMAL);
        stmt.setInt(1, PRICE_ATTR_ID);
        stmt.setInt(2, DISCOUNTED_PRICE_ATTR_ID);
        stmt.setInt(3, bookId);

        result = stmt.executeQuery();
        i = 6;
        while (result.next()) {
            book[i++] = result.getString("value");
        }
        result.close();
        stmt.close();

        return book;
    }

	private int[] getRange() throws Exception {
	    String sql = "select min(entity_id), max(entity_id) from catalog_product_entity";
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

    public void addDocument(String[] parts) throws Exception {
        Document doc = new Document();
        doc.add(new Field("entityId", parts[0], Field.Store.YES, Field.Index.NO));
        doc.add(new Field("sourcedfrom", parts[1], Field.Store.NO, Field.Index.TOKENIZED));
        doc.add(new Field("author", parts[2], Field.Store.YES, Field.Index.TOKENIZED));
        doc.add(new Field("url", parts[3], Field.Store.YES, Field.Index.NO));
        doc.add(new Field("image", parts[4], Field.Store.YES, Field.Index.NO));
        doc.add(new Field("title", parts[5], Field.Store.YES, Field.Index.TOKENIZED));
        doc.add(new Field("discountprice", parts[6], Field.Store.YES, Field.Index.NO));
        doc.add(new Field("listprice", parts[7], Field.Store.YES, Field.Index.NO));
        indexWriter.addDocument(doc);
    }

    public void runIndex() throws Exception {
        try {
            int range[] = getRange();
            long fstart = System.currentTimeMillis();
            long fstop = fstart;

            for (int i = range[0]; i <= range[1]; i++) {
                String[] book = getBook(i);
                addDocument(book);
                if ((i % 10000) == 0) {
                    fstop = System.currentTimeMillis();
                    System.out.println("Indexed: "+i+" books in "+(fstop-fstart)/1000+ " seconds.");
                }
            }
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
