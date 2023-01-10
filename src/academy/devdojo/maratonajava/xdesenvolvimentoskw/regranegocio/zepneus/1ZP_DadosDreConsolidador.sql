SELECT CAB.DTNEG          AS DTREF
     , CAB.NUNOTA
     , CAB.NUMNOTA
     , CAB.CODPARC
     , PAR.RAZAOSOCIAL
     , CAB.DTNEG
     , CAB.CODEMP
     , CAB.CODTIPOPER
     , TTP.DESCROPER
     , CAB.CODCENCUS
     , CUS.DESCRCENCUS
     , CUSPAI.CODCENCUS   AS CODCENCUSPAI
     , CUSPAI.DESCRCENCUS AS DESCRCENCUSPAI
     , CUSAVO.CODCENCUS   AS CODCENCUSAVO
     , CUSAVO.DESCRCENCUS AS DESCRCENCUSAVO
     , CAB.CODNAT
     , NAT.DESCRNAT
     , PAI.CODNAT         AS CODNATPAI
     , PAI.DESCRNAT       AS DESCRNATPAI
     , AVO.CODNAT         AS CODNATAVO
     , AVO.DESCRNAT       AS DESCRNATAVO
     , CASE
           WHEN CAB.TIPMOV = 'V' THEN SUM(ITE.VLRTOT)
           WHEN CAB.TIPMOV = 'D' THEN SUM(ITE.VLRTOT) * -1
           WHEN CAB.TIPMOV = 'C' THEN SUM(ITE.VLRTOT) * -1
           WHEN CAB.TIPMOV = 'E' THEN SUM(ITE.VLRTOT)
    END                   AS VALOR
     , 'ESTOQUE'          AS ORIGEM
     , CLAS.ORDEM                               -- PARA ORDERNAR
     , CLAS.CLASSIFICADOR AS NOME_CLASSIFICADOR -- PARA NOMEAR


FROM TGFCAB CAB
         INNER JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
         INNER JOIN TGFNAT NAT ON NAT.CODNAT = CAB.CODNAT
         INNER JOIN TGFNAT PAI ON PAI.CODNAT = NAT.CODNATPAI
         INNER JOIN TGFNAT AVO ON AVO.CODNAT = PAI.CODNATPAI
         LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = CAB.CODCENCUS
         LEFT JOIN TSICUS CUSPAI ON CUSPAI.CODCENCUS = CUS.CODCENCUSPAI
         LEFT JOIN TSICUS CUSAVO ON CUSAVO.CODCENCUS = CUSPAI.CODCENCUSPAI
         INNER JOIN TGFITE ITE ON ITE.NUNOTA = CAB.NUNOTA
         INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = CAB.CODTIPOPER AND TTP.DHALTER = CAB.DHTIPOPER
         INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT

WHERE SUBSTRING(CONVERT(VARCHAR(10), NAT.CODNAT), 1, 4) IN
      (1001, 1002, 1003, 1102, 1201, 1202, 1203, 1205, 1206, 1207, 1208, 1209, 1210, 1211)
  AND CAB.STATUSNOTA = 'L'
  AND CAB.TIPMOV IN ('V', 'D', 'E', 'C')
  AND CAB.DTNEG BETWEEN :PERIODO.INI AND :PERIODO.FIN


GROUP BY CAB.NUNOTA
       , CAB.NUMNOTA
       , CAB.CODPARC
       , PAR.RAZAOSOCIAL
       , CAB.DTNEG
       , CAB.CODEMP
       , CAB.CODTIPOPER
       , TTP.DESCROPER
       , CAB.CODCENCUS
       , CUS.DESCRCENCUS
       , CUSPAI.CODCENCUS
       , CUSPAI.DESCRCENCUS
       , CUSAVO.CODCENCUS
       , CUSAVO.DESCRCENCUS
       , CAB.CODNAT
       , NAT.DESCRNAT
       , PAI.CODNAT
       , PAI.DESCRNAT
       , AVO.CODNAT
       , AVO.DESCRNAT
       , TTP.GOLDEV
       , CLAS.ORDEM
       , CLAS.CLASSIFICADOR
       , CAB.TIPMOV

