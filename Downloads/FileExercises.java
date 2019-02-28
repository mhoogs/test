import java.io.*;
import java.io.FileWriter;
import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.IOException;
public class FileExercises{
	
	public void append(boolean bool, String filename){
		try{
			String str = String.valueOf(bool);
			BufferedWriter bw = new BufferedWriter(new FileWriter(filename, true));
			bw.write(str);
			bw.newLine();
			bw.flush();
		}
			catch(IOException e){
		}
	}
		
	
	public void getLetters(String inputFileName, String outputFileName){
		int lineCounter = 0;
		String errorMessage = null;
		try{
			BufferedReader input = new BufferedReader(new FileReader(inputFileName));
			PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter(outputFileName)));
			
			String line = input.readLine();
			while(line!=null){
				lineCounter ++;
				String[] words = line.split(" ");
				for(int i = 0; i<words.length; i++){
					String word = words[i];
					char newWord = word.charAt(0);
					char h = Character.toLowerCase(newWord);
					
					writer.print(h);
				}
				line = input.readLine();
			}
			writer.flush();
			writer.close();
			input.close();
		}
			catch (FileNotFoundException e){
				try(Writer w = new FileWriter(outputFileName, true)){
					
				e.printStackTrace(new PrintWriter(new BufferedWriter(w)));
			}
			catch(IOException ioee){}
		}
				
				
		
		catch(IOException ioe){
			ioe.printStackTrace();}
			
		}
		
	
	
	public int count (char aChar, String filename) {
		int counter =0;
		
		try{
			Reader in = new FileReader(filename);
			int a = -1;
			while((a = in.read())> -1){
				if(a == aChar ){
					counter ++;
				}
			char f = Character.toUpperCase(aChar);
				if(a== f){
					counter++;
				}
			}}
			catch(FileNotFoundException e){
				return -1;}
			catch (IOException e){
				counter =-1;
			}
			catch(Exception e){}
			return counter;
		
	}
			
			
			
	
	public long addLongs(String inputFileName){
		long sum =0;
		try{
			DataInputStream in = new DataInputStream(new FileInputStream(inputFileName));
			for(int counter =0; counter<100; counter++){
			 long nextLong = in.readLong();
				sum += nextLong;}
			} catch (IOException e) {
				sum = -1;
			}
			return sum;
		}
	
}
