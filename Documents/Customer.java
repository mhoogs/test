
// This class stimulates the creation of customer profiles for bank accounts with their name and a number ID
public class Customer
{

	// Declaring and Initializing needed variables
	private String name = null;
	private int customerID = 0;

	// Default Constructor
	public Customer()
	{

	}

	// Constructor that takes customer's name and ID as parameters and assists with setters
	public Customer(String customerName, int customerIDnum)
	{

		setName(customerName);
		setID(customerIDnum);

	}
	
	// Copy Constructor
	public Customer(Customer customerToCopy)
	{

		setName(customerToCopy.getName());
		setID(customerToCopy.getID());

	}

	// Setter method for customer's name 
	public void setName(String customerName)
	{

		name = customerName;

	}

	// Getter method for customer's name, returns String type
	public String getName()
	{

		return name;

	}

	// Setter method for customer's ID
	public void setID(int idNum)
	{

		customerID = idNum;

	}

	// Getter method for customer's ID, returns int type
	public int getID()
	{

		return customerID;

	}

	// Combines customer's name and ID so it may be used by other classes, returns String type
	public String toString()
	{

		String nameAndCustomerID = (name + (", ") + customerID);
		return nameAndCustomerID;
	} 

}
