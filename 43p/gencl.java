import java.util.*;
class gencl
{
	public static <T> void add1(T n)
	{
		T t1 = n%10;
		t1=(t1*10)+n;
		t1/=10;
	}
	public static void main(String[] args)
	{
		add1<Integer> g= new add1<Integer>();
		g.add1(10);
		System.out.println(g.add1());
	}
}