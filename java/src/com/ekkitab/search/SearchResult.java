package com.ekkitab.search;

import java.util.*;

public class SearchResult {
    private List<String> bookIds;
    private Map<String, Integer> resultCategories; 
    private int hitCount;
    private String suggestQuery;

    public SearchResult(List<String> bookIds, 
                        Map<String, Integer> resultCategories, 
                        int hitCount, 
                        String suggestQuery) {

        this.suggestQuery = suggestQuery;
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
