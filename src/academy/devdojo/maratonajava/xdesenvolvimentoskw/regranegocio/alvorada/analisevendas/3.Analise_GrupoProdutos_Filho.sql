    SELECT
        CODGRUPOPROD_BIS
         , DESCRGRUPOPROD_BIS
         , CODGRUPOPROD_AVO
         , DESCRGRUPOPROD_AVO
         , SUM(VLRTOTITEM) AS VLRTOTITEM

    FROM SQA_DADOS_GERENCIAL

    WHERE
        DTNEG BETWEEN :P_PERIODO.INI AND :P_PERIODO.FIN
      AND (CODGRUPOPROD_BIS IN :P_CODGRUPOPRODBIS)
      AND (CODGRUPOPROD_AVO = :A_CODGRUPOPRODAVO)
      AND (CODGRUPOPROD_PAI = :A_CODGRUPOPRODPAI)
      AND STATUSNOTA = 'L'
      AND TIPMOV = 'V'

    GROUP BY CODGRUPOPROD_BIS, DESCRGRUPOPROD_BIS, CODGRUPOPROD_AVO, DESCRGRUPOPROD_AVO, CODGRUPOPROD_PAI, DESCRGRUPOPROD_PAI, CODGRUPOPROD, DESCRGRUPOPROD