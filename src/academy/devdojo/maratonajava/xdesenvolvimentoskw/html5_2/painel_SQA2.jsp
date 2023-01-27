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

    <snk:load />
    <!--  -->

    <script>
        /* Exportamos o metodo injetado do sankhya para um contexto global onde poderemos utilizar em outros arquivos Javascript */
        var abrirNivel = openLevel;
        /*  */
    </script>

    <!-- Injecao do arquivo JS que contera a implementacao adicional com o carregamento do arquivo apos a renderizacao da pagina -->
    <script defer src="${BASE_FOLDER}/script.js"></script>
    <!--  -->
    
</head>
<body>
<button class="left" onclick="abrirNivelImplementadoExternamente ('lvl_aueapxm')">Visão por Grupo</button>

</body>
</html>