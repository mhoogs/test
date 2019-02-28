import static org.junit.Assert.*;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

import org.junit.Test;

public class RecursionExercisesTest {

	//Check the submission file for the words "for" and "while"
	public void testCheckWords(){
		Scanner scan = null;
		try {
			scan = new Scanner (new FileInputStream("RecursionExercises.java"));
		} catch (FileNotFoundException e){
			fail("Recursion3.java not found");
		}
		
		while (scan.hasNext()){
			String line = scan.nextLine();
			
			if (line.contains("for") || line.contains("while")){
				fail("Found word \"for\" or \"while\": " + line);
			}
		}
		
		scan.close();
	}
	
	// Testing fractionSum
	
	@Test 
	public void test_fractionSum_negative() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing fractionSum of negative number", 0.0, se.fractionSum(-1),0.00001);
		assertEquals("Testing fractionSum of negative number", 0.0, se.fractionSum(-2),0.00001);
		assertEquals("Testing fractionSum of negative number", 0.0, se.fractionSum(-5),0.00001);
		assertEquals("Testing fractionSum of negative number", 0.0, se.fractionSum(-10),0.00001);
	}
	
	@Test 
	public void test_fractionSum_zero() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing fractionSum of zero", 0.0, se.fractionSum(0),0.00001);
	}
	
	@Test 
	public void test_fractionSum_one() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing fractionSum of one", 1.0, se.fractionSum(1),0.00001);
	}
	
	@Test 
	public void test_fractionSum_ten() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing fractionSum of ten", 2.928968, se.fractionSum(10), 0.00001);
	}
	
	// Testing sum1
	
	@Test 
	public void test_sum1_negative() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing summing of negative number", 0, se.sum1(-1));
		assertEquals("Testing summing of negative number", 0, se.sum1(-2));
		assertEquals("Testing summing of negative number", 0, se.sum1(-5));
		assertEquals("Testing summing of negative number", 0, se.sum1(-10));
	}
	
	@Test 
	public void test_sum1_zero() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing summing of zero", 0, se.sum1(0));
	}
	
	@Test 
	public void test_sum1_one() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing summing odd numbers from zero to one", 1, se.sum1(1));
	}
	
	@Test 
	public void test_sum1_two() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing summing odd numbers from zero to two", 1, se.sum1(2));
	}
	
	@Test 
	public void test_sum1_ten() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		assertEquals("Testing summing odd numbers from zero to ten", 25, se.sum1(10));
	}
	
	
	//Testing sum2
	
	@Test
	public void test_sum2_ZeroTo9() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		ArrayList<Integer> list = new ArrayList<Integer>();
		for (int i = 0; i < 10; i++){
			list.add(i);
		}
		
		assertEquals("Testing sum2 for {0, 1, ..., 9}.", 25, se.sum2(list));
		
	}
	
	@Test
	public void test_sum2_OnlyOdd() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		ArrayList<Integer> list = new ArrayList<Integer>();
		for (int i = 0; i <= 100; i++){
			list.add(i*2+1);
		}
		
		assertEquals("Testing sum2 for {1,3,5,...,201}.", 10201, se.sum2(list));
		
	}
	
	@Test
	public void test_sum2_OnlyEven() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		ArrayList<Integer> list = new ArrayList<Integer>();
		for (int i = 0; i < 75; i++){
			list.add(i*2);
		}
		
		assertEquals("Testing sum2 for {0,2,4,6,...,150}.", 0, se.sum2(list));
		
	}
	
	@Test
	public void test_sum2_EmptyList() {
		//Test empty lsit
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		ArrayList<Integer> list = new ArrayList<Integer>();
		
		
		assertEquals("Testing sum2 for {}.", 0, se.sum2(list));
		
	}
	
	@Test
	public void test_sum2_NullList() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		
		assertEquals("Testing sum2 for null list.", 0, se.sum2(null));
		
	}
	
	// testing getVowels
	@Test
	public void test_getVowels_NullString() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		
		assertEquals("Testing getVowels for null string.", null, se.getVowels(null));
		
	}
	
	@Test
	public void test_getVowels_EmptyString() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		
		assertEquals("Testing getVowels for empty string.", "", se.getVowels(""));
		
	}
	
	@Test
	public void test_getVowels_OnlyVowels() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		
		assertEquals("Testing getVowels for string with only vowels.", "aeiuaeiyoo", se.getVowels("aeiuaeiyoo"));
		
	}
	
	@Test
	public void test_getVowels_NoVowels() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		
		assertEquals("Testing getVowels for string with no vowels.", "", se.getVowels("sqwrtplkjhgfdszxcvbnm"));
		
	}
	
	@Test
	public void test_getVowels_VowelsAndConsonants() {
		testCheckWords();
		RecursionExercises se = new RecursionExercises();
		
		assertEquals("Testing getVowels for string with vowels and consonants.", "IiiAiioe", se.getVowels("Is is this A string with vowels?"));
	}
	

}
