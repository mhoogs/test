public class Prey extends Animal{
	private String defence = "stampede";
	private int herdSize=1;
	
	public Prey(char aType, int aHealth, String aDefence){
		super(aType, aHealth);
		if(aDefence== "stampede"|| aDefence =="huddle" || aDefence =="hide"){
		this.defence = aDefence;
	}
	}
	
	public Prey(Prey toCopy){
		super(toCopy);
		this.defence = toCopy.getDefence();
	}
	
	public String getDefence(){
		return defence;
	}
	
	public void setDefence(String aDefence){
		if(aDefence== "stampede"|| aDefence =="huddle" || aDefence =="hide"){
			this.defence = aDefence;
		}
	
			
	}
	
	public int getHerdSize(){
		return herdSize;
	}
	
	public void setHerdSize(int size){
		if (size >= 1){
			this.herdSize = size;
		}
	}
	
	public double getRelativeHealth(){
		double x = 0.0;
		
		if (this.getDefence().equals("hide")){
			 x = super.getHealth();
			 return x;
		}
		else{
			double y  = (double) ((super.getHealth()*this.getHerdSize()));
			y = y/10;
			return y;
		}
	}
	
	public String toString(){
		return ("[Prey] " + super.toString() + " Defence: " + this.getDefence());
	}
			
}
