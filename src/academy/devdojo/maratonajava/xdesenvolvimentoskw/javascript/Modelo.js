mensagem = "";

//Incluir na tabela de revisão a próxima revisão.

function acessorio() {

//Objeto acessorio

    this.NUPRD = 0;

    this.CODEMP = 0;

    this.CODPROD = 0;

    this.CONTROLE = "";

    this.VARIACAO = 0;

    this.QTD = 0;

}

function pintura() {

//Objeto acessorio

    this.NUPRD = 0;

    this.CODEMP = 0;

    this.CODPROD = 0;

    this.NUPRDPIN = 0;

    this.CONTROLE = "";

    this.CODASC = 0;

    this.QTD = 0;

}

function mprima() {

//Objeto materia prima

    this.NUPRD = 0;

    this.CODEMP = 0;

    this.SEQUENCIA = 0;

    this.SEQORIG = 0;

    this.CODPROD = 0;

    this.CONTROLE = "";

    this.QTD = 0;

    this.CODLOCAL = 0;

    this.CODETAPA = 0;

    this.NUPRDPIN = 0;

    this.CODVOL = "";

}

function plncorte() {

//Objeto plano de corte

    this.NUPRD = 0;

    this.CODEMP = 0;

    this.NUPARTE = 0;

    this.NUETAPA = 0;

    this.ORIENT = "";

    this.CODPROD = 0;

}

