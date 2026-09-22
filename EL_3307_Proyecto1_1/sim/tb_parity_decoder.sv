`timescale 1ns/1ps

module tb_parity_decoder;

    reg [7:0] palabra_recibida;

    wire paridad_ok;
    wire error_paridad;

    integer i;
    integer unos;
    integer errores;

    parity_decoder dut (
        .palabra_recibida(palabra_recibida),
        .paridad_ok(paridad_ok),
        .error_paridad(error_paridad)
    );

    initial begin

        $dumpfile("parity_decoder.vcd");
        $dumpvars(0, tb_parity_decoder);

        $display("================================================================");
        $display("             TESTBENCH DECODIFICADOR DE PARIDAD");
        $display("                 PRUEBA DE 256 COMBINACIONES");
        $display("================================================================");
        $display("  #     ENTRADA     # UNOS     PARIDAD     SALIDA");
        $display("----------------------------------------------------------------");

        errores = 0;

        for (i = 0; i < 256; i = i + 1) begin

            palabra_recibida = i;

            #10;

            unos = palabra_recibida[0] +
                   palabra_recibida[1] +
                   palabra_recibida[2] +
                   palabra_recibida[3] +
                   palabra_recibida[4] +
                   palabra_recibida[5] +
                   palabra_recibida[6] +
                   palabra_recibida[7];

            if ((unos % 2) == 0) begin

                if (paridad_ok == 1'b1 && error_paridad == 1'b0) begin
                    $display("%3d     %08b         %1d        PAR          OK",
                             i, palabra_recibida, unos);
                end
                else begin
                    $display("%3d     %08b         %1d        PAR          ERROR",
                             i, palabra_recibida, unos);
                    errores = errores + 1;
                end

            end
            else begin

                if (paridad_ok == 1'b0 && error_paridad == 1'b1) begin
                    $display("%3d     %08b         %1d       IMPAR         OK",
                             i, palabra_recibida, unos);
                end
                else begin
                    $display("%3d     %08b         %1d       IMPAR         ERROR",
                             i, palabra_recibida, unos);
                    errores = errores + 1;
                end

            end

        end

        $display("----------------------------------------------------------------");
        $display("TOTAL DE COMBINACIONES PROBADAS: 256");
        $display("TOTAL DE ERRORES: %0d", errores);

        if (errores == 0)
            $display("RESULTADO FINAL: TODAS LAS COMBINACIONES FUNCIONAN");
        else
            $display("RESULTADO FINAL: HAY ERRORES EN EL CIRCUITO");

        $display("================================================================");

        $finish;

    end

endmodule