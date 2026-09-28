module Correccion_error (
    input  logic [6:0] palabra_hamming,
    input  logic       ERROR_PARIDAD,
    input  logic [2:0] sindrome,

    output logic [6:0] palabra_corregida,
    output logic [3:0] datos,
    output logic       SEC,
    output logic       DED
);

    // ------------------------------------------------
    // Corrección de errores Hamming (7,4)
    //
    // Posiciones:
    // 1 = B1 = palabra_hamming[6]
    // 2 = B2 = palabra_hamming[5]
    // 3 = B3 = palabra_hamming[4]
    // 4 = B4 = palabra_hamming[3]
    // 5 = B5 = palabra_hamming[2]
    // 6 = B6 = palabra_hamming[1]
    // 7 = B7 = palabra_hamming[0]
    //
    // ERROR_PARIDAD:
    // 0 = paridad global correcta
    // 1 = error de paridad global
    //
    // SEC = error simple corregido
    // DED = doble error detectado
    // ------------------------------------------------


    always_comb begin

        // Por defecto, la palabra permanece sin cambios
        palabra_corregida = palabra_hamming;

        // Por defecto, no hay indicadores de error
        SEC = 1'b0;
        DED = 1'b0;


        // ------------------------------------------------
        // CASO 1:
        // Paridad correcta + síndrome 000
        // No existe error.
        // ------------------------------------------------

        if ((ERROR_PARIDAD == 1'b0) &&
            (sindrome == 3'b000)) begin

            palabra_corregida = palabra_hamming;
            SEC = 1'b0;
            DED = 1'b0;

        end


        // ------------------------------------------------
        // CASO 2:
        // Error de paridad + síndrome diferente de 000
        // Error simple en la palabra Hamming.
        // El síndrome indica la posición.
        // ------------------------------------------------

        else if ((ERROR_PARIDAD == 1'b1) &&
                 (sindrome != 3'b000)) begin

            SEC = 1'b1;
            DED = 1'b0;

            // Corrección según la posición indicada
            case (sindrome)

                3'b001: palabra_corregida[6] = ~palabra_hamming[6]; // Posición 1
                3'b010: palabra_corregida[5] = ~palabra_hamming[5]; // Posición 2
                3'b011: palabra_corregida[4] = ~palabra_hamming[4]; // Posición 3
                3'b100: palabra_corregida[3] = ~palabra_hamming[3]; // Posición 4
                3'b101: palabra_corregida[2] = ~palabra_hamming[2]; // Posición 5
                3'b110: palabra_corregida[1] = ~palabra_hamming[1]; // Posición 6
                3'b111: palabra_corregida[0] = ~palabra_hamming[0]; // Posición 7

                default:
                    palabra_corregida = palabra_hamming;

            endcase

        end


        // ------------------------------------------------
        // CASO 3:
        // Error de paridad + síndrome 000
        // Error en el bit de paridad global.
        //
        // La palabra Hamming de 7 bits permanece igual,
        // ya que el bit afectado no pertenece a ella.
        // ------------------------------------------------

        else if ((ERROR_PARIDAD == 1'b1) &&
                 (sindrome == 3'b000)) begin

            palabra_corregida = palabra_hamming;
            SEC = 1'b0;
            DED = 1'b0;

        end


        // ------------------------------------------------
        // CASO 4:
        // Paridad correcta + síndrome diferente de 000
        // Condición de doble error.
        //
        // No se realiza ninguna corrección porque el
        // síndrome ya no representa de forma confiable
        // una posición de un único bit erróneo.
        // ------------------------------------------------

        else if ((ERROR_PARIDAD == 1'b0) &&
                 (sindrome != 3'b000)) begin

            palabra_corregida = palabra_hamming;
            SEC = 1'b0;
            DED = 1'b1;

        end

    end


    // ------------------------------------------------
    // Extracción de los cuatro bits de información
    //
    // Palabra Hamming:
    //
    // Posición:  1   2   3   4   5   6   7
    //            P1  P2  D1  P4  D2  D3  D4
    //
    // Datos:
    // D1 = posición 3
    // D2 = posición 5
    // D3 = posición 6
    // D4 = posición 7
    // ------------------------------------------------

    assign datos = {
        palabra_corregida[0], // D4
        palabra_corregida[1], // D3
        palabra_corregida[2], // D2
        palabra_corregida[4]  // D1
    };

endmodule