HAVING SUM(ITE.VLRTOT) > 0

UNION ALL

SELECT CAB.DTNEG                                                                               AS DTREF
     , CAB.NUNOTA
     , CAB.NUMNOTA
     , CAB.CODPARC
     , PAR.RAZAOSOCIAL
     , CAB.DTNEG
     , CAB.CODEMP
     , CAB.CODTIPOPER
     , TTP.DESCROPER
     , CAB.CODCENCUS
     , CUS.DESCRCENCUS
     , CUSPAI.CODCENCUS                                                                        AS CODCENCUSPAI
     , CUSPAI.DESCRCENCUS                                                                      AS DESCRCENCUSPAI
     , CUSAVO.CODCENCUS                                                                        AS CODCENCUSAVO
     , CUSAVO.DESCRCENCUS                                                                      AS DESCRCENCUSAVO
     , 30000000                                                                                AS CODNAT
     , 'CMV '                                                                                  AS DESCRNAT
     , 30000000                                                                                AS CODNATPAI
     , PAI.DESCRNAT AS DESCRNATPAI
     , AVO.CODNAT                                                                              AS CODNATAVO
     , AVO.DESCRNAT                                                                            AS DESCRNATAVO
     , (((SELECT MAX(CUS.CUSMEDICM)
          FROM TGFCUS CUS
          WHERE CUS.CODPROD = ITE.CODPROD
            AND CUS.CODEMP = CAB.CODEMP
            AND CUS.DTATUAL = (SELECT MAX(CN.DTATUAL)
                               FROM TGFCUS CN
                               WHERE CN.CODPROD = CUS.CODPROD
                                 AND CN.DTATUAL <= CAB.DTNEG
                                 AND CN.CODEMP = CUS.CODEMP)) * ITE.QTDNEG) * TTP.GOLDEV) * -1 AS VALOR
     , 'CUSTO'                                                                                 AS ORIGEM
     , 3                                                                                       AS ORDEM              -- PARA ORDERNAR
     , CLAS.CLASSIFICADOR                                                                      AS NOME_CLASSIFICADOR -- PARA NOMEAR


FROM TGFCAB CAB
         INNER JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
         INNER JOIN TGFNAT NAT ON NAT.CODNAT = CAB.CODNAT
         INNER JOIN TGFNAT PAI ON PAI.CODNAT = NAT.CODNATPAI
         INNER JOIN TGFNAT AVO ON AVO.CODNAT = PAI.CODNATPAI
         LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = CAB.CODCENCUS
         LEFT JOIN TSICUS CUSPAI ON CUSPAI.CODCENCUS = CUS.CODCENCUSPAI
         LEFT JOIN TSICUS CUSAVO ON CUSAVO.CODCENCUS = CUSPAI.CODCENCUSPAI
         INNER JOIN TGFITE ITE ON ITE.NUNOTA = CAB.NUNOTA
         INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = CAB.CODTIPOPER AND TTP.DHALTER = CAB.DHTIPOPER
         INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT

WHERE TTP.GOLSINAL = -1
  AND CAB.STATUSNOTA = 'L'
  AND CAB.DTNEG BETWEEN :PERIODO.INI AND :PERIODO.FIN

GROUP BY CAB.NUNOTA
       , CAB.NUMNOTA
       , CAB.CODPARC
       , PAR.RAZAOSOCIAL
       , CAB.DTNEG
       , CAB.CODEMP
       , CAB.CODTIPOPER
       , TTP.DESCROPER
       , CAB.CODCENCUS
       , CUS.DESCRCENCUS
       , CUSPAI.CODCENCUS
       , CUSPAI.DESCRCENCUS
       , CUSAVO.CODCENCUS
       , CUSAVO.DESCRCENCUS
       , CAB.CODNAT
       , NAT.DESCRNAT
       , PAI.CODNAT
       , PAI.DESCRNAT
       , AVO.CODNAT
       , AVO.DESCRNAT
       , ITE.CODPROD
       , ITE.QTDNEG
       , TTP.GOLDEV
       , CLAS.CLASSIFICADOR

