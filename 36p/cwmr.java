import java.io.*;
public class cwmr
{
	public static void main(String args[])throws IOException
	{
		FileInputStream in = null;
		FileOutputStream out = null;
	
		try
		{
            File file = new File("D:/c program/java/36p/hello.txt");
            if(!file.exists())
            {
                file.createNewFile();
                System.out.println("file is created sucessfully");
            }
			FileOutputStream fout = new FileOutputStream(file);
            String s="Java is programming language";
            byte b[] = s.getBytes();
            fout.write(b);
            System.out.println("writing complete");

            FileInputStream fin = new FileInputStream(file);
            int i;
            while((i=fin.read())!=-1)
            {
                System.out.print((char)i);
            }
            s="java is an object oriented laguage";
            b=s.getBytes();
            fout.write(b);
            System.out.println("\n Modification Complete");

            while((i=fin.read())!=-1)
            {
                System.out.print((char)i);
            }
            fin.close();
        fout.close();
		}
        catch(IOException e)
        {
            System.out.println("File Eror : "+e);
        }
		finally
		{
			if(in!=null)
			{
					in.close();
			}
			if(out!=null)
			{
				out.close();
			}
		}
	}
}