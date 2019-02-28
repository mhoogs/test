import static org.junit.Assert.*;

import org.junit.Test;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Expressions1Test {
	String filename = "Expressions1.java";

	private boolean containsImportStatement() {
		boolean containsImport = false;
		
		try {
			BufferedReader in = new BufferedReader(new FileReader(filename));
			String line = in.readLine();
			while (line != null && !containsImport) {
				if (line.matches("import+\\s.*")) {
					containsImport = true;
				} 
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
		}
		return containsImport;
	}
	
	/**
	Checks if the specified library is used anywhere in the code tested.  It checks
	for the word exactly.  If there is a variable name that contains the library name,
	this will result in a false positive.
	*/
	private boolean usesLibrary(String libraryName) {
		boolean usesLibrary = false;
		
		try {
			BufferedReader in = new BufferedReader(new FileReader(filename));
			String line = in.readLine();
			while (line != null && !usesLibrary) {
				if (line.contains(libraryName)) {
					usesLibrary = true;
				} 
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
		}
		return usesLibrary;	
	}
	
	/**
		Checks if the coding construct is used in the class we're testing.  It expects the 
		construct to be preceded and followed by white space or parenthesis.
	*/
	private boolean usesConstruct(String constructName) {
		boolean usesConstruct = false;
		
		try {
			BufferedReader in = new BufferedReader(new FileReader(filename));
			String line = in.readLine();
			while (line != null && !usesConstruct) {
				if (line.matches(".*\\s+if+[\\s+,(].*")) {
					usesConstruct = true;
				} 
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
		}
		return usesConstruct;	
	}
		
	@Test
	public void test_isUpper_A() {
		assertFalse("Don't use the Character class in your code.",usesLibrary("Character"));
		
		boolean expected = true;
		boolean actual = Expressions1.isUpper('A');
		
		assertEquals("Checking if A is upper case letter", expected, actual);
	}

	@Test
	public void test_isUpper_Z() {
		assertFalse("Don't use the Character class in your code.",usesLibrary("Character"));
		
		boolean expected = true;
		boolean actual = Expressions1.isUpper('Z');
		
		assertEquals("Checking if Z is upper case letter", expected, actual);
	}

	@Test
	public void test_isUpper_F() {
		assertFalse("Don't use the Character class in your code.",usesLibrary("Character"));
		
		boolean expected = true;
		boolean actual = Expressions1.isUpper('F');
		
		assertEquals("Checking if F is upper case letter", expected, actual);
	}

	@Test
	public void test_isUpper_a() {
		assertFalse("Don't use the Character class in your code.",usesLibrary("Character"));
		
		boolean expected = false;
		boolean actual = Expressions1.isUpper('a');
		
		assertEquals("Checking if a is upper case letter", expected, actual);
	}

	@Test
	public void test_isUpper_7() {
		assertFalse("Don't use the Character class in your code.",usesLibrary("Character"));
		
		boolean expected = false;
		boolean actual = Expressions1.isUpper('7');
		
		assertEquals("Checking if 7 is upper case letter", expected, actual);
	}

	
	@Test
	public void test_computePolynomial_0_0() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		double expected = 28;
		double actual = Expressions1.computePolynomial(0.0);
		
		assertEquals("Value of polynomial at 0.0", expected, actual, 0.00001);
	}

	@Test
	public void test_computePolynomial_100_15() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		double expected = 9857.7225;
		double actual = Expressions1.computePolynomial(100.15);
		
		assertEquals("Value of polynomial at 100.15", expected, actual, 0.00001);
	}

	@Test
	public void test_computePolynomial_negativeNum() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		double expected = 31.990756;
		double actual = Expressions1.computePolynomial(-1.234);
		
		assertEquals("Value of polynomial at -1.234", expected, actual, 0.00001);
	}

	@Test
	public void test_computePolynomial_SmallNegativeNum() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		double expected = 97555156.0;
		double actual = Expressions1.computePolynomial(-9876.0);
		
		assertEquals("Value of polynomial at -9876.0", expected, actual, 0.00001);
	}

	@Test
	public void test_computePolynomial_LargeNum() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		double expected = 97515652.0;
		double actual = Expressions1.computePolynomial(9876.0);
		
		assertEquals("Value of polynomial at 9876.0", expected, actual, 0.00001);
	}

	@Test
	public void test_floorAfterMult_MultResultsInWholeNum() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		long expected = 6;
		long actual = Expressions1.floorAfterMult(2,3.0);
		
		assertEquals("Value of floor(2 * 3.0)", expected, actual);
	}

	@Test
	public void test_floorAfterMult_MultResultsInNegativeNum() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		long expected = -6;
		long actual = Expressions1.floorAfterMult(2,-3.0);
		
		assertEquals("Value of floor(2 * -3.0)", expected, actual);
	}

	@Test
	public void test_floorAfterMult_MultResultsInDecimal() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		long expected = 6;
		long actual = Expressions1.floorAfterMult(2,3.25);
		
		assertEquals("Value of floor(2 * 3.25)", expected, actual);
	}

	@Test
	public void test_floorAfterMult_checkIfCastAfterMult() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		long expected = 31;
		long actual = Expressions1.floorAfterMult(5,6.2);
		
		assertEquals("Value of floor(5 * 6.2)", expected, actual);
	}

	@Test
	public void test_floorAfterMult_checkIfCastAfterMultLargeDiff() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		
		long expected = 34;
		long actual = Expressions1.floorAfterMult(5,6.999);
		
		assertEquals("Value of floor(5 * 6.999)", expected, actual);
	}

	
	@Test
	public void test_addOctalDigits_12345() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		assertFalse("Don't use while statements.", usesConstruct("while"));
		assertFalse("Don't use for statements.", usesConstruct("for"));
		
		
		int expected = 15;
		int actual = Expressions1.addOctalDigits(012345);
		
		assertEquals("testing octal 12345", expected, actual);
	}
	
	@Test
	public void test_addOctalDigits_00000() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		assertFalse("Don't use while statements.", usesConstruct("while"));
		assertFalse("Don't use for statements.", usesConstruct("for"));
		
		
		int expected = 0;
		int actual = Expressions1.addOctalDigits(0);
		
		assertEquals("testing octal 00000", expected, actual);
	}

	@Test
	public void test_addOctalDigits_76543() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		assertFalse("Don't use while statements.", usesConstruct("while"));
		assertFalse("Don't use for statements.", usesConstruct("for"));
		
		
		int expected = 25;
		int actual = Expressions1.addOctalDigits(076543);
		
		assertEquals("testing octal 76543", expected, actual);
	}
	
	@Test
	public void test_addOctalDigits_10000() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		assertFalse("Don't use while statements.", usesConstruct("while"));
		assertFalse("Don't use for statements.", usesConstruct("for"));
		
		
		int expected = 1;
		int actual = Expressions1.addOctalDigits(010000);
		
		assertEquals("testing octal 10000", expected, actual);
	}

	@Test
	public void test_addOctalDigits_711111() {
		assertFalse("Don't use the Math library or the word Math in your code.",usesLibrary("Math"));
		assertFalse("Don't use if statements.", usesConstruct("if"));
		assertFalse("Don't use while statements.", usesConstruct("while"));
		assertFalse("Don't use for statements.", usesConstruct("for"));
		
		
		int expected = 5;
		int actual = Expressions1.addOctalDigits(0711111);
		
		assertEquals("testing octal 711111 (note six digits)", expected, actual);
	}


}
