package academy.devdojo.maratonajava.xdesenvolvimentoskw.ztreino;

import java.util.ArrayList;

public class listas {
    public static void main(String[] args) {
        ArrayList<Aluno> listaAlunos = new ArrayList<>();

        System.out.println("----------1----------");
        listaAlunos.add(new Aluno("Fulano"));
        listaAlunos.add(new Aluno("Cicrano"));
        listaAlunos.add(new Aluno("Beltrano"));
        System.out.println(listaAlunos.size());

        System.out.println("----------2----------");
        for (Aluno aluno : listaAlunos) {
            System.out.println(aluno.getNome());
        }

        System.out.println("----------3----------");
        System.out.println(listaAlunos.contains(new Aluno("Cicrano")));

        System.out.println("----------4----------");
        listaAlunos.remove(new Aluno("Cicrano"));
        listaAlunos.remove(1);
        System.out.println(listaAlunos.size());

        System.out.println("----------5----------");
        for (Aluno aluno : listaAlunos) {
            System.out.println(aluno.getNome());
        }

    }

}
