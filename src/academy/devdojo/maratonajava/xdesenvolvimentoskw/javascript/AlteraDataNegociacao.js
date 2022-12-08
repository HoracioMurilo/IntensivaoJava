var query = getQuery();

for(var i = 0; i < linhas.length; i++){
    var linha = linhas[i];

    query.setParam("NUFIN", linha.getCampo("NUFIN"));
    query.setParam("DATANEGOCIACAO", getParam("DATANEGOCIACAO"));

    query.nativeSelect("SELECT * FROM TGFFIN WHERE NUFIN = {NUFIN}");

    while(query.next()){

        var origemLct = query.getString("ORIGEM");

        if(origemLct == 'E'){
            mensagem = "<b><br>  Lançamento Origem Estoque não pode Ser Alterado  <br><br>"  ;

        } else if (origemLct == 'F') {
            query.update("ALTER TRIGGER SANKHYA.TRG_UPT_TGFFIN DISABLE ");
            query.update("ALTER TRIGGER SANKHYA.TRG_INC_UPD_TGFRAT DISABLE ");
            query.update(" UPDATE TGFFIN SET DTNEG = {DATANEGOCIACAO} WHERE NUFIN = {NUFIN} AND ORIGEM ='F' ");

        }

        query.update("ALTER TRIGGER SANKHYA.TRG_UPT_TGFFIN ENABLE ");
        query.update("ALTER TRIGGER SANKHYA.TRG_INC_UPD_TGFRAT ENABLE ");

    }
    query.close();
}

mensagem = "<b><br>  CENTRO DE RESULTADO DOS REGISTRO(s) ATUALIZADA(s) !  <br><br>"  ;