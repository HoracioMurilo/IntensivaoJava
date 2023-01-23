var query = getQuery();

for (var i = 0; i < linhas.length; i++) {
    var linha = linhas[i];

    query.setParam("NUNOTA", linha.getCampo("NUNOTA"));

    query.nativeSelect("SELECT * FROM TGFCAB WHERE NUNOTA = {NUNOTA}");

    while (query.next()) {

        var origemLct = query.getInt("CODTIPOPER");

        if (origemLct == 1105) {
            query.update(" UPDATE TGFCAB SET STATUSNFSE = 'A' WHERE NUNOTA = {NUNOTA} AND TIPMOV IN ('V','D') ");
        } else if (origemLct == 1118) {
            query.update(" UPDATE TGFCAB SET STATUSNFE = 'A' WHERE NUNOTA = {NUNOTA} AND TIPMOV IN ('V','D') ");
        }
    }

    query.close();
}

mensagem = "<br> <h3 style=\"backgro'und-color:#f8fa79;\">Atenção</h3> <p><b>ILUSTRISSIMO USUARIO</b> ESSE PROCESSO É EXTREMAMENTE PERIGOSO E <b>JA FOI EXECUTADO</b>, SÓ EXECUTE SE TIVER CERTEZA !</p><br>";