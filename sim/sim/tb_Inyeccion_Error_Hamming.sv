`timescale 1ns/1ps

module tb_Inyeccion_Error_Hamming;

    // =========================================================
    // ENTRADAS
    // =========================================================

    logic [3:0] datos_i;

    logic I1_i;
    logic I2_i;
    logic I3_i;

    logic [2:0] err1_pos_i;
    logic [2:0] err2_pos_i;

    logic error_P_i;


    // =========================================================
    // SALIDAS
    // =========================================================

    wire D0_o;
    wire D1_o;
    wire D2_o;
    wire D3_o;

    wire I1_o;
    wire I2_o;
    wire I3_o;

    wire P_o;


    // =========================================================
    // PALABRA HAMMING DE SALIDA
    //
    // [7] = P
    // [6] = I3
    // [5] = I2
    // [4] = I1
    // [3] = D3
    // [2] = D2
    // [1] = D1
    // [0] = D0
    // =========================================================

    wire [7:0] palabra_salida;

    assign palabra_salida = {
        P_o,
        I3_o,
        I2_o,
        I1_o,
        D3_o,
        D2_o,
        D1_o,
        D0_o
    };


    // =========================================================
    // INSTANCIA DEL MODULO
    // =========================================================

    Inyeccion_Error_Hamming uut (

        .datos_i(datos_i),

        .I1_i(I1_i),
        .I2_i(I2_i),
        .I3_i(I3_i),

        .err1_pos_i(err1_pos_i),
        .err2_pos_i(err2_pos_i),

        .error_P_i(error_P_i),

        .D0_o(D0_o),
        .D1_o(D1_o),
        .D2_o(D2_o),
        .D3_o(D3_o),

        .I1_o(I1_o),
        .I2_o(I2_o),
        .I3_o(I3_o),

        .P_o(P_o)
    );


    // =========================================================
    // CONTADORES DE PRUEBAS
    // =========================================================

    integer pruebas_totales;
    integer pruebas_correctas;


    // =========================================================
    // TAREA DE PRUEBA
    // =========================================================

    task automatic probar;

        input logic [3:0] dato;
        input logic [2:0] error1;
        input logic [2:0] error2;
        input logic errorP;

        logic i1_esperado;
        logic i2_esperado;
        logic i3_esperado;

        logic [7:0] palabra_base;
        logic [7:0] mascara1;
        logic [7:0] mascara2;
        logic [7:0] palabra_esperada;

        begin

            // -------------------------------------------------
            // DATOS DE ENTRADA
            // -------------------------------------------------

            datos_i = dato;

            err1_pos_i = error1;
            err2_pos_i = error2;

            error_P_i = errorP;


            // -------------------------------------------------
            // CALCULO DE PARIDADES
            // -------------------------------------------------

            i1_esperado = dato[0] ^ dato[1] ^ dato[3];

            i2_esperado = dato[0] ^ dato[2] ^ dato[3];

            i3_esperado = dato[1] ^ dato[2] ^ dato[3];


            I1_i = i1_esperado;
            I2_i = i2_esperado;
            I3_i = i3_esperado;


            // Esperar propagacion combinacional

            #10;


            // -------------------------------------------------
            // PALABRA BASE
            // -------------------------------------------------

            palabra_base = {
                i1_esperado ^ i2_esperado ^ i3_esperado,
                i3_esperado,
                i2_esperado,
                i1_esperado,
                dato[3],
                dato[2],
                dato[1],
                dato[0]
            };


            // -------------------------------------------------
            // MASCARA ERROR 1
            // -------------------------------------------------

            case (error1)

                3'b000: mascara1 = 8'b00000000;
                3'b001: mascara1 = 8'b00000001;
                3'b010: mascara1 = 8'b00000010;
                3'b011: mascara1 = 8'b00000100;
                3'b100: mascara1 = 8'b00001000;
                3'b101: mascara1 = 8'b00010000;
                3'b110: mascara1 = 8'b00100000;
                3'b111: mascara1 = 8'b01000000;

                default: mascara1 = 8'b00000000;

            endcase


            // -------------------------------------------------
            // MASCARA ERROR 2
            // -------------------------------------------------

            case (error2)

                3'b000: mascara2 = 8'b00000000;
                3'b001: mascara2 = 8'b00000001;
                3'b010: mascara2 = 8'b00000010;
                3'b011: mascara2 = 8'b00000100;
                3'b100: mascara2 = 8'b00001000;
                3'b101: mascara2 = 8'b00010000;
                3'b110: mascara2 = 8'b00100000;
                3'b111: mascara2 = 8'b01000000;

                default: mascara2 = 8'b00000000;

            endcase


            // -------------------------------------------------
            // PALABRA ESPERADA
            // -------------------------------------------------

            palabra_esperada =
                palabra_base ^
                mascara1 ^
                mascara2;

            palabra_esperada[7] =
                palabra_esperada[7] ^ errorP;


            // -------------------------------------------------
            // MOSTRAR PRUEBA
            // -------------------------------------------------

            pruebas_totales = pruebas_totales + 1;

            $display("");
            $display("------------------------------------------------------------");

            $display("PRUEBA #%0d", pruebas_totales);

            $display("Datos       : %04b", dato);

            $display("I1 I2 I3    : %b %b %b",
                     i1_esperado,
                     i2_esperado,
                     i3_esperado);

            $display("Error 1     : %03b", error1);

            $display("Error 2     : %03b", error2);

            $display("Error P     : %b", errorP);

            $display("Base        : %08b  HEX: %02h",
                     palabra_base,
                     palabra_base);

            $display("Esperada    : %08b  HEX: %02h",
                     palabra_esperada,
                     palabra_esperada);

            $display("Salida      : %08b  HEX: %02h",
                     palabra_salida,
                     palabra_salida);


            // -------------------------------------------------
            // VERIFICACION
            // -------------------------------------------------

            if (palabra_salida === palabra_esperada) begin

                $display("RESULTADO   : OK");

                pruebas_correctas =
                    pruebas_correctas + 1;

            end
            else begin

                $display("RESULTADO   : ERROR");

                $display("Diferencia  : %08b",
                         palabra_salida ^ palabra_esperada);

            end

        end

    endtask


    // =========================================================
    // INICIO DE SIMULACION
    // =========================================================

    initial begin

        pruebas_totales = 0;
        pruebas_correctas = 0;


        // =====================================================
        // VCD
        // =====================================================

        $dumpfile("Inyeccion_Error_Hamming.vcd");
        $dumpvars(0, tb_Inyeccion_Error_Hamming);


        // =====================================================
        // ENCABEZADO
        // =====================================================

        $display("");
        $display("============================================================");
        $display("       TESTBENCH INYECCION DE ERROR HAMMING");
        $display("============================================================");

        $display("");
        $display("Formato:");
        $display("[P I3 I2 I1 D3 D2 D1 D0]");

        $display("");
        $display("Codigos de error:");
        $display("000 = Sin error");
        $display("001 = D0");
        $display("010 = D1");
        $display("011 = D2");
        $display("100 = D3");
        $display("101 = I1");
        $display("110 = I2");
        $display("111 = I3");


        // =====================================================
        // 1. SIN ERROR
        // =====================================================

        probar(
            4'b0000,
            3'b000,
            3'b000,
            1'b0
        );


        // =====================================================
        // 2. DATO 1010 SIN ERROR
        // =====================================================

        probar(
            4'b1010,
            3'b000,
            3'b000,
            1'b0
        );


        // =====================================================
        // 3. ERROR D0
        // =====================================================

        probar(
            4'b1010,
            3'b001,
            3'b000,
            1'b0
        );


        // =====================================================
        // 4. ERROR D1
        // =====================================================

        probar(
            4'b1010,
            3'b010,
            3'b000,
            1'b0
        );


        // =====================================================
        // 5. ERROR D2
        // =====================================================

        probar(
            4'b1010,
            3'b011,
            3'b000,
            1'b0
        );


        // =====================================================
        // 6. ERROR D3
        // =====================================================

        probar(
            4'b1010,
            3'b100,
            3'b000,
            1'b0
        );


        // =====================================================
        // 7. ERROR I1
        // =====================================================

        probar(
            4'b1010,
            3'b101,
            3'b000,
            1'b0
        );


        // =====================================================
        // 8. ERROR I2
        // =====================================================

        probar(
            4'b1010,
            3'b110,
            3'b000,
            1'b0
        );


        // =====================================================
        // 9. ERROR I3
        // =====================================================

        probar(
            4'b1010,
            3'b111,
            3'b000,
            1'b0
        );


        // =====================================================
        // 10. ERROR EN P
        // =====================================================

        probar(
            4'b1010,
            3'b000,
            3'b000,
            1'b1
        );


        // =====================================================
        // 11. DOS ERRORES: D0 + D1
        // =====================================================

        probar(
            4'b1010,
            3'b001,
            3'b010,
            1'b0
        );


        // =====================================================
        // 12. DOS ERRORES: I1 + I2
        // =====================================================

        probar(
            4'b1010,
            3'b101,
            3'b110,
            1'b0
        );


        // =====================================================
        // 13. DOS ERRORES + P
        // =====================================================

        probar(
            4'b1010,
            3'b011,
            3'b111,
            1'b1
        );


        // =====================================================
        // 14. OTRA PALABRA
        // =====================================================

        probar(
            4'b1111,
            3'b001,
            3'b100,
            1'b0
        );

        probar(
            4'b0101,
            3'b101,
            3'b000,
            1'b1
        );

        probar(
            4'b1100,
            3'b000,
            3'b111,
            1'b1
        );

        $display("");
        $display("============================================================");
        $display("                    RESUMEN FINAL");

        $display("Pruebas realizadas : %0d",
                 pruebas_totales);

        $display("Pruebas correctas  : %0d",
                 pruebas_correctas);

        $display("Pruebas con error  : %0d",
                 pruebas_totales - pruebas_correctas);

        if (pruebas_totales == pruebas_correctas) begin

            $display("");
            $display("******** TODAS LAS PRUEBAS PASARON ********");

        end
        else begin

            $display("");
            $display("******** HAY PRUEBAS CON ERROR ********");

        end

        $display("============================================================");
        $display("");


        $finish;

    end

endmodule