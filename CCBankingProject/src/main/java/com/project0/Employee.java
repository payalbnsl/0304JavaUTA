package com.project0;

import java.io.Serializable;

public class Employee implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -3922407356452873685L;
	private String employID;
	private String password;
	private String Name;
	private char rank;
	
	public Employee(String employID, String password, String Name, char rank) {
		super();
		this.employID = employID;
		this.password = password;
		this.Name = Name;
		this.rank = rank;
	}

	public String getEmployID() {
		return employID;
	}

	public void setEmployID(String employID) {
		this.employID = employID;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public char getRank() {
		return rank;
	}

	public void setRank(char rank) {
		this.rank = rank;
	}

	@Override
	public String toString() {
		return "Employee [employID=" + employID + ", password=" + password + ", Name=" + Name + ", rank=" + rank + "]";
	}
	
	
	

}