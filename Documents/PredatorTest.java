import static org.junit.Assert.*;

import org.junit.Test;

import java.io.*;

public class PredatorTest {
	public static final String CLASSNAME = "Predator";
	public static final String FILENAME = CLASSNAME + ".java";
	
	
	private void testInterface() {
		String[] instanceVars = {"String huntStyle"};
		assertTrue("Instance variables should be private with correct name and signature.", instanceVariablesArePrivate(instanceVars));

		assertTrue("Class should not have the default constructor.", noDefaultConstructor());
		
		assertFalse("Should not override or call getStatus.", hasMethod("String getStatus()"));
		assertFalse("Should not override or call getType.", hasMethod("char getType()"));
	}
	
	
	// Testing constructors
	
	@Test
	public void test_Constructor_huntStyle_valid(){
		testInterface();
		Predator c = new Predator('f',25,"ambush");
		assertEquals("Created prey (f,25,ambush) testing huntStyle", "ambush", c.getHuntStyle());
		assertEquals("Created prey with valid 25 health.", 25, c.getHealth());
		assertEquals("Created prey (f,25,ambush) testing type", 'f', c.getType());

		c = new Predator('f',25,"stalk");
		assertEquals("Created prey (f,25,stalk) testing huntStyle", "stalk", c.getHuntStyle());
		assertEquals("Created prey with valid 25 health.", 25, c.getHealth());
		assertEquals("Created prey (f,25,stalk) testing type", 'f', c.getType());
	}
	
	@Test
	public void test_Constructor_huntStyle_invalid(){
		testInterface();
		Predator c = new Predator('f',25,"camouflage");
		assertEquals("Created prey (f,25,camouflage) testing huntStyle", "ambush", c.getHuntStyle());
		assertEquals("Created prey with valid 25 health.", 25, c.getHealth());
		assertEquals("Created prey (f,25,camouflage) testing type", 'f', c.getType());

		c = new Predator('f',25,"nothing");
		assertEquals("Created prey (f,25,nothing) testing huntStyle", "ambush", c.getHuntStyle());
		assertEquals("Created prey with valid 25 health.", 25, c.getHealth());
		assertEquals("Created prey (f,25,nothing) testing type", 'f', c.getType());

		c = new Predator('f',25,"");
		assertEquals("Created prey (f,25,'') testing huntStyle", "ambush", c.getHuntStyle());
		assertEquals("Created prey with valid 25 health.", 25, c.getHealth());
		assertEquals("Created prey (f,25,'') testing type", 'f', c.getType());
	}
	
	@Test
	public void test_CopyConstructor() {
		testInterface();
		Predator c = new Predator('n',10,"ambush");
		Predator c2 = new Predator(c);
		assertEquals("Copied prey with huntStyle stalk", "ambush", c2.getHuntStyle());
		assertEquals("Copied prey with 10 health.", 10, c2.getHealth());
		assertEquals("Copied prey with 'n' type.", 'n', c2.getType());
	}
	
	@Test
	public void test_CopyConstructor2() {
		testInterface();
		Predator c = new Predator('a',45,"stalk");
		Predator c2 = new Predator(c);
		assertEquals("Copied prey with huntStyle stalk", "stalk", c2.getHuntStyle());
		assertEquals("Copied prey with 45 health.", 45, c2.getHealth());
		assertEquals("Copied prey with 'a' type.", 'a', c2.getType());
	}


// Testing setter and getters

	@Test
	public void test_setter_and_getter_huntStyle_invalid(){
		testInterface();
		Predator c = new Predator('n',50,"ambush");
		c.setHuntStyle("run");
		assertEquals("Set huntStyle to invalid run, should have left unchanged from ambush", "ambush", c.getHuntStyle());
	}
	
	@Test
	public void test_setter_and_getter_huntStyle_stalk(){
		testInterface();
		Predator c = new Predator('n',50,"ambush");
		c.setHuntStyle("stalk");
		assertEquals("Changed huntStyle from ambushd to stalk", "stalk", c.getHuntStyle());
	}
	
	@Test
	public void test_setter_and_getter_huntStyle_huddle(){
		testInterface();
		Predator c = new Predator('n',50,"stalk");
		c.setHuntStyle("ambush");
		assertEquals("Changed huntStyle from stalk to ambush", "ambush", c.getHuntStyle());
	}
	
	@Test
	public void test_getRelativeHealth_ambush(){
		testInterface();
		Predator p = new Predator('m',10,"ambush");
		assertEquals("Ambush huntStyle and health 10.", 15.0, p.getRelativeHealth(),0.000001);
	}
	
	@Test
	public void test_getRelativeHealth_ambush2(){
		testInterface();
		Predator p = new Predator('m',123,"ambush");
		assertEquals("Ambush huntStyle and health 123.", 184.5, p.getRelativeHealth(),0.000001);
	}
	
	@Test
	public void test_getRelativeHealth_stalk(){
		testInterface();
		Predator p = new Predator('m',10,"stalk");
		assertEquals("Hide huntStyle, herd size 1 and health 10.", 7.5, p.getRelativeHealth(),0.000001);
	}
	
	@Test
	public void test_getRelativeHealth_stalk2(){
		testInterface();
		Predator p = new Predator('m',43,"stalk");
		assertEquals("Hide huntStyle, herd size 1 and health 43.", 32.25, p.getRelativeHealth(),0.000001);
	}
	

	
	// ToString
	
