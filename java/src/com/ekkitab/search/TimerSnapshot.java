package com.ekkitab.search;

public class TimerSnapshot {
	private long average;
	private long max;
	private long min;
	private int  count;
	private long total;
	
	public TimerSnapshot() {
		this.average = 0;
		this.max = 0;
		this.min = 100000;
		this.count = 0;
		this.total = 0;
	}
	
	public long getAverageTime() {
		return average;
	}
	
	public long getMaxTime() {
		return max;
	}
	
	public long getMinTime() {
		return min;
	}
	
	public void set(long timeInMillis) {
		count++;
		total += timeInMillis;
		if (timeInMillis > max) {
			max = (int)timeInMillis;
		}
		if (timeInMillis < min) {
			min = (int)timeInMillis;
		}
		average = (int)total/count;
	}

}
