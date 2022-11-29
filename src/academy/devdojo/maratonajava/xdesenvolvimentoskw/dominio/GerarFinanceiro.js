var query = getQuery();

query.setParam("AD_NROOS", getParam("AD_NROOS"));
query.setParam("CODTIPOPER", getParam("CODTIPOPER"));
var vAD_NROOS = getParam("AD_NROOS");
var vCODTIPOPER = getParam("CODTIPOPER");


query.nativeSelect(" SELECT " +
    "              Z.AD_NROOS " +
    "              , Z.AD_PROCESSADO " +
    "              , Z.CODBCO " +
    "              , Z.CODCENCUS " +
    "              , Z.CODCTABCOINT " +
    "              , Z.CODEMP " +
    "              , Z.CODNAT " +
    "              , Z.CODPARC " +
    "              , Z.CODTIPTIT " +
    "              , Z.CODTIPVENDA " +
    "              , Z.CODVEICULO " +
    "              , Z.DTNEG " +
    "              , SUM(Z.VLRNOTA) AS VLRNOTA " +
    "              FROM " +
    "              (SELECT " +
    "              CAB.AD_NROOS " +
    "              , CAB.AD_PROCESSADO " +
    "              , (SELECT MAX(CODBCO) FROM TGFFIN FIN WHERE FIN.NUNOTA = CAB.NUNOTA) AS CODBCO " +
    "              , CAB.CODCENCUS " +
    "              , (SELECT MAX(CODCTABCOINT) FROM TGFFIN FIN WHERE FIN.NUNOTA = CAB.NUNOTA) AS CODCTABCOINT " +
    "              , CAB.CODEMP " +
    "              , CAB.CODNAT " +
    "              , CAB.CODPARC " +
    "              , CAB.CODTIPOPER " +
    "              , (SELECT MAX(CODTIPTIT) FROM TGFFIN FIN WHERE FIN.NUNOTA = CAB.NUNOTA) AS CODTIPTIT " +
    "              , CAB.CODTIPVENDA " +
    "              , CAB.CODVEICULO " +
    "              , CAB.DTNEG " +
    "              , CAB.VLRNOTA AS VLRNOTA " +
    "              FROM TGFCAB CAB " +
    "              WHERE " +
    "              AD_PROCESSADO = 'N' " +
    "              AND STATUSNOTA = 'L' " +
    "              AND CAB.AD_NROOS = {AD_NROOS})Z " +
    "              GROUP BY Z.AD_NROOS " +
    "              , Z.AD_PROCESSADO " +
    "              , Z.CODBCO " +
    "              , Z.CODCENCUS " +
    "              , Z.CODCTABCOINT " +
    "              , Z.CODEMP " +
    "              , Z.CODNAT " +
    "              , Z.CODPARC " +
    "              , Z.CODTIPTIT " +
    "              , Z.CODTIPVENDA " +
    "              , Z.CODVEICULO " +
    "              , Z.DTNEG ");

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
        linhaOS.setCampo("DTVENC", new java.util.Date);
        linhaOS.setCampo("CODPARC", query.getInt("CODPARC"));
        linhaOS.setCampo("CODTIPOPER", vCODTIPOPER);
        linhaOS.setCampo("CODNAT", query.getInt("CODNAT"));
        linhaOS.setCampo("CODBCO", query.getInt("CODBCO"));
        linhaOS.setCampo("CODCTABCOINT", query.getInt("CODCTABCOINT"));
        linhaOS.setCampo("CODTIPTIT", query.getInt("CODTIPTIT"));
        linhaOS.setCampo("VLRDESDOB", query.getDouble("VLRNOTA"));
        linhaOS.setCampo("RECDESP", "1");
        linhaOS.setCampo("PROVISAO", "N");
        linhaOS.setCampo("ORIGEM", "F");
        linhaOS.setCampo("HISTORICO", "ROTINA AUTOMATICA");

        linhaOS.save();

    }

    query.close();

}
mensagem = "Foi gerado o título ";
mensagem += linhaOS.getCampo("NUFIN");
mensagem += " no valor de ";
mensagem += linhaOS.getCampo("VLRDESDOB")
mensagem += "Financeiro gerado para a Ordem de Serviço: " + vAD_NROOS + " ";
