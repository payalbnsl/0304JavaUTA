package com.banking;

import java.util.ArrayList;

public class Customer extends User
{
	private static final long serialVersionUID = 9133213573522223703L;
	private String name;
//	private String phoneNumber, licenseNumber;
//	transient private String ssn;

	public Customer(String name, String username, String password)
	{
		super(username, password);
		this.name = name;
//		phoneNumber = phone;
//		licenseNumber = license;
//		ssn = social;
	}

	public Account applyForAccount(long accountNumber, Account.AccountType type)
	{
		return new Account(accountNumber, type, this);
	}

//	public Account applyForJointAccount(long accountNumber, 
//			Account.AccountType type, Customer partner)
//	{
//		Account acct = applyForAccount(accountNumber, type);
//		return acct.addOwner(partner);
//	}

	public ArrayList<String> getAccountOperations(Account acct)
	{
		ArrayList<String> options = new ArrayList<>();

		try
		{
			acct.hasWriteAccess(this);
		}
		catch (InvalidUserAccessException e)
		{
			return options; 	// Return empty list
		}
		catch (AccountNotOpenException e)
		{
			
		}
		options.add("WITHDRAW");
		options.add("DEPOSIT");
		options.add("TRANSFER");
		options.add("CLOSE");

		return options;
	}

	public String toString()
	{
//		StringBuilder sb = new StringBuilder();
//		sb.append(name);
//		sb.append("\t" + phoneNumber);
//		sb.append("\t" + licenseNumber);
//		sb.append("\t" + "***-**-" + ssn.substring(7));

//		return sb.toString();
		return name;
	}
}