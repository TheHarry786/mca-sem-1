/*Write a java program to count the availability of text lines in the particular file. A file is
read before
counting lines of a particular file*/

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class co
{
	public static void main(String args[])throws IOException
	{

        long lines = 0;
        // File file = new File("hello.txt");
        Path path = Paths.get("hello.txt");
        
		try
		{
           
            lines = Files.lines(path).count();
            System.out.println("File Line : "+lines);
			
		}
        

        catch(IOException e)
        {
            System.out.println("File Eror : "+e);
        }
		//return lines;
	}
}
