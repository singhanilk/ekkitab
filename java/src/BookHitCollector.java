import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.Term;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Hit;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.HitIterator;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopFieldDocCollector;
import org.apache.lucene.search.Sort;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.analysis.SimpleAnalyzer;
import org.apache.lucene.queryParser.QueryParser;
import java.util.*;
import java.io.*;

public class BookHitCollector extends TopFieldDocCollector {

    private IndexSearcher searcher = null;
    private Map<String, Integer> countMap = new HashMap<String, Integer>();
    private Set<String> uniques = new HashSet<String>(); 
    private String fieldname = "";

    public BookHitCollector(IndexSearcher searcher, IndexReader reader, Sort sorter, int maxSearchResults, String category) throws IOException {
        super(reader, sorter, maxSearchResults);
        this.searcher = searcher;
        int depth = 1;
        if (category.length() > 0) {
            String[] fields = category.split("/");
            depth = fields.length + 1;
        }
        fieldname = "level"+depth+"_real";
    }

    public void collect(int doc, float score) {
        //super.collect(doc, score);
        try {
            Document document = searcher.doc(doc);
            if (document != null) {
               Field field = document.getField("entityId");
               String id = null;
               if (field != null)
                   id = field.stringValue();
               if ((id != null) && (uniques.add(id)))
                    super.collect(doc, score);
               field = document.getField(fieldname);
               if (field != null) {
                   String key = field.stringValue();
                   if (key.length() > 0) {
                        if (countMap.containsKey(key))
                            countMap.put(key, new Integer(((Integer)countMap.get(key)).intValue() + 1));
                        else 
                            countMap.put(key, new Integer("1"));
                   }
               }
            }
        }
        catch (Exception e) {
            System.err.println("ERROR: " + e.getMessage());
        }
    }

    public Map<String, Integer> getCounts() {
        return countMap;
    }
}