	@Test
	public void test_toString() {
		testInterface();
		assertTrue("Should override toString and it should invoke parent toString (not getter methods in parent).", toStrInvokesParentToStr());
		Predator c = new Predator('b', 51, "stalk");

		assertEquals("[Predator] Type: b Health: 38.25 Hunt style: stalk", c.toString());
	}

	@Test
	public void test_toString2() {
		testInterface();
		assertTrue("Should override toString and it should invoke parent toString (not getter methods in parent).", toStrInvokesParentToStr());
		Predator c = new Predator('f', 5, "ambush");

		assertEquals("[Predator] Type: f Health: 7.5 Hunt style: ambush", c.toString());
	}

////////////// End of test methods /////////////////////////////

	
	private boolean hasMethod(String signature) {
		boolean contains = false;
		
		try {
			BufferedReader in = new BufferedReader(new FileReader(FILENAME));
			String line = in.readLine();
			while (line != null) {
				if (line.contains(signature)) {
					contains = true;
				}
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
			contains = false;
		} catch (IOException e) {
			contains =  false;
		}
		return contains;
	
	}	
	
	private boolean toStrInvokesParentToStr(){
		boolean callsGetter = false;
		boolean callsParent = false;
		
		
		try {
			BufferedReader in = new BufferedReader(new FileReader(FILENAME));
			String line = in.readLine();
			while (line != null) {
				if (line.contains("toString")) {
					// This should be start of toString method
					while (!line.contains("}")) {
						line = in.readLine();
						if (line.contains("getHeight")){
							callsGetter = true;
						}
						if (line.contains("super.toString()")) {
							callsParent = true;
						}
					}
				}
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
			callsParent = false;
		} catch (IOException e) {
			callsParent =  false;
		}
		return callsParent && !callsGetter;
	}
	
	private boolean hasRequiredAbstractMethods(String[] abstractMethods) {
		boolean[] methodsAbstract = new boolean[abstractMethods.length];
		for (int index = 0; index < abstractMethods.length; index++){
			methodsAbstract[index] = false;
		}
		boolean classIsAbstract = false;
		
		try {
			BufferedReader in = new BufferedReader(new FileReader(FILENAME));
			String line = in.readLine();
			while (line != null) {
				if (line.contains("public abstract class " + CLASSNAME)){
					classIsAbstract = true;
				} else {
					for (int index = 0; index < abstractMethods.length; index++) {
						String stmt = "public abstract " + abstractMethods[index];
						if (line.contains(stmt)) {
							methodsAbstract[index] = true;
						}
					}
				}					
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
			classIsAbstract = false;
		} catch (IOException e) {
			classIsAbstract = false;
		}
		
		boolean allAbstract = classIsAbstract;
		for (boolean b : methodsAbstract) {
			allAbstract = allAbstract && b;
		}
		return allAbstract;
	
	}
	
	private boolean hasRequiredProtectedMethods(String[] protectedMethods) {
		boolean[] methodsProtected = new boolean[protectedMethods.length];
		for (int index = 0; index < protectedMethods.length; index++){
			methodsProtected[index] = false;
		}
		boolean allProtected = true;

		try {
			BufferedReader in = new BufferedReader(new FileReader(FILENAME));
			String line = in.readLine();
			while (line != null) {
				for (int index = 0; index < protectedMethods.length; index++) {
					String stmt = "protected " + protectedMethods[index];
						if (line.contains(stmt)) {
							methodsProtected[index] = true;
						}
				}

				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
			allProtected = false;
		} catch (IOException e) {
			allProtected = false;
		}

		for (boolean b : methodsProtected) {
			allProtected = allProtected && b;
		}
		return allProtected;
	}

	private boolean instanceVariablesArePrivate(String[] instanceVars){
		boolean[] varsPrivate = new boolean[instanceVars.length];
		for (int index = 0; index < instanceVars.length; index++){
			varsPrivate[index] = false;
		}
		boolean allPrivate = true;

		
		try {
			BufferedReader in = new BufferedReader(new FileReader(FILENAME));
			String line = in.readLine();
			while (line != null) {
				if (line.contains("private")) {
					line = line.trim();
					for (int index = 0; index < instanceVars.length; index++){
						String stmt = "private " + instanceVars[index];
						if (line.length() >= stmt.length()){
							String subline = line.substring(0,stmt.length());
							if (subline.equals(stmt)){
								varsPrivate[index] = true;
							}
						}
					}
				}
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
			allPrivate = false;
		} catch (IOException e) {
			allPrivate =  false;
		}

		for (boolean b : varsPrivate) {
			allPrivate = allPrivate && b;
		}
		return allPrivate;
	}	

	private boolean noDefaultConstructor(){
		boolean noDefault = true;
		String[] versions = new String[9];
		versions[0] = "public " + CLASSNAME + "()";
		versions[1] = "public " + CLASSNAME + " ()";
		versions[2] = "public " + CLASSNAME + " ( )";
		versions[3] = "protected " + CLASSNAME + "()";
		versions[4] = "protected " + CLASSNAME + " ()";
		versions[5] = "protected " + CLASSNAME + " ( )";
		versions[6] = CLASSNAME + "()";
		versions[7] = CLASSNAME + " ()";
		versions[8] = CLASSNAME + " ( )";

		try {
			BufferedReader in = new BufferedReader(new FileReader(FILENAME));
			String line = in.readLine();
			while (line != null) {
				for (String stmt : versions) {
					if (line.contains(stmt)) {
						noDefault = false;
					}
				}
				line = in.readLine();
			}
			in.close();
		} catch (FileNotFoundException e) {
			noDefault = false;
		} catch (IOException e) {
			noDefault =  false;
		}
		return noDefault;
	}				
		
}
