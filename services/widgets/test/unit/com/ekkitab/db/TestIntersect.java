package com.ekkitab.db;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

import org.junit.Test;

public class TestIntersect {

	@Test
	public void testIsEmpty() {
	}
	@Test
	public void testSimple() {
		List<Integer> listOne = Arrays.asList(3,4,5,7,10);
		SortedSet<Integer> sset = new TreeSet<Integer>(listOne);
		List<SortedSet<Integer>> lists = new ArrayList<SortedSet<Integer>>();
		lists.add(sset);
		INTERSECT<Integer> inter = new INTERSECT<Integer>(lists);
		for(Integer in : inter) {
			System.out.println(in);
		}
	}
	@Test
	public void testIterator() {
		List<Integer> listOne = Arrays.asList(3,4,5,7,10);
		SortedSet<Integer> sset1 = new TreeSet<Integer>(listOne);
		List<Integer> listTwo = Arrays.asList(5,7);
		SortedSet<Integer> sset2  = new TreeSet<Integer>(listTwo);
		
		List<SortedSet<Integer>> lists = new ArrayList<SortedSet<Integer>>();
		lists.add(sset1);
		lists.add(sset2);
		INTERSECT<Integer> inter = new INTERSECT<Integer>(lists);
		for(Integer in : inter) {
			System.out.println(in);
		}
	}
	@Test
	public void testNullIntersector() {
		List<Integer> listOne = Arrays.asList(3,4,5,7,10);
		SortedSet<Integer> sset1 = new TreeSet<Integer>(listOne);
		List<Integer> listTwo = Arrays.asList(15,17);
		SortedSet<Integer> sset2  = new TreeSet<Integer>(listTwo);
		
		List<SortedSet<Integer>> lists = new ArrayList<SortedSet<Integer>>();
		lists.add(sset1);
		lists.add(sset2);
		INTERSECT<Integer> inter = new INTERSECT<Integer>(lists);
		for(Integer in : inter) {
			System.out.println(in);
		}
	}
	@Test
	public void testIteratorMore() {
		List<Integer> listOne = Arrays.asList(5,7);
		SortedSet<Integer> sset1 = new TreeSet<Integer>(listOne);
		List<Integer> listTwo = Arrays.asList(3,4,5,7,10);
		SortedSet<Integer> sset2  = new TreeSet<Integer>(listTwo);
		
		List<SortedSet<Integer>> lists = new ArrayList<SortedSet<Integer>>();
		lists.add(sset1);
		lists.add(sset2);
		INTERSECT<Integer> inter = new INTERSECT<Integer>(lists);
		for(Integer in : inter) {
			System.out.println(in);
		}
	}

	@Test
	public void testHeadSet() {
	}

	@Test
	public void testTailSet() {
	}

	@Test
	public void testFirst() {
	}

	@Test
	public void testLast() {
	}

}
