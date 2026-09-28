
`timescale 1ns/1ps

module TB_Determinacion_Sindrome;

    // Entrada al módulo
    logic [6:0] palabra_hamming;

    // Salidas del módulo
    logic S1;
    logic S2;
    logic S4;
    logic [2:0] sindrome;

    // Instancia del módulo bajo prueba
    Determinacion_Sindrome DUT (
        .palabra_hamming(palabra_hamming),
        .S1(S1),
        .S2(S2),
        .S4(S4),
        .sindrome(sindrome)
    );

    // Pruebas
    initial begin

        $display("==============================================");
        $display(" TESTBENCH - DETERMINACION DE SINDROME");
        $display("==============================================");

        // -------------------------------------------------
        // Caso 1: Palabra correcta
        // 0110011
        // Sindrome esperado: 000
        // -------------------------------------------------
        palabra_hamming = 7'b0110011;
        #10;

        $display("Caso 1: Sin error");
        $display("Palabra: %b | S1=%b S2=%b S4=%b | Sindrome=%b",
                 palabra_hamming, S1, S2, S4, sindrome);

        if (sindrome == 3'b000)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 2: Error en posicion 1
        // -------------------------------------------------
        palabra_hamming = 7'b1110011;
        #10;

        $display("Caso 2: Error en posicion 1");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b001)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 3: Error en posicion 2
        // -------------------------------------------------
        palabra_hamming = 7'b0010011;
        #10;

        $display("Caso 3: Error en posicion 2");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b010)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 4: Error en posicion 3
        // -------------------------------------------------
        palabra_hamming = 7'b0100011;
        #10;

        $display("Caso 4: Error en posicion 3");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b011)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 5: Error en posicion 4
        // -------------------------------------------------
        palabra_hamming = 7'b0111011;
        #10;

        $display("Caso 5: Error en posicion 4");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b100)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 6: Error en posicion 5
        // -------------------------------------------------
        palabra_hamming = 7'b0100111;
        #10;

        $display("Caso 6: Error en posicion 5");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b101)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 7: Error en posicion 6
        // -------------------------------------------------
        palabra_hamming = 7'b0110111;
        #10;

        $display("Caso 7: Error en posicion 6");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b110)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        // -------------------------------------------------
        // Caso 8: Error en posicion 7
        // -------------------------------------------------
        palabra_hamming = 7'b0110010;
        #10;

        $display("Caso 8: Error en posicion 7");
        $display("Palabra: %b | Sindrome=%b",
                 palabra_hamming, sindrome);

        if (sindrome == 3'b111)
            $display("RESULTADO: CORRECTO");
        else
            $display("RESULTADO: ERROR");

        $display("==============================================");
        $display(" FIN DE LAS PRUEBAS");
        $display("==============================================");

        $finish;
    end

endmodule

