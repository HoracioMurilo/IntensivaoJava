var query = getQuery();

query.setParam("AD_NROOS", getParam("AD_NROOS"));
query.setParam("CODTIPOPER", getParam("CODTIPOPER"));
var vAD_NROOS = getParam("AD_NROOS");
var vCODTIPOPER = getParam("CODTIPOPER");


query.nativeSelect("    SELECT\n" +
    "    \n" +
    "    SUM(Z.VLRNOTA)/(SELECT MAX(PPG.SEQUENCIA) FROM TGFTPV TPV INNER JOIN TGFPPG PPG ON PPG.CODTIPVENDA = TPV.CODTIPVENDA WHERE TPV.CODTIPVENDA = Z.CODTIPVENDA) AS VLRNOTA\n" +
    "    , PPG.SEQUENCIA\n" +
    "    , PPG.PRAZO\n" +
    "    , PPG.CODTIPTITPAD\n" +
    "    , Z.DTNEG\n" +
    "    , PRAZO AS DTVENC\n" +
    "    , Z.AD_NROOS\n" +
    "    , Z.AD_PROCESSADO\n" +
    "    , Z.CODBCO\n" +
    "    , Z.CODCENCUS\n" +
    "    , Z.CODCTABCOINT\n" +
    "    , Z.CODEMP\n" +
    "    , Z.CODNAT\n" +
    "    , Z.CODPARC\n" +
    "    , Z.CODTIPTIT\n" +
    "    , Z.CODTIPVENDA\n" +
    "    , Z.CODVEICULO\n" +
    "    , Z.DTNEG\n" +
    "    \n" +
    "    FROM\n" +
    "            (SELECT \n" +
    "            CAB.AD_NROOS \n" +
    "            , CAB.AD_PROCESSADO \n" +
    "            , (SELECT MAX(CODBCO) FROM TGFFIN FIN WHERE FIN.NUNOTA = CAB.NUNOTA) AS CODBCO \n" +
    "            , CAB.CODCENCUS \n" +
    "            , (SELECT MAX(CODCTABCOINT) FROM TGFFIN FIN WHERE FIN.NUNOTA = CAB.NUNOTA) AS CODCTABCOINT \n" +
    "            , CAB.CODEMP \n" +
    "            , CAB.CODNAT \n" +
    "            , CAB.CODPARC \n" +
    "            , CAB.CODTIPOPER \n" +
    "            , (SELECT MAX(CODTIPTIT) FROM TGFFIN FIN WHERE FIN.NUNOTA = CAB.NUNOTA) AS CODTIPTIT \n" +
    "            , CAB.CODTIPVENDA \n" +
    "            , CAB.CODVEICULO \n" +
    "            , CAB.DTNEG \n" +
    "            , CAB.VLRNOTA AS VLRNOTA \n" +
    "            FROM TGFCAB CAB \n" +
    "        \n" +
    "            WHERE \n" +
    "            AD_PROCESSADO = 'N' \n" +
    "            AND STATUSNOTA = 'L' \n" +
    "            AND CAB.AD_NROOS = 282362\n" +
    "            )Z \n" +
    "            \n" +
    "            INNER JOIN TGFTPV TPV ON TPV.CODTIPVENDA = Z.CODTIPVENDA\n" +
    "            INNER JOIN TGFPPG PPG ON PPG.CODTIPVENDA = TPV.CODTIPVENDA \n" +
    "            \n" +
    "    GROUP BY Z.CODTIPVENDA, PPG.SEQUENCIA, PPG.PRAZO, Z.DTNEG, PPG.CODTIPTITPAD, Z.AD_NROOS\n" +
    "    , Z.AD_PROCESSADO\n" +
    "    , Z.CODBCO\n" +
    "    , Z.CODCENCUS\n" +
    "    , Z.CODCTABCOINT\n" +
    "    , Z.CODEMP\n" +
    "    , Z.CODNAT\n" +
    "    , Z.CODPARC\n" +
    "    , Z.CODTIPTIT\n" +
    "    , Z.CODTIPVENDA\n" +
    "    , Z.CODVEICULO\n" +
    "    , Z.DTNEG\n" +
    "    \n" +
    "    ORDER BY PPG.SEQUENCIA");


while (query.next()) {

    var vPROCESSADO = query.getString("AD_PROCESSADO");

    if (vPROCESSADO != "S") {

        var linhaOS = novaLinha("TGFFIN");

        //CAMPOS QUE EXISTEM NA CONSULTA
        linhaOS.setCampo("CODEMP", query.getInt("CODEMP"));
        linhaOS.setCampo("NUMNOTA", query.getInt("AD_NROOS"));
        linhaOS.setCampo("CODCENCUS", query.getInt("CODCENCUS"));
        linhaOS.setCampo("DTNEG", new java.util.Date);
        linhaOS.setCampo("DTENTSAI", new java.util.Date);
        linhaOS.setCampo("DTVENC", query.getDate("DTVENC"));
        linhaOS.setCampo("CODPARC", query.getInt("CODPARC"));
        linhaOS.setCampo("CODTIPOPER", vCODTIPOPER);
        linhaOS.setCampo("CODNAT", query.getInt("CODNAT"));
        linhaOS.setCampo("CODBCO", query.getInt("CODBCO"));
        linhaOS.setCampo("CODCTABCOINT", query.getInt("CODCTABCOINT"));
        linhaOS.setCampo("CODTIPTIT", query.getInt("CODTIPTIT"));
        linhaOS.setCampo("SEQUENCIA", query.getInt("SEQUENCIA"));
        linhaOS.setCampo("VLRDESDOB", query.getDouble("VLRNOTA"));
        linhaOS.setCampo("RECDESP", "1");
        linhaOS.setCampo("PROVISAO", "N");
        linhaOS.setCampo("ORIGEM", "F");
        linhaOS.setCampo("HISTORICO", "ROTINA AUTOMATICA");

        linhaOS.save();
    }
}

query.close();
mensagem = "Foi gerado o título ";
mensagem += linhaOS.getCampo("NUFIN");
mensagem += " no valor de ";
mensagem += linhaOS.getCampo("VLRDESDOB")
mensagem += "Financeiro gerado para a Ordem de Serviço: " + vAD_NROOS + " ";
