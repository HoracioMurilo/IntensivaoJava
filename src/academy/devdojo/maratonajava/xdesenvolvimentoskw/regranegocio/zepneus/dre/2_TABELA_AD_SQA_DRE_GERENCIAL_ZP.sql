/* 1 - CRIAÇÃO DA TABELA */
CREATE TABLE AD_SQA_DRE_GERENCIAL_ZP (
                                         DTREF DATE,
                                         MES INT,
                                         ANO INT,
                                         CODEMP INT,
                                         CODCENCUS INT,
                                         DESCRCENCUS VARCHAR(40),
                                         CODNAT INT,
                                         DESCRNAT VARCHAR(40),
                                         VALOR FLOAT,
                                         ORIGEM VARCHAR(40),
                                         ORDEM INT,
                                         NOME_CLASSIFICADOR VARCHAR(40));

/* 2 - CRIAÇÃO DOS INDICES */
CREATE INDEX AD_SQA_DRE_GERENCIAL_ZP_IDX_1
    ON AD_SQA_DRE_GERENCIAL_ZP (DTREF, CODEMP, CODCENCUS, CODNAT)


/* 3 - ALIMENTAÇÃO DA TABELA */
INSERT INTO AD_SQA_DRE_GERENCIAL_ZP
SELECT * FROM SQA_DRE_GERENCIAL (NOLOCK)

/* 1 - APGANDO DADOS DA TABELA */
DELETE FROM AD_SQA_DRE_GERENCIAL_ZP