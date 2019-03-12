package com.revature.banking;

import java.io.Serializable;

public class User implements Serializable {



	/**
	 * 
	 */
	private static final long serialVersionUID = -1731951615283135608L;
	String username, password;
	
	public User(String username, String password) {
		super();
		this.username = username;
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
}