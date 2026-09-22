`timescale 1ns/1ps

module Lectura_Palabra_tb;

    // Entrada de 4 bits
    reg [3:0] datos_i;

    // Salida de 7 segmentos
    wire [6:0] seg_o;

    // Contador de pruebas
    integer pruebas_correctas;
    integer pruebas_fallidas;

    // Instancia del módulo que se va a probar
    Lectura_Palabra DUT (
        .datos_i(datos_i),
        .seg_o(seg_o)
    );

    initial begin

        // Inicializar contadores
        pruebas_correctas = 0;
        pruebas_fallidas = 0;

        $display("==============================================================");
        $display("             TESTBENCH LECTURA_PALABRA");
        $display("==============================================================");
        $display(" BINARIO       HEX       SEGMENTOS [G F E D C B A]");
        $display("--------------------------------------------------------------");

        // ======================================================
        // PRUEBA 0
        // ======================================================

        datos_i = 4'b0000;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        // Para 0 deben estar encendidos A,B,C,D,E,F
        if (seg_o == 7'b0111111)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 1
        // ======================================================

        datos_i = 4'b0001;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        // Para 1 deben estar encendidos B,C
        if (seg_o == 7'b0000110)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 2
        // ======================================================

        datos_i = 4'b0010;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1011011)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 3
        // ======================================================

        datos_i = 4'b0011;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1001111)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 4
        // ======================================================

        datos_i = 4'b0100;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1100110)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 5
        // ======================================================

        datos_i = 4'b0101;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1101101)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 6
        // ======================================================

        datos_i = 4'b0110;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1111101)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 7
        // ======================================================

        datos_i = 4'b0111;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b0000111)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 8
        // ======================================================

        datos_i = 4'b1000;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1111111)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA 9
        // ======================================================

        datos_i = 4'b1001;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1101111)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA A
        // ======================================================

        datos_i = 4'b1010;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1110111)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA B
        // ======================================================

        datos_i = 4'b1011;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1111100)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA C
        // ======================================================

        datos_i = 4'b1100;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b0111001)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA D
        // ======================================================

        datos_i = 4'b1101;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1011110)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA E
        // ======================================================

        datos_i = 4'b1110;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1111001)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;


        // ======================================================
        // PRUEBA F
        // ======================================================

        datos_i = 4'b1111;
        #10;

        $display("  %b           %h           %b", datos_i, datos_i, seg_o);

        if (seg_o == 7'b1110001)
            pruebas_correctas = pruebas_correctas + 1;
        else
            pruebas_fallidas = pruebas_fallidas + 1;

        $display("--------------------------------------------------------------");
        
        $finish;

    end

endmodule