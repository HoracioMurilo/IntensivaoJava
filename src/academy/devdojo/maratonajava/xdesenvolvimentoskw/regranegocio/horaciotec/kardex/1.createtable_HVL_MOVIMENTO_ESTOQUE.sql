create table HVL_MOVIMENTO_ESTOQUE
(
    CODEMP            INTEGER       not null,
    DTENTSAI          DATE          not null,
    NUNOTA            INTEGER       not null,
    NUMNOTA           INTEGER       not null,
    CODPARC           INTEGER       not null,
    CHAVENFE          VARCHAR(44),
    CODTIPOPER        INTEGER       not null,
    ATUALESTOQUE      INTEGER       not null,
    CODTRIB           INTEGER,
    CODCFO            INTEGER,
    CODPROD           INTEGER       not null,
    DESCRPROD         VARCHAR2(255),
    QTDNEG            NUMBER        not null,
    VLRUNIT           NUMBER        not null,
    VLRTOT            NUMBER        not null,
    VLRICMS           NUMBER        not null,
    VLRSUBST          NUMBER        not null,
    VLRSUBSTANT       NUMBER        not null,
    QTD_ANTERIOR      NUMBER,
    ESTOQUE_ACUMULADO NUMBER,
    COLUNA_CALCULO    NUMBER
)

create index HVL_MOV_EST_DTENTSAI_index
    on HVL_MOVIMENTO_ESTOQUE (DTENTSAI)

create index HVL_MOV_EST_CODEMP_index
    on HVL_MOVIMENTO_ESTOQUE (CODEMP)

create index HVL_MOV_EST_CODTIPOPER_index
    on HVL_MOVIMENTO_ESTOQUE (CODTIPOPER)

create index HVL_MOV_EST_CODPROD_index
    on HVL_MOVIMENTO_ESTOQUE (CODPROD)

create index HVL_MOV_EST_CODTRIB_index
    on HVL_MOVIMENTO_ESTOQUE (CODTRIB)


