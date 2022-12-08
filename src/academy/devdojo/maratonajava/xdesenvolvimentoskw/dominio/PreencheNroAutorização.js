var query = getQuery();

for(var i = 0; i < linhas.length; i++){
    var linha = linhas[i];

    query.setParam("NUFIN", linha.getCampo("NUFIN"));
    query.setParam("LBONRAUTORIZA", getParam("LBONRAUTORIZA"));

    query.nativeSelect("SELECT * FROM TGFFIN WHERE NUFIN = {NUFIN}");

    while(query.next()){
            query.update(" UPDATE TGFFIN SET LBONRAUTORIZA = {LBONRAUTORIZA} WHERE NUFIN = {NUFIN} ");
    }
    query.close();
}

mensagem = "<b><br>  REGISTRO(s) PREENCHIDOS(s) !  <br><br>"  ;
