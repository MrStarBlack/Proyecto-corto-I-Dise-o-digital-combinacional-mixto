module Correccion_error (
    input  logic [6:0] palabra_hamming,
    input  logic       ERROR_PARIDAD,
    input  logic [2:0] sindrome,

    output logic [6:0] palabra_corregida,
    output logic [3:0] datos,
    output logic       SEC,
    output logic       DED
);
    logic [6:0] flip;

    // Se invierte el bit indicado por el síndrome solo si hay error de paridad global
    assign flip[6] = ERROR_PARIDAD & ~sindrome[2] & ~sindrome[1] &  sindrome[0]; // pos 1
    assign flip[5] = ERROR_PARIDAD & ~sindrome[2] &  sindrome[1] & ~sindrome[0]; // pos 2
    assign flip[4] = ERROR_PARIDAD & ~sindrome[2] &  sindrome[1] &  sindrome[0]; // pos 3
    assign flip[3] = ERROR_PARIDAD &  sindrome[2] & ~sindrome[1] & ~sindrome[0]; // pos 4
    assign flip[2] = ERROR_PARIDAD &  sindrome[2] & ~sindrome[1] &  sindrome[0]; // pos 5
    assign flip[1] = ERROR_PARIDAD &  sindrome[2] &  sindrome[1] & ~sindrome[0]; // pos 6
    assign flip[0] = ERROR_PARIDAD &  sindrome[2] &  sindrome[1] &  sindrome[0]; // pos 7

    assign palabra_corregida = palabra_hamming ^ flip;

    // Error simple: paridad global mala (síndrome 000 = error en P)
    assign SEC = ERROR_PARIDAD;

    // Doble error: paridad global buena pero síndrome distinto de 000
    assign DED = ~ERROR_PARIDAD & (sindrome[2] | sindrome[1] | sindrome[0]);

    // D0=pos3, D1=pos5, D2=pos6, D3=pos7 (D0 es el LSB)
    assign datos = { palabra_corregida[0],   // D3
                     palabra_corregida[1],   // D2
                     palabra_corregida[2],   // D1
                     palabra_corregida[4] }; // D0
endmodule
