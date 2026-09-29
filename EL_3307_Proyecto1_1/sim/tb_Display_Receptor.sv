`timescale 1ns/1ps

module tb_Display_Receptor;


    logic [3:0] datos;
    logic       SEC;
    logic       DED;
    logic [2:0] sindrome;
    logic       SWITCH;

    logic [3:0] LED_DATOS;
    logic       LED_SEC;
    logic       LED_DED;

    // Display de catodo
    logic catodo_a;
    logic catodo_b;
    logic catodo_c;
    logic catodo_d;
    logic catodo_e;
    logic catodo_f;
    logic catodo_g;

    // Display de anodo
    logic anodo_a;
    logic anodo_b;
    logic anodo_c;
    logic anodo_d;
    logic anodo_e;
    logic anodo_f;
    logic anodo_g;

    // =================================================
    // INSTANCIA DEL MODULO A PROBAR
    // =================================================

    Display_Receptor DUT (
        .datos       (datos),
        .SEC         (SEC),
        .DED         (DED),
        .sindrome    (sindrome),
        .SWITCH      (SWITCH),

        .LED_DATOS   (LED_DATOS),
        .LED_SEC     (LED_SEC),
        .LED_DED     (LED_DED),

        .catodo_a    (catodo_a),
        .catodo_b    (catodo_b),
        .catodo_c    (catodo_c),
        .catodo_d    (catodo_d),
        .catodo_e    (catodo_e),
        .catodo_f    (catodo_f),
        .catodo_g    (catodo_g),

        .anodo_a     (anodo_a),
        .anodo_b     (anodo_b),
        .anodo_c     (anodo_c),
        .anodo_d     (anodo_d),
        .anodo_e     (anodo_e),
        .anodo_f     (anodo_f),
        .anodo_g     (anodo_g)
    );


    // =================================================
    // PROCEDIMIENTO PRINCIPAL
    // =================================================

    initial begin

        $dumpfile("Display_Receptor.vcd");
        $dumpvars(0, tb_Display_Receptor);


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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

        $display("");


        // =================================================
        // PRUEBA 2
        // SWITCH ON
        //
        // Sindrome = 101
        // 101 = 5
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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

        $display("");


        // =================================================
        // PRUEBA 3
        // SIN ERROR
        //
        // Sindrome = 000
        // SWITCH ON -> muestra 0
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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

        $display("");


        // =================================================
        // PRUEBA 7
        // DOBLE ERROR
        //
        // DED = 1
        // Debe mostrar E = 1110
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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

        $display("");


        // =================================================
        // PRUEBA 8
        // OTRO DATO
        //
        // Datos = 0101
        // Hexadecimal = 5
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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

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

        $display("Catodo            : %b%b%b%b%b%b%b",
                 catodo_a, catodo_b, catodo_c,
                 catodo_d, catodo_e, catodo_f, catodo_g);

        $display("Anodo             : %b%b%b%b%b%b%b",
                 anodo_a, anodo_b, anodo_c,
                 anodo_d, anodo_e, anodo_f, anodo_g);

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

