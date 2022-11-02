package academy.devdojo.maratonajava.zdesenvolvimento.Apatrimonial.dominio;

public enum TipoImobilizado {
    VEICULOS(1, "Veículos"),
    MOVEIS_E_UTENSILIOS(2, "Moveis e Utensilios"),
    IMOVEIS(3, "Imoveis"),
    TERRENOS(4, "Terrenos"),
    MAQUINAS_E_EQUIPAMENTOS(5, "Maquinas e Equipamentos"),
    INSTALACOES(6, "Instalações"),
    BENFEITORIAS(7, "Benfeitorias"),
    COMPUTADORES_E_PERIFERICOS(8, "Computadores e Perifericos");

    private int valor;
    private String nomeRelatorio;

    TipoImobilizado(int valor, String nomeRelatorio) {
        this.valor = valor;
        this.nomeRelatorio = nomeRelatorio;
    }

    public int getValor() {
        return valor;
    }

    public String getNomeRelatorio() {
        return nomeRelatorio;
    }
}