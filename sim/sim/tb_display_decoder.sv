`timescale 1ns/1ps

module tb_display_decoder;

    // ==========================================
    // ENTRADAS
    // ==========================================

    reg [6:0] palabra_corregida;
    reg [2:0] syndrome;
    reg ded;
    reg switch_display;

    // ==========================================
    // SALIDAS
    // ==========================================

    wire [6:0] leds;
    wire [6:0] segmentos;

    // ==========================================
    // VARIABLES DE PRUEBA
    // ==========================================

    integer hex_value;
    integer syndrome_value;
    integer switch_value;
    integer ded_value;

    integer pruebas;
    integer errores;

    reg [3:0] dato;
    reg [6:0] segmentos_esperados;
    reg [6:0] leds_esperados;


    // ==========================================
    // MODULO BAJO PRUEBA
    // ==========================================

    display_decoder DUT (
        .palabra_corregida(palabra_corregida),
        .syndrome(syndrome),
        .ded(ded),
        .switch_display(switch_display),
        .leds(leds),
        .segmentos(segmentos)
    );


    // ==========================================
    // VALORES ESPERADOS DEL DISPLAY
    //
    // segmentos[6:0] = G F E D C B A
    //
    // DISPLAY DE ANODO COMUN
    //
    // 0 = ENCENDIDO
    // 1 = APAGADO
    // ==========================================

    function [6:0] segmentos_hex;

        input [3:0] valor;

        begin

            case (valor)

                4'h0: segmentos_hex = 7'b1000000;
                4'h1: segmentos_hex = 7'b1111001;
                4'h2: segmentos_hex = 7'b0100100;
                4'h3: segmentos_hex = 7'b0110000;
                4'h4: segmentos_hex = 7'b0011001;
                4'h5: segmentos_hex = 7'b0010010;
                4'h6: segmentos_hex = 7'b0000010;
                4'h7: segmentos_hex = 7'b1111000;
                4'h8: segmentos_hex = 7'b0000000;
                4'h9: segmentos_hex = 7'b0010000;
                4'hA: segmentos_hex = 7'b0001000;
                4'hB: segmentos_hex = 7'b0000011;
                4'hC: segmentos_hex = 7'b1000110;
                4'hD: segmentos_hex = 7'b0100001;
                4'hE: segmentos_hex = 7'b0000110;
                4'hF: segmentos_hex = 7'b0001110;

                default:
                    segmentos_hex = 7'b1111111;

            endcase

        end

    endfunction


    // ==========================================
    // INICIO DE LA SIMULACION
    // ==========================================

    initial begin

        pruebas = 0;
        errores = 0;

        palabra_corregida = 7'b0000000;
        syndrome = 3'b000;
        ded = 1'b0;
        switch_display = 1'b0;

        #10;




        // ==================================================
        // PRUEBA 1
        // 16 VALORES HEXADECIMALES
        // SWITCH = 0
        // DED = 0
        // ==================================================

        $display("-----------------------------------------------");
        $display("PRUEBA 1: VALORES HEXADECIMALES");
        $display("-----------------------------------------------");

        for (hex_value = 0;
             hex_value < 16;
             hex_value = hex_value + 1) begin

            dato = hex_value;

            // ------------------------------------------
            // Construir palabra Hamming
            //
            // H1 H2 D1 H4 D2 D3 D4
            //
            // bit 0 = H1
            // bit 1 = H2
            // bit 2 = D1
            // bit 3 = H4
            // bit 4 = D2
            // bit 5 = D3
            // bit 6 = D4
            // ------------------------------------------

            palabra_corregida[0] = 1'b0;
            palabra_corregida[1] = 1'b0;

            palabra_corregida[2] = dato[0];

            palabra_corregida[3] = 1'b0;

            palabra_corregida[4] = dato[1];
            palabra_corregida[5] = dato[2];
            palabra_corregida[6] = dato[3];

            syndrome = 3'b000;
            switch_display = 1'b0;
            ded = 1'b0;

            #1;

            segmentos_esperados = segmentos_hex(dato);

            pruebas = pruebas + 1;

            if (segmentos !== segmentos_esperados) begin

                errores = errores + 1;

                $display(
                    "ERROR HEX %h | Esperado=%b | Obtenido=%b",
                    dato,
                    segmentos_esperados,
                    segmentos
                );

            end
            else begin

                $display(
                    "OK HEX %h | Segmentos=%b",
                    dato,
                    segmentos
                );

            end

        end



        // ==================================================
        // PRUEBA 2
        // 8 SINDROMES
        // SWITCH = 1
        // DED = 0
        // ==================================================

        $display("");
        $display("-----------------------------------------------");
        $display("PRUEBA 2: 8 SINDROMES");
        $display("-----------------------------------------------");

        for (syndrome_value = 0;
             syndrome_value < 8;
             syndrome_value = syndrome_value + 1) begin

            syndrome = syndrome_value;

            switch_display = 1'b1;

            ded = 1'b0;

            palabra_corregida = 7'b0000000;

            #1;

            segmentos_esperados =
                segmentos_hex(syndrome_value);

            pruebas = pruebas + 1;

            if (segmentos !== segmentos_esperados) begin

                errores = errores + 1;

                $display(
                    "ERROR SYNDROME %03b | Esperado=%b | Obtenido=%b",
                    syndrome,
                    segmentos_esperados,
                    segmentos
                );

            end
            else begin

                $display(
                    "OK SYNDROME %03b | Segmentos=%b",
                    syndrome,
                    segmentos
                );

            end

        end



        // ==================================================
        // PRUEBA 3
        // AMBOS ESTADOS DEL SWITCH
        //
        // Se utiliza un mismo dato y un síndrome
        // diferente para comprobar que realmente
        // cambia lo mostrado.
        // ==================================================

        $display("");
        $display("-----------------------------------------------");
        $display("PRUEBA 3: SWITCH OFF / ON");
        $display("-----------------------------------------------");


        // ------------------------------------------
        // DATO = A
        // SYNDROME = 5
        // ------------------------------------------

        dato = 4'hA;

        palabra_corregida[0] = 1'b0;
        palabra_corregida[1] = 1'b0;
        palabra_corregida[2] = dato[0];
        palabra_corregida[3] = 1'b0;
        palabra_corregida[4] = dato[1];
        palabra_corregida[5] = dato[2];
        palabra_corregida[6] = dato[3];

        syndrome = 3'b101;

        ded = 1'b0;


        // ------------------------------------------
        // SWITCH = 0
        // Debe mostrar A
        // ------------------------------------------

        switch_display = 1'b0;

        #1;

        segmentos_esperados = segmentos_hex(4'hA);

        pruebas = pruebas + 1;

        if (segmentos !== segmentos_esperados) begin

            errores = errores + 1;

            $display(
                "ERROR SWITCH=0 | Esperado A | Obtenido=%b",
                segmentos
            );

        end
        else begin

            $display(
                "OK SWITCH=0 | Mostrando A | %b",
                segmentos
            );

        end


        // ------------------------------------------
        // SWITCH = 1
        // Debe mostrar 5
        // ------------------------------------------

        switch_display = 1'b1;

        #1;

        segmentos_esperados = segmentos_hex(4'h5);

        pruebas = pruebas + 1;

        if (segmentos !== segmentos_esperados) begin

            errores = errores + 1;

            $display(
                "ERROR SWITCH=1 | Esperado 5 | Obtenido=%b",
                segmentos
            );

        end
        else begin

            $display(
                "OK SWITCH=1 | Mostrando 5 | %b",
                segmentos
            );

        end



        // ==================================================
        // PRUEBA 4
        // DED = 0
        // ==================================================

        $display("");
        $display("-----------------------------------------------");
        $display("PRUEBA 4: DED = 0");
        $display("-----------------------------------------------");

        ded = 1'b0;

        #1;

        pruebas = pruebas + 1;

        if (leds[6] !== 1'b0) begin

            errores = errores + 1;

            $display(
                "ERROR DED=0 | LED DED esperado=0 | obtenido=%b",
                leds[6]
            );

        end
        else begin

            $display(
                "OK DED=0 | LED DED=%b",
                leds[6]
            );

        end



        // ==================================================
        // PRUEBA 5
        // DED = 1
        // ==================================================

        $display("");
        $display("-----------------------------------------------");
        $display("PRUEBA 5: DED = 1");
        $display("-----------------------------------------------");

        ded = 1'b1;

        #1;

        pruebas = pruebas + 1;

        if (leds[6] !== 1'b1) begin

            errores = errores + 1;

            $display(
                "ERROR DED=1 | LED DED esperado=1 | obtenido=%b",
                leds[6]
            );

        end
        else begin

            $display(
                "OK DED=1 | LED DED=%b",
                leds[6]
            );

        end



        // ==================================================
        // PRUEBA 6
        // COMPROBAR LOS 7 LEDS
        // ==================================================

        $display("");
        $display("-----------------------------------------------");
        $display("PRUEBA 6: LEDS DE LA FPGA");
        $display("-----------------------------------------------");

        palabra_corregida = 7'b1010101;

        ded = 1'b0;

        switch_display = 1'b0;

        #1;

        leds_esperados = 7'b0010101;

        pruebas = pruebas + 1;

        if (leds !== leds_esperados) begin

            errores = errores + 1;

            $display(
                "ERROR LEDS | Esperado=%b | Obtenido=%b",
                leds_esperados,
                leds
            );

        end
        else begin

            $display(
                "OK LEDS | Valor=%b",
                leds
            );

        end



        // ==================================================
        // PRUEBA 7
        // DED CON DIFERENTES VALORES
        // ==================================================

        $display("");
        $display("-----------------------------------------------");
        $display("PRUEBA 7: DED CON LOS DOS ESTADOS");
        $display("-----------------------------------------------");


        for (ded_value = 0;
             ded_value < 2;
             ded_value = ded_value + 1) begin

            ded = ded_value;

            #1;

            pruebas = pruebas + 1;

            if (leds[6] !== ded) begin

                errores = errores + 1;

                $display(
                    "ERROR DED=%b | LED=%b",
                    ded,
                    leds[6]
                );

            end
            else begin

                $display(
                    "OK DED=%b | LED=%b",
                    ded,
                    leds[6]
                );

            end

        end



        // ==================================================
        // RESULTADO FINAL
        // ==================================================

        $display("");
        $display("================================================");
        $display(" RESULTADO FINAL");
        $display("================================================");

        $display(
            "Cantidad de pruebas: %0d",
            pruebas
        );

        $display(
            "Cantidad de errores: %0d",
            errores
        );

        $display("");


        if (errores == 0) begin

            $display("****************************************");
            $display("*Pasaron*");
            $display("****************************************");

        end
        else begin

            $display("****************************************");
            $display("* SE ENCONTRARON ERRORES               *");
            $display("****************************************");

        end

        $display("");

        $finish;

    end



    // ==================================================
    // GENERAR ARCHIVO VCD
    // ==================================================

    initial begin

        $dumpfile("tb_display_decoder.vcd");

        $dumpvars(0, tb_display_decoder);

    end

endmodule