SELECT
    CAB.CODEMP
     , CAB.DTENTSAI
     , CAB.DTNEG
     , CAB.HRENTSAI
     , CAB.NUNOTA
     , CAB.NUMNOTA
     , CAB.CODTIPOPER
     , TTP.DESCROPER
     , ITE.CODPROD
     , PRO.DESCRPROD
     , ITE.CODTRIB
     , ITE.CODCFO
     , CASE WHEN ITE.ATUALESTOQUE = 1 THEN ITE.QTDNEG *1 WHEN ITE.ATUALESTOQUE = -1 THEN ITE.QTDNEG * -1 ELSE 0 END AS QTDNEG
     , ITE.VLRUNIT
     , CASE WHEN ITE.ATUALESTOQUE = 1 THEN ITE.VLRTOT *1 WHEN ITE.ATUALESTOQUE = -1 THEN ITE.VLRTOT * -1 ELSE 0 END AS VLRTOT
     , CASE WHEN ITE.ATUALESTOQUE = 1 THEN ITE.VLRICMS *1 WHEN ITE.ATUALESTOQUE = -1 THEN ITE.VLRICMS * -1 ELSE 0 END AS VLRICMS
     , CASE WHEN ITE.ATUALESTOQUE = 1 THEN ITE.VLRSUBST *1 WHEN ITE.ATUALESTOQUE = -1 THEN ITE.VLRSUBST * -1 ELSE 0 END AS VLRSUBST
     , ITE.ATUALESTOQUE AS IDENTIFICADOR_INTERNO
     , SUM(ITE.QTDNEG * ITE.ATUALESTOQUE) OVER (ORDER BY CAB.DTNEG) AS ESTOQUE_ACUMULADO
     , (SELECT NVL (SUM (EST.ESTOQUE), 0)
        FROM TGFEST EST
        WHERE EST.TIPO = 'P'
          AND EST.CODPROD = PRO.CODPROD)
    - (SELECT NVL (SUM(ESE.QTDNEG
        * (CASE WHEN (ESE.ATUALESTOQUE <> 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('N', 'T', 'D')) THEN ESE.ATUALESTOQUE
                WHEN (ESE.ATUALESTOQUE = 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('P', 'R')) THEN CASE WHEN (NVL (ESE.ATUALESTTERC, 'N') = 'P') THEN 1
                                                                                                    ELSE -1 END
            END)),0)
       FROM TGFESE ESE
       WHERE ESE.CODPROD = PRO.CODPROD
         AND ((ESE.ATUALESTOQUE <> 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('N', 'T', 'D')) OR (ESE.ATUALESTOQUE = 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('P', 'R')))
         AND ESE.DTREFERENCIA >= '01/01/2022'
      ) * 1 AS SALDO_INICIAL

     ,  (SELECT NVL (SUM(ESE.QTDNEG
    * (CASE WHEN (ESE.ATUALESTOQUE <> 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('N', 'T', 'D')) THEN ESE.ATUALESTOQUE
            WHEN (ESE.ATUALESTOQUE = 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('P', 'R')) THEN CASE WHEN (NVL (ESE.ATUALESTTERC, 'N') = 'P') THEN 1
                                                                                                ELSE -1 END
        END)),0)
         FROM TGFESE ESE
         WHERE ESE.CODPROD = PRO.CODPROD
           AND ((ESE.ATUALESTOQUE <> 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('N', 'T', 'D')) OR (ESE.ATUALESTOQUE = 0 AND NVL (ESE.ATUALESTTERC, 'N') IN ('P', 'R')))
           AND ESE.DTREFERENCIA >= '01/01/2022'
        ) * 1 AS MOVIMENTACAO_PER

FROM TGFITE ITE

         INNER JOIN TGFCAB CAB ON ITE.NUNOTA = CAB.NUNOTA
         INNER JOIN TGFPRO PRO ON PRO.CODPROD = ITE.CODPROD
         INNER JOIN TGFTOP TTP ON TTP.CODTIPOPER = CAB.CODTIPOPER AND TTP.DHALTER = CAB.DHTIPOPER

WHERE ITE.CODPROD = 676
  AND (TTP.ATUALEST = 'B' OR TTP.ATUALEST = 'E')
  AND ((CASE WHEN CAB.TIPMOV = 'V' THEN (CASE WHEN SERIENOTA = 'CF' THEN 1 ELSE (CASE WHEN CAB.STATUSNFE = 'A' THEN 1 ELSE 0 END) END) ELSE 0 END) =1
    OR (CASE WHEN CAB.TIPMOV = 'D' THEN (CASE WHEN CAB.STATUSNFE = 'A' THEN 1 ELSE 0 END) ELSE 0 END) =1
    OR (CASE WHEN CAB.TIPMOV = 'C' THEN (CASE WHEN CAB.STATUSNOTA = 'L' THEN 1 ELSE 0 END) ELSE 0 END) =1
    OR (CASE WHEN CAB.TIPMOV = 'E' THEN (CASE WHEN CAB.STATUSNOTA = 'L' THEN 1 ELSE 0 END) ELSE 0 END) = 1)
  AND CAB.DTENTSAI >= '01/01/2022'

ORDER BY 9 ASC, 3 ASC