package com.ekkitab.search;

import java.util.*;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.MapFieldSelector;
import org.apache.lucene.document.FieldSelector;
import org.apache.lucene.document.FieldSelectorResult;
import org.apache.lucene.document.LoadFirstFieldSelector;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.HitCollector;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopFieldDocCollector;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.RAMDirectory;
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
    private static String indexDir;
    private static Directory searchDir;
    private static IndexReader reader;
    private static IndexSearcher searcher;
    private static Sort sorter;
    private static Directory author_spell_dir;
    private static Directory title_spell_dir;
    private static SpellChecker author_speller;
    private static SpellChecker title_speller;
    private static Logger logger = LogManager.getLogger("EkkitabSearch.class");
    private static final int MAXHITS = 1000;
    private static final int FUZZYLIMIT = 150;

    public EkkitabSearch(String indexDir) throws EkkitabSearchException {
        this.indexDir = indexDir;
        try {
        	this.searchDir = new RAMDirectory(FSDirectory.getDirectory(this.indexDir));
    	    this.reader    = IndexReader.open(this.searchDir, true);
    		this.searcher  = new IndexSearcher(reader);
    		this.sorter = new Sort();	
    		this.author_spell_dir = FSDirectory.getDirectory(this.indexDir + "_spell_author");
    		this.title_spell_dir = FSDirectory.getDirectory(this.indexDir + "_spell_title");
    		this.author_speller = new SpellChecker(this.author_spell_dir);
    		this.title_speller = new SpellChecker(this.title_spell_dir);
        }
        catch(Exception e) {
        	throw new EkkitabSearchException(e.getMessage());
        }
        logger.info("Success:  Singleton instance of EkkitabSearch has been initialized.");
    }

    public SearchResult searchInCategory(long instanceId, 
                                         String query,
                                         String searchfield,
                                         String[] categories, 
                                         int start, int end) throws EkkitabSearchException {

        if ((reader == null) || (searcher == null))	
            throw new EkkitabSearchException("Initialization Error!");

        ScoreDoc[] docs = null;
        Query luceneQuery = null;

        String searchQuery = createSearchQuery(query, categories, searchfield);
        logger.debug("DEBUG: Search Query is: '" + searchQuery + "'");
        String suggestQueries[] = new String[1];
        suggestQueries[0] = "";

        try {
        	if (!searchQuery.equals("")) {
        		luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
        	}

        	//suggestQuery = "";

        	if (luceneQuery != null) {
        		docs = search(luceneQuery, instanceId);
        		if ((docs == null) && (!query.equals(""))){ // Try lucene suggest
        			suggestQueries  = getSuggestQuery(query);
        			if (suggestQueries.length > 0) {
        				searchQuery = createSearchQuery(suggestQueries[0], categories, searchfield);
        				//logger.debug("DEBUG: Search Query is: '" + searchQuery + "'");
        				if (!searchQuery.equals("")) {
        					luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
        					if (luceneQuery != null) {
        						docs = search(luceneQuery, instanceId);
        					}
        				}
        			}
        		}
        	}
        }
        catch (Exception e) {
        	logger.fatal("["+instanceId+"] Lucene search failed with exception" + e.getMessage());
        	throw new EkkitabSearchException(e);
        }

        if (docs == null) {
        	logger.debug("["+instanceId+"] No results.");
        	SearchResult result = new SearchResult(new ArrayList<String>(), 
                                    			   new HashMap<String, Integer>(),
                                     			   0,
                                     			   "",
                                     			   "",
                                                   searchQuery);
        	return result;
        }

        //BitSet allhits = new BitSet(reader.maxDoc());
        //for (int i = 0; (i < docs.length); i++) {
        //	allhits.set(docs[i].doc);
        //}

        //List<String> books = null;
        String[] fields = {"entityId"};
        BitSet processed = new BitSet(reader.maxDoc());
        int index = 0;
        List<String> books = new ArrayList<String>();
        int documentCount = 0;
        
        long fstart = System.currentTimeMillis();
        long f1total = 0, f2total = 0, f3total = 0;
        FieldSelector fselect = new FieldSelector() {
        	public FieldSelectorResult accept(String fieldName) {
        		if (fieldName.equals("entityId"))
        			return FieldSelectorResult.LOAD_AND_BREAK;
        		else
        			return FieldSelectorResult.NO_LOAD;
        	}
        };

        
        if (docs.length > 0) {
        	try {
        		for (int i = 0; i < docs.length; i++) {
        			if (!processed.get(docs[i].doc)) {
        				long f = System.currentTimeMillis();
        				Document doc = reader.document(docs[i].doc, fselect);
        				f1total += System.currentTimeMillis() - f;
        				
        				if (doc != null) {
        					f = System.currentTimeMillis();
        					String id = doc.get("entityId");
        					f2total += System.currentTimeMillis() - f;
        					if (id != null) {
        						if ((index++ >= start) && (index <= end)) {
        							books.add(id);
        						}
        						f = System.currentTimeMillis();
        						Term t = new Term("entityId", id);
        						TermDocs td = reader.termDocs(t);
        						while (td.next()) {
        							processed.set(td.doc(),true);
        						}
        						td.close();
        						f3total += System.currentTimeMillis() - f;
        						documentCount++;
        						if ((documentCount > FUZZYLIMIT) && (index > end)) {
        							documentCount = docs.length;
        							break;
        						}
        					}
        				}
        			}
        		}
        	}
        	catch (Exception e) {
        		logger.fatal("["+instanceId+"] Error processing Lucene reults " + e.getMessage());
        		throw new EkkitabSearchException(e.getMessage());
        	}
        }
        long fstop = System.currentTimeMillis();

        logger.debug("["+instanceId+"] Collection times: "+(fstop - fstart)+":"+f1total+":"+f2total+":"+f3total+" millisec.");
        
        StringBuffer otherSuggestions = new StringBuffer();
        for (int i=1; i < suggestQueries.length; i++) {
        	otherSuggestions.append(suggestQueries[i]+"|");
        }

        return (new SearchResult(books, new HashMap<String, Integer>(), documentCount, 
        		    (suggestQueries.length > 0 ? suggestQueries[0] : ""), otherSuggestions.toString(),searchQuery)); 
    }

    public Map<String, Integer> getValidCategories(long instanceId, String searchQuery, int level, Set<String> categories)
    							throws EkkitabSearchException {

        if ((reader == null) || (searcher == null))	
            throw new EkkitabSearchException("Initialization Error!");

        final BitSet hits = new BitSet(reader.maxDoc());

        Map<String, Integer> catMap = new HashMap<String, Integer>();
        int catsize = 0;
        long ftotal = 0;

        long fstart = System.currentTimeMillis();
        if (categories != null) {
            catsize = categories.size();
            searchQuery = searchQuery.equals("") ? "" : searchQuery + " AND ";
            
            for (String category: categories) {
                 //hits.clear();
                 String query = searchQuery + "+level"+level+":"+category.replaceAll("\\W+", "");
                 try {
                	 long f = System.currentTimeMillis();
                	 Query luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(query);
                	 ftotal += System.currentTimeMillis() - f;
                	 //searcher.search(luceneQuery, new HitCollector() { 
                     //                                    	public void collect(int doc, float score) {
                     //                                    		hits.set(doc);
                     //                                    	}
                     //                                	});
                	 TopDocs t = searcher.search(luceneQuery, null, MAXHITS);
                	 if (t.totalHits > 0)
                		 catMap.put(category, t.totalHits);
                 }
                 catch (Exception e) {
                	logger.fatal("Search failed while collecting category information with error " + e.getMessage());
                	throw new EkkitabSearchException(e);
                 }
                 //if (hits.cardinality() > 0) {
                	//catMap.put(category, (hits.cardinality() > MAXHITS ? MAXHITS : hits.cardinality())); 
                 //}
            }
       }
       long fstop = System.currentTimeMillis();

       logger.debug("["+instanceId+"] Hits counted in "+catsize+" categories in: "+(fstop - fstart)+":"+ftotal+" millisec.");
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

    private ScoreDoc[] search(Query query, long instanceId) throws Exception {
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

    private String[] getSuggestQuery(String query) throws Exception {

       //StringBuilder sb = new StringBuilder();
       query = query.replaceAll("\"", "");
       query = query.replaceAll("\\W+", "");
       
       List<String> results = new ArrayList<String>();
       String[] suggestions = new String[0];
       
       suggestions = author_speller.suggestSimilar(query, 5);
            
       for (String suggestion: suggestions) {

           TermQuery tq = new TermQuery(new Term("spell_author", suggestion));
                
           TopFieldDocCollector collector = new TopFieldDocCollector(reader, sorter, 10);

           searcher.search(tq, collector);

           ScoreDoc[] docs = new ScoreDoc[0];
           if (collector.getTotalHits() > 0) {
               docs = collector.topDocs().scoreDocs;
           }
                
           int count = results.size();

           for (int i = 0; (i < docs.length) && (results.size() == count); i++) {
                Document doc = searcher.doc(docs[i].doc);
                if (doc != null) {
                     String[] values = doc.getValues("author");
                     for (String value: values) {
                          String name = value.replaceAll("\\W+", "").toLowerCase();
                          if (name.equals(suggestion)) {
                              results.add(value);
                          }
                          else {
                        	  String[] words = value.split(" ");
                              for (String word: words) {
                        		 word = word.replaceAll("\\W+", "").toLowerCase();
                        		 if (word.equals(suggestion)) {
                        		     results.add(value);
                        			 break;
                        		 }
                              }
                          }
                     }
                }
           }
       }
            
       if (results.size() == 0) {
           suggestions = title_speller.suggestSimilar(query, 5);
       }

            /*
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
            }*/
       return (results.size() > 0 ? results.toArray(new String[0]): suggestions);
    }

    private BitSet dedup(BitSet hits) throws Exception {
    	String[] fields = {"entityId"};
        for (int i = hits.nextSetBit(0); (i >= 0); i = hits.nextSetBit(i+1)) {
            Document doc = reader.document(i, new MapFieldSelector(fields));
            if (doc != null) {
               String id = doc.get("entityId");
               if (id != null) {
                    Term t = new Term("entityId", id);
                    //TermEnum te = reader.terms(t);
                    //if (te != null) {
                        //Term ct = te.term();
                        //if((ct != null) && (ct.field()== t.field())) {
                            //if (te.docFreq() > 1) {
                    TermDocs td = reader.termDocs(t);
                    while (td.next()) {
                    	 if (td.doc() != i)
                            hits.set(td.doc(),false);
                    }
                    td.close();
                            // }
                    //hits.set(i);
                      //  }
                   // }
               }
            }
        }
        return hits;
    }

    private List<String> getBooks(long instanceId, ScoreDoc[] hits, BitSet uniques, int start, int end) 
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
    
    protected void finalize() throws Throwable {
    	logger.fatal("Severe:  Singleton instance of EkkitabSearch has been destroyed.");
        try {
        	if (searcher != null) {
    			searcher.close(); 
    			searcher = null;
    		}
        	if (reader != null) {
    			reader.close();
    			reader = null;
    		} 
        } finally {
            super.finalize();
        }
    }

}