UNION ALL

SELECT CAB.DTNEG                  AS DTREF
     , CAB.NUNOTA
     , CAB.NUMNOTA
     , CAB.CODPARC
     , PAR.RAZAOSOCIAL
     , CAB.DTNEG
     , CAB.CODEMP
     , CAB.CODTIPOPER
     , TTP.DESCROPER
     , CAB.CODCENCUS
     , CUS.DESCRCENCUS
     , CUSPAI.CODCENCUS           AS CODCENCUSPAI
     , CUSPAI.DESCRCENCUS         AS DESCRCENCUSPAI
     , CUSAVO.CODCENCUS           AS CODCENCUSAVO
     , CUSAVO.DESCRCENCUS         AS DESCRCENCUSAVO
     , 40000000                   AS CODNAT
     , 'IMPOSTOS SOBRE VENDAS'    AS DESCRNAT
     , 40000000                   AS CODNATPAI
     , PAI.DESCRNAT               AS DESCRNATPAI
     , AVO.CODNAT                 AS CODNATAVO
     , AVO.DESCRNAT               AS DESCRNATAVO
     , SUM(VALOR) * -1            AS VALOR
     , 'IMPOSTOS'                 AS ORIGEM
     , 2                          AS ORDEM
     , (SELECT OPCAO
        FROM TDDOPC
        WHERE NUCAMPO = (SELECT NUCAMPO FROM TDDCAM WHERE NOMETAB = 'TGFDIN' AND NOMECAMPO = 'CODIMP')
          AND VALOR = DIN.CODIMP) AS NOME_CLASSIFICADOR


FROM TGFCAB CAB
         INNER JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
         INNER JOIN TGFNAT NAT ON NAT.CODNAT = CAB.CODNAT
         INNER JOIN TGFNAT PAI ON PAI.CODNAT = NAT.CODNATPAI
         INNER JOIN TGFNAT AVO ON AVO.CODNAT = PAI.CODNATPAI
         LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = CAB.CODCENCUS
         LEFT JOIN TSICUS CUSPAI ON CUSPAI.CODCENCUS = CUS.CODCENCUSPAI
         LEFT JOIN TSICUS CUSAVO ON CUSAVO.CODCENCUS = CUSPAI.CODCENCUSPAI
         INNER JOIN TGFITE ITE ON ITE.NUNOTA = CAB.NUNOTA
         INNER JOIN TGFDIN DIN ON DIN.NUNOTA = ITE.NUNOTA AND DIN.SEQUENCIA = ITE.SEQUENCIA
         INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = CAB.CODTIPOPER AND TTP.DHALTER = CAB.DHTIPOPER
         INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT

WHERE TTP.GOLSINAL = -1
  AND TTP.GOLDEV = 1
  AND CAB.STATUSNOTA = 'L'
  AND CAB.TIPMOV IN ('V', 'D', 'E', 'C')
  AND CAB.DTNEG BETWEEN :PERIODO.INI AND :PERIODO.FIN
  AND DIN.CODIMP IN (1,4,6,7)


GROUP BY CAB.NUNOTA
       , CAB.NUMNOTA
       , CAB.CODPARC
       , PAR.RAZAOSOCIAL
       , CAB.DTNEG
       , CAB.CODEMP
       , CAB.CODTIPOPER
       , TTP.DESCROPER
       , CAB.CODCENCUS
       , CUS.DESCRCENCUS
       , CUSPAI.CODCENCUS
       , CUSPAI.DESCRCENCUS
       , CUSAVO.CODCENCUS
       , CUSAVO.DESCRCENCUS
       , CAB.CODNAT
       , NAT.DESCRNAT
       , PAI.CODNAT
       , PAI.DESCRNAT
       , AVO.CODNAT
       , AVO.DESCRNAT
       , DIN.CODIMP

