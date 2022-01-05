import java.io.File;
import java.io.FileInputStream;
import java.util.*;
public class counlin
{
    public static void main(String args[])
    {
        try{
            File f = new File("hello.txt");
            Scanner sc =  new Scanner(System.in);
            int count = 0;
            while(sc.hasNextLine())
            {
                sc.nextLine();
                count++;
            }
            sc.close();
            System.out.println("there is :"+count+"lines");

        }
        catch(Exception e)
        {
            System.out.print("error :"+e);
        }
    }
}