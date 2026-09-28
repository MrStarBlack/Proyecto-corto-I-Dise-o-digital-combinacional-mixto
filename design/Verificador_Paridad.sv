module Verificador_Paridad (
    input  logic [7:0] palabra_recibida,
    output logic       ERROR_PARIDAD
);

    logic xor_1;
    logic xor_2;
    logic xor_3;
    logic xor_4;
    logic xor_5;
    logic xor_6;

    // Primera etapa de XOR
    assign xor_1 = palabra_recibida[7] ^ palabra_recibida[6];
    assign xor_2 = palabra_recibida[5] ^ palabra_recibida[4];
    assign xor_3 = palabra_recibida[3] ^ palabra_recibida[2];
    assign xor_4 = palabra_recibida[1] ^ palabra_recibida[0];

    // Segunda etapa de XOR
    assign xor_5 = xor_1 ^ xor_2;
    assign xor_6 = xor_3 ^ xor_4;

    // Tercera etapa de XOR
    assign ERROR_PARIDAD = xor_5 ^ xor_6;

endmodule