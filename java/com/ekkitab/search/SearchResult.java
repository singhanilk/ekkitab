package com.ekkitab.search;

import src.com.ekkitab.search.*;
import java.util.*;

public class SearchResult {
    private List<String> bookIds;
    private Map<String, Integer> resultCategories; 
    private int hitCount;
    private String suggestQuery;
    private String searchQuery;
    private String suggestOther;

    public SearchResult(List<String> bookIds, 
                        Map<String, Integer> resultCategories,
                        int hitCount, 
                        String suggestQuery,
                        String suggestOther,
                        String searchQuery) {

        this.suggestQuery = suggestQuery;
        this.searchQuery = searchQuery;
        this.suggestOther = suggestOther;
        this.bookIds      = bookIds;
        this.resultCategories = resultCategories;
        this.hitCount     = hitCount;
    }

    public void setSuggestQuery(String query) {
        this.suggestQuery = query;
    }

    public String getSuggestQuery() {
        return suggestQuery;
    }

    public void setSearchQuery(String query) {
        this.searchQuery = query;
    }

    public String getSearchQuery() {
        return searchQuery;
    }
    
    public void setSuggestOther(String suggestion) {
        this.suggestOther = suggestion;
    }

    public String getSuggestOther() {
        return suggestOther;
    }
    
    

    public void setBookIds(List<String> ids) {
        this.bookIds = ids;
    }

    public List<String> getBookIds() {
        return bookIds;
    }

    public void setResultCategories(Map<String, Integer> categoryMap) {
        this.resultCategories = categoryMap;
    }

    public Map<String, Integer> getResultCategories() {
        return resultCategories;
    }

    public void setHitCount(int count) {
        this.hitCount = count;
    }

    public int getHitCount() {
        return hitCount;
    }

}
