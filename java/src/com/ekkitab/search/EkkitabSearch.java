package com.ekkitab.search;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.MapFieldSelector;
import org.apache.lucene.document.FieldSelector;
import org.apache.lucene.document.FieldSelectorResult;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopFieldDocCollector;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.store.RAMDirectory;
import org.apache.lucene.store.Directory;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.TermDocs;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
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
    private static AtomicReference<TimerSnapshot> basicSearchTimer = new AtomicReference<TimerSnapshot>(new TimerSnapshot());
    private static AtomicReference<TimerSnapshot> catSearchTimer = new AtomicReference<TimerSnapshot>(new TimerSnapshot());
    private enum MATCH_MODE {MATCH_PHRASE, MATCH_WORDS};
    

    public EkkitabSearch(String indexDir) throws EkkitabSearchException {
        this.indexDir = indexDir;
        try {
        	if (Runtime.getRuntime().maxMemory() < 3000000000L) { // not enough memory for RAM directory
        		this.searchDir =  FSDirectory.getDirectory(this.indexDir);
        		logger.info("Inadequate memory for RAM Directory. Using disk based index.");
        	}
        	else {
        		this.searchDir = new RAMDirectory(FSDirectory.getDirectory(this.indexDir));
        		logger.info("Adequate memory for RAM Directory. Using memory based index.");
        	}
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
    
    public SearchResult  getSequential(long instanceId, int page, int pagesz) throws EkkitabSearchException {
    	
    	int start = (page - 1)* pagesz;
    	int end   = start + pagesz;
    	List<String> books = new ArrayList<String>();
    	BitSet processed = new BitSet(reader.maxDoc());
    	
    	try {
    		if ((start >= 0) && (start < reader.numDocs())) {
    			int index = 0;
    			int max = reader.numDocs();
    			for (int i = 0; (i < max) && (index <= end); i++)	{
    				if (!processed.get(i)) {
    					Document doc = reader.document(i);
    					String id = doc.get("entityId");
    					if ((index++ >= start) && (index <= end)) {
    						books.add(id);
    					}
    					Term t = new Term("entityId", id);
    					TermDocs td = reader.termDocs(t);
    					while (td.next()) {
    						processed.set(td.doc(),true);
    					}
    					td.close();
    				}
    			}
    		}
    	}
    	catch (Exception e) {
    		logger.fatal("["+instanceId+"] Lucene sequential search failed with exception" + e.getMessage());
        	throw new EkkitabSearchException(e);
    	}
    	
    	return new SearchResult(books, new HashMap<String, Integer>(), 0, "", "", ""); 
    }
    
    public SearchResult searchInCategory(long instanceId, 
                                         String query,
                                         String searchfield,
                                         String[] categories, 
                                         int start, int end) throws EkkitabSearchException {

        if ((reader == null) || (searcher == null))	
            throw new EkkitabSearchException("Search Not Initialized.");

        long fstart = System.currentTimeMillis();
        ScoreDoc[] docs = null;
                
        String searchQuery = null;
        Query luceneQuery = null;
        String suggestQueries[] = {""};

        //Search strategy: steps to execute until you find one or more books.
        //1. Try to get exact match for give phrase.
        //2. Break up phrase into words. Search for words.
        //3. Try suggest (if not exact match requested)
        //4. In the above if searchfield is isbn, then step 1. only.
        
        try {

        	boolean exitsearch = false;
        	
        	MATCH_MODE matchmode = MATCH_MODE.MATCH_PHRASE;
        	searchQuery = createSearchQuery(query, categories, searchfield, matchmode);
        	
            if ((searchQuery != null) && (!searchQuery.equals(""))) {
        		luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
        		//logger.debug("DEBUG: Lucene Query is: '" + luceneQuery.toString() + "'");
            }
        	docs = search(luceneQuery, instanceId);
        	if (docs == null) {   
        		if ((searchfield != null) && (searchfield.equals("isbn") || searchfield.equals("exact"))) {
        			exitsearch = true;;
        		}
        	}
        	
            if ((docs == null) && (!exitsearch)) {
                if ((query != null) && (query.trim().split(" ").length > 1)) {
        		    matchmode = MATCH_MODE.MATCH_WORDS;
        		    searchQuery = createSearchQuery(query, categories, searchfield, matchmode);
            	
                    if ((searchQuery != null) && (!searchQuery.equals(""))) {
            		    luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
            		    //logger.debug("DEBUG: Lucene Query is: '" + luceneQuery.toString() + "'");
                    }
            	    docs = search(luceneQuery, instanceId);
                }
        	}
        	
        	if ((docs == null) && (!exitsearch)) {
        		suggestQueries  = getSuggestQuery(query, searchfield);
    			if (suggestQueries.length > 0) {
                    matchmode = MATCH_MODE.MATCH_PHRASE;
    				searchQuery = createSearchQuery(suggestQueries[0], categories, searchfield, matchmode);
                	
                    if ((searchQuery != null) && (!searchQuery.equals(""))) {
                		luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(searchQuery);
                		//logger.debug("DEBUG: Lucene Query is: '" + luceneQuery.toString() + "'");
                    }
                	docs = search(luceneQuery, instanceId);
    			}
        	}
            
        }
        catch (Exception e) {
        	logger.fatal("["+instanceId+"] Lucene search failed with exception " + e.getMessage());
        	throw new EkkitabSearchException(e);
        }

        if (docs == null) {
        	//logger.debug("["+instanceId+"] No results.");
        	SearchResult result = new SearchResult(new ArrayList<String>(), 
                                    			   new HashMap<String, Integer>(),
                                     			   0,
                                     			   "",
                                     			   "",
                                                   "");
        	return result;
        }

        BitSet processed = new BitSet(reader.maxDoc());
        int index = 0;
        List<String> books = new ArrayList<String>();
        int documentCount = 0;
        
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
        				//long f = System.currentTimeMillis();
        				Document doc = reader.document(docs[i].doc, fselect);
        				//f1total += System.currentTimeMillis() - f;
        				
        				if (doc != null) {
        					//f = System.currentTimeMillis();
        					String id = doc.get("entityId");
        					//f2total += System.currentTimeMillis() - f;
        					if (id != null) {
        						if ((index++ >= start) && (index <= end)) {
        							books.add(id);
        						}
        						//f = System.currentTimeMillis();
        						Term t = new Term("entityId", id);
        						TermDocs td = reader.termDocs(t);
        						while (td.next()) {
        							processed.set(td.doc(),true);
        						}
        						td.close();
        						//f3total += System.currentTimeMillis() - f;
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
        synchronized (basicSearchTimer) {
        	TimerSnapshot timer = basicSearchTimer.get();
        	timer.set(fstop - fstart);
        	basicSearchTimer.set(timer);
        }
        //logger.debug("["+instanceId+"] Collection times: "+(fstop - fstart)+":"+f1total+":"+f2total+":"+f3total+" millisec.");
        
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
       
        long fstart = System.currentTimeMillis();
        if (categories != null) {
            int catsize = categories.size();
            searchQuery = searchQuery.equals("") ? "" : searchQuery + " AND ";
            
            for (String category: categories) {
                 //hits.clear();
                 String query = searchQuery + "+level"+level+":"+category.replaceAll("\\W+", "");
                 try {
                	 //long f = System.currentTimeMillis();
                	 Query luceneQuery = new QueryParser("title", new StandardAnalyzer()).parse(query);
                	 //ftotal += System.currentTimeMillis() - f;
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
       synchronized (catSearchTimer) {
       	TimerSnapshot timer = catSearchTimer.get();
       	timer.set(fstop - fstart);
       	catSearchTimer.set(timer);
       }
       //logger.debug("["+instanceId+"] Hits counted in "+catsize+" categories in: "+(fstop - fstart)+":"+ftotal+" millisec.");
       return catMap;

    }

    private String getFieldValue(Field fd) {
        return (fd == null ? null : fd.stringValue());
    }
    
    private String createSearchQuery(String query, String[] categories, String searchfield, MATCH_MODE mode) {

        if ((categories == null) && 
            ((query == null) || (query.equals("")))) {
            return "";
        }
        
        if ((searchfield != null) && (searchfield.equals("exact"))) {
        	return query;
        }

        StringBuffer sb = new StringBuffer();
        List<String> terms = new ArrayList<String>();        
        if (!query.equals("")) {
        	switch (mode) {
        		case MATCH_PHRASE:
        			terms.add("\"" + query + "\"");
        			break;
        		case MATCH_WORDS:
        			String[] words = query.split(" ");
        			for (String word: words) {
        				terms.add("\"" + word + "\"");
        			}
        			break;
        		default: break;
        	}
       
        	sb.append("( ");
        	for (String term: terms) {
        		if (searchfield != null) {
        			sb.append(searchfield+":"+term+" ");
        		}
        		else {
        			sb.append("title:"+term+" ");
        			sb.append("author:"+term+"^2 ");
        		}
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
    	
       if (query == null) {
    	   return null;
       }
       //logger.debug("["+instanceId+"] Lucene Query: "+query.toString());
       TopFieldDocCollector collector = new TopFieldDocCollector(reader, sorter, MAXHITS);

       //long fstart = System.currentTimeMillis();
       searcher.search(query, collector);
       //long fstop = System.currentTimeMillis();

       //logger.debug("["+instanceId+"] Search returned in: "+(fstop - fstart)/1000+" sec. with "+collector.getTotalHits()+" hits.");

       ScoreDoc[] docs = null;
       if (collector.getTotalHits() > 0) {
           docs = collector.topDocs().scoreDocs;
       }
       return docs;
    }

    private String[] getSuggestQuery(String query, String searchfield) throws Exception {
    	
       List<String> results = new ArrayList<String>();
       String[] suggestions = new String[0];
        
       if (query.equals("")) {
    	   return suggestions;
       }
       if (searchfield != null) {
    	   if (searchfield.equals("exact")) { //Nothing to do.
    		   return suggestions;
    	   }
       }

       //StringBuilder sb = new StringBuilder();
       query = query.replaceAll("\"", "");
       query = query.replaceAll("\\W+", "");
       
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
    
    protected TimerSnapshot getTimer(String type) {
    	if (type.equalsIgnoreCase("basic"))
    		return basicSearchTimer.get();
    	else if (type.equalsIgnoreCase("categories"))
    		return catSearchTimer.get();
    	return null;
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
