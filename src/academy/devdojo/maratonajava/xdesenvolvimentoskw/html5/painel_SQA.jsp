<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>

<html>

<head>
    <meta charset="UTF-8">
    <title>HTML5 Component</title>
    <link rel="stylesheet" type="text/css" href="${BASE_FOLDER}/css/relcomercial.css">
    <snk:load/>

    <script type='text/javascript'>
        function dfcGerencial(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.52.1', params);

        }
    </script>

    <script type='text/javascript'>
        function dreGerencial(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.53.1', params);
        }
    </script>

    <script type='text/javascript'>
        function analiseDevolucoes(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.56.1', params);
        }
    </script>

    <script type='text/javascript'>
        function metaDistribuicao(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.54.1', params);
        }
    </script>

    <script type='text/javascript'>
        function analiseDespesas(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.57.1', params);
        }
    </script>

    <script type='text/javascript'>
        function auditoriaPosicaoAdiantamento(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.169.1', params);
        }
    </script>

    <script type='text/javascript'>
        function auditoriaMovimento(codparc) {
            var params = {
                CODPARC: parseInt('&{CODPARC}')
            };
            openApp('br.com.sankhya.menu.adicional.nuDsb.167.1', params);
        }
    </script>

</head>

<body>
<img class="cabtdtamanho1" style="width: 20%;"
     src="http://focomagazine.com.br/uploads/imagem_arquivo/273969_alvorada2.jpg">
<h1><span>RELATÓRIOS GERENCIAIS</span></h1>
<!-- Título -->
<table style="height: 400px;">
    <tr>
        <td class="subtdtipo"> FINANCEIRO <br><br>
        </td>
        <td class="subtdtipo"> COMERCIAIS <br><br>
        </td>
        <td class="subtdtipo"> CONTABEIS <br><br>
        </td>
        <td class="subtdtipo"> ANALISE 4 <br><br>
        </td>
        <td class="subtdtipo"> ANALISE 5 <br><br>
        </td>
    </tr>

    <!-- linha 1 Cliente  -->
    <tr>
        <td class="listatdtipo"><a href="javascript:dfcGerencial(88)"> <span style="color:black">
            DFC - Gerencial </span></a>
        <td class="listatdtipo"><a href="javascript:metaDistribuicao(88)"> <span style="color:black"> Meta de Venda Dist. </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards2 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards3 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards4 </span></a>
    </tr>

    <!-- linha 2 -->

    <tr>
        <td class="listatdtipo"><a href="javascript:dreGerencial(88)"> <span style="color:black">
            DRE - Gerencial </span></a>
        <td class="listatdtipo"><a href="javascript:auditoriaPosicaoFornecedor(88)"> <span style="color:black"> Dashboards1 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards2 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards3 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards4 </span></a>
    </tr>

    <!-- linha 3  -->
    <tr>
        <td class="listatdtipo"><a href="javascript:analiseDevolucoes(88)">
          <span style="color:black">
            Analise das Devoluções </span></a>
        <td class="listatdtipo"><a href="javascript:auditoriaPosicaoAdiantamento(88)"> <span style="color:black"> Dashboards1 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards2 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards3 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards4 </span></a>
    </tr>

    <!-- linha 4  -->
    <tr>
        <td class="listatdtipo"><a href="javascript:analiseDespesas(88)"> <span style="color:black">
            Analise das Despesas Op. </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span style="color:black"> Em Desenvolvimento </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards2 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards3 </span></a>
        <td class="listatdtipo"><a href="javascript:bcclienteprincipal(88)"> <span
                style="color:black"> Dashboards4 </span></a>
    </tr>

</table>

<br>

<br>
</body>

<footer>
    <span class="listatdtipo">Legenda </span> <br>
    <span class="listatdtipolegenda" style="color:red"> Em Desenvolvimento sem acesso </span> <br>
    <span class="listatdtipolegenda" style="color:green"> Validar </span> <br>
    <span class="listatdtipolegenda" style="color:black"> Liberado e validado </span> <br>
    <img class="cabtdtamanho" img style=float:right src="https://sqabrasil.com/wp-content/uploads/2022/04/logo-sqa.svg">
</footer>

</html>