module parity_decoder (
    input wire [7:0] palabra_recibida,

    output wire paridad_ok,
    output wire error_paridad
);

    wire xor_01;
    wire xor_23;
    wire xor_45;
    wire xor_67;

    wire xor_0123;
    wire xor_4567;

    wire paridad_total;

    // ==========================================
    // PRIMERA ETAPA
    // ==========================================

    assign xor_01 = palabra_recibida[0] ^ palabra_recibida[1];
    assign xor_23 = palabra_recibida[2] ^ palabra_recibida[3];
    assign xor_45 = palabra_recibida[4] ^ palabra_recibida[5];
    assign xor_67 = palabra_recibida[6] ^ palabra_recibida[7];

    // ==========================================
    // SEGUNDA ETAPA
    // ==========================================

    assign xor_0123 = xor_01 ^ xor_23;
    assign xor_4567 = xor_45 ^ xor_67;

    // ==========================================
    // PARIDAD GLOBAL
    // ==========================================

    assign paridad_total = xor_0123 ^ xor_4567;

    // ==========================================
    // PARIDAD PAR
    //
    // 0 = cantidad par de unos
    // 1 = cantidad impar de unos
    // ==========================================

    assign paridad_ok    = ~paridad_total;
    assign error_paridad = paridad_total;

endmodule