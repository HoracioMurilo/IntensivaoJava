create PROCEDURE CALCULAR_CUSTO_MEDIO
AS
    v_DTENTSAI              DATE;
    v_CODEMP                INT;
    v_CODPROD               INT;
    v_ATUALESTOQUE          INT;
    v_QTDNEG                INT;
    v_VLRUNIT               FLOAT;
    v_VLRTOT                FLOAT;
    v_ESTOQUE_ACUMULADO     INT;
    v_ROWNUM                INT;
    v_COUNT                 INT;
    v_QTDNEG_TOTAL          INT;
    v_VLRTOT_TOTAL          FLOAT;
    v_CUSTO_MEDIO_PONDERADO FLOAT;
    v_CODEMP_OLD            int ;
    v_CODPROD_OLD           int ;
    v_TESTE                 INT;
    CURSOR c1 IS
        SELECT ROWNUM
             , DTENTSAI
             , CODEMP
             , CODPROD
             , ATUALESTOQUE
             , QTDNEG
             , VLRUNIT
             , VLRTOT
             , ESTOQUE_ACUMULADO
        FROM HVL_MOVIMENTO_ESTOQUE
        WHERE CODPROD = 2153
          AND CODEMP = 2
        ORDER BY CODEMP, CODPROD, DTENTSAI;

BEGIN
    v_VLRTOT_TOTAL := 0;
    v_QTDNEG_TOTAL := 0;
    v_CUSTO_MEDIO_PONDERADO := 0;
    v_COUNT := 0;
    v_DTENTSAI := '01/01/1999';
    v_CODPROD_OLD := 0;
    v_CODEMP_OLD := 0;
    v_TESTE := 0;


    OPEN c1;
    LOOP
        FETCH c1 INTO v_ROWNUM, v_DTENTSAI, v_CODEMP, v_CODPROD, v_ATUALESTOQUE, v_QTDNEG, v_VLRUNIT, v_VLRTOT, v_ESTOQUE_ACUMULADO;
        EXIT WHEN c1%NOTFOUND;

        /*VALIDA SE A EMPRESA E O PRODUTO CONTINUAM SENDO O MESMO*/
        IF v_CODEMP = v_CODEMP_OLD AND v_CODPROD = v_CODPROD_OLD THEN

            IF v_ATUALESTOQUE = -1 THEN
                v_TESTE := v_TESTE - v_QTDNEG;
            end if;

            /*VALIDA SE É UMA COMPRA SE FOR SOMA QTDNEG E VLR TOT*/
            IF v_ATUALESTOQUE = 1 THEN

                V_TESTE := v_TESTE + v_QTDNEG;

                v_QTDNEG_TOTAL := v_QTDNEG_TOTAL + v_QTDNEG;
                v_VLRTOT_TOTAL := v_VLRTOT_TOTAL + v_VLRTOT;
                v_CUSTO_MEDIO_PONDERADO := v_VLRTOT_TOTAL / v_QTDNEG_TOTAL;
            END IF;

            UPDATE HVL_MOVIMENTO_ESTOQUE
            SET CUSTO_MEDIO_PONDERADO = v_CUSTO_MEDIO_PONDERADO
            WHERE DTENTSAI = v_DTENTSAI
              AND CODPROD = v_CODPROD
              AND CODEMP = v_CODEMP;

            /*VALIDA SE O ESTOQUE ZEROU, POIS SE ZERAR A MÉDIA RECOMEÇA*/
            IF v_ESTOQUE_ACUMULADO = 0 THEN
                v_QTDNEG_TOTAL := 0;
                v_VLRTOT_TOTAL := 0;
                v_CUSTO_MEDIO_PONDERADO := 0;
            END IF;

        ELSE

            /*AQUI É RECOMEÇADO A MÉDIA QUANDO TEMOS A ADIÇÃO DE UM OUTRO PRODUTO/EMPRESA*/
            IF v_ATUALESTOQUE = 1 THEN

                V_TESTE := v_TESTE + v_QTDNEG;

                v_QTDNEG_TOTAL := v_QTDNEG;
                v_VLRTOT_TOTAL := v_VLRTOT;
                v_CUSTO_MEDIO_PONDERADO := v_VLRTOT_TOTAL / v_QTDNEG_TOTAL;
                v_CODEMP_OLD := v_CODEMP;
                v_CODPROD_OLD := v_CODPROD;
            END IF;

            UPDATE HVL_MOVIMENTO_ESTOQUE
            SET CUSTO_MEDIO_PONDERADO = v_CUSTO_MEDIO_PONDERADO
            WHERE DTENTSAI = v_DTENTSAI
              AND CODPROD = v_CODPROD
              AND CODEMP = v_CODEMP;

        END IF;

    END LOOP;
    CLOSE c1;

end;
/

