WITH DADOS AS (SELECT
                   Z.CODEMP
                    , Z.DTENTSAI
                    , Z.DTNEG
                    , Z.HRENTSAI
                    , Z.NUNOTA
                    , Z.NUMNOTA
                    , Z.CODTIPOPER
                    , Z.DESCROPER
                    , Z.CHAVENFE
                    , Z.CODPROD
                    , Z.DESCRPROD
                    , Z.CODTRIB
                    , Z.CODCFO
                    , Z.SALDO
                    , Z.VLRUNIT
                    , Z.VLRTOT
                    , Z.VLRICMS
                    , Z.VLRSUBST
                    , Z.VLRSUBSTANT
                    , LAG(SALDO) OVER (PARTITION BY Z.CODPROD ORDER BY NVL(Z.HRENTSAI,Z.DTENTSAI)) AS QUANTIDADE_ANTERIOR
                    , SUM(Z.SALDO) OVER (ORDER BY NVL(Z.HRENTSAI,Z.DTENTSAI)) AS ESTOQUE_ACUMULADO


               FROM
                   (SELECT
                        -999999 AS CODEMP
                         , SYSDATE - 45000 AS DTENTSAI
                         , SYSDATE - 45000 AS DTNEG
                         , SYSDATE - 45000 AS HRENTSAI
                         , -999999 AS NUNOTA
                         , -999999 AS NUMNOTA
                         , -999999 AS CODTIPOPER
                         , '' AS DESCROPER
                         , '' AS CHAVENFE
                         , 2296 AS CODPROD
                         , '' AS DESCRPROD
                         , -999999 AS CODTRIB
                         , -999999 AS CODCFO
                         , (SELECT HT_SALDO_INICIAL(11, 2296, '01/01/2022') FROM DUAL) AS SALDO
                         , -999999 AS VLRUNIT
                         , -999999 AS VLRTOT
                         , -999999 AS VLRICMS
                         , -999999 AS VLRSUBST
                         , -999999 AS VLRSUBSTANT

                    FROM DUAL

                    UNION ALL

                    SELECT
                        CAB.CODEMP
                         , CAB.DTENTSAI
                         , CAB.DTNEG
                         , CAB.HRENTSAI
                         , CAB.NUNOTA
                         , CAB.NUMNOTA
                         , CAB.CODTIPOPER
                         , TTP.DESCROPER
                         , CAB.CHAVENFE
                         , ITE.CODPROD
                         , PRO.DESCRPROD
                         , ITE.CODTRIB
                         , ITE.CODCFO
                         , ITE.QTDNEG * ITE.ATUALESTOQUE
                         , ITE.VLRUNIT
                         , ITE.VLRTOT
                         , ITE.VLRICMS
                         , ITE.VLRSUBST
                         , ITE.VLRSUBSTANT
                         --  , (SELECT HT_SALDO_INICIAL(11, 2296, '01/01/2022') FROM DUAL) - SUM(ITE.QTDNEG * ITE.ATUALESTOQUE) OVER (ORDER BY NVL(HRENTSAI,DTENTSAI)) AS ESTOQUE_ACUMULADO




                    FROM TGFCAB CAB
                             INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = CAB.CODTIPOPER AND TTP.DHALTER = CAB.DHTIPOPER
                             INNER JOIN TGFITE ITE ON ITE.NUNOTA = CAB.NUNOTA
                             INNER JOIN TGFPRO PRO ON ITE.CODPROD = PRO.CODPROD

                    WHERE ITE.CODPROD = 2296
                      AND CAB.CODEMP = 11
                      AND CAB.DTENTSAI BETWEEN  '01/01/2022' AND '31/12/2022'
                      AND CAB.TIPMOV IN ('V','D','E','C')
                      AND TTP.ATUALEST IN ('B','E')
                   )Z


               GROUP BY     Z.CODEMP
                      , Z.DTENTSAI
                      , Z.DTNEG
                      , Z.HRENTSAI
                      , Z.NUNOTA
                      , Z.NUMNOTA
                      , Z.CODTIPOPER
                      , Z.DESCROPER
                      , Z.CHAVENFE
                      , Z.CODPROD
                      , Z.DESCRPROD
                      , Z.CODTRIB
                      , Z.CODCFO
                      , Z.SALDO
                      , Z.VLRUNIT
                      , Z.VLRTOT
                      , Z.VLRICMS
                      , Z.VLRSUBST
                      , Z.VLRSUBSTANT
-- ORDER BY NVL(Z.HRENTSAI,Z.DTENTSAI) ASC
)

SELECT * FROM DADOS 