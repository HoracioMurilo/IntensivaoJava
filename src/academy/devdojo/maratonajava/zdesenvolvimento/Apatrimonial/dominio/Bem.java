package academy.devdojo.maratonajava.zdesenvolvimento.Apatrimonial.dominio;

import java.time.LocalDate;

public class Bem implements Calculos{
    protected int notaFiscal;
    protected double valor;
    protected String descricao;
    protected LocalDate dataAquisicao;
    protected TipoImobilizado tipoImobilizado;

    // LocalDate date = LocalDate.of(2022, Month.JANUARY, 27);
    public Bem(int notaFiscal, double valor, String descricao, LocalDate dataAquisicao, TipoImobilizado tipoImobilizado) {
        this.notaFiscal = notaFiscal;
        this.valor = valor;
        this.descricao = descricao;
        this.dataAquisicao = dataAquisicao;
        this.tipoImobilizado = tipoImobilizado;
    }

    @Override
    public String toString() {
        return "Bem{" +
                "notaFiscal=" + notaFiscal +
                ", valor=" + valor +
                ", descricao='" + descricao + '\'' +
                ", dataAquisicao='" + dataAquisicao + '\'' +
                ", tipoImobilizado=" + tipoImobilizado.getNomeRelatorio() + ", código=" + tipoImobilizado.getValor() +
                '}';
    }

    public int getNotaFiscal() {
        return notaFiscal;
    }

    public double getValor() {
        return valor;
    }

    public String getDescricao() {
        return descricao;
    }

    public LocalDate getDataAquisicao() {
        return dataAquisicao;
    }

    public TipoImobilizado getTipoImobilizado() {
        return tipoImobilizado;
    }

}