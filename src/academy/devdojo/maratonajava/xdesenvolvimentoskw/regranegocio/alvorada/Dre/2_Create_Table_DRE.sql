-- Esse é só um exemplo pois faremos pelo consolidador de dados

create table AD_SQA_DRE_GERENCIAL_ALV
(
    NUNOTA             INT not null
        primary key,
    NUMNOTA            INT,
    CODPROD            INT,
    CODGRUPOPROD       INT,
    DTREF              DATE,
    MES                INT,
    ANO                INT,
    CODEMP             INT not null,
    CODEMPMATRIZ       INT,
    CODTIPOPER         INT,
    CODCENCUS          INT,
    DESCRCENCUS        VARCHAR(40),
    CODNAT             INT,
    DESCRNAT           VARCHAR(40),
    VALOR              DECIMAL,
    ORIGEM             VARCHAR(40),
    ORDEM              INT,
    NOME_CLASSIFICADOR VARCHAR(40)
)


create index CND_SQA_DRE_CODGRUP_index
    on CND_SQA_DRE_GERENCIAL_ALV (CODGRUPOPROD)

create index CND_SQA_DRE_MES_index
    on CND_SQA_DRE_GERENCIAL_ALV (MES)

create index CND_SQA_DRE_ANO_index
    on CND_SQA_DRE_GERENCIAL_ALV (ANO)

create index CND_SQA_DRE_CODEMP_index
    on CND_SQA_DRE_GERENCIAL_ALV (CODEMP)

create index CND_SQA_DRE_CODTIPOPER_index
    on CND_SQA_DRE_GERENCIAL_ALV (CODTIPOPER)

create index CND_SQA_DRE_CODNAT_index
    on CND_SQA_DRE_GERENCIAL_ALV (CODNAT);

create index CND_SQA_DRE_CODCENCUS_index
    on CND_SQA_DRE_GERENCIAL_ALV (CODCENCUS);

INSERT INTO AD_SQA_DRE_GERENCIAL_ZP
SELECT * FROM SQA_DRE_GERENCIAL