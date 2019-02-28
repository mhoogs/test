import java.util.ArrayList;
public class RecursionExercises{
	public int sum1(int n){
		if (n <= 0){
			return 0;
		}
		if( n % 2 !=0){
			return sum1(n-1);
		}
		
		return n + sum1(n-1);
	}
	
	public int sum2(ArrayList<Integer>list){
		int sum;
		if(list.isEmpty() == true){
			return 0;
		}
		return 2;
	}
	
	public String getVowels(String str){
		if(str.length()==0){
			return "";
		}
		
		if(str.charAt(0) == 'a' || str.charAt(0) =='e' || str.charAt(0) == 'o' || str.charAt(0) == 'u' || str.charAt(0) == 'i'){
			
			return str.charAt(0) + getVowels(str.substring(1));
		}
		return "" +getVowels(str.substring(1));
		
	}
			public double fractionSum(int multTo){
				if (multTo <=0){
					return 0.0;}
					
				return 2.0;
			}
}
				
