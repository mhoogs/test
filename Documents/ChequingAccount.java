
public class ChequingAccount extends BankAccount
{
	double overDraftFee;
	double overDraftAmount;
	
	public ChequingAccount()
	{
		
	}
	
	public ChequingAccount(double transactionFee)
	{
		this.overDraftFee = transactionFee;
		
	
	}
	public ChequingAccount(ChequingAccount copyAccount){
		setOverdraftAmount(copyAccount.getOverDraftAmount());
		setOverDraftFee(copyAccount.getOverdraftFee());
	}
		
	public ChequingAccount(Customer accountHolder, double startBalance, double transactionFee)
	{
		this.balance = startBalance;
		this.overDraftFee = transactionFee;
		this.newCustomer = accountHolder;

	}
	
	public double getOverdraftFee()
	{
		return overDraftFee;
	}
	
	public void setOverDraftFee(double fee)
	{
		this.overDraftFee = fee;
	}
	
	public double getOverDraftAmount()
	{
		return overDraftAmount;
	}
	
	public void setOverdraftAmount(double amount)
	{
		this.overDraftAmount = amount;
	}
	
	public void withdraw(double money)
    	{
        	if((balance - money) <= (overdraftAmount) || Double.isNaN(money) || Double.isInfinite(money))
        	{
    
            		this.setBalance(balance -= money);
            		}
            	
				
						
    	}
	
	
	
}
