import java.util.function.Predicate;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
class Counter
{
    public static <T> int countIf(List<T> list,Predicate<T> p)
    {
        int count = 0;
        for(T elem : list)
        {
            if(p.test(elem))
            {
                ++count;
            }
        }
        return count;
    }
}
class Operation
{
    public static boolean checkEvenNumber(final int num)
    {
        return num % 2 == 0;
    }
    public static boolean checkkOddNumber(final int num)
    {
        return num % 2 != 0;
    }
    public static boolean checkPrimeNumber(final int num)
    {
        if(num == 0 || num ==1)
        {
            return false;
        }
        for(int i =2;i * i<=num;i++)
        {
            if(num%i == 0)
            {
                return false;
            }
        }
        return true;
    }
    public static boolean checkPalindrome(Integer num)
    {
        int r,sum=0,temp;
        temp=num;
        while(num>0)
        {
            r=num%10;
            sum=(sum*10)+r;
            num=num/10;
        }
        return(temp==sum);
    }
}
public class genop
{
    public static void main(String args[])
    {
        List<Integer> list = Arrays.asList(1,2,121,3,4,5,10,65456);
        int count=0;

        count= Counter.countIf(list, Operation::checkkOddNumber);
        System.out.println("Number of odd:"+count);

        count= Counter.countIf(list, Operation::checkEvenNumber);
        System.out.println("Number of even:"+count);

        count= Counter.countIf(list, Operation::checkPrimeNumber);
        System.out.println("Number of Prime:"+count);

        count= Counter.countIf(list, Operation::checkPalindrome);
        System.out.println("Number of Palindrome:"+count);
    }
}