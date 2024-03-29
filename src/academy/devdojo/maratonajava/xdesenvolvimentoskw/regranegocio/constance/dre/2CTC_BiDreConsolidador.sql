WITH NATUREZA_PAI AS (SELECT CODNAT
                           , CODNATPAI
                           , CONCAT(CODNAT, ' - ', DESCRNAT)                                      AS DESCRNAT
                           , NOME_CLASSIFICADOR
                           , ORDEM
                           , SUM(CASE WHEN MONTH(DTNEG) = 01 THEN VALOR ELSE 0 END)               AS JANEIRO
                           , SUM(CASE WHEN MONTH(DTNEG) = 02 THEN VALOR ELSE 0 END)               AS FEVEREIRO
                           , SUM(CASE WHEN MONTH(DTNEG) = 03 THEN VALOR ELSE 0 END)               AS MARCO
                           , SUM(CASE WHEN MONTH(DTNEG) = 04 THEN VALOR ELSE 0 END)               AS ABRIL
                           , SUM(CASE WHEN MONTH(DTNEG) = 05 THEN VALOR ELSE 0 END)               AS MAIO
                           , SUM(CASE WHEN MONTH(DTNEG) = 06 THEN VALOR ELSE 0 END)               AS JUNHO
                           , SUM(CASE WHEN MONTH(DTNEG) = 07 THEN VALOR ELSE 0 END)               AS JULHO
                           , SUM(CASE WHEN MONTH(DTNEG) = 08 THEN VALOR ELSE 0 END)               AS AGOSTO
                           , SUM(CASE WHEN MONTH(DTNEG) = 09 THEN VALOR ELSE 0 END)               AS SETEMBRO
                           , SUM(CASE WHEN MONTH(DTNEG) = 10 THEN VALOR ELSE 0 END)               AS OUTUBRO
                           , SUM(CASE WHEN MONTH(DTNEG) = 11 THEN VALOR ELSE 0 END)               AS NOVEMBRO
                           , SUM(CASE WHEN MONTH(DTNEG) = 12 THEN VALOR ELSE 0 END)               AS DEZEMBRO
                           , SUM(VALOR)                                                           AS TOTAL
                           , SUM((VALOR)) / ((MONTH(:P_PERIODO.FIN) - MONTH(:P_PERIODO.INI)) + 1) AS MEDIA
                           , 0                                                                    AS AV_MEDIA

                      FROM CND_SQA_DRE_GER

                      WHERE DTNEG BETWEEN :P_PERIODO.INI AND :P_PERIODO.FIN
                        AND CODCENCUS IN :P_CODCENCUS
                        AND CODEMP IN :P_CODEMP

                      GROUP BY CODNATPAI, CODNAT, DESCRNAT, NOME_CLASSIFICADOR, ORDEM),

