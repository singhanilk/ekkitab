/**
 * 
 */
package com.ekkitab.db;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * @author venki
 *
 */
public class INTERSECT<V> implements SortedSet<V> {

	private List<SortedSet<V>> sets = null;
	
	public INTERSECT(List<SortedSet<V>> slist) {
		sets = slist;
	}
	@Override
	public int size() {
		throw new UnsupportedOperationException("INTERSECT does not implement size() operation");
	}

	@Override
	public boolean isEmpty() {
		//a intersection is empty if for each element of set 0 is not found in any other set
		if(sets.size() == 1) {
			return sets.get(0).isEmpty();
		} else {
			boolean found = false;
			for(V e : sets.get(0)) {
				for(int i = 1 ; i < sets.size() ; i++) {
					SortedSet<V> tail = sets.get(i).tailSet(e);
					if(tail != null) {
						int cmp = compare(e,tail.first());
						found = (cmp == 0);
					}
				}
				if(found) {
					break; //atleast there is one element found in all sets
				}
			}
			return !found;
		}
	}

	@Override
	public boolean contains(Object o) {
		for(SortedSet<V> set : sets) {
			if(!set.contains(o)) {
				return false;
			}
		}
		return true;
	}

	@Override
	public Iterator<V> iterator() {
		return new IntersectIterator();
	}

	@Override
	public Object[] toArray() {
		throw new UnsupportedOperationException("INTERSECT does not implement Object[] toArray() call");
	}

	@Override
	public <T> T[] toArray(T[] a) {
		throw new UnsupportedOperationException("INTERSECT does not implement <T> T[] toArray(T[] a) call");}

	@Override
	public boolean add(V e) {
		//add the element to each set
		for(SortedSet<V> set : sets) {
			boolean added = set.add(e);
			if(!added) {
				return false;
			}
		}
		return true;
	}

	@Override
	public boolean remove(Object o) {
		//remove the element to each set
		for(SortedSet<V> set : sets) {
			boolean removed = set.remove(o);
			if(!removed) {
				return false;
			}
		}
		return true;
	}

	@Override
	public boolean containsAll(Collection<?> c) {
		for(SortedSet<V> set : sets) {
			if(!set.containsAll(c)) {
				return false;
			}
		}
		return true;		
	}

	@Override
	public boolean addAll(Collection<? extends V> c) {
		for(SortedSet<V> set : sets) {
			if(!set.addAll(c)) {
				return false;
			}
		}
		return true;		
	}

	@Override
	public boolean retainAll(Collection<?> c) {
		for(SortedSet<V> set : sets) {
			if(!set.retainAll(c)) {
				return false;
			}
		}
		return true;		
	}

	@Override
	public boolean removeAll(Collection<?> c) {
		for(SortedSet<V> set : sets) {
			if(!set.removeAll(c)) {
				return false;
			}
		}
		return true;		
	}

	@Override
	public void clear() {
		for(SortedSet<V> set : sets) {
			set.clear();
		}
	}

	@Override
	public Comparator<? super V> comparator() {
		if(sets != null) {
			return sets.get(0).comparator();
		} else {
			return null;
		}
	}

	@Override
	public SortedSet<V> subSet(V fromElement, V toElement) {
		//intersection of all sub-sets
		List<SortedSet<V>> subList = new ArrayList<SortedSet<V>>();
		for(SortedSet<V> set :sets) {
			subList.add(set.subSet(fromElement, toElement));
		}
		return new INTERSECT<V>(subList);
	}

	@Override
	public SortedSet<V> headSet(V toElement) {
		//intersection of all head-sets
		List<SortedSet<V>> subList = new ArrayList<SortedSet<V>>();
		for(SortedSet<V> set :sets) {
			subList.add(set.headSet(toElement));
		}
		return new INTERSECT<V>(subList);
	}

	@Override
	public SortedSet<V> tailSet(V fromElement) {
		//intersection of all tail-sets
		List<SortedSet<V>> subList = new ArrayList<SortedSet<V>>();
		for(SortedSet<V> set :sets) {
			subList.add(set.tailSet(fromElement));
		}
		return new INTERSECT<V>(subList);
	}

	@Override
	public V first() {
		//lowest of the all firsts
		SortedSet<V> fset = new TreeSet<V>();
		for(SortedSet<V> set :sets) {
			V e = set.first();
			if(e == null) {
				return null;
			}
			fset.add(e);
		}
		return fset.first();
	}

	@Override
	public V last() {
		//highest of the all highest
		SortedSet<V> fset = new TreeSet<V>();
		for(SortedSet<V> set :sets) {
			V e = set.last();
			if(e == null) {
				return null;
			}
			fset.add(e);
		}
		return fset.last();
	}
	private int compare(V first, V second) {
		if(comparator() != null) {
			return comparator().compare(first, second);
		} else {
			//it is assumed they are Comparable
			return ((Comparable<V>)first).compareTo(second);
		}
	}
	public class IntersectIterator implements Iterator<V> {

		private List<SortedSet<V>> csets = new ArrayList<SortedSet<V>>(sets);
		private V ret = null;
		public IntersectIterator() {
			_next();
		}
		@Override
		public boolean hasNext() {
			return ret != null;
		}
		private SortedSet<V> excludedSet(SortedSet<V> s , V e) {
			int c = compare(s.first(),e);
			SortedSet<V> ts = c > 0 ? s : s.tailSet(e); //tailset on concurrent hashmap throws an exception if 'e' not in range of (low,high) of s
			if(compare(ts.first(), e) == 0) {
				//top matches - move to next
				//ideally next and previous must have been added to basic interface
				Iterator<V> tsi = ts.iterator();
				V nxt = tsi.next();
				nxt = tsi.hasNext() ? tsi.next() : null;
				return (nxt != null) ? ts.tailSet(nxt) : null;
			} else {
				return ts;
			}
		}
		private void _next() {
			//find the least of the first's of the current sets
			ret = null;
			//iterate till you find a first of all sets which match
			boolean over = false;
			while((ret == null) && !over) {
				for(int i = 0 ; i < csets.size() ; i++) {
					if(csets.get(i) == null) {
						//some set has been cut to zero size exit - no more elements are possible
						ret = null;
						over = true;
						break;
					}
					if(i == 0) {
						ret = csets.get(0).first();
						csets.set(0, excludedSet(csets.get(0), ret));
					} else {					
						if(ret != null) {
							SortedSet<V> pset = csets.get(i);
							int c = compare(pset.first(), ret);
							//tailset on concurrent hashmap throws an exception if 'e' not in range of (low,high) of s
							SortedSet<V> tset = (c > 0) ? pset : pset.tailSet(ret);
							if(tset.isEmpty()) {
								ret = null;
								csets.set(i, null); //no more elements left in this set
							} else {
								//are they same
								if(compare(tset.first(), ret) != 0) {
									//not a match
									csets.set(i, excludedSet(pset,ret));
									ret = null;
								} else {
									//a match
									//still move ahead
									csets.set(i, excludedSet(pset,ret));
								}
							}
						}		
					}
				}
			}
		}
		@Override
		public V next() {
			V toReturn = ret;
			_next();
			return toReturn;
		}
		@Override
		public void remove() {
			throw new UnsupportedOperationException();
		}		
	}
}
