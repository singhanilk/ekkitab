package com.ekkitab.search;
import src.com.ekkitab.search.*;
import java.util.*;

public class CategoryLevel {

    private Map<String, CategoryLevel> map = null;

    public CategoryLevel() {
        map = new HashMap<String, CategoryLevel>(); 
    }

    public CategoryLevel put(String key, String value) {
        if ((value == null) || (value.length() == 0)) {
           putKey(key);
           return null;
        }
        if (map.containsKey(key)) {
           CategoryLevel nextvalue = map.get(key);
           nextvalue.putKey(value);
           return nextvalue;
        }                        
        else {
           CategoryLevel nextvalue = new CategoryLevel(); 
           nextvalue.putKey(value); 
           map.put(key, nextvalue);
           return nextvalue;
        }
    }                

    public void putKey(String key) {
        if (!map.containsKey(key)) {
            CategoryLevel nextvalue = new CategoryLevel(); 
            map.put(key, nextvalue);
        }
    }        

    public Set<String> getKeys() {
        return map.keySet();
    }

    public CategoryLevel get(String key) {
        if (map.containsKey(key))
           return map.get(key);
        else
           return null;
    }
}
