package com.ekkitab.db;

import java.util.ArrayList;
import java.util.Set;

import static org.junit.Assert.*;

import org.junit.Test;

class TestProduct {

	@Test
	public void testProduct() {
		Product p = new Product();
		Map<String, Object> vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56788");
		vals.put("author", "R.K.Narayan");
		p.setValues(100, vals);
		assertTrue(p.getHandle() == 100);
		assertTrue(p.getValue("isbn").equals("12345-56788"));
		assertTrue(p.getValue("author").equals("R.K.Narayan"));
	}

	@Test
	public void testGetAttributes() {
		Product p = new Product();
		Map<String, Object> vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56788");
		vals.put("author", "R.K.Narayan");
		p.setValues(100, vals);
		Set<String> attrs = p.getAttributes();
		assertTrue(attrs.contains("isbn"));
		assertTrue(attrs.contains("author")); 
	}
	@Test
	public void testSetValues(){
		Product p = new Product();
		Map<String, Object> vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56788");
		vals.put("author", "R.K.Narayan");
		p.setValues(100, vals);
		def rets = p.getValues(["isbn","author"]);
		assertTrue(rets == ["12345-56788","R.K.Narayan"]);
	}
	@Test
	public void testGetValue(){
		Product p = new Product();
		Map<String, Object> vals = new HashMap<String, Object>();
		vals.put("isbn", "12345-56788");
		vals.put("author", "R.K.Narayan");
		p.setValues(100, vals);
		def val = p.getValue("isbn");
		assertTrue(val.equals("12345-56788"));
	}
}
