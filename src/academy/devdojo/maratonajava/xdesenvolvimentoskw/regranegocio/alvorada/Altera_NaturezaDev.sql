CREATE OR REPLACE PROCEDURE STP_AJUSTA_CAMPOS_DEVVENDA (
    P_NUNOTA          INT,
    P_SUCESSO     OUT VARCHAR,
    P_MENSAGEM    OUT VARCHAR2,
    P_CODUSULIB   OUT NUMERIC)
AS
BEGIN
    DECLARE

        V_TIPNEG     INT;
        V_EXISTE     VARCHAR(2);
        V_COUNT      INT;
        V_CODTIPOPER INT;
        V_VLRTOTORIG NUMBER;
        V_VLRTOT     NUMBER;

/******************************************************************************
Autor:    Murilo Horacio - SQA

Data:     25/10/2022

Objetivo: Regra de Negócio para mudar a natureza dos lançamentos da top de dev. de venda para a nat. de dev. de vendas.
******************************************************************************/

    BEGIN

        SELECT
            CODTIPOPER
        INTO    V_CODTIPOPER
        FROM TGFCAB CAB
        WHERE CAB.NUNOTA = P_NUNOTA;

        SELECT NVL((SELECT 'S'
                    FROM AD_CENTPARAMTOP A
                    WHERE A.NUPAR = 1
                      AND A.CODTIPOPER = V_CODTIPOPER),'N')
        INTO V_EXISTE
        FROM DUAL;

        IF V_EXISTE = 'S' THEN

            P_SUCESSO := 'S';

            UPDATE TGFCAB SET CODNAT = 10030100
            WHERE NUNOTA = P_NUNOTA;

            UPDATE TGFFIN SET CODNAT = 10030100
            WHERE NUNOTA = P_NUNOTA;

        END IF;

    END;
END;
