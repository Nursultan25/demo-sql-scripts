package recources;

public class test {
    public static void main(String[] args){
        String email = "nurs@gmail.com";
        String name = email.substring(0, email.indexOf('@'));
        System.out.println(name);
    }
}
