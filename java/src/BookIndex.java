import java.io.*;
import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.document.Field;

public class BookIndex {
    private String file;
    private BufferedReader reader = null;
    private Document d = null;
    IndexWriter indexWriter = null;

    public BookIndex(String file, String indexDir) throws Exception {
        this.file = file;
        Directory d  = FSDirectory.getDirectory(indexDir);
        indexWriter = new IndexWriter(d,new SimpleAnalyzer(),true);
        indexWriter.setUseCompoundFile(true);
    }

    public void addDocument(String[] parts) throws Exception {
        Document doc = new Document();
        doc.add(new Field("entityId", parts[0], Field.Store.YES, Field.Index.NO));
        doc.add(new Field("author", parts[1], Field.Store.YES, Field.Index.TOKENIZED));
        doc.add(new Field("title", parts[2], Field.Store.YES, Field.Index.TOKENIZED));
        doc.add(new Field("image", parts[3], Field.Store.YES, Field.Index.NO));
        doc.add(new Field("url", parts[4], Field.Store.YES, Field.Index.NO));
        indexWriter.addDocument(doc);
    }

    public void runIndex() throws Exception {
        int i = 1;

        if (reader == null) {
            reader = new BufferedReader(new FileReader(file));
        }
        try {
            long fstart = System.currentTimeMillis();
            long fstop = fstart;
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\t");
                if (parts.length != 5) {
                    System.out.println("Line has wrong format.");
                    throw new Exception("Bad Line Format");
                }
                if ((i++ % 10000) == 0) {
                    fstop = System.currentTimeMillis();
                    System.out.println("Indexed: "+i+" books in "+(fstop-fstart)/1000+ " seconds.");
                }
                addDocument(parts);
            }
            indexWriter.optimize();
            indexWriter.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            reader.close();
        }
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("No input file defined (OR) no index directory defined.");
            return;
        }
        else {
            try {
                BookIndex bookIndex = new BookIndex(args[0], args[1]);
                bookIndex.runIndex();
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }
    }
}
