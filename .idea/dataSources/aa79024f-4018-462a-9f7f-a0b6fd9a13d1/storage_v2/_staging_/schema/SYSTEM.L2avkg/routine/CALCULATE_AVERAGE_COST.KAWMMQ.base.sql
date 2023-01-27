create PROCEDURE calculate_average_cost
AS
    total_cost NUMBER;
    total_quantity NUMBER;
    average_cost NUMBER;
    cursor c_inventory is
        SELECT dtentsai,vlrtot,qtdneg,estoque_acumulado FROM HVL_MOVIMENTO_ESTOQUE ORDER BY dtentsai;
    v_dtentsai DATE;
    v_vlrtot NUMBER;
    v_qtdneg NUMBER;
    v_estoque_acumulado NUMBER;
BEGIN
    total_cost := 0;
    total_quantity := 0;
    average_cost := 0;

    open c_inventory;
    loop
        fetch c_inventory into v_dtentsai,v_vlrtot,v_qtdneg,v_estoque_acumulado;
        exit when c_inventory%notfound;
        if v_estoque_acumulado = 0 then
            total_cost := 0;
            total_quantity := 0;
            average_cost := 0;
        end if;

        total_cost := total_cost + v_vlrtot;
        total_quantity := total_quantity + v_qtdneg;
        average_cost := total_cost / total_quantity;

        update HVL_MOVIMENTO_ESTOQUE set COLUNA_CALCULO = average_cost where dtentsai = v_dtentsai;
    end loop;
    close c_inventory;
    dbms_output.put_line('Custo médio ponderado calculado com sucesso!');
END;
/

