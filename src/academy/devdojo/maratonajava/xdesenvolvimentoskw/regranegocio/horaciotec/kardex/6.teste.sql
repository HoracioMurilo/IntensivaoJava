CREATE OR REPLACE PROCEDURE "STP_PREMIACAO_CALCULA_UNV" (

		P_CODUSU NUMBER,        -- Codigo do usuario logado
		P_IDSESSAO VARCHAR2,    -- Identificador da execuc?o. Serve para buscar informac?es dos parametros/campos da execuc?o.
		P_QTDLINHAS NUMBER,     -- Informa a quantidade de registros selecionados no momento da execuc?o.
		P_MENSAGEM OUT VARCHAR2 -- Caso seja passada uma mensagem aqui, ela sera exibida como uma informac?o ao usuario.
) AS
	PARAM_ANO	 		NUMBER;
	PARAM_MES	 		NUMBER;
	PARAM_VENDEDOR NUMBER;
	PARAM_VENDEDORF NUMBER;

	V_ANO				NUMBER;
	V_MES				NUMBER;
	V_ANOT			NUMBER;
	V_MEST			NUMBER;

	V_CODVEND			NUMBER;
	V_PREMIACAO		NUMBER;

  V_CODEMP		NUMBER;
  V_REFERENCIA DATE;
  V_VALORAV		NUMBER;
  V_MESINI VARCHAR2(2);
  V_MESFIM VARCHAR2(2);
  V_VALORSERVICO		NUMBER;
  V_VALORTOTAL		NUMBER;
  V_ORIGEM 		VARCHAR2(1);
  V_CODUSU		NUMBER;
  V_DATAINCLUSAO DATE;
  V_STATUS  		VARCHAR2(1);
  V_COMPETENCIAPAGTO DATE;
  V_TIPO 		VARCHAR2(1);

	V_CONTADOR			NUMBER;
	P_COUNT         	NUMBER;

  V_VALORAVPG   NUMBER;
  V_VALORSERVICOPG NUMBER;
  V_VALORTOTALPG NUMBER;
  V_PREMIACAOTOTALAV  NUMBER;
  V_PREMIACAOTOTALOUTROS NUMBER;
  V_PREMIACAOTOTAL  NUMBER;
  V_PREMIACAOSALDOAV NUMBER;
  V_PREMIACAOSALDOOUTROS  NUMBER;
  V_PREMIACAOSALDO NUMBER;

  V_VLRANT NUMBER;

  V_CODEVENTO NUMBER;
  V_VENDCOMIS NUMBER;
  V_VENDMETA NUMBER;
  V_BONUSCAMP   NUMBER;
  V_ULTIMODIA DATE;
  V_TOTALCOMIS NUMBER;
  V_TOTALBONUS NUMBER;
  V_STOTALCOMIS NUMBER;
  V_STOTALBONUS NUMBER;
  V_TOTALPREMIO NUMBER;
  V_REALIZADO NUMBER;
  V_REALIZADOCAMP NUMBER;
  V_META NUMBER;

BEGIN

	PARAM_ANO	:= ACT_INT_PARAM(P_IDSESSAO, 'ANO');
	PARAM_MES	:= ACT_INT_PARAM(P_IDSESSAO, 'MES');
	PARAM_VENDEDOR	:= ACT_INT_PARAM(P_IDSESSAO, 'VENDEDOR');
	PARAM_VENDEDORF	:= ACT_INT_PARAM(P_IDSESSAO, 'VENDEDORF');

  -- Evento para Premiações mensais.
  V_CODEVENTO := 44;
  P_COUNT := 0;
  V_REFERENCIA := TO_DATE('01'||'/'||SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2)||'/'||SUBSTR(TO_CHAR(PARAM_ANO,'0000'),2,4),'DD/MM/RRRR');

  IF (PARAM_VENDEDOR > 0) AND (PARAM_VENDEDORF > 0) THEN
    SELECT COUNT(*)
    INTO P_COUNT
    FROM AD_PREMIACAO
    WHERE REFERENCIA = V_REFERENCIA
      AND CODVEND >= PARAM_VENDEDOR
      AND CODVEND <= PARAM_VENDEDORF;
  ELSE
    SELECT COUNT(*)
    INTO P_COUNT
    FROM AD_PREMIACAO
    WHERE REFERENCIA = V_REFERENCIA;

  END IF;

  --IF P_COUNT > 0 THEN