for (var i = 0; i < linhas.length; i++) {

    var linha = linhas[i];

//Setando o numero da proxima revisao

    var query = getQuery();

    var nuprd = linha.getCampo("NUPRD");

    var empresa = linha.getCampo("CODEMP");

    query.setParam("NUPRD", nuprd);

    query.setParam("CODEMP", empresa);

    query.nativeSelect("Select max(REV) REV from AD_prdrev where NUPRD = {NUPRD} and CODEMP={CODEMP}");

    var revisao = 0;

    if (query.next()) {

        revisao = query.getInt("REV");

        revisao++;

    }

    var reg = novaLinha("AD_PRDREV");

    reg.setCampo("NUPRD", nuprd);

    reg.setCampo("CODEMP", empresa);

    reg.setCampo("REV", revisao);

    reg.save();

//Fim Setando o numero da proxima revisao

//revisao do cabecalho

    var reg = novaLinha("AD_PRDCABREV");

    reg.setCampo("NUPRD", linha.getCampo("NUPRD"));

    reg.setCampo("CODEMP", linha.getCampo("CODEMP"));

    reg.setCampo("NUNOTA", linha.getCampo("NUNOTA"));

    reg.setCampo("SEQUENCIA", linha.getCampo("SEQUENCIA"));

    reg.setCampo("REV", revisao);

    reg.save();

//Não funciona com o metodo deletar.

//Fim revisao do cabecalho

//revisao dos Acessórios

//Buscando estado atual.

    query.setParam("NUPRD", nuprd);

    query.setParam("CODEMP", empresa);

    query.nativeSelect("select NUPRD,CODEMP,CODPROD,CONTROLE,VARIACAO,QTD from AD_prdasc where nuprd={NUPRD} AND CODEMP = {CODEMP}");

    var acessorios = new Array();

    while (query.next()) {

        var a = new acessorio();

        a.NUPRD = query.getInt("NUPRD");

        a.CODEMP = query.getInt("CODEMP");

        a.CODPROD = query.getInt("CODPROD");

        a.CONTROLE = query.getString("CONTROLE");

        a.VARIACAO = query.getInt("VARIACAO");

        a.QTD = query.getInt("QTD");

        acessorios.push(a);

    }

    for (var j = 0; j < acessorios.length; j++) {

        var asce = acessorios[j];

        var reg = novaLinha("AD_PRDASCREV");

        reg.setCampo("NUPRD", asce.NUPRD);

        reg.setCampo("CODEMP", asce.CODEMP);

        reg.setCampo("CODPROD", asce.CODPROD);

        reg.setCampo("CONTROLE", asce.CONTROLE + "");

        reg.setCampo("VARIACAO", asce.VARIACAO);

        reg.setCampo("QTD", asce.QTD);

        reg.setCampo("REV", revisao);

        reg.save();

    }

//Checando revisao dos Pintura

    query.setParam("NUPRD", nuprd);

    query.setParam("CODEMP", empresa);

    query.nativeSelect("select NUPRD,CODEMP,NUPRDPIN,CODPROD,CONTROLE,CODASC,QTD from AD_PRDPIN where nuprd={NUPRD} AND CODEMP = {CODEMP}");

    var pinturas = new Array();

    while (query.next()) {

        var a = new pintura();

        a.NUPRD = query.getInt("NUPRD");

        a.CODEMP = query.getInt("CODEMP");

        a.NUPRDPIN = query.getInt("NUPRDPIN");

        a.CODPROD = query.getInt("CODPROD");

        a.CONTROLE = query.getInt("CONTROLE");

        a.CODASC = query.getInt("CODASC");

        a.QTD = query.getInt("QTD");

        pinturas.push(a);

    }

    for (var j = 0; j < pinturas.length; j++) {

        var pin = pinturas[j];

        var reg = novaLinha("AD_PRDPINREV");

        reg.setCampo("NUPRD", pin.NUPRD);

        reg.setCampo("CODEMP", pin.CODEMP);

        reg.setCampo("NUPRDPIN", pin.NUPRDPIN);

        reg.setCampo("CODPROD", pin.CODPROD);

        reg.setCampo("CONTROLE", pin.CONTROLE + "");

        reg.setCampo("CODASC", pin.CODASC);

        reg.setCampo("QTD", pin.QTD);

        reg.setCampo("REV", revisao);

        reg.save();

    }

//Fim Checando pintura

//Checando revisao dos Materia Prima

    query.setParam("NUPRD", nuprd);

    query.setParam("CODEMP", empresa);

    query.nativeSelect("select NUPRD,CODEMP,SEQUENCIA,SEQORIG,CODPROD,CONTROLE,CODLOCAL,QTD,CODETAPA,NUPRDPIN,CODVOL from AD_PRDMP where nuprd={NUPRD} AND CODEMP = {CODEMP}");

    var mps = new Array();

    while (query.next()) {

        var a = new mprima();

        a.NUPRD = query.getInt("NUPRD");

        a.CODEMP = query.getInt("CODEMP");

        a.SEQUENCIA = query.getInt("SEQUENCIA");

        a.SEQORIG = query.getInt("SEQORIG");

        a.CODPROD = query.getInt("CODPROD");

        a.CONTROLE = query.getString("CONTROLE");

        a.CODLOCAL = query.getInt("CODLOCAL");

        a.CODETAPA = query.getInt("CODETAPA");

        a.NUPRDPIN = query.getInt("NUPRDPIN");

        a.CODVOL = query.getString("CODVOL");

        a.QTD = query.getInt("QTD");

        mps.push(a);

    }

    for (var j = 0; j < mps.length; j++) {

        var mp = mps[j];

        var reg = novaLinha("AD_PRDMPREV");

        reg.setCampo("NUPRD", mp.NUPRD);

        reg.setCampo("CODEMP", mp.CODEMP);

        reg.setCampo("SEQUENCIA", mp.SEQUENCIA);

        reg.setCampo("SEQORIG", mp.SEQORIG);

        reg.setCampo("CODPROD", mp.CODPROD);

        reg.setCampo("CONTROLE", mp.CONTROLE + "");

        reg.setCampo("CODLOCAL", mp.CODLOCAL);

        reg.setCampo("NUPRDPIN", mp.NUPRDPIN);

        reg.setCampo("CODVOL", mp.CODVOL);

        reg.setCampo("QTD", mp.QTD);

        reg.setCampo("REV", revisao);

        reg.save();

    }

//Fim revisao dos Materia Prima

//revisao dos Plano de Corte

//Buscando estado atual.

    query.setParam("NUPRD", nuprd);

    query.setParam("CODEMP", empresa);

    query.nativeSelect("select NUPRD,CODEMP,NUPARTE,NUETAPA,ORIENT,CODPROD from AD_prdpln where nuprd={NUPRD} AND CODEMP = {CODEMP}");

    var plns = new Array();

    while (query.next()) {

        var a = new plncorte();

        a.NUPRD = query.getInt("NUPRD");

        a.CODEMP = query.getInt("CODEMP");

        a.NUPARTE = query.getInt("NUPARTE");

        a.NUETAPA = query.getInt("NUETAPA");

        a.ORIENT = query.getString("ORIENT");

        a.CODPROD = query.getInt("CODPROD");

        plns.push(a);

    }

    for (var j = 0; j < plns.length; j++) {

        var pln = plns[j];

        var reg = novaLinha("AD_PRDPLNREV");

        reg.setCampo("NUPRD", pln.NUPRD);

        reg.setCampo("CODEMP", pln.CODEMP);

        reg.setCampo("NUPARTE", pln.NUPARTE);

        reg.setCampo("NUETAPA", pln.NUETAPA);

        reg.setCampo("ORIENT", pln.ORIENT);

        reg.setCampo("CODPROD", pln.CODPROD);

        reg.setCampo("REV", revisao);

        reg.save();

    }

//Fim revisao dos Plano de Corte

    mensagem = mensagem + "Revisão " + revisao + " do plano de Corte " + nuprd + " da empresa " + empresa + " gerado com sucesso\n";

}