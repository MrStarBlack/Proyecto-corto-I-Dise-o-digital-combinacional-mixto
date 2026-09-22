`timescale 1ns/1ps

module tb_error_correction;

    reg [6:0] hamming_recibido;
    reg [2:0] syndrome;
    reg error_paridad;

    wire [6:0] palabra_corregida;
    wire sec;
    wire ded;

    error_correction dut (
        .hamming_recibido(hamming_recibido),
        .syndrome(syndrome),
        .error_paridad(error_paridad),
        .palabra_corregida(palabra_corregida),
        .sec(sec),
        .ded(ded)
    );

    initial begin

        $dumpfile("error_correction.vcd");
        $dumpvars(0, tb_error_correction);

        $display("");
        $display("============================================================");
        $display("       TESTBENCH - SUBSISTEMA DE CORRECCION SEC-DED");
        $display("============================================================");
        $display("");

        /*
         * ======================================================
         * CASO 1 - SIN ERROR
         * ======================================================
         *
         * Paridad = 0
         * Syndrome = 000
         *
         * No se debe modificar la palabra.
         */

        hamming_recibido = 7'b1010101;
        syndrome = 3'b000;
        error_paridad = 1'b0;

        #10;

        $display("CASO 1 - SIN ERROR");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b0 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * ======================================================
         * CASOS 2-8 - UN ERROR / SEC
         * ======================================================
         *
         * Paridad = 1
         * Syndrome diferente de 000
         *
         * Se debe corregir el bit indicado por el syndrome.
         */


        /*
         * CASO 2 - ERROR EN BIT 1
         * Syndrome = 001
         */

        hamming_recibido = 7'b1010100;
        syndrome = 3'b001;
        error_paridad = 1'b1;

        #10;

        $display("CASO 2 - SEC: ERROR EN BIT 1");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 3 - ERROR EN BIT 2
         * Syndrome = 010
         */

        hamming_recibido = 7'b1010111;
        syndrome = 3'b010;
        error_paridad = 1'b1;

        #10;

        $display("CASO 3 - SEC: ERROR EN BIT 2");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 4 - ERROR EN BIT 3
         * Syndrome = 011
         */

        hamming_recibido = 7'b1010001;
        syndrome = 3'b011;
        error_paridad = 1'b1;

        #10;

        $display("CASO 4 - SEC: ERROR EN BIT 3");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 5 - ERROR EN BIT 4
         * Syndrome = 100
         */

        hamming_recibido = 7'b1011101;
        syndrome = 3'b100;
        error_paridad = 1'b1;

        #10;

        $display("CASO 5 - SEC: ERROR EN BIT 4");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 6 - ERROR EN BIT 5
         * Syndrome = 101
         */

        hamming_recibido = 7'b1000101;
        syndrome = 3'b101;
        error_paridad = 1'b1;

        #10;

        $display("CASO 6 - SEC: ERROR EN BIT 5");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 7 - ERROR EN BIT 6
         * Syndrome = 110
         */

        hamming_recibido = 7'b1110101;
        syndrome = 3'b110;
        error_paridad = 1'b1;

        #10;

        $display("CASO 7 - SEC: ERROR EN BIT 6");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 8 - ERROR EN BIT 7
         * Syndrome = 111
         */

        hamming_recibido = 7'b0010101;
        syndrome = 3'b111;
        error_paridad = 1'b1;

        #10;

        $display("CASO 8 - SEC: ERROR EN BIT 7");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b1 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * ======================================================
         * CASOS 9-15 - DOBLE ERROR / DED
         * ======================================================
         *
         * Paridad = 0
         * Syndrome diferente de 000
         *
         * Se debe detectar DED.
         * La palabra NO se debe modificar.
         */


        /*
         * CASO 9 - DED
         * Syndrome = 001
         */

        hamming_recibido = 7'b1010100;
        syndrome = 3'b001;
        error_paridad = 1'b0;

        #10;

        $display("CASO 9 - DED: SYNDROME 001");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 10 - DED
         * Syndrome = 010
         */

        hamming_recibido = 7'b1010111;
        syndrome = 3'b010;
        error_paridad = 1'b0;

        #10;

        $display("CASO 10 - DED: SYNDROME 010");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 11 - DED
         * Syndrome = 011
         */

        hamming_recibido = 7'b1010001;
        syndrome = 3'b011;
        error_paridad = 1'b0;

        #10;

        $display("CASO 11 - DED: SYNDROME 011");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 12 - DED
         * Syndrome = 100
         */

        hamming_recibido = 7'b1011101;
        syndrome = 3'b100;
        error_paridad = 1'b0;

        #10;

        $display("CASO 12 - DED: SYNDROME 100");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 13 - DED
         * Syndrome = 101
         */

        hamming_recibido = 7'b1000101;
        syndrome = 3'b101;
        error_paridad = 1'b0;

        #10;

        $display("CASO 13 - DED: SYNDROME 101");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 14 - DED
         * Syndrome = 110
         */

        hamming_recibido = 7'b1110101;
        syndrome = 3'b110;
        error_paridad = 1'b0;

        #10;

        $display("CASO 14 - DED: SYNDROME 110");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * CASO 15 - DED
         * Syndrome = 111
         */

        hamming_recibido = 7'b0010101;
        syndrome = 3'b111;
        error_paridad = 1'b0;

        #10;

        $display("CASO 15 - DED: SYNDROME 111");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == hamming_recibido &&
            sec == 1'b0 &&
            ded == 1'b1)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        /*
         * ======================================================
         * CASO 16 - ERROR EN PARIDAD GLOBAL
         * ======================================================
         *
         * Paridad = 1
         * Syndrome = 000
         *
         * El error esta en el bit de paridad global,
         * por lo que los 7 bits Hamming permanecen iguales.
         */

        hamming_recibido = 7'b1010101;
        syndrome = 3'b000;
        error_paridad = 1'b1;

        #10;

        $display("CASO 16 - ERROR EN PARIDAD GLOBAL");
        $display("  Recibida  : %b", hamming_recibido);
        $display("  Syndrome  : %b", syndrome);
        $display("  Paridad   : %b", error_paridad);
        $display("  Corregida : %b", palabra_corregida);
        $display("  SEC       : %b", sec);
        $display("  DED       : %b", ded);

        if (palabra_corregida == 7'b1010101 &&
            sec == 1'b0 &&
            ded == 1'b0)
            $display("  RESULTADO: OK");
        else
            $display("  RESULTADO: ERROR");

        $display("");


        $display("============================================================");
        $display("              FIN DEL TESTBENCH");
        $display("============================================================");

        $finish;

    end

endmodule