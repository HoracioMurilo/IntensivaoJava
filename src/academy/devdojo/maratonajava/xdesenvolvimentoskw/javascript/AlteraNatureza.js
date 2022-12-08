var query = getQuery();

for(var i = 0; i < linhas.length; i++){
    var linha = linhas[i];

    query.setParam("NUFIN", linha.getCampo("NUFIN"));
    query.setParam("NUNOTA", linha.getCampo("NUNOTA"));
    query.setParam("CODNAT", getParam("CODNAT"));

    query.nativeSelect("SELECT * FROM TGFFIN WHERE NUFIN = {NUFIN}");

    while(query.next()){

        var origemLct = query.getString("ORIGEM");
        var cteFinanceiro = query.getInt("CODTIPOPER");

        if(origemLct == 'E' && cteFinanceiro != 1301){
            query.update("ALTER TRIGGER SANKHYA.TRG_UPT_TGFFIN DISABLE ");
            query.update("ALTER TRIGGER SANKHYA.TRG_INC_UPD_TGFRAT DISABLE ");
            query.update("UPDATE TGFCAB SET CODNAT = {CODNAT} WHERE NUNOTA = {NUNOTA} ");
            query.update("UPDATE TGFFIN SET CODNAT = {CODNAT} WHERE NUFIN = {NUFIN} ");
            query.update("UPDATE TGFRAT SET CODNAT = {CODNAT} WHERE NUFIN = {NUFIN} ");

        } else if (origemLct == 'E' && cteFinanceiro == 1301) {
            query.update("ALTER TRIGGER SANKHYA.TRG_UPT_TGFFIN DISABLE ");
            query.update("ALTER TRIGGER SANKHYA.TRG_INC_UPD_TGFRAT DISABLE ");
            query.update("UPDATE TGFFIN SET CODNAT = {CODNAT} WHERE NUFIN = {NUFIN} ");
            query.update("UPDATE TGFRAT SET CODNAT = {CODNAT} WHERE NUFIN = {NUFIN} ");

        } else if (origemLct == 'F') {
            query.update("ALTER TRIGGER SANKHYA.TRG_UPT_TGFFIN DISABLE ");
            query.update("ALTER TRIGGER SANKHYA.TRG_INC_UPD_TGFRAT DISABLE ");
            query.update("UPDATE TGFFIN SET CODNAT = {CODNAT} WHERE NUFIN = {NUFIN} ");
            query.update("UPDATE TGFRAT SET CODNAT = {CODNAT} WHERE NUFIN = {NUFIN} ");

        }

        query.update("ALTER TRIGGER SANKHYA.TRG_UPT_TGFFIN ENABLE ");
        query.update("ALTER TRIGGER SANKHYA.TRG_INC_UPD_TGFRAT ENABLE ");

    }
    query.close();
}

mensagem = "<b><br>  NATUREZA DOS REGISTRO(s) ATUALIZADA(s) !  <br><br>"  ;