var query = getQuery();

for (var i = 0; i < linhas.length; i++) {
    var linha = linhas[i];

    query.setParam("NUNOTA", linha.getCampo("NUNOTA"));

    query.setParam("AD_CHECKLCTO", getParam("AD_CHECKLCTO"));

    query.nativeSelect("SELECT * FROM TGFFIN WHERE ORIGEM = 'E' AND NUNOTA = {NUNOTA} UNION ALL SELECT * FROM TGFFIN WHERE ORIGEM = 'F' AND NUFIN = {NUNOTA}");

    while (query.next()) {

        var origemLct = query.getString("ORIGEM");

        if (origemLct == 'F') {
            query.update("UPDATE TGFFIN SET AD_CHECKLCTO = {AD_CHECKLCTO} WHERE NUFIN = {NUNOTA} ");
        } else if (origemLct == 'E') {
            query.update("UPDATE TGFCAB SET AD_CHECKLCTO = {AD_CHECKLCTO} WHERE NUNOTA = {NUNOTA} ");
            query.update("UPDATE TGFFIN SET AD_CHECKLCTO = {AD_CHECKLCTO} WHERE NUNOTA = {NUNOTA} AND ORIGEM = 'E' ")
        }
    }

    query.close();
}

mensagem = "<b>  LANÇAMENTO(s) CLASSIFICADO(s) !  </b><br>";