/*ESSA LINHA ESTÁ NO INICIO DEVIDO DEVIDO AO CALCULA DA A.VERTICAL E PELA CARACTERISTICA DA LINGUAGEM ESTRUTURAL*/
     RECEITALIQUIDA AS (SELECT '#2a7344'                                                              AS BKCOLOR
                             , '#f9f9f9'                                                              AS FGCOLOR
                             , 4                                                                      AS SEQUENCIA
                             , 10                                                                     AS ORDEM
                             , 0                                                                      AS CODNATPAI
                             , 0                                                                      AS CODNAT
                             , '<b><span style=''font-size: 13px;''>( = ) RECEITA LIQUIDA</span></b>' AS DESCRCTA
                             , Z.*
                        FROM (SELECT ISNULL(SUM(JANEIRO), 0)   AS JANEIRO,
                                     ISNULL(SUM(FEVEREIRO), 0) AS FEVEREIRO,
                                     ISNULL(SUM(MARCO), 0)     AS MARCO,
                                     ISNULL(SUM(ABRIL), 0)     AS ABRIL,
                                     ISNULL(SUM(MAIO), 0)      AS MAIO,
                                     ISNULL(SUM(JUNHO), 0)     AS JUNHO,
                                     ISNULL(SUM(JULHO), 0)     AS JULHO,
                                     ISNULL(SUM(AGOSTO), 0)    AS AGOSTO,
                                     ISNULL(SUM(SETEMBRO), 0)  AS SETEMBRO,
                                     ISNULL(SUM(OUTUBRO), 0)   AS OUTUBRO,
                                     ISNULL(SUM(NOVEMBRO), 0)  AS NOVEMBRO,
                                     ISNULL(SUM(DEZEMBRO), 0)  AS DEZEMBRO,
                                     ISNULL(SUM(MEDIA), 0)     AS MEDIA,
                                     100                       AS AV_MEDIA,
                                     ISNULL(SUM(TOTAL), 0)     AS TOTAL
                              FROM NATUREZA_PAI
                              WHERE ORDEM IN (1, 2, 3)) Z),

     RECEITABRUTA AS (SELECT '#2a7344'                    AS BKCOLOR
                           , '#f9f9f9'                    AS FGCOLOR
                           , 0                            AS SEQUENCIA
                           , 0                            AS ORDEM
                           , 0                            AS CODNATPAI
                           , 0                            AS CODNAT
                           , '<b>( = ) RECEITA BRUTA</b>' AS DESCRCTA
                           , Z.*
                      FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                   ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                   ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                   ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                   ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                   ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                   ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                   ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                   ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                   ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                   ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                   ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                   ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                   ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                   ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                            FROM NATUREZA_PAI
                            WHERE ORDEM IN (1)) Z),

     RECEITA AS (SELECT CASE WHEN LEN(CODNAT) = 8 THEN '#f9f9f9' WHEN LEN(CODNAT) = 3 THEN '#06973a' END AS BKCOLOR
                      , CASE WHEN LEN(CODNAT) = 8 THEN '#000000' WHEN LEN(CODNAT) = 3 THEN '#f9f9f9' END AS FGCOLOR
                      , 1                                                                                AS SEQUENCIA
                      , 1                                                                                AS ORDEM
                      , CODNATPAI
                      , CODNAT
                      , DESCRNAT
                      , JANEIRO
                      , FEVEREIRO
                      , MARCO
                      , ABRIL
                      , MAIO
                      , JUNHO
                      , JULHO
                      , AGOSTO
                      , SETEMBRO
                      , OUTUBRO
                      , NOVEMBRO
                      , DEZEMBRO
                      , MEDIA
                      , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100                          AS AV_MEDIA
                      , TOTAL
                 FROM NATUREZA_PAI
                 WHERE ORDEM IN (1)),

     DEDUCOES AS (SELECT '#06973a'         AS BKCOLOR
                       , '#f9f9f9'         AS FGCOLOR
                       , 2                 AS SEQUENCIA
                       , 2                 AS ORDEM
                       , 0                 AS CODNATPAI
                       , 0                 AS CODNAT
                       , '<b>DEDUÇÕES</b>' AS DESCRCTA
                       , Z.*
                  FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                               ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                               ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                               ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                               ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                               ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                               ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                               ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                               ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                               ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                               ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                               ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                               ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                               ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                               ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                        FROM NATUREZA_PAI
                        WHERE ORDEM IN (2, 3)) Z),

     DEDUCOES_2 AS (SELECT CASE
                               WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                               WHEN LEN(CODNAT) = 3 THEN '#06973a' END AS BKCOLOR
                         , CASE
                               WHEN LEN(CODNAT) = 8 THEN '#000000'
                               WHEN LEN(CODNAT) = 3
                                   THEN '#f9f9f9' END                  AS FGCOLOR
                         , 3                                           AS SEQUENCIA
                         , 2                                           AS ORDEM
                         , Z.*
                    FROM (SELECT CODNATPAI,
                                 CODNAT,
                                 DESCRNAT,
                                 ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                 ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                 ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                 ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                 ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                 ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                 ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                 ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                 ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                 ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                 ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                 ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                 ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                 ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                 ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                          FROM NATUREZA_PAI
                          WHERE ORDEM IN (2, 3)
                          GROUP BY CODNATPAI, CODNAT, DESCRNAT) Z),

     CUSTOS AS (SELECT '#06973a'    AS BKCOLOR
                     , '#f9f9f9'    AS FGCOLOR
                     , 5            AS SEQUENCIA
                     , 11           AS ORDEM
                     , 0            AS CODNATPAI
                     , 0            AS CODNAT
                     , '<b>CMV</b>' AS DESCRCTA
                     , Z.*
                FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                             ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                             ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                             ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                             ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                             ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                             ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                             ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                             ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                             ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                             ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                             ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                             ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                             ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                             ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                      FROM NATUREZA_PAI
                      WHERE CODNAT = 30000000) Z),

     CUSTOS_2 AS (SELECT CASE
                             WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                             WHEN LEN(CODNAT) = 3 THEN '#06973a' END AS BKCOLOR
                       , CASE
                             WHEN LEN(CODNAT) = 8 THEN '#000000'
                             WHEN LEN(CODNAT) = 3
                                 THEN '#f9f9f9' END                  AS FGCOLOR
                       , 6                                           AS SEQUENCIA
                       , 11                                          AS ORDEM
                       , Z.*
                  FROM (SELECT CODNATPAI                                                          AS CODNATPAI,
                               CODNAT                                                             AS CODNAT,
                               DESCRNAT                                                           AS DESCRCTA,
                               ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                               ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                               ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                               ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                               ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                               ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                               ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                               ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                               ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                               ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                               ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                               ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                               ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                               ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                               ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                        FROM NATUREZA_PAI
                        WHERE CODNAT = 30000000
                        GROUP BY CODNATPAI, CODNAT, DESCRNAT) Z),

     RESULTADOBRUTO AS (SELECT '#2a7344'                      AS BKCOLOR
                             , '#f9f9f9'                      AS FGCOLOR
                             , 7                              AS SEQUENCIA
                             , 20                             AS ORDEM
                             , 0                              AS CODNATPAI
                             , 0                              AS CODNAT
                             , '<b>( = ) RESULTADO BRUTO</b>' AS DESCRCTA
                             , Z.*
                        FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                     ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                     ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                     ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                     ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                     ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                     ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                     ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                     ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                     ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                     ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                     ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                     ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                     ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                     ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                              FROM NATUREZA_PAI
                              WHERE ORDEM IN (1, 2, 3)
                                AND CODNAT = 30000000) Z),

     MARGEMBRUTA AS (SELECT '#4a4a4d'                   AS BKCOLOR
                          , '#f9f9f9'                   AS FGCOLOR
                          , 8                           AS SEQUENCIA
                          , 21                          AS ORDEM
                          , 0                           AS CODNATPAI
                          , 0                           AS CODNAT
                          , '<b>( = ) MARGEM BRUTA</b>' AS DESCRCTA
                          , Z.*
                     FROM (SELECT SUM(JANEIRO) / (SELECT IIF(SUM(JANEIRO) = 0, 1, SUM(JANEIRO))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS JANEIRO
                                , SUM(FEVEREIRO) / (SELECT IIF(SUM(FEVEREIRO) = 0, 1, SUM(FEVEREIRO))
                                                    FROM NATUREZA_PAI
                                                    WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS FEVEREIRO
                                , SUM(MARCO) / (SELECT IIF(SUM(MARCO) = 0, 1, SUM(MARCO))
                                                FROM NATUREZA_PAI
                                                WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS MARCO
                                , SUM(ABRIL) / (SELECT IIF(SUM(ABRIL) = 0, 1, SUM(ABRIL))
                                                FROM NATUREZA_PAI
                                                WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS ABRIL
                                , SUM(MAIO) / (SELECT IIF(SUM(MAIO) = 0, 1, SUM(MAIO))
                                               FROM NATUREZA_PAI
                                               WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS MAIO
                                , SUM(JUNHO) / (SELECT IIF(SUM(JUNHO) = 0, 1, SUM(JUNHO))
                                                FROM NATUREZA_PAI
                                                WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS JUNHO
                                , SUM(JULHO) / (SELECT IIF(SUM(JULHO) = 0, 1, SUM(JULHO))
                                                FROM NATUREZA_PAI
                                                WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS JULHO
                                , SUM(AGOSTO) / (SELECT IIF(SUM(AGOSTO) = 0, 1, SUM(AGOSTO))
                                                 FROM NATUREZA_PAI
                                                 WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS AGOSTO
                                , SUM(SETEMBRO) / (SELECT IIF(SUM(SETEMBRO) = 0, 1, SUM(SETEMBRO))
                                                   FROM NATUREZA_PAI
                                                   WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS SETEMBRO
                                , SUM(OUTUBRO) / (SELECT IIF(SUM(OUTUBRO) = 0, 1, SUM(OUTUBRO))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS OUTUBRO
                                , SUM(NOVEMBRO) / (SELECT IIF(SUM(NOVEMBRO) = 0, 1, SUM(NOVEMBRO))
                                                   FROM NATUREZA_PAI
                                                   WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS NOVEMBRO
                                , SUM(DEZEMBRO) / (SELECT IIF(SUM(DEZEMBRO) = 0, 1, SUM(DEZEMBRO))
                                                   FROM NATUREZA_PAI
                                                   WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS DEZEMBRO
                                , SUM(MEDIA) / (SELECT IIF(SUM(MEDIA) = 0, 1, SUM(MEDIA))
                                                FROM NATUREZA_PAI
                                                WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS MEDIA
                                , SUM(TOTAL) / (SELECT IIF(SUM(TOTAL) = 0, 1, SUM(TOTAL))
                                                FROM NATUREZA_PAI
                                                WHERE ORDEM IN (1, 2, 3, 4)) *
                                  100 AS TOTAL

                           FROM NATUREZA_PAI
                           WHERE ORDEM IN (1, 2, 3)
                             AND CODNAT = 30000000) Z),

     DESPESAS AS (SELECT '#2a7344'                      AS BKCOLOR
                       , '#f9f9f9'                      AS FGCOLOR
                       , 9                              AS SEQUENCIA
                       , 10                             AS ORDEM
                       , 0                              AS CODNATPAI
                       , 0                              AS CODNAT
                       , '<b>DESPESAS OPERACIONAIS</b>' AS DESCRCTA
                       , Z.*
                  FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                               ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                               ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                               ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                               ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                               ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                               ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                               ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                               ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                               ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                               ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                               ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                               ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                               ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                               ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                        FROM NATUREZA_PAI
                        WHERE ORDEM IN (20, 21, 22, 23, 24, 25, 26)) Z),

     AD_FRETEVENDAS AS (SELECT '#06973a'       AS BKCOLOR
                             , '#f9f9f9'       AS FGCOLOR
                             , 10              AS SEQUENCIA
                             , 22              AS ORDEM
                             , 0               AS CODNATPAI
                             , 0               AS CODNAT
                             , '<b>FRETES</b>' AS DESCRCTA
                             , Z.*
                        FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                     ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                     ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                     ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                     ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                     ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                     ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                     ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                     ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                     ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                     ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                     ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                     ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                     ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                     ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                              FROM NATUREZA_PAI
                              WHERE ORDEM IN (30)) Z),

     AD_FRETEVENDAS_2 AS (SELECT CASE
                                     WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                     WHEN LEN(CODNAT) = 3 THEN '#06973a' END                  AS BKCOLOR
                               , CASE
                                     WHEN LEN(CODNAT) = 8 THEN '#000000'
                                     WHEN LEN(CODNAT) = 3
                                         THEN '#f9f9f9' END                                   AS FGCOLOR
                               , 11                                                           AS SEQUENCIA
                               , 23                                                           AS ORDEM
                               , CODNATPAI
                               , CODNAT
                               , CONCAT('<span style=font-size: 12px;>', DESCRNAT, '</span>') as DESCRNAT
                               , JANEIRO
                               , FEVEREIRO
                               , MARCO
                               , ABRIL
                               , MAIO
                               , JUNHO
                               , JULHO
                               , AGOSTO
                               , SETEMBRO
                               , OUTUBRO
                               , NOVEMBRO
                               , DEZEMBRO
                               , MEDIA
                               , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100      AS AV_MEDIA
                               , TOTAL
                          FROM NATUREZA_PAI
                          WHERE ORDEM IN (30)),

     DESPESASCOMPESSOAL AS (SELECT '#06973a'        AS BKCOLOR
                                 , '#f9f9f9'        AS FGCOLOR
                                 , 12               AS SEQUENCIA
                                 , 22               AS ORDEM
                                 , 0                AS CODNATPAI
                                 , 0                AS CODNAT
                                 , '<b>PESSOAL</b>' AS DESCRCTA
                                 , Z.*
                            FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                         ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                         ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                         ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                         ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                         ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                         ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                         ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                         ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                         ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                         ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                         ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                         ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                         ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                         ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                  FROM NATUREZA_PAI
                                  WHERE ORDEM IN (20)) Z),

     DESPESASCOMPESSOAL_2 AS (SELECT CASE
                                         WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                         WHEN LEN(CODNAT) = 3 THEN '#06973a' END                  AS BKCOLOR
                                   , CASE
                                         WHEN LEN(CODNAT) = 8 THEN '#000000'
                                         WHEN LEN(CODNAT) = 3
                                             THEN '#f9f9f9' END                                   AS FGCOLOR
                                   , 13                                                           AS SEQUENCIA
                                   , 23                                                           AS ORDEM
                                   , CODNATPAI
                                   , CODNAT
                                   , CONCAT('<span style=font-size: 12px;>', DESCRNAT, '</span>') as DESCRNAT
                                   , JANEIRO
                                   , FEVEREIRO
                                   , MARCO
                                   , ABRIL
                                   , MAIO
                                   , JUNHO
                                   , JULHO
                                   , AGOSTO
                                   , SETEMBRO
                                   , OUTUBRO
                                   , NOVEMBRO
                                   , DEZEMBRO
                                   , MEDIA
                                   , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100      AS AV_MEDIA
                                   , TOTAL
                              FROM NATUREZA_PAI
                              WHERE ORDEM IN (20)),

     DESPESACOMERCIAL AS (SELECT '#06973a'          AS BKCOLOR
                               , '#f9f9f9'          AS FGCOLOR
                               , 14                 AS SEQUENCIA
                               , 24                 AS ORDEM
                               , 0                  AS CODNATPAI
                               , 0                  AS CODNAT
                               , '<b>COMERCIAL</b>' AS DESCRCTA
                               , Z.*
                          FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                       ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                       ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                       ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                       ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                       ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                       ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                       ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                       ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                       ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                       ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                       ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                       ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                       ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                       ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                FROM NATUREZA_PAI
                                WHERE ORDEM IN (21)) Z),

     DESPESACOMERCIAL_2 AS (SELECT CASE
                                       WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                       WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                                 , CASE
                                       WHEN LEN(CODNAT) = 8 THEN '#000000'
                                       WHEN LEN(CODNAT) = 3
                                           THEN '#f9f9f9' END                              AS FGCOLOR
                                 , 15                                                      AS SEQUENCIA
                                 , 25                                                      AS ORDEM
                                 , CODNATPAI
                                 , CODNAT
                                 , DESCRNAT
                                 , JANEIRO
                                 , FEVEREIRO
                                 , MARCO
                                 , ABRIL
                                 , MAIO
                                 , JUNHO
                                 , JULHO
                                 , AGOSTO
                                 , SETEMBRO
                                 , OUTUBRO
                                 , NOVEMBRO
                                 , DEZEMBRO
                                 , MEDIA
                                 , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                                 , TOTAL
                            FROM NATUREZA_PAI
                            WHERE ORDEM IN (21)),

     DESPESAESTRUTURAL AS (SELECT '#06973a'           AS BKCOLOR
                                , '#f9f9f9'           AS FGCOLOR
                                , 16                  AS SEQUENCIA
                                , 26                  AS ORDEM
                                , 0                   AS CODNATPAI
                                , 0                   AS CODNAT
                                , '<b>ESTRUTURAL</b>' AS DESCRCTA
                                , Z.*
                           FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                        ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                        ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                        ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                        ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                        ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                        ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                        ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                        ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                        ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                        ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                        ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                        ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                        ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                        ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                 FROM NATUREZA_PAI
                                 WHERE ORDEM IN (22)) Z),

     DESPESAESTRUTURAL_2 AS (SELECT CASE
                                        WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                        WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                                  , CASE
                                        WHEN LEN(CODNAT) = 8 THEN '#000000'
                                        WHEN LEN(CODNAT) = 3
                                            THEN '#f9f9f9' END                              AS FGCOLOR
                                  , 17                                                      AS SEQUENCIA
                                  , 15                                                      AS ORDEM
                                  , CODNATPAI
                                  , CODNAT
                                  , DESCRNAT
                                  , JANEIRO
                                  , FEVEREIRO
                                  , MARCO
                                  , ABRIL
                                  , MAIO
                                  , JUNHO
                                  , JULHO
                                  , AGOSTO
                                  , SETEMBRO
                                  , OUTUBRO
                                  , NOVEMBRO
                                  , DEZEMBRO
                                  , MEDIA
                                  , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                                  , TOTAL
                             FROM NATUREZA_PAI
                             WHERE ORDEM IN (22)),

     DESPESACOMSERVICO AS (SELECT '#06973a'        AS BKCOLOR
                                , '#f9f9f9'        AS FGCOLOR
                                , 18               AS SEQUENCIA
                                , 27               AS ORDEM
                                , 0                AS CODNATPAI
                                , 0                AS CODNAT
                                , '<b>SERVIÇO</b>' AS DESCRCTA
                                , Z.*
                           FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                        ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                        ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                        ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                        ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                        ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                        ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                        ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                        ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                        ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                        ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                        ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                        ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                        ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                        ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                 FROM NATUREZA_PAI
                                 WHERE ORDEM IN (23)) Z),

     DESPESACOMSERVICO_2 AS (SELECT CASE
                                        WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                        WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                                  , CASE
                                        WHEN LEN(CODNAT) = 8 THEN '#000000'
                                        WHEN LEN(CODNAT) = 3
                                            THEN '#f9f9f9' END                              AS FGCOLOR
                                  , 19                                                      AS SEQUENCIA
                                  , 28                                                      AS ORDEM
                                  , CODNATPAI
                                  , CODNAT
                                  , DESCRNAT
                                  , JANEIRO
                                  , FEVEREIRO
                                  , MARCO
                                  , ABRIL
                                  , MAIO
                                  , JUNHO
                                  , JULHO
                                  , AGOSTO
                                  , SETEMBRO
                                  , OUTUBRO
                                  , NOVEMBRO
                                  , DEZEMBRO
                                  , MEDIA
                                  , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                                  , TOTAL
                             FROM NATUREZA_PAI
                             WHERE ORDEM IN (23)),

     DESPESAVIAGENS AS (SELECT '#06973a'        AS BKCOLOR
                             , '#f9f9f9'        AS FGCOLOR
                             , 20               AS SEQUENCIA
                             , 29               AS ORDEM
                             , 0                AS CODNATPAI
                             , 0                AS CODNAT
                             , '<b>VIAGENS</b>' AS DESCRCTA
                             , Z.*
                        FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                     ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                     ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                     ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                     ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                     ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                     ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                     ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                     ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                     ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                     ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                     ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                     ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                     ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                     ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                              FROM NATUREZA_PAI
                              WHERE ORDEM IN (24)) Z),

     DESPESAVIAGENS_2 AS (SELECT CASE
                                     WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                     WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                               , CASE
                                     WHEN LEN(CODNAT) = 8 THEN '#000000'
                                     WHEN LEN(CODNAT) = 3
                                         THEN '#f9f9f9' END                              AS FGCOLOR
                               , 21                                                      AS SEQUENCIA
                               , 30                                                      AS ORDEM
                               , CODNATPAI
                               , CODNAT
                               , DESCRNAT
                               , JANEIRO
                               , FEVEREIRO
                               , MARCO
                               , ABRIL
                               , MAIO
                               , JUNHO
                               , JULHO
                               , AGOSTO
                               , SETEMBRO
                               , OUTUBRO
                               , NOVEMBRO
                               , DEZEMBRO
                               , MEDIA
                               , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                               , TOTAL
                          FROM NATUREZA_PAI
                          WHERE ORDEM IN (24)),

     DESPESAMARKETING AS (SELECT '#06973a'          AS BKCOLOR
                               , '#f9f9f9'          AS FGCOLOR
                               , 22                 AS SEQUENCIA
                               , 31                 AS ORDEM
                               , 0                     CODNATPAI
                               , 0                  AS CODNAT
                               , '<b>MARKETING</b>' AS DESCRCTA
                               , Z.*
                          FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                       ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                       ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                       ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                       ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                       ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                       ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                       ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                       ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                       ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                       ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                       ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                       ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                       ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                       ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                FROM NATUREZA_PAI
                                WHERE ORDEM IN (25)) Z),

     DESPESAMARKETING_2 AS (SELECT CASE
                                       WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                       WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                                 , CASE
                                       WHEN LEN(CODNAT) = 8 THEN '#000000'
                                       WHEN LEN(CODNAT) = 3
                                           THEN '#f9f9f9' END                              AS FGCOLOR
                                 , 23                                                      AS SEQUENCIA
                                 , 32                                                      AS ORDEM
                                 , CODNATPAI
                                 , CODNAT
                                 , DESCRNAT
                                 , JANEIRO
                                 , FEVEREIRO
                                 , MARCO
                                 , ABRIL
                                 , MAIO
                                 , JUNHO
                                 , JULHO
                                 , AGOSTO
                                 , SETEMBRO
                                 , OUTUBRO
                                 , NOVEMBRO
                                 , DEZEMBRO
                                 , MEDIA
                                 , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                                 , TOTAL
                            FROM NATUREZA_PAI
                            WHERE ORDEM IN (25)),

     DESPESAGERAL AS (SELECT '#06973a'                    AS BKCOLOR
                           , '#f9f9f9'                    AS FGCOLOR
                           , 24                           AS SEQUENCIA
                           , 33                           AS ORDEM
                           , 0                            AS CODNATPAI
                           , 0                            AS CODNAT
                           , '<b>GERAL/USO E CONSUMO</b>' AS DESCRCTA
                           , Z.*
                      FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                   ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                   ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                   ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                   ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                   ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                   ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                   ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                   ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                   ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                   ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                   ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                   ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                   ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                   ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                            FROM NATUREZA_PAI
                            WHERE ORDEM IN (26)) Z),

     DESPESAGERAL_2 AS (SELECT CASE
                                   WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                   WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                             , CASE
                                   WHEN LEN(CODNAT) = 8 THEN '#000000'
                                   WHEN LEN(CODNAT) = 3
                                       THEN '#f9f9f9' END                              AS FGCOLOR
                             , 25                                                      AS SEQUENCIA
                             , 34                                                      AS ORDEM
                             , CODNATPAI
                             , CODNAT
                             , DESCRNAT
                             , JANEIRO
                             , FEVEREIRO
                             , MARCO
                             , ABRIL
                             , MAIO
                             , JUNHO
                             , JULHO
                             , AGOSTO
                             , SETEMBRO
                             , OUTUBRO
                             , NOVEMBRO
                             , DEZEMBRO
                             , MEDIA
                             , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                             , TOTAL
                        FROM NATUREZA_PAI
                        WHERE ORDEM IN (26)),

     RESULTADOOPERACIONAL AS (SELECT '#2a7344'                                    AS BKCOLOR
                                   , '#f9f9f9'                                    AS FGCOLOR
                                   , 26                                           AS SEQUENCIA
                                   , 40                                           AS ORDEM
                                   , 0                                            AS CODNATPAI
                                   , 0                                            AS CODNAT
                                   , '<b>( = ) RESULTADO OPERACIONAL(EBITDA)</b>' AS DESCRCTA
                                   , Z.*
                              FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                           ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                           ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                           ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                           ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                           ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                           ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                           ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                           ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                           ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                           ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                           ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                           ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                           ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)), 0) * 100 AS AV_MEDIA,
                                           ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                    FROM NATUREZA_PAI
                                    WHERE ORDEM IN (1, 2, 3, 20, 21, 22, 23, 24, 25, 26)
                                      AND CODNAT = 30000000) Z),

     FINANCEIRAS AS (SELECT '#06973a'            AS BKCOLOR
                          , '#f9f9f9'            AS FGCOLOR
                          , 27                   AS SEQUENCIA
                          , 41                   AS ORDEM
                          , 0                    AS CODNATPAI
                          , 0                    AS CODNAT
                          , '<b>FINANCEIRAS</b>' AS DESCRCTA
                          , Z.*
                     FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                  ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                  ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                  ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                  ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                  ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                  ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                  ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                  ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                  ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                  ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                  ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                  ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                  ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                  ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                           FROM NATUREZA_PAI
                           WHERE ORDEM IN (12, 13)) Z),


     FINANCEIRAS_2 AS (SELECT CASE
                                  WHEN LEN(CODNAT) = 8 THEN '#f9f9f9'
                                  WHEN LEN(CODNAT) = 3 THEN '#06973a' END             AS BKCOLOR
                            , CASE
                                  WHEN LEN(CODNAT) = 8 THEN '#000000'
                                  WHEN LEN(CODNAT) = 3
                                      THEN '#f9f9f9' END                              AS FGCOLOR
                            , 28                                                      AS SEQUENCIA
                            , 42                                                      AS ORDEM
                            , CODNATPAI
                            , CODNAT
                            , DESCRNAT
                            , JANEIRO
                            , FEVEREIRO
                            , MARCO
                            , ABRIL
                            , MAIO
                            , JUNHO
                            , JULHO
                            , AGOSTO
                            , SETEMBRO
                            , OUTUBRO
                            , NOVEMBRO
                            , DEZEMBRO
                            , MEDIA
                            , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100 AS AV_MEDIA
                            , TOTAL
                       FROM NATUREZA_PAI
                       WHERE ORDEM IN (12, 13)),

     OUTRAS AS (SELECT '#06973a'                        AS BKCOLOR
                     , '#f9f9f9'                        AS FGCOLOR
                     , 29                               AS SEQUENCIA
                     , 43                               AS ORDEM
                     , 0                                AS CODNATPAI
                     , 0                                AS CODNAT
                     , '<b>OUTRAS DESPESA/RECEITAS</b>' AS DESCRCTA
                     , Z.*
                FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                             ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                             ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                             ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                             ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                             ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                             ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                             ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                             ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                             ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                             ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                             ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                             ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                             ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                             ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                      FROM NATUREZA_PAI
                      WHERE ORDEM IN (14)) Z),


     OUTRAS_2 AS (SELECT CASE WHEN LEN(CODNAT) = 8 THEN '#f9f9f9' WHEN LEN(CODNAT) = 3 THEN '#06973a' END AS BKCOLOR
                       , CASE WHEN LEN(CODNAT) = 8 THEN '#000000' WHEN LEN(CODNAT) = 3 THEN '#f9f9f9' END AS FGCOLOR
                       , 30                                                                               AS SEQUENCIA
                       , 44                                                                               AS ORDEM
                       , CODNATPAI
                       , CODNAT
                       , DESCRNAT
                       , JANEIRO
                       , FEVEREIRO
                       , MARCO
                       , ABRIL
                       , MAIO
                       , JUNHO
                       , JULHO
                       , AGOSTO
                       , SETEMBRO
                       , OUTUBRO
                       , NOVEMBRO
                       , DEZEMBRO
                       , MEDIA
                       , (ABS(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100                          AS AV_MEDIA
                       , TOTAL
                  FROM NATUREZA_PAI
                  WHERE ORDEM IN (14)),


     RESULTADOLIQUIDO AS (SELECT '#2a7344'                                     AS BKCOLOR
                               , '#f9f9f9'                                     AS FGCOLOR
                               , 31                                            AS SEQUENCIA
                               , 50                                            AS ORDEM
                               , 0                                             AS CODNATPAI
                               , 0                                             AS CODNAT
                               , '<b>( = ) RESULTADO ANTES DO IRPJ E CSLL</b>' AS DESCRCTA
                               , Z.*
                          FROM (SELECT ISNULL(SUM(JANEIRO), 0)                                            AS JANEIRO,
                                       ISNULL(SUM(FEVEREIRO), 0)                                          AS FEVEREIRO,
                                       ISNULL(SUM(MARCO), 0)                                              AS MARCO,
                                       ISNULL(SUM(ABRIL), 0)                                              AS ABRIL,
                                       ISNULL(SUM(MAIO), 0)                                               AS MAIO,
                                       ISNULL(SUM(JUNHO), 0)                                              AS JUNHO,
                                       ISNULL(SUM(JULHO), 0)                                              AS JULHO,
                                       ISNULL(SUM(AGOSTO), 0)                                             AS AGOSTO,
                                       ISNULL(SUM(SETEMBRO), 0)                                           AS SETEMBRO,
                                       ISNULL(SUM(OUTUBRO), 0)                                            AS OUTUBRO,
                                       ISNULL(SUM(NOVEMBRO), 0)                                           AS NOVEMBRO,
                                       ISNULL(SUM(DEZEMBRO), 0)                                           AS DEZEMBRO,
                                       ISNULL(SUM(MEDIA), 0)                                              AS MEDIA,
                                       ISNULL((SUM(MEDIA) / (SELECT MEDIA FROM RECEITALIQUIDA)) * 100, 0) AS AV_MEDIA,
                                       ISNULL(SUM(TOTAL), 0)                                              AS TOTAL
                                FROM NATUREZA_PAI
                                WHERE ORDEM IN (1, 2, 3, 20, 21, 22, 23, 24, 25, 26, 12, 13, 14)
                                  AND CODNAT = 30000000) Z),

     MARGEMLIQUIDA AS (SELECT '#4a4a4d'                      AS BKCOLOR
                            , '#f9f9f9'                      AS FGCOLOR
                            , 32                             AS SEQUENCIA
                            , 51                             AS ORDEM
                            , 0                              AS CODNATPAI
                            , 0                              AS CODNAT
                            , '<b>( = ) MAERGEM LIQUIDA</b>' AS DESCRCTA
                            , Z.*
                       FROM (SELECT SUM(JANEIRO) / (SELECT IIF(SUM(JANEIRO) = 0, 1, SUM(JANEIRO))
                                                    FROM NATUREZA_PAI
                                                    WHERE ORDEM IN (1, 2)) *
                                    100 AS JANEIRO
                                  , SUM(FEVEREIRO) / (SELECT IIF(SUM(FEVEREIRO) = 0, 1, SUM(FEVEREIRO))
                                                      FROM NATUREZA_PAI
                                                      WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS FEVEREIRO
                                  , SUM(MARCO) / (SELECT IIF(SUM(MARCO) = 0, 1, SUM(MARCO))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS MARCO
                                  , SUM(ABRIL) / (SELECT IIF(SUM(ABRIL) = 0, 1, SUM(ABRIL))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS ABRIL
                                  , SUM(MAIO) / (SELECT IIF(SUM(MAIO) = 0, 1, SUM(MAIO))
                                                 FROM NATUREZA_PAI
                                                 WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS MAIO
                                  , SUM(JUNHO) / (SELECT IIF(SUM(JUNHO) = 0, 1, SUM(JUNHO))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS JUNHO
                                  , SUM(JULHO) / (SELECT IIF(SUM(JULHO) = 0, 1, SUM(JULHO))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS JULHO
                                  , SUM(AGOSTO) / (SELECT IIF(SUM(AGOSTO) = 0, 1, SUM(AGOSTO))
                                                   FROM NATUREZA_PAI
                                                   WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS AGOSTO
                                  , SUM(SETEMBRO) / (SELECT IIF(SUM(SETEMBRO) = 0, 1, SUM(SETEMBRO))
                                                     FROM NATUREZA_PAI
                                                     WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS SETEMBRO
                                  , SUM(OUTUBRO) / (SELECT IIF(SUM(OUTUBRO) = 0, 1, SUM(OUTUBRO))
                                                    FROM NATUREZA_PAI
                                                    WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS OUTUBRO
                                  , SUM(NOVEMBRO) / (SELECT IIF(SUM(NOVEMBRO) = 0, 1, SUM(NOVEMBRO))
                                                     FROM NATUREZA_PAI
                                                     WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS NOVEMBRO
                                  , SUM(DEZEMBRO) / (SELECT IIF(SUM(DEZEMBRO) = 0, 1, SUM(DEZEMBRO))
                                                     FROM NATUREZA_PAI
                                                     WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS DEZEMBRO
                                  , SUM(MEDIA) / (SELECT IIF(SUM(MEDIA) = 0, 1, SUM(MEDIA))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS MEDIA
                                  , SUM(TOTAL) / (SELECT IIF(SUM(TOTAL) = 0, 1, SUM(TOTAL))
                                                  FROM NATUREZA_PAI
                                                  WHERE ORDEM IN (1, 2, 3, 4)) *
                                    100 AS TOTAL

                             FROM NATUREZA_PAI
                             WHERE ORDEM IN (1, 2, 3, 4)) Z)


SELECT *
FROM RECEITABRUTA
UNION ALL

SELECT *
FROM RECEITA
UNION ALL

SELECT *
FROM DEDUCOES
UNION ALL

SELECT *
FROM DEDUCOES_2
UNION ALL

SELECT *
FROM RECEITALIQUIDA
UNION ALL

SELECT *
FROM CUSTOS
UNION ALL

SELECT *
FROM CUSTOS_2
UNION ALL

SELECT *
FROM RESULTADOBRUTO
UNION ALL

SELECT *
FROM DESPESAS
UNION ALL

SELECT *
FROM AD_FRETEVENDAS
UNION ALL

SELECT *
FROM AD_FRETEVENDAS_2
UNION ALL

SELECT *
FROM DESPESASCOMPESSOAL
UNION ALL

SELECT *
FROM DESPESASCOMPESSOAL_2
UNION ALL

SELECT *
FROM DESPESACOMERCIAL
UNION ALL

SELECT *
FROM DESPESACOMERCIAL_2
UNION ALL

SELECT *
FROM DESPESAESTRUTURAL
UNION ALL

SELECT *
FROM DESPESAESTRUTURAL_2
UNION ALL

SELECT *
FROM DESPESACOMSERVICO
UNION ALL

SELECT *
FROM DESPESACOMSERVICO_2
UNION ALL

SELECT *
FROM DESPESAVIAGENS
UNION ALL

SELECT *
FROM DESPESAVIAGENS_2
UNION ALL

SELECT *
FROM DESPESAMARKETING
UNION ALL

SELECT *
FROM DESPESAMARKETING_2
UNION ALL

SELECT *
FROM DESPESAGERAL
UNION ALL

SELECT *
FROM DESPESAGERAL_2
UNION ALL

SELECT *
FROM RESULTADOOPERACIONAL
UNION ALL

SELECT *
FROM FINANCEIRAS
UNION ALL

SELECT *
FROM FINANCEIRAS_2
UNION ALL

SELECT *
FROM OUTRAS
UNION ALL

SELECT *
FROM OUTRAS_2
UNION ALL

SELECT *
FROM RESULTADOLIQUIDO

ORDER BY 3 ASC, 6 ASC