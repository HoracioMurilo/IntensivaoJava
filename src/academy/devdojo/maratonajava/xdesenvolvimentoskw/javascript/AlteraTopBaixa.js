var query = getQuery();

for (var i=0; i <linhas.length; i++){
    var linha = linhas[i];

    query.setParam("NUFIN",linha.getCampo("NUFIN"));
    query.setParam("CODTIPOPER",getParam("CODTIPOPER"));

    query.nativeSelect("SELECT  MAX(DHALTER) AS DHALTER FROM TGFTOP WHERE CODTIPOPER = {CODTIPOPER} ");
    while(query.next()){

        var simpleDateFormat = newJava("java.text.SimpleDateFormat");
        simpleDateFormat.applyPattern("dd/MM/yyyy HH:mm:ss");
        var DHTOP = simpleDateFormat.format(query.getDate("DHALTER"));

        query.update("UPDATE TGFFIN SET CODTIPOPERBAIXA = {CODTIPOPER} , DHTIPOPERBAIXA =  TO_DATE('" + DHTOP + "','DD/MM/YYYY HH24:MI:SS') WHERE NUFIN = {NUFIN}");
    }
    query.close();

}

mensagem = "<b><br>  REGISTRO(s) ATUALIZADO(s) !  <br><br>"  ;