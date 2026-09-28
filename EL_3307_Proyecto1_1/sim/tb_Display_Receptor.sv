`timescale 1ns/1ps

module tb_Display_Receptor;

    // =================================================
    // SEÑALES DEL TESTBENCH
    // =================================================

    logic [3:0] datos;
    logic       SEC;
    logic       DED;
    logic [2:0] sindrome;
    logic       SWITCH;

    logic [3:0] LED_DATOS;
    logic       LED_SEC;
    logic       LED_DED;

    logic [6:0] display_catodo;
    logic [6:0] display_anodo;


    // =================================================
    // INSTANCIA DEL MODULO A PROBAR
    // =================================================

    Display_Receptor DUT (
        .datos           (datos),
        .SEC             (SEC),
        .DED             (DED),
        .sindrome        (sindrome),
        .SWITCH          (SWITCH),

        .LED_DATOS       (LED_DATOS),
        .LED_SEC         (LED_SEC),
        .LED_DED         (LED_DED),

        .display_catodo  (display_catodo),
        .display_anodo   (display_anodo)
    );


    // =================================================
    // PROCEDIMIENTO PRINCIPAL
    // =================================================

    initial begin

        $display("==============================================");
        $display(" TESTBENCH - DISPLAY_RECEPTOR");
        $display("==============================================");
        $display("");


        // =================================================
        // PRUEBA 1
        // SWITCH OFF
        //
        // Datos = 1011
        // Hexadecimal = B
        //
        // Los displays deben mostrar B.
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b0;
        DED      = 1'b0;
        sindrome = 3'b000;
        SWITCH   = 1'b0;

        #10;

        $display("PRUEBA 1 - SWITCH OFF");
        $display("Datos             : %b", datos);
        $display("Sindrome          : %b", sindrome);
        $display("SWITCH            : %b", SWITCH);
        $display("LED_DATOS         : %b", LED_DATOS);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 2
        // SWITCH ON
        //
        // Sindrome = 101
        // 101 = 5
        //
        // Los displays deben mostrar 5.
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b1;
        DED      = 1'b0;
        sindrome = 3'b101;
        SWITCH   = 1'b1;

        #10;

        $display("PRUEBA 2 - ERROR EN POSICION 5");
        $display("Datos             : %b", datos);
        $display("Sindrome          : %b", sindrome);
        $display("SWITCH            : %b", SWITCH);
        $display("LED_DATOS         : %b", LED_DATOS);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 3
        // SIN ERROR
        //
        // Sindrome = 000
        //
        // Con SWITCH ON se debe mostrar 0.
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b0;
        DED      = 1'b0;
        sindrome = 3'b000;
        SWITCH   = 1'b1;

        #10;

        $display("PRUEBA 3 - SIN ERROR");
        $display("Datos             : %b", datos);
        $display("Sindrome          : %b", sindrome);
        $display("SWITCH            : %b", SWITCH);
        $display("LED_DATOS         : %b", LED_DATOS);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 4
        // ERROR EN POSICION 1
        //
        // Sindrome = 001
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b1;
        DED      = 1'b0;
        sindrome = 3'b001;
        SWITCH   = 1'b1;

        #10;

        $display("PRUEBA 4 - ERROR EN POSICION 1");
        $display("Sindrome          : %b", sindrome);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 5
        // ERROR EN POSICION 2
        //
        // Sindrome = 010
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b1;
        DED      = 1'b0;
        sindrome = 3'b010;
        SWITCH   = 1'b1;

        #10;

        $display("PRUEBA 5 - ERROR EN POSICION 2");
        $display("Sindrome          : %b", sindrome);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 6
        // ERROR EN POSICION 7
        //
        // Sindrome = 111
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b1;
        DED      = 1'b0;
        sindrome = 3'b111;
        SWITCH   = 1'b1;

        #10;

        $display("PRUEBA 6 - ERROR EN POSICION 7");
        $display("Sindrome          : %b", sindrome);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 7
        // DOBLE ERROR
        //
        // DED = 1
        //
        // Los displays deben mostrar E.
        // LED_DED debe encenderse.
        // =================================================

        datos    = 4'b1011;
        SEC      = 1'b0;
        DED      = 1'b1;
        sindrome = 3'b101;
        SWITCH   = 1'b1;

        #10;

        $display("PRUEBA 7 - DOBLE ERROR");
        $display("Datos             : %b", datos);
        $display("Sindrome          : %b", sindrome);
        $display("SWITCH            : %b", SWITCH);
        $display("LED_DATOS         : %b", LED_DATOS);
        $display("LED_SEC           : %b", LED_SEC);
        $display("LED_DED           : %b", LED_DED);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 8
        // OTRO DATO
        //
        // Datos = 0101
        // Hexadecimal = 5
        //
        // SWITCH OFF
        // =================================================

        datos    = 4'b0101;
        SEC      = 1'b0;
        DED      = 1'b0;
        sindrome = 3'b000;
        SWITCH   = 1'b0;

        #10;

        $display("PRUEBA 8 - DATO 0101");
        $display("Datos             : %b", datos);
        $display("SWITCH            : %b", SWITCH);
        $display("LED_DATOS         : %b", LED_DATOS);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // PRUEBA 9
        // OTRO DATO
        //
        // Datos = 1111
        // Hexadecimal = F
        // =================================================

        datos    = 4'b1111;
        SEC      = 1'b0;
        DED      = 1'b0;
        sindrome = 3'b000;
        SWITCH   = 1'b0;

        #10;

        $display("PRUEBA 9 - DATO 1111");
        $display("Datos             : %b", datos);
        $display("SWITCH            : %b", SWITCH);
        $display("LED_DATOS         : %b", LED_DATOS);
        $display("Display Catodo    : %b", display_catodo);
        $display("Display Anodo     : %b", display_anodo);
        $display("");


        // =================================================
        // FINAL
        // =================================================

        $display("==============================================");
        $display(" FIN DEL TESTBENCH");
        $display("==============================================");

        #10;

        $finish;

    end

endmodule

