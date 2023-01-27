package academy.devdojo.maratonajava.javacore.Ycolecoes.test;

import academy.devdojo.maratonajava.javacore.Ycolecoes.dominio.Smartphone;

import java.util.ArrayList;
import java.util.List;

public class ShmartPhoneListTest01 {
    public static void main(String[] args) {

        Smartphone s1 = new Smartphone("11111", "Iphone");
        Smartphone s2 = new Smartphone("22222", "Samsung");
        Smartphone s3 = new Smartphone("33333", "Nokia");
        List<Smartphone> smartphones = new ArrayList<>(6);

        smartphones.add(s1);
        smartphones.add(s2);
        smartphones.add(0, s3);

//        smartphones.clear();

        for (Smartphone smartphone : smartphones) {
            System.out.println(smartphone);
        }

        Smartphone s4 = new Smartphone("22222", "Samsung");
        smartphones.add(0, s4);

        // Verificando se contem
        System.out.println(smartphones.contains(s4));

        // Achando o Indice
        int indexSmartphone4 = smartphones.indexOf(s4);
        System.out.println(smartphones.get(indexSmartphone4));
    }
}
