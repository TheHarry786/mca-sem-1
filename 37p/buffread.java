/*Write a java program to illustrate use of standard input stream to read the user input*/
import java.util.*;
import java.io.*;
class bufread
{
    public static void main(String args[])
    {
        int first,second,third;
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
       try{
        System.out.println("enter the first value:");
        first = Integer.parseInt(br.readLine());
       
        System.out.println("enter the first value:");
        second = Integer.parseInt(br.readLine());

        third = first * second;
        System.out.print(third);
       }
       catch(Exception e)
       {
           
       }
    }
}