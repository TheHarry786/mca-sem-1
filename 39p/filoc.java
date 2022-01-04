import java.io.*;
public class filoc
{
	public static void main(String args[])throws IOException
	{
        File file = new File("D:/c program/java/36p/hello.txt");
        if(!file.exists())
        {
            file.createNewFile();
            System.out.println("file is created sucessfully");
        }
        
        else
        {
            System.out.println("File is exsit"+ " "+file.getAbsolutePath());
            
        }
    }
}