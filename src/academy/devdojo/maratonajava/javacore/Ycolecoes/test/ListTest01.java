package academy.devdojo.maratonajava.javacore.Ycolecoes.test;

import java.util.ArrayList;
import java.util.List;

public class ListTest01 {
    public static void main(String[] args) {
        List<String> nomes = new ArrayList<>();
        List<String> nomes2 = new ArrayList<>();
        nomes.add("Murilo");
        nomes.add("Madu");
        nomes2.add("João");
        nomes2.add("Leonardo");
        nomes2.add("Sávio");
        nomes2.add("Tarcisio");

//        nomes.remove("Madu");

        nomes.addAll(nomes2);

        int j = 1;

        for (String nome : nomes) {
            System.out.println(j + " - " + nome);
            j++;
        }

        System.out.println("-------------");

        int size = nomes.size();
        for (int i = 0; i < size; i++) {
            System.out.println(i + " - " + nomes.get(i));
        }

    }
}