--		P_MENSAGEM := 'Cálculo para o Ano ['||PARAM_ANO||'] e mês ['||PARAM_MES||'] já foi realizado, favor verificar !';
 --   RETURN;

  --END IF;

	V_CONTADOR := 0;
	--Identifica quais os vendedores tem direito à premiação - no mês/ano digitados

	FOR C1 IN (
	WITH DADOS AS (
		SELECT CAB.CODVEND,
			CASE WHEN VEN.AD_CODCLASS IN ('VI', 'VD') THEN 'V'
			WHEN VEN.AD_CODCLASS IN ('RC', 'CG') THEN 'R'
			END AS CLASSVEND,
			TO_CHAR(TRUNC(CAB.DTNEG, 'MM'), 'YYYY-MM') AS ANOMES,
			TRUNC(CAB.DTNEG, 'MM') AS REFERENCIA,
			CAB.CODEMP,
			VLRMETA,
			AD_UNIDNEG,
			TIPMOV,
			SUM((ITE.VLRTOT-ITE.VLRDESC)*DECODE(TIPMOV,'D',-1,1)) AS REALIZADO

		FROM TGFCAB CAB
		JOIN TGFITE ITE ON CAB.NUNOTA = ITE.NUNOTA
		JOIN TGFVEN VEN ON VEN.CODVEND = CAB.CODVEND
		JOIN TGFPRO PRO ON ITE.CODPROD = PRO.CODPROD
		JOIN TGFGRU GRU ON PRO.CODGRUPOPROD = GRU.CODGRUPOPROD
		LEFT JOIN AD_SEGMENVEND SEG ON SEG.CODVEND = CAB.CODVEND
		AND GRU.AD_UNIDNEG = SEG.CODUNIDNEG
		AND PERIODOANO = PARAM_ANO
		AND PERIODOMES = PARAM_MES
			WHERE ((CAB.TIPMOV = 'V' AND TO_CHAR(CAB.DTFATUR, 'MM') = SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2)
			AND TO_CHAR(CAB.DTFATUR, 'YYYY') = SUBSTR(TO_CHAR(PARAM_ANO,'0000'),2,4)) OR
			(CAB.TIPMOV = 'D' AND TO_CHAR(CAB.DTENTSAI, 'MM') = SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2)
			AND TO_CHAR(CAB.DTENTSAI, 'YYYY') = SUBSTR(TO_CHAR(PARAM_ANO,'0000'),2,4))
			)
			AND ((CAB.TIPMOV = 'D' AND CAB.STATUSNOTA = 'L') OR (CAB.TIPMOV = 'V' AND CAB.STATUSNFE = 'A'))
			AND CAB.CODTIPOPER IN (SELECT CODTIPOPER FROM AD_CENTPARAMTOP WHERE NUPAR = 13)
			AND CAB.CODVEND NOT IN (SELECT CODVEND FROM AD_CENTPARAMVEND WHERE NUPAR = 13)
			and ((CAB.CODVEND BETWEEN PARAM_VENDEDOR AND PARAM_VENDEDORF) OR (PARAM_VENDEDOR IS NULL OR PARAM_VENDEDORF IS NULL))

			GROUP BY AD_UNIDNEG, CAB.CODEMP, TIPMOV, CAB.CODVEND, VLRMETA, AD_CODCLASS, TO_CHAR(TRUNC(CAB.DTNEG, 'MM'), 'YYYY-MM'), TRUNC(CAB.DTNEG, 'MM')

			ORDER BY CODEMP, CODVEND, AD_UNIDNEG)

