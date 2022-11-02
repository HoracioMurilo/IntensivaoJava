package academy.devdojo.maratonajava.zdesenvolvimento.Apatrimonial.dominio;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public interface Calculos {
    default int QuantidadeMesesParaDepreciar(Bem bem) {
        if (bem.getTipoImobilizado().getValor() == 1) { // Veiculos -- 5%
            return 60;
        } else if (bem.getTipoImobilizado().getValor() == 2) { // Moveis e Utensilios -- 10%
            return 120;
        } else if (bem.getTipoImobilizado().getValor() == 3) { // Imoveis -- 25%
            return 300;
        } else if (bem.getTipoImobilizado().getValor() == 4) { // Terrenos -- 0%
            return 0;
        } else if (bem.getTipoImobilizado().getValor() == 5) { // Maquinas e Equipamentos -- 10%
            return 120;
        } else if (bem.getTipoImobilizado().getValor() == 6) { // Instalacoes -- 10%
            return 120;
        } else if (bem.getTipoImobilizado().getValor() == 7) { // Benfeitorias -- 0
            return 0;
        } else if (bem.getTipoImobilizado().getValor() == 8) { // Computadores e Perifericos -- 5%
            return 60;
        }
        return 0;
    }

    default int QuantidadeAnosParaDepreciar(Bem bem) {
        if (bem.getTipoImobilizado().getValor() == 1) { // Veiculos -- 5%
            return 5;
        } else if (bem.getTipoImobilizado().getValor() == 2) { // Moveis e Utensilios -- 10%
            return 10;
        } else if (bem.getTipoImobilizado().getValor() == 3) { // Imoveis -- 25%
            return 25;
        } else if (bem.getTipoImobilizado().getValor() == 4) { // Terrenos -- 0%
            return 0;
        } else if (bem.getTipoImobilizado().getValor() == 5) { // Maquinas e Equipamentos -- 10%
            return 10;
        } else if (bem.getTipoImobilizado().getValor() == 6) { // Instalacoes -- 10%
            return 10;
        } else if (bem.getTipoImobilizado().getValor() == 7) { // Benfeitorias -- 0
            return 0;
        } else if (bem.getTipoImobilizado().getValor() == 8) { // Computadores e Perifericos -- 5%
            return 5;
        }
        return 0;
    }

    default double ValorDepreciacaoMensal(Bem bem) {
        return bem.getValor() / QuantidadeMesesParaDepreciar(bem);
    }

    default double DepreciacaoAcumuladaAgora(Bem bem) {
        double quantidadeMeses = ChronoUnit.MONTHS.between(bem.getDataAquisicao(), LocalDate.now());
        double depreciacao = quantidadeMeses * ValorDepreciacaoMensal(bem);
        return depreciacao;
    }

    default double SaldoAgora(Bem bem) {
        double saldo = bem.getValor() - DepreciacaoAcumuladaAgora(bem);
        return saldo;
    }

    default double DepreciacaoAcumuladaData(Bem bem, String data) {
        LocalDate var = LocalDate.parse(data);
        double quantidadeMeses = ChronoUnit.MONTHS.between(bem.getDataAquisicao(), var);
        double depreciacao = quantidadeMeses * ValorDepreciacaoMensal(bem);
        return depreciacao;
    }

    default double SaldoData(Bem bem, String data) {
        double teste = DepreciacaoAcumuladaData(bem, data);
        double saldo = bem.getValor() - teste;
        return saldo;
    }

}
