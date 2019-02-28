public class Expressions1 
{    public static boolean isUpper(char achar)
		{return achar < (char)(achar ^ 0x20);}
		
		
	public static double computePolynomial(double x)
	{  return ((3-x)*(3-x))+(4*(7+x))-9;}
	
	public static long floorAfterMult(int num1, double num2)
	{
		return (int)(num1*num2); }
	
	public static int addOctalDigits(int fiveOctalDigitNum)
	{	
		int sum = (fiveOctalDigitNum%8) + ((fiveOctalDigitNum/8%8)/1) + ((fiveOctalDigitNum/64%8)/1) + ((fiveOctalDigitNum/512%8)/1) + (fiveOctalDigitNum/4096);
		return sum;
	}
	
}