SELECT CODVEND,
    CODEMP,
    REALIZADO,
    VLRMETA,
    ROUND(VLRAV,2) AS VLRAV
    FROM(
        SELECT CODVEND,
            CODEMP,
            SUM(REALIZADO) AS REALIZADO,
            SUM(VLRMETA) AS VLRMETA,
            SUM(REALIZADO*(VALOR/100)) AS VLRAV

        FROM (
                SELECT X.CODVEND,
                    CODEMP,
                    SUM(REALIZADO) AS REALIZADO,
                    MAX(VLRMETA) AS VLRMETA,
                    X.AD_UNIDNEG,
                    Z.VALOR
                FROM DADOS X,

                    (SELECT ROUND((SUM(REALIZADO)*100)/MAX(VLRMETA),2) AS PERCTOTAL, AD_UNIDNEG, CODVEND FROM DADOS
                    GROUP BY AD_UNIDNEG, CODVEND
                    HAVING SUM(REALIZADO) >= MAX(VLRMETA)*(SELECT VALOR FROM AD_CENTPARAMVAL WHERE NUPAR = 13))Y,

                    (SELECT VALOR, VALORINI, VALORFIN, REGRA FROM AD_CENTPARAMDIN
                    WHERE NUPAR = 13)Z

                WHERE X.AD_UNIDNEG = Y.AD_UNIDNEG
                AND X.CODVEND = Y.CODVEND
                AND Y.PERCTOTAL BETWEEN Z.VALORINI AND Z.VALORFIN
                AND Z.REGRA = X.CLASSVEND
                GROUP BY X.CODVEND, CODEMP, X.AD_UNIDNEG, VALOR)
        GROUP BY CODEMP, CODVEND)

)
	LOOP

	V_ANO 			:= SUBSTR(TO_CHAR(PARAM_ANO,'0000'),2,4);
	V_MES 			:= SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2);
	V_TIPO    	    := 'M';         -- Mês Vigente

		P_COUNT := 0;

			SELECT COUNT(*)
			INTO P_COUNT
			FROM AD_PREMIACAO
			WHERE CODVEND = C1.CODVEND
			  AND REFERENCIA = V_REFERENCIA
			  AND CODEMP = C1.CODEMP
			  AND TIPO = V_TIPO;

			IF P_COUNT = 0 THEN

				INSERT INTO AD_PREMIACAO(CODVEND,
										REFERENCIA,
										CODEMP,
										TIPO,
										VALORAV,
										VALORTOTAL,
										ORIGEM,
										CODUSU,
										DATAINCLUSAO,
										STATUS,
										COMPETENCIAPAGTO,
										VLRMETA,
										VLRREALIZADO)
				VALUES (C1.CODVEND,
						V_REFERENCIA,
						C1.CODEMP,
						V_TIPO,
						C1.VLRAV,
						C1.VLRAV,
						'C',
						0,
						SYSDATE,
						0,
						V_REFERENCIA,
						C1.VLRMETA,
						C1.REALIZADO);

				COMMIT;

				V_CONTADOR := V_CONTADOR + 1;

			END IF;

		END LOOP;

V_MESINI := '00';
V_MESFIM := '00';

IF SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2) = '03'
THEN
V_MESINI := '01';
V_MESFIM := '03';

ELSIF SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2) = '06'
THEN
V_MESINI := '04';
V_MESFIM := '06';
ELSIF SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2) = '09'
THEN
V_MESINI := '07';
V_MESFIM := '09';
ELSIF SUBSTR(TO_CHAR(PARAM_MES,'00'),2,2) = '12'
THEN
V_MESINI := '10';
V_MESFIM := '12';

END IF ;

