`timescale 1ns/1ps

module tb_Correccion_error;

    // =================================================
    // ENTRADAS DEL MODULO
    // =================================================

    logic [6:0] palabra_hamming;
    logic       ERROR_PARIDAD;
    logic [2:0] sindrome;

    // =================================================
    // SALIDAS DEL MODULO
    // =================================================

    logic [6:0] palabra_corregida;
    logic [3:0] datos;
    logic       SEC;
    logic       DED;


    // =================================================
    // INSTANCIA DEL MODULO A PROBAR
    // =================================================

    Correccion_error DUT (
        .palabra_hamming   (palabra_hamming),
        .ERROR_PARIDAD     (ERROR_PARIDAD),
        .sindrome          (sindrome),
        .palabra_corregida (palabra_corregida),
        .datos             (datos),
        .SEC               (SEC),
        .DED               (DED)
    );


    // =================================================
    // PROCEDIMIENTO DE PRUEBA
    // =================================================

    initial begin

        $display("==============================================");
        $display(" TESTBENCH - CORRECCION_ERROR");
        $display("==============================================");
        $display("");


        // =================================================
        // PRUEBA 1
        // SIN ERROR
        //
        // El síndrome ya fue calculado por el módulo
        // Determinacion_Sindrome.
        //
        // Sindrome = 000
        // ERROR_PARIDAD = 0
        //
        // No se debe modificar la palabra.
        // =================================================

        palabra_hamming = 7'b0110011;
        sindrome        = 3'b000;
        ERROR_PARIDAD   = 1'b0;

        #10;

        $display("PRUEBA 1 - SIN ERROR");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("Datos             : %b", datos);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 2
        // CORRECCION DEL BIT 1
        //
        // El síndrome YA viene calculado:
        //
        // Sindrome = 001
        //
        // El módulo solamente debe utilizarlo para
        // realizar la corrección.
        // =================================================

        palabra_hamming = 7'b1110011;
        sindrome        = 3'b001;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 2 - CORRECCION BIT 1");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 3
        // CORRECCION DEL BIT 2
        //
        // Sindrome = 010
        // =================================================

        palabra_hamming = 7'b0010011;
        sindrome        = 3'b010;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 3 - CORRECCION BIT 2");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 4
        // CORRECCION DEL BIT 3
        //
        // Sindrome = 011
        // =================================================

        palabra_hamming = 7'b0100011;
        sindrome        = 3'b011;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 4 - CORRECCION BIT 3");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 5
        // CORRECCION DEL BIT 4
        //
        // Sindrome = 100
        // =================================================

        palabra_hamming = 7'b0111011;
        sindrome        = 3'b100;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 5 - CORRECCION BIT 4");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 6
        // CORRECCION DEL BIT 5
        //
        // EJEMPLO PRINCIPAL DEL PROYECTO
        //
        // Original:
        // 0110011
        //
        // Recibido:
        // 0110111
        //
        // El modulo de sindrome ya determino:
        // 101
        //
        // Correcion_error solamente realiza:
        // inversion del bit correspondiente.
        //
        // Resultado esperado:
        // 0110011
        // =================================================

        palabra_hamming = 7'b0110111;
        sindrome        = 3'b101;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 6 - CORRECCION BIT 5");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("Datos             : %b", datos);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 7
        // CORRECCION DEL BIT 6
        //
        // Sindrome = 110
        // =================================================

        palabra_hamming = 7'b0110001;
        sindrome        = 3'b110;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 7 - CORRECCION BIT 6");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 8
        // CORRECCION DEL BIT 7
        //
        // Sindrome = 111
        // =================================================

        palabra_hamming = 7'b0110010;
        sindrome        = 3'b111;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 8 - CORRECCION BIT 7");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 9
        // ERROR EN PARIDAD GLOBAL
        //
        // El síndrome es 000.
        //
        // No existe un bit Hamming que corregir.
        // =================================================

        palabra_hamming = 7'b0110011;
        sindrome        = 3'b000;
        ERROR_PARIDAD   = 1'b1;

        #10;

        $display("PRUEBA 9 - ERROR DE PARIDAD GLOBAL");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // PRUEBA 10
        // DOBLE ERROR
        //
        // El síndrome YA fue calculado.
        //
        // ERROR_PARIDAD = 0
        // Sindrome != 000
        //
        // El módulo NO debe utilizar el síndrome para
        // realizar una corrección porque se trata de DED.
        // =================================================

        palabra_hamming = 7'b0110101;
        sindrome        = 3'b101;
        ERROR_PARIDAD   = 1'b0;

        #10;

        $display("PRUEBA 10 - DOBLE ERROR");
        $display("Palabra recibida  : %b", palabra_hamming);
        $display("Sindrome recibido : %b", sindrome);
        $display("Palabra corregida : %b", palabra_corregida);
        $display("Datos             : %b", datos);
        $display("SEC               : %b", SEC);
        $display("DED               : %b", DED);
        $display("");


        // =================================================
        // FIN DE LA SIMULACION
        // =================================================

        $display("==============================================");
        $display(" FIN DEL TESTBENCH");
        $display("==============================================");

        #10;

        $finish;

    end

endmodule

