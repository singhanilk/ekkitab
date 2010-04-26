package com.ekkitab.search;

public class EkkitabSearchException extends Exception {

    public EkkitabSearchException() {
    }

    public EkkitabSearchException(String string) {
        super(string);
    }

    public EkkitabSearchException(String string, Throwable throwable) {
        super(string, throwable);
    }

    public EkkitabSearchException(Throwable throwable) {
        super(throwable);
    }
}