-- VERIFICAÇÃO SE AS VARIAVEIS INICIADAS EM 0 NÃO SÃO MAIS 0.
    IF V_MESINI <> '00' AND V_MESFIM <> '00'
    THEN
    FOR C2 IN (
	WITH DADOS AS(
		SELECT CAB.CODVEND,
			CASE WHEN VEN.AD_CODCLASS IN ('VI', 'VD') THEN 'V'
			WHEN VEN.AD_CODCLASS IN ('RC', 'CG') THEN 'R'
			END AS CLASSVEND,
			CAB.CODEMP,
			AD_UNIDNEG,
			SUM((ITE.VLRTOT-ITE.VLRDESC)*DECODE(TIPMOV,'D',-1,1)) AS REALIZADO


		FROM TGFCAB CAB
		JOIN TGFITE ITE ON CAB.NUNOTA = ITE.NUNOTA
		JOIN TGFVEN VEN ON VEN.CODVEND = CAB.CODVEND
		JOIN TGFPRO PRO ON ITE.CODPROD = PRO.CODPROD
		JOIN TGFGRU GRU ON PRO.CODGRUPOPROD = GRU.CODGRUPOPROD

			WHERE ((TO_CHAR(CAB.DTFATUR, 'MM') BETWEEN V_MESINI AND V_MESFIM
			AND TO_CHAR(CAB.DTFATUR, 'YYYY') = V_ANO
			AND TIPMOV = 'V')OR
			(TO_CHAR(CAB.DTENTSAI, 'MM') BETWEEN V_MESINI AND V_MESFIM
			AND TO_CHAR(CAB.DTENTSAI, 'YYYY') = V_ANO
			AND TIPMOV = 'D'))
			AND ((CAB.TIPMOV = 'D' AND CAB.STATUSNOTA = 'L') OR (CAB.TIPMOV = 'V' AND CAB.STATUSNFE = 'A'))
			AND CAB.CODTIPOPER IN (SELECT CODTIPOPER FROM AD_CENTPARAMTOP WHERE NUPAR = 13)
			AND CAB.CODVEND NOT IN (SELECT CODVEND FROM AD_CENTPARAMVEND WHERE NUPAR = 13)
			AND ((CAB.CODVEND BETWEEN PARAM_VENDEDOR AND PARAM_VENDEDORF) OR (PARAM_VENDEDOR IS NULL OR PARAM_VENDEDORF IS NULL))
			GROUP BY AD_UNIDNEG, CAB.CODEMP, CAB.CODVEND, AD_CODCLASS
			ORDER BY CODVEND, AD_UNIDNEG, CODEMP

)
SELECT CODVEND,
    AD_UNIDNEG,
    REALTOT,
    METATOT,
    (SELECT VALOR FROM AD_CENTPARAMDIN
			WHERE NUPAR = 13
			AND ROUND(((REALTOT*100)/METATOT),2) BETWEEN VALORINI AND VALORFIN
			AND REGRA = CLASSVEND) AS PERC,
    ROUND(((REALTOT*100)/METATOT),2) AS ATINGIDO
FROM(
    SELECT CODVEND,
    AD_UNIDNEG,
	CLASSVEND,
    SUM(REALIZADO) AS REALTOT,
    MAX(VLRMETA) METATOT
    FROM (
            SELECT DADOS.CODVEND,
             CLASSVEND,
             CODEMP,
             DADOS.AD_UNIDNEG,
             SUM(REALIZADO) AS REALIZADO,
             MAX(VLRMETA) AS VLRMETA
             FROM DADOS,
                			(SELECT SUM(VLRMETA) AS VLRMETA, CODVEND, CODUNIDNEG
                        FROM AD_SEGMENVEND
                        WHERE PERIODOANO = V_ANO
                        AND VLRMETA > 0
                        AND PERIODOMES BETWEEN V_MESINI AND V_MESFIM
                        GROUP BY CODVEND, CODUNIDNEG)Y

            WHERE DADOS.AD_UNIDNEG = Y.CODUNIDNEG
            AND DADOS.CODVEND = Y.CODVEND
            GROUP BY DADOS.CODVEND, DADOS.CODEMP, DADOS.AD_UNIDNEG, CLASSVEND )Z
    GROUP BY AD_UNIDNEG, CODVEND, CLASSVEND
    HAVING SUM(REALIZADO) >= MAX(VLRMETA)*(SELECT VALOR FROM AD_CENTPARAMVAL WHERE NUPAR = 13)
    )
	ORDER BY CODVEND, AD_UNIDNEG
)

    LOOP

		FOR C3 IN (
					WITH DADOS AS (
					SELECT CAB.CODVEND,
						CASE WHEN VEN.AD_CODCLASS IN ('VI', 'VD') THEN 'V'
						WHEN VEN.AD_CODCLASS IN ('RC', 'CG') THEN 'R'
						END AS CLASSVEND,
						CASE WHEN TIPMOV = 'D' THEN TRUNC(DTENTSAI, 'MM')
						ELSE TRUNC(DTFATUR, 'MM') END REFERENCIA,
						CAB.CODEMP,
						AD_UNIDNEG,
						TIPMOV,
						SUM((ITE.VLRTOT-ITE.VLRDESC)*DECODE(TIPMOV,'D',-1,1)) AS REALIZADO

					FROM TGFCAB CAB
					JOIN TGFITE ITE ON CAB.NUNOTA = ITE.NUNOTA
					JOIN TGFVEN VEN ON VEN.CODVEND = CAB.CODVEND
					JOIN TGFPRO PRO ON ITE.CODPROD = PRO.CODPROD
					JOIN TGFGRU GRU ON PRO.CODGRUPOPROD = GRU.CODGRUPOPROD

						WHERE ((TO_CHAR(CAB.DTFATUR, 'MM') BETWEEN V_MESINI AND V_MESFIM
						AND TO_CHAR(CAB.DTFATUR, 'YYYY') = V_ANO
						AND TIPMOV = 'V')OR
						(TO_CHAR(CAB.DTENTSAI, 'MM') BETWEEN V_MESINI AND V_MESFIM
						AND TO_CHAR(CAB.DTENTSAI, 'YYYY') = V_ANO
						AND TIPMOV = 'D'))
						AND CAB.CODVEND = C2.CODVEND
						AND AD_UNIDNEG = C2.AD_UNIDNEG
						AND ((CAB.TIPMOV = 'D' AND CAB.STATUSNOTA = 'L') OR (CAB.TIPMOV = 'V' AND CAB.STATUSNFE = 'A'))
						AND CAB.CODTIPOPER IN (SELECT CODTIPOPER FROM AD_CENTPARAMTOP WHERE NUPAR = 13)
						AND CAB.CODVEND NOT IN (SELECT CODVEND FROM AD_CENTPARAMVEND WHERE NUPAR = 13)
						and ((CAB.CODVEND BETWEEN PARAM_VENDEDOR AND PARAM_VENDEDORF) OR (PARAM_VENDEDOR IS NULL OR PARAM_VENDEDORF IS NULL))

						GROUP BY AD_UNIDNEG, CAB.CODEMP, TIPMOV, CAB.CODVEND, AD_CODCLASS, CASE WHEN TIPMOV = 'D' THEN TRUNC(DTENTSAI, 'MM')
						ELSE TRUNC(DTFATUR, 'MM') END
						ORDER BY CODEMP, CODVEND, AD_UNIDNEG)

			SELECT CODVEND,
			REFERENCIA,
			CODEMP,
			AD_UNIDNEG,
			REALEMP,
			REALTOT,
			VLRMETA
			FROM
				(
				SELECT CODVEND,
					REFERENCIA,
					CODEMP,
					AD_UNIDNEG,
					SUM(REALIZADO) AS REALEMP,
					(SELECT SUM(REALIZADO)
						FROM DADOS
						WHERE CODVEND = X.CODVEND
						AND AD_UNIDNEG = X.AD_UNIDNEG
						AND REFERENCIA = X.REFERENCIA) AS REALTOT,
					(SELECT VLRMETA
						FROM AD_SEGMENVEND
						WHERE CODVEND = X.CODVEND
						AND PERIODOMES = TO_CHAR(REFERENCIA, 'MM')
						AND PERIODOANO = TO_CHAR(REFERENCIA, 'YYYY')
						AND CODUNIDNEG = X.AD_UNIDNEG) AS VLRMETA
					FROM DADOS X

					GROUP BY X.CODVEND, REFERENCIA, AD_UNIDNEG, CODEMP)A
			WHERE REALTOT < VLRMETA*(SELECT VALOR FROM AD_CENTPARAMVAL WHERE NUPAR = 13)
			ORDER BY CODVEND, AD_UNIDNEG, CODEMP
					)

    LOOP


        V_TIPO := 'S';

		IF (C3.CODVEND > 0)
		THEN
		V_VALORAV :=0;
		V_VALORAV := ROUND(((C2.PERC/100)*C3.REALEMP),2);

		P_COUNT :=0;

		SELECT COUNT(*)
		INTO P_COUNT
		FROM AD_PREMIACAO
		WHERE CODVEND = C3.CODVEND
		  AND REFERENCIA = V_REFERENCIA
		  AND CODEMP = C3.CODEMP
		  AND TIPO = V_TIPO;


			IF (P_COUNT = 0) AND (V_VALORAV > 0) THEN

				INSERT INTO AD_PREMIACAO(CODVEND,
										REFERENCIA,
										CODEMP,
										TIPO,
										VALORAV,
										VALORTOTAL,
										ORIGEM,
										CODUSU,
										DATAINCLUSAO,
										STATUS,
										COMPETENCIAPAGTO,
										VLRMETA,
										VLRREALIZADO
								)
				VALUES (C3.CODVEND,
						V_REFERENCIA,
						C3.CODEMP,
						V_TIPO,
						V_VALORAV,
						V_VALORAV,
						'C',
						0,
						SYSDATE,
						0,
						V_REFERENCIA,
						C2.METATOT,
						C2.REALTOT);

				COMMIT;

				V_CONTADOR := V_CONTADOR + 1;

			ELSE

			SELECT VALORAV
			INTO V_VLRANT
			FROM AD_PREMIACAO
			WHERE CODVEND = C3.CODVEND
			  AND REFERENCIA = V_REFERENCIA
			  AND CODEMP = C3.CODEMP
			  AND TIPO = V_TIPO;

			 V_VLRANT := V_VLRANT + V_VALORAV;


			UPDATE AD_PREMIACAO
			SET VALORAV = V_VLRANT
			WHERE CODVEND = C3.CODVEND
			  AND REFERENCIA = V_REFERENCIA
			  AND CODEMP = C3.CODEMP
			  AND TIPO = V_TIPO;

			COMMIT;

			END IF;
	END IF;
	END LOOP;
    END LOOP;
	END IF;

IF V_CONTADOR = 0 THEN
	P_MENSAGEM := 'Não foi processado nenhum registro, verificar os parametros !';
ELSE
	P_MENSAGEM := 'Processamento efetuado com sucesso, foram processados ['||V_CONTADOR||'] registro(s) !';
END IF;

RETURN;
END;
/