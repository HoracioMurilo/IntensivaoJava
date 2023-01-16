ALTER VIEW SQA_DRE_GERENCIAL AS
    SELECT
        A.DTREF
         , A.MES
         , A.ANO
         , A.CODEMP
         , A.CODCENCUS
         , A.DESCRCENCUS
         , A.CODNAT
         , A.DESCRNAT
         , SUM(A.VALOR) AS VALOR
         , A.ORIGEM
         , A.ORDEM
         , A.NOME_CLASSIFICADOR

    FROM
        ( SELECT
              CAB.DTNEG AS DTREF
               , MONTH(CAB.DTNEG) AS MES
               , YEAR(CAB.DTNEG) AS ANO
               , CAB.CODEMP
               , CAB.CODCENCUS
               , CUS.DESCRCENCUS
               , CAB.CODNAT
               , NAT.DESCRNAT
               , CASE
                     WHEN CAB.TIPMOV = 'V' THEN (CAB.VLRNOTA)
                     WHEN CAB.TIPMOV = 'D' THEN ((CAB.VLRNOTA) - (SELECT SUM(VALOR) FROM TGFITE ITE INNER JOIN TGFDIN DIN ON DIN.NUNOTA = ITE.NUNOTA AND ITE.SEQUENCIA = DIN.SEQUENCIA WHERE ITE.NUNOTA = CAB.NUNOTA AND DIN.CODIMP IN (1,4,6,7))) * -1
                     WHEN CAB.TIPMOV = 'C' THEN ((CAB.VLRNOTA) - (SELECT SUM(VALOR) FROM TGFITE ITE INNER JOIN TGFDIN DIN ON DIN.NUNOTA = ITE.NUNOTA AND ITE.SEQUENCIA = DIN.SEQUENCIA WHERE ITE.NUNOTA = CAB.NUNOTA AND DIN.CODIMP IN (1,4,6,7))) * -1
                     WHEN CAB.TIPMOV = 'E' THEN (CAB.VLRNOTA)
                END AS VALOR
               , 'ESTOQUE' AS ORIGEM
               , CLAS.ORDEM
               , CLAS.CLASSIFICADOR AS NOME_CLASSIFICADOR

          FROM TGFCAB CAB

                   LEFT JOIN TGFNAT NAT ON NAT.CODNAT = CAB.CODNAT
                   LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = CAB.CODCENCUS
                   INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT

          WHERE
                  SUBSTRING(CONVERT(VARCHAR (10),NAT.CODNAT),1,4) IN (1001,1002,1003,1102,1201,1202,1203,1205,1206,1207,1208,1209,1210,1211)
            AND CAB.STATUSNOTA = 'L'
            AND CAB.TIPMOV IN ('V','D','E','C')
            AND CAB.DTNEG BETWEEN '01/01/2022' AND '31/12/2022'
            AND CAB.CODEMP = 408

          UNION ALL

          SELECT
              Z.DTNEG AS DTREF
               , MONTH(Z.DTNEG) AS MES
               , YEAR(Z.DTNEG) AS ANO
               , Z.CODEMP
               , Z.CODCENCUS
               , Z.DESCRCENCUS
               , 30000000 AS CODNAT
               , 'CMV ' AS DESCRNAT
               , ROUND(SUM(CASE WHEN Z.TIPMOV = 'V' THEN CUSTOTOTAL * (-1) ELSE CUSTOTOTAL * (1) END), 2) AS VALOR
               ,'CUSTO' AS ORIGEM
               , 3 AS ORDEM
               , Z.CLASSIFICADOR AS NOME_CLASSIFICADOR

          FROM (
                   SELECT
                       CAB.CODEMP
                        , CAB.NUMNOTA
                        , CAB.CODNAT
                        , CAB.CODCENCUS
                        , CUS.DESCRCENCUS
                        , CLAS.CLASSIFICADOR
                        , CAB.DTNEG
                        , CAB.TIPMOV
                        , ISNULL((SELECT SUM(C.CUSSEMICM*I.QTDNEG)
                                  FROM TGFCUS C, TGFITE I
                                  WHERE I.NUNOTA = CAB.NUNOTA
                                    AND C.CODEMP = I.CODEMP
                                    AND C.CODPROD = I.CODPROD
                                    AND C.DTATUAL = (SELECT MAX(DTATUAL)
                                                     FROM TGFCUS
                                                     WHERE CODEMP = C.CODEMP
                                                       AND CODPROD = C.CODPROD AND DTATUAL <= CAB.DTNEG)),0) AS CUSTOTOTAL

                   FROM TGFCAB CAB INNER JOIN TGFTOP TPO (NOLOCK) ON CAB.CODTIPOPER = TPO.CODTIPOPER AND CAB.DHTIPOPER = TPO.DHALTER
                                   LEFT JOIN  TSICUS CUS (NOLOCK) ON CUS.CODCENCUS = CAB.CODCENCUS
                                   INNER JOIN AD_SQADRE CLAS (NOLOCK) ON CLAS.CODNAT = CAB.CODNAT

                   WHERE CAB.STATUSNOTA = 'L'
                     AND TPO.ATUALFIN <> 0
                     AND TPO.CODTIPOPER NOT IN (188, 1003, 403, 852, 365,7010,1015)
                     AND CAB.TIPMOV IN ('V','D')
                     AND CAB.DTNEG BETWEEN '01/01/2022' AND '31/12/2022'
                     AND CAB.CODEMP = 408
               )Z

          GROUP BY

              Z.DTNEG
                 , MONTH(Z.DTNEG)
                 , YEAR(Z.DTNEG)
                 , Z.CODEMP
                 , Z.CODCENCUS
                 , Z.DESCRCENCUS
                 , Z.CLASSIFICADOR

          UNION ALL

          SELECT
              CAB.DTNEG AS DTREF
               , MONTH(CAB.DTNEG) AS MES
               , YEAR(CAB.DTNEG) AS ANO
               , CAB.CODEMP
               , CAB.CODCENCUS
               , CUS.DESCRCENCUS
               , 40000000                   AS CODNAT
               , 'IMPOSTOS SOBRE VENDAS'    AS DESCRNAT
               , VALOR * -1                 AS VALOR
               , 'IMPOSTOS'                 AS ORIGEM
               , 2                          AS ORDEM
               , (SELECT OPCAO FROM TDDOPC WHERE NUCAMPO = (SELECT NUCAMPO FROM TDDCAM WHERE NOMETAB = 'TGFDIN' AND NOMECAMPO = 'CODIMP') AND VALOR = DIN.CODIMP) AS NOME_CLASSIFICADOR
          FROM TGFCAB CAB

                   LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = CAB.CODCENCUS
                   INNER JOIN TGFITE ITE ON ITE.NUNOTA = CAB.NUNOTA
                   INNER JOIN TGFDIN DIN ON DIN.NUNOTA = ITE.NUNOTA AND DIN.SEQUENCIA = ITE.SEQUENCIA
                   INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = CAB.CODTIPOPER AND TTP.DHALTER = CAB.DHTIPOPER

          WHERE
                  TTP.GOLSINAL = -1
            AND TTP.GOLDEV = 1
            AND CAB.STATUSNOTA = 'L'
            AND CAB.TIPMOV IN ('V','D','E','C')
            AND DIN.CODIMP IN (1,4,6,7)
            AND CAB.DTNEG BETWEEN '01/01/2022' AND '31/12/2022'
            AND CAB.CODEMP = 408

          UNION ALL

          SELECT
              FIN.DTNEG AS DTREF
               , MONTH(FIN.DTNEG) AS MES
               , YEAR(FIN.DTNEG) AS ANO
               , FIN.CODEMP
               , FIN.CODCENCUS
               , CUS.DESCRCENCUS
               , FIN.CODNAT
               , NAT.DESCRNAT
               , FIN.VLRDESDOB * FIN.RECDESP AS VALOR
               , 'FINANCEIRO'                AS ORIGEM
               , CLAS.ORDEM
               , CLAS.CLASSIFICADOR          AS NOME_CLASSIFICADOR

          FROM TGFFIN FIN

                   INNER JOIN TGFNAT NAT ON NAT.CODNAT = FIN.CODNAT
                   LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = FIN.CODCENCUS
                   INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT

          WHERE
                  SUBSTRING(CONVERT(VARCHAR (10), NAT.CODNAT), 1, 4) IN (1002, 1003, 1102, 1201, 1202, 1203, 1205, 1206, 1207, 1208, 1209, 1210, 1211)
            AND FIN.ORIGEM IN ('F', 'P')
            AND FIN.DTNEG BETWEEN '01/01/2022' AND '31/12/2022'
            AND FIN.CODEMP = 408

          UNION ALL

          SELECT
              RAT.DTNEG AS DTREF
               , MONTH(RAT.DTNEG) AS MES
               , YEAR(RAT.DTNEG) AS ANO
               , RAT.CODEMP
               , RAT.CODCENCUS
               , CUS.DESCRCENCUS
               , RAT.CODNAT
               , NAT.DESCRNAT
               , CASE WHEN RECDESP = 1 THEN RAT.VLRDESDOB * -1 ELSE RAT.VLRDESDOB * 1 END AS VALOR
               , 'RATEIO'                     AS ORIGEM
               , CLAS.ORDEM
               , CLAS.CLASSIFICADOR           AS NOME_CLASSIFICADOR
          FROM VGFFINRAT RAT
                   INNER JOIN TGFNAT NAT ON NAT.CODNAT = RAT.CODNAT
                   LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = RAT.CODCENCUS
                   INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT
          WHERE
                  CUS.DESCRCENCUS LIKE '%CONTROLADORIA%'
            AND RAT.DTNEG BETWEEN '01/01/2022' AND '31/12/2022'
            AND RAT.CODEMP = 408
        ) A


    GROUP BY
        A.DTREF
           , A.MES
           , A.ANO
           , A.CODEMP
           , A.CODCENCUS
           , A.DESCRCENCUS
           , A.CODNAT
           , A.DESCRNAT
           , A.ORIGEM
           , A.ORDEM
           , A.NOME_CLASSIFICADOR;