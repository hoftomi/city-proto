package com.hof.tronnelkul.common;

/** Row of a per-day count query: day as yyyy-MM-dd and the count. */
public interface DayCount {
    String getDay();
    long getCount();
}
