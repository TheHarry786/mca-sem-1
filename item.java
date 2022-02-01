import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.Scanner;

public class item {
    int product_bar_code, price, net_price;
    String product_brand_name;

    item(int a, String b, int c) {
        product_bar_code = a;
        product_brand_name = b;
        price = c;

        netprice(c);
    }

    item() {
        System.out.println("not exists");
    }

    void display() {
        try {
            File file = new File("1.txt");
            PrintWriter writer = new PrintWriter(file);
            writer.println(product_brand_name);
            writer.println(product_bar_code);
            writer.println(price);
            writer.println(net_price);
            writer.close();

            FileReader fileReader = new FileReader(file);

            int i;
            while ((i = fileReader.read()) != -1) {
                System.out.print((char) i);
            }
            fileReader.close();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

    }

    void netprice(int pri) {
        if (pri >= 200 && pri <= 499)
            net_price = price - (pri * 5 / 100);
        else if (pri >= 500)
            net_price = price - (pri * 10 / 100);
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int p = sc.nextInt();

        item i = new item(111, "car", p);
        i.display();
    }
}