HAVING SUM(VALOR) > 0

UNION ALL

SELECT FIN.DTNEG                        AS DTREF
     , FIN.NUFIN
     , FIN.NUMNOTA
     , FIN.CODPARC
     , PAR.RAZAOSOCIAL
     , FIN.DTNEG
     , FIN.CODEMP
     , FIN.CODTIPOPER
     , TTP.DESCROPER
     , FIN.CODCENCUS
     , CUS.DESCRCENCUS
     , CUSPAI.CODCENCUS                 AS CODCENCUSPAI
     , CUSPAI.DESCRCENCUS               AS DESCRCENCUSPAI
     , CUSAVO.CODCENCUS                 AS CODCENCUSAVO
     , CUSAVO.DESCRCENCUS               AS DESCRCENCUSAVO
     , FIN.CODNAT
     , NAT.DESCRNAT
     , PAI.CODNAT                       AS CODNATPAI
     , PAI.DESCRNAT                     AS DESCRNATPAI
     , AVO.CODNAT                       AS CODNATAVO
     , AVO.DESCRNAT                     AS DESCRNATAVO
     , SUM(FIN.VLRDESDOB) * FIN.RECDESP AS VALOR
     , 'FINANCEIRO'                     AS ORIGEM
     , CLAS.ORDEM                                             -- PARA ORDERNAR
     , CLAS.CLASSIFICADOR               AS NOME_CLASSIFICADOR -- PARA NOMEAR


FROM TGFFIN FIN
         INNER JOIN TGFPAR PAR ON PAR.CODPARC = FIN.CODPARC
         INNER JOIN TGFNAT NAT ON NAT.CODNAT = FIN.CODNAT
         INNER JOIN TGFNAT PAI ON PAI.CODNAT = NAT.CODNATPAI
         INNER JOIN TGFNAT AVO ON AVO.CODNAT = PAI.CODNATPAI
         LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = FIN.CODCENCUS
         LEFT JOIN TSICUS CUSPAI ON CUSPAI.CODCENCUS = CUS.CODCENCUSPAI
         LEFT JOIN TSICUS CUSAVO ON CUSAVO.CODCENCUS = CUSPAI.CODCENCUSPAI
         INNER JOIN TGFITE ITE ON ITE.NUNOTA = FIN.NUNOTA
         INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = FIN.CODTIPOPER AND TTP.DHALTER = FIN.DHTIPOPER
         INNER JOIN AD_SQADRE CLAS ON CLAS.CODNAT = NAT.CODNAT

WHERE SUBSTRING(CONVERT(VARCHAR(10), NAT.CODNAT), 1, 4) IN
      (1001, 1002, 1003, 1102, 1201, 1202, 1203, 1205, 1206, 1207, 1208, 1209, 1210, 1211)
  AND FIN.ORIGEM IN ('F', 'P')
  AND FIN.DTNEG BETWEEN :PERIODO.INI AND :PERIODO.FIN

GROUP BY FIN.NUFIN
       , FIN.NUMNOTA
       , FIN.CODPARC
       , PAR.RAZAOSOCIAL
       , FIN.DTNEG
       , FIN.CODEMP
       , FIN.CODTIPOPER
       , TTP.DESCROPER
       , FIN.CODCENCUS
       , CUS.DESCRCENCUS
       , CUSPAI.CODCENCUS
       , CUSPAI.DESCRCENCUS
       , CUSAVO.CODCENCUS
       , CUSAVO.DESCRCENCUS
       , FIN.CODNAT
       , NAT.DESCRNAT
       , PAI.CODNAT
       , PAI.DESCRNAT
       , AVO.CODNAT
       , AVO.DESCRNAT
       , CLAS.ORDEM
       , CLAS.CLASSIFICADOR
       , FIN.RECDESP

HAVING SUM(FIN.VLRDESDOB) > 0