package com.ekkitab.search;

import java.util.*;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.HitCollector;
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
import org.apache.lucene.index.TermEnum;
import org.apache.lucene.index.TermDocs;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.DuplicateFilter;
import org.apache.lucene.search.spell.SpellChecker;

public class EkkitabSearch {
    private String query;
    private String indexDir;
    private String searchfield;
    private Directory searchDir;
    private IndexReader reader;
    private IndexSearcher searcher;
    private Sort sorter;
    private String searchQuery;
    private static Logger logger = LogManager.getLogger("EkkitabSearch.class");
    private static final int MAXHITS = 1000;
    private long instanceId;

    public EkkitabSearch(long instanceId, String query, String indexDir, String searchfield)
    					throws EkkitabSearchException {
    	this.instanceId = instanceId;
        this.query = query;
        this.indexDir = indexDir;
        this.searchfield = searchfield;
        try {
        	searchDir = FSDirectory.getDirectory(this.indexDir);
        }
        catch(Exception e) {
        	logger.fatal("Failed to read search index directory.");
        	throw new EkkitabSearchException(e);
        }
        this.reader = null;
        this.searcher = null;
        this.sorter = new Sort();
        searchQuery = null;
    }

    public SearchResult searchInCategory(String[] categories, int start, int end) 
    					throws EkkitabSearchException {
    	
        try {
    		if (reader == null) {
    			reader = IndexReader.open(searchDir);
    		} 
    		if (searcher == null) {
    			searcher = new IndexSearcher(reader);
    		}
        }
        catch(Exception e) {
        	logger.fatal("Failed to initialize Lucene Search.");
        	throw new EkkitabSearchException(e);
        }

        ScoreDoc[] docs = null;
        Query luceneQuery = null;

        searchQuery = createSearchQuery(query, categories, searchfield);
        String suggestQuery;

        try {
        	if (!searchQuery.equals("")) {
        		luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
        	}

        	suggestQuery = "";

        	if (luceneQuery != null) {
        		docs = search(luceneQuery);
        		if (docs == null) { // Try lucene suggest
        			suggestQuery  = getSuggestQuery(query);
        			searchQuery = createSearchQuery(suggestQuery, categories, searchfield);
        			//logger.debug("DEBUG: Search Query is: '" + searchQuery + "'");
        			if (!searchQuery.equals("")) {
        				luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
        				if (luceneQuery != null) {
        					docs = search(luceneQuery);
        				}
        			}
        		}
        	}
        }
        catch (Exception e) {
        	logger.fatal("Lucene search failed with exception" + e.getMessage());
        	throw new EkkitabSearchException(e);
        }

        if (docs == null) {
        	logger.debug("["+instanceId+"] No results.");
        	SearchResult result = new SearchResult(new ArrayList<String>(), 
                                    			   new HashMap<String, Integer>(),
                                     			   0,
                                     			   "");
        	return result;
        }

        BitSet allhits = new BitSet(reader.maxDoc());
        for (int i = 0; (i < docs.length); i++) {
        	allhits.set(docs[i].doc);
        }

        List<String> books = null;
        
        long fstart = System.currentTimeMillis();
        if (allhits.cardinality() > 0) {
        	try {
        		allhits = dedup(allhits);
        		books = getBooks(docs, allhits, start, end);
        	}
        	catch (Exception e){
        		logger.fatal("Failed to get books with error: " + e.getMessage());
        		throw new EkkitabSearchException(e);
        	}
        }
        long fstop = System.currentTimeMillis();

        logger.debug("["+instanceId+"] Books collected in "+(fstop - fstart)+" millisec.");

        return (new SearchResult(books, new HashMap<String, Integer>(), allhits.cardinality(), suggestQuery)); 
    }

    public Map<String, Integer> getValidCategories(int level, Set<String> categories)
    							throws EkkitabSearchException {

    	try {
    		if (reader == null) {
    			reader = IndexReader.open(searchDir);
    		} 
    		if (searcher == null) {
    			searcher = new IndexSearcher(reader);
    		}
    	}	
        catch(Exception e) {
        	logger.fatal("Failed to initialize Lucene Search.");
        	throw new EkkitabSearchException(e);
        }
        if (searchQuery == null) {
			searchQuery = "";
		}

        final BitSet hits = new BitSet(reader.maxDoc());

        Map<String, Integer> catMap = new HashMap<String, Integer>();
        int catsize = 0;

        long fstart = System.currentTimeMillis();
        if (categories != null) {
            catsize = categories.size();
            searchQuery = searchQuery.equals("") ? "" : searchQuery + " AND ";
            for (String category: categories) {
                 hits.clear();
                 String query = searchQuery + "+level"+level+":"+category.replaceAll("\\W+", "");
                 try {
                	 Query luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(query);
                	 searcher.search(luceneQuery, new HitCollector() { 
                                                         	public void collect(int doc, float score) {
                                                         		hits.set(doc);
                                                         	}
                                                     	});
                 }
                 catch (Exception e) {
                	logger.fatal("Search failed while collecting category information with error " + e.getMessage());
                	throw new EkkitabSearchException(e);
                 }
                 if (hits.cardinality() > 0) {
                	catMap.put(category, (hits.cardinality() > MAXHITS ? MAXHITS : hits.cardinality())); 
                 }
            }
       }
       long fstop = System.currentTimeMillis();

       logger.debug("["+instanceId+"] Hits counted in "+catsize+" categories in: "+(fstop - fstart)+" millisec.");
       return catMap;

    }

    private String getFieldValue(Field fd) {
        return (fd == null ? null : fd.stringValue());
    }
    
    private String createSearchQuery(String query, String[] categories, String searchfield) {

        if ((categories == null) && 
            ((query == null) || (query.equals("")))) {
            return "";
        }

        StringBuffer sb = new StringBuffer();

        if (!query.equals("")) {
           String phrase = "\"" + query + "\"";
           sb.append("( ");
           if (searchfield != null) {
              sb.append(searchfield+":"+phrase+"^5 ");
           }
           else {
              sb.append("title:"+phrase+"^5 ");
              sb.append("author:"+phrase+"^5 ");
           }
           sb.append(" ) ");
        }

        if (categories != null) {
           String prelude = "";
           if (sb.length() > 0) {
              prelude = " AND ";
           }
           sb.append(" ");
           for (int i = 0; i<categories.length; i++) {
              int j = i+1;
              sb.append(prelude + "+level"+j+":"+categories[i].toLowerCase().replaceAll("\\W+", "")+" "); 
              prelude = " AND ";
           }
        }

        return (sb.toString());
    }

    private ScoreDoc[] search(Query query) throws Exception {
       logger.debug("["+instanceId+"] Lucene Query: "+query.toString());
       TopFieldDocCollector collector = new TopFieldDocCollector(reader, sorter, MAXHITS);

       long fstart = System.currentTimeMillis();
       searcher.search(query, collector);
       long fstop = System.currentTimeMillis();

       logger.debug("["+instanceId+"] Search returned in: "+(fstop - fstart)/1000+" sec. with "+collector.getTotalHits()+" hits.");

       ScoreDoc[] docs = null;
       if (collector.getTotalHits() > 0) {
           docs = collector.topDocs().scoreDocs;
       }
       return docs;
    }

    private String getSuggestQuery(String query) throws Exception {

       StringBuilder sb = new StringBuilder();
       query = query.replaceAll("\"", "");
       try {
            Directory dir = FSDirectory.getDirectory(this.indexDir + "_spell");
            SpellChecker spchkr = new SpellChecker(dir);
            String[] words = query.split(" ");
            for (String word: words) {
                if (word.length() <= 3) { //discard 3 letter words
                    sb.append(word + " ");
                    continue;
                }
                if (!spchkr.exist(word)) {
                    String[] suggestwords = spchkr.suggestSimilar(word, 1);
                    if (suggestwords.length > 0) {
                        sb.append(suggestwords[0] + " ");
                    } 
                }
                else {
                    sb.append(word + " ");
                }
            }
       }
       finally {
       }
       return sb.toString();
    }

    private BitSet dedup(BitSet hits) throws Exception {
        for (int i = hits.nextSetBit(0); (i >= 0); i = hits.nextSetBit(i+1)) {
            Document doc = reader.document(i);
            if (doc != null) {
               String id = doc.get("entityId");
               if (id != null) {
                    Term t = new Term("entityId", id);
                    TermEnum te = reader.terms(t);
                    if (te != null) {
                        Term ct = te.term();
                        if((ct != null) && (ct.field()== t.field())) {
                            if (te.docFreq() > 1) {
                                TermDocs td = reader.termDocs(ct);
                                while (td.next()) {    
                                   hits.set(td.doc(),false);
                                } 
                            }
                            hits.set(i);
                        }
                    }
               }
            }
        }
        return hits;
    }

    private List<String> getBooks(ScoreDoc[] hits, BitSet uniques, int start, int end) 
                        throws Exception {

        int index = 0;
        List<String> result = new ArrayList<String>();
        try {
           for (int i = 0; (i < hits.length) && (index < end); i++) {
               if (uniques.nextSetBit(hits[i].doc) == hits[i].doc) {
                    Document doc = searcher.doc(hits[i].doc);
                    if (doc != null) {
                        String id = getFieldValue(doc.getField("entityId"));
                        if (id != null) {
                            if (index++ >= start) {
                                result.add(getFieldValue(doc.getField("entityId")));
                            }
                        }
                    }
               }
           }
        }
        catch (Exception e) {
            logger.debug("["+instanceId+"] "+e.getMessage());
            throw new Exception(e.getMessage());
        }
        return result;
    }
}
