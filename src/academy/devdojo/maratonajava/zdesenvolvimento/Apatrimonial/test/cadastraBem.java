package academy.devdojo.maratonajava.zdesenvolvimento.Apatrimonial.test;

import academy.devdojo.maratonajava.zdesenvolvimento.Apatrimonial.dominio.Bem;
import academy.devdojo.maratonajava.zdesenvolvimento.Apatrimonial.dominio.TipoImobilizado;

import java.time.LocalDate;

public class cadastraBem {
    public static void main(String[] args) {
        Bem bem1 = new Bem(5581, 5000, "Computador Dell i5", LocalDate.of(2022, 5, 31), TipoImobilizado.COMPUTADORES_E_PERIFERICOS);
        Bem bem2 = new Bem(2586, 8500, "Computador Dell i7", LocalDate.of(2022, 1, 31), TipoImobilizado.COMPUTADORES_E_PERIFERICOS);
        Bem bem3 = new Bem(3545, 4500, "Instalação Eletrica Barracao", LocalDate.of(2022, 7, 31), TipoImobilizado.INSTALACOES);
        Bem bem4 = new Bem(86732, 65000, "Honda Civic 2018", LocalDate.of(2022, 3, 31), TipoImobilizado.VEICULOS);
        Bem bem5 = new Bem(2453, 1500, "Mesa Sala Comercial", LocalDate.of(2022, 8, 31), TipoImobilizado.MOVEIS_E_UTENSILIOS);
        Bem bem6 = new Bem(3737, 4000, "Instalação Eletrica Sala Comercial", LocalDate.of(2022, 3, 31), TipoImobilizado.INSTALACOES);

        System.out.println(bem1.toString());
        System.out.println(bem2.toString());
        System.out.println(bem3.toString());
        System.out.println(bem4.toString());
        System.out.println(bem5.toString());
        System.out.println(bem6.toString());
        System.out.println();
        System.out.println("****** FICHA TECNICA PATRIMONIAL SQA ******");
        System.out.println(bem1.getTipoImobilizado().getNomeRelatorio() + " - " + bem1.getDescricao());
        System.out.println("Quantidade de meses para depreciação total: " + bem1.QuantidadeMesesParaDepreciar(bem1));
        System.out.println("Quantidade de anos para depreciação total: " + bem1.QuantidadeAnosParaDepreciar(bem1));
        System.out.println("Valor de depreciação mensal R$" + bem1.ValorDepreciacaoMensal(bem1));
        System.out.println("Depreciação Acumulada hoje R$" + bem1.DepreciacaoAcumuladaAgora(bem1));
        System.out.println("Saldo a depreciar hoje R$" + bem1.SaldoAgora(bem1));
        System.out.println("Depreciação Acumulada com base na data informada R$" + bem1.DepreciacaoAcumuladaData(bem1, "2022-08-31"));
        System.out.println("Saldo a depreciar com base na data informada R$" + bem1.SaldoData(bem1, "2022-08-31"));
        System.out.println("--------------------------------------------------------------------------------------------------------------");        System.out.println(bem2.getTipoImobilizado().getNomeRelatorio() + " - " + bem2.getDescricao());
        System.out.println("Quantidade de meses para depreciação total: " + bem2.QuantidadeMesesParaDepreciar(bem2));
        System.out.println("Quantidade de anos para depreciação total: " + bem2.QuantidadeAnosParaDepreciar(bem2));
        System.out.println("Valor de depreciação mensal R$" + bem2.ValorDepreciacaoMensal(bem2));
        System.out.println("Depreciação Acumulada hoje R$" + bem2.DepreciacaoAcumuladaAgora(bem2));
        System.out.println("Saldo a depreciar hoje R$" + bem2.SaldoAgora(bem2));
        System.out.println("Depreciação Acumulada com base na data informada R$" + bem2.DepreciacaoAcumuladaData(bem2, "2022-08-31"));
        System.out.println("Saldo a depreciar com base na data informada R$" + bem2.SaldoData(bem2, "2022-08-31"));
        System.out.println("--------------------------------------------------------------------------------------------------------------");
        System.out.println(bem3.getTipoImobilizado().getNomeRelatorio() + " - " + bem3.getDescricao());
        System.out.println("Quantidade de meses para depreciação total: " + bem3.QuantidadeMesesParaDepreciar(bem3));
        System.out.println("Quantidade de anos para depreciação total: " + bem3.QuantidadeAnosParaDepreciar(bem3));
        System.out.println("Valor de depreciação mensal R$" + bem3.ValorDepreciacaoMensal(bem3));
        System.out.println("Depreciação Acumulada hoje R$" + bem3.DepreciacaoAcumuladaAgora(bem3));
        System.out.println("Saldo a depreciar hoje R$" + bem3.SaldoAgora(bem3));
        System.out.println("Depreciação Acumulada com base na data informada R$" + bem3.DepreciacaoAcumuladaData(bem3, "2022-08-31"));
        System.out.println("Saldo a depreciar com base na data informada R$" + bem3.SaldoData(bem3, "2022-08-31"));
        System.out.println("--------------------------------------------------------------------------------------------------------------");        System.out.println(bem4.getTipoImobilizado().getNomeRelatorio() + " - " + bem4.getDescricao());
        System.out.println("Quantidade de meses para depreciação total: " + bem4.QuantidadeMesesParaDepreciar(bem4));
        System.out.println("Quantidade de anos para depreciação total: " + bem4.QuantidadeAnosParaDepreciar(bem4));
        System.out.println("Valor de depreciação mensal R$" + bem4.ValorDepreciacaoMensal(bem4));
        System.out.println("Depreciação Acumulada hoje R$" + bem4.DepreciacaoAcumuladaAgora(bem4));
        System.out.println("Saldo a depreciar hoje R$" + bem4.SaldoAgora(bem4));
        System.out.println("Depreciação Acumulada com base na data informada R$" + bem4.DepreciacaoAcumuladaData(bem4, "2022-08-31"));
        System.out.println("Saldo a depreciar com base na data informada R$" + bem4.SaldoData(bem4, "2022-08-31"));
        System.out.println("--------------------------------------------------------------------------------------------------------------");        System.out.println(bem5.getTipoImobilizado().getNomeRelatorio() + " - " + bem5.getDescricao());
        System.out.println("Quantidade de meses para depreciação total: " + bem5.QuantidadeMesesParaDepreciar(bem5));
        System.out.println("Quantidade de anos para depreciação total: " + bem5.QuantidadeAnosParaDepreciar(bem5));
        System.out.println("Valor de depreciação mensal R$" + bem5.ValorDepreciacaoMensal(bem5));
        System.out.println("Depreciação Acumulada hoje R$" + bem5.DepreciacaoAcumuladaAgora(bem5));
        System.out.println("Saldo a depreciar hoje R$" + bem5.SaldoAgora(bem5));
        System.out.println("Depreciação Acumulada com base na data informada R$" + bem5.DepreciacaoAcumuladaData(bem5, "2022-08-31"));
        System.out.println("Saldo a depreciar com base na data informada R$" + bem5.SaldoData(bem5, "2022-08-31"));
        System.out.println("--------------------------------------------------------------------------------------------------------------");        System.out.println(bem6.getTipoImobilizado().getNomeRelatorio() + " - " + bem6.getDescricao());
        System.out.println("Quantidade de meses para depreciação total: " + bem6.QuantidadeMesesParaDepreciar(bem6));
        System.out.println("Quantidade de anos para depreciação total: " + bem6.QuantidadeAnosParaDepreciar(bem6));
        System.out.println("Valor de depreciação mensal R$" + bem6.ValorDepreciacaoMensal(bem6));
        System.out.println("Depreciação Acumulada hoje R$" + bem6.DepreciacaoAcumuladaAgora(bem6));
        System.out.println("Saldo a depreciar hoje R$" + bem6.SaldoAgora(bem6));
        System.out.println("Depreciação Acumulada com base na data informada R$" + bem6.DepreciacaoAcumuladaData(bem6, "2022-08-31"));
        System.out.println("Saldo a depreciar com base na data informada R$" + bem6.SaldoData(bem6, "2022-08-31"));
        System.out.println("--------------------------------------------------------------------------------------------------------------");


    }

}