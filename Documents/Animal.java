public abstract class Animal{
	private char type='n';
	private int health=50;
	
	public Animal(char atype, int ahealth){
		
	if (atype == 'm' || atype == 'b' || atype == 'f' || atype == 'r' || atype == 'n' || atype == 'a'){
			this.type = atype;
		}
		if(ahealth > 0){
		this.health = ahealth;}
	}
	
	public Animal(Animal toCopy){
		setType(toCopy.getType());
		setHealth(toCopy.getHealth());
	}
	
	
	public char getType(){
		
		return type;
	}
	
	public int getHealth(){
		return health;
	}
	
	public abstract double getRelativeHealth();
	
	protected void setType(char atype){
		if (atype == 'm' || atype == 'b' || atype == 'f' || atype == 'r' || atype == 'n' || atype == 'a'){
			this.type = atype;
		}
		else{
			this.type = 'n';
		}
	}
	
	public void setHealth(int amount){
		if(amount >0){
			this.health = amount;
		}
		
		else if(amount ==0)
			{this.health = 50;}
			else{
				this.health = 50;
			}
		}
	
	public String getStatus(){
		if (this.getRelativeHealth() < 25){
			return "critical";
		}
		else if (this.getRelativeHealth() >= 25 && this.getRelativeHealth() < 50){
			return "tenuous";
		}
		
		else if(this.getRelativeHealth()< 75 && this.getRelativeHealth()>= 50){
			return "good";
		}
		
		else {
			return "excellent";
		}
	}
	
	public String toString(){
		return ("Type: " + this.getType() + " Health: " + this.getRelativeHealth());
	}
}
			
		
