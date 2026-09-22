`timescale 1ns/1ps

module tb_syndrome_decoder;

    reg [6:0] hamming_recibido;

    wire [2:0] syndrome;

    syndrome_decoder dut (
        .hamming_recibido(hamming_recibido),
        .syndrome(syndrome)
    );

    initial begin

        $dumpfile("syndrome_decoder.vcd");
        $dumpvars(0, tb_syndrome_decoder);

        $display("==========================================");
        $display("TESTBENCH - DECODIFICADOR DE SINDROME");

        // ======================================
        // Sin error
        // ======================================

        hamming_recibido = 7'b0000000;
        #10;

        if (syndrome == 3'b000)
            $display("OK: 0000000 -> Sindrome 000");
        else
            $display("ERROR: 0000000");


        // ======================================
        // Error en posición 1
        // ======================================

        hamming_recibido = 7'b0000001;
        #10;

        if (syndrome == 3'b001)
            $display("OK: 0000001 -> Sindrome 001");
        else
            $display("ERROR: 0000001");


        // ======================================
        // Error en posición 2
        // ======================================

        hamming_recibido = 7'b0000010;
        #10;

        if (syndrome == 3'b010)
            $display("OK: 0000010 -> Sindrome 010");
        else
            $display("ERROR: 0000010");


        // ======================================
        // Error en posición 3
        // ======================================

        hamming_recibido = 7'b0000100;
        #10;

        if (syndrome == 3'b011)
            $display("OK: 0000100 -> Sindrome 011");
        else
            $display("ERROR: 0000100");


        // ======================================
        // Error en posición 4
        // ======================================

        hamming_recibido = 7'b0001000;
        #10;

        if (syndrome == 3'b100)
            $display("OK: 0001000 -> Sindrome 100");
        else
            $display("ERROR: 0001000");


        // ======================================
        // Error en posición 5
        // ======================================

        hamming_recibido = 7'b0010000;
        #10;

        if (syndrome == 3'b101)
            $display("OK: 0010000 -> Sindrome 101");
        else
            $display("ERROR: 0010000");


        // ======================================
        // Error en posición 6
        // ======================================

        hamming_recibido = 7'b0100000;
        #10;

        if (syndrome == 3'b110)
            $display("OK: 0100000 -> Sindrome 110");
        else
            $display("ERROR: 0100000");


        // ======================================
        // Error en posición 7
        // ======================================

        hamming_recibido = 7'b1000000;
        #10;

        if (syndrome == 3'b111)
            $display("OK: 1000000 -> Sindrome 111");
        else
            $display("ERROR: 1000000");


        $finish;

    end

endmodule