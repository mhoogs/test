public class Predator extends Animal{
	private String huntStyle = "ambush";
	
	public Predator(char type, int health, String huntStyle){
		super(type, health);
		if (huntStyle.equals ("ambush") || huntStyle.equals("stalk")){
			this.huntStyle = huntStyle;
		}
	}
	
	public Predator(Predator toCopy){
		super(toCopy);
		this.huntStyle = toCopy.getHuntStyle();
	}
	
	public String getHuntStyle(){
		return huntStyle;
	}
	
	public void setHuntStyle(String style){
		if (style.equals("ambush") || style.equals("stalk")){
			this.huntStyle = style;
		}
		
		
	}
	
	public double getRelativeHealth(){
		if (this.getHuntStyle().equals("ambush")){
			double y = (double) (this.getHealth()*1.5);
			return y;
		}
		else{
			double y = (double) (this.getHealth() * 0.75);
			return y;
		}
	}
	public String toString(){
		return ("[Predator] " +super.toString() + " Hunt style: " + this.getHuntStyle());
	}
	
}
	
