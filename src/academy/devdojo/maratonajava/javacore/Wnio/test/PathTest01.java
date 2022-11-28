package academy.devdojo.maratonajava.javacore.Wnio.test;

import java.nio.file.Path;
import java.nio.file.Paths;

public class PathTest01 {
    public static void main(String[] args) {
        Path p1 = Paths.get("G:\\Meu Drive\\Desenvolvimento SQA\\02 - PROGRAMAÇÃO\\20 - DevDojoJava\\maratona-java\\file.txt");
        Path p2 = Paths.get("G:\\Meu Drive\\Desenvolvimento SQA\\02 - PROGRAMAÇÃO\\20 - DevDojoJava\\maratona-java", "file.txt");
        Path p3 = Paths.get("G" , "Meu Drive\\Desenvolvimento SQA\\02 - PROGRAMAÇÃO\\20 - DevDojoJava\\maratona-java", "file.txt");
        Path p4 = Paths.get("G" , "Meu Drive", "Desenvolvimento SQA", "02 - PROGRAMAÇÃO", "20 - DevDojoJava", "maratona-java", "file.txt");

        System.out.println(p1.getFileName());
        System.out.println(p2.getFileName());
        System.out.println(p3.getFileName());
        System.out.println(p4.getFileName());
    }
}
