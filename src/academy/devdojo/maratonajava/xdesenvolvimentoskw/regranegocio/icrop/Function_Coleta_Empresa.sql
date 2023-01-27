CREATE OR REPLACE FUNCTION SQA_COLETA_EMP_ICROP( P_NUMCONTRATO INTEGER )
RETURN INTEGER IS
    P_CODEMP INTEGER;

BEGIN

    SELECT (CASE
                WHEN CON.AD_TIPOCONT = 'C' THEN (CASE
                                                     WHEN CON.AD_UNIDADE = 'GO' THEN 4
                                                     WHEN CON.AD_UNIDADE = 'BA' THEN 6
                                                     WHEN CON.AD_UNIDADE = 'S' THEN 8
                                                     WHEN CON.AD_UNIDADE = 'MT' THEN 5
                                                     WHEN CON.AD_UNIDADE = 'SP' THEN 9
                                                     WHEN CON.AD_UNIDADE = 'MG' THEN 7
                                                     WHEN CON.AD_UNIDADE = 'NO' THEN 10
                                                     WHEN CON.AD_UNIDADE = 'T' THEN 1
                                                     ELSE 99 END)
                ELSE CON.CODEMP END) AS CODEMP
    INTO P_CODEMP

    FROM TCSCON CON
    WHERE CON.NUMCONTRATO = P_NUMCONTRATO;

    RETURN P_CODEMP;

END;
