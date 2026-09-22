module syndrome_decoder (
    input wire [6:0] hamming_recibido,

    output wire [2:0] syndrome
);

    wire s1;
    wire s2;
    wire s4;

    // ==========================================
    // S1
    //
    // Posiciones:
    // 1, 3, 5, 7
    // ==========================================

    assign s1 =
        hamming_recibido[0] ^
        hamming_recibido[2] ^
        hamming_recibido[4] ^
        hamming_recibido[6];

    // ==========================================
    // S2
    //
    // Posiciones:
    // 2, 3, 6, 7
    // ==========================================

    assign s2 =
        hamming_recibido[1] ^
        hamming_recibido[2] ^
        hamming_recibido[5] ^
        hamming_recibido[6];

    // ==========================================
    // S4
    //
    // Posiciones:
    // 4, 5, 6, 7
    // ==========================================

    assign s4 =
        hamming_recibido[3] ^
        hamming_recibido[4] ^
        hamming_recibido[5] ^
        hamming_recibido[6];

    // ==========================================
    // SALIDA DEL SINDROME
    //
    // syndrome[2] = S4
    // syndrome[1] = S2
    // syndrome[0] = S1
    // ==========================================

    assign syndrome[2] = s4;
    assign syndrome[1] = s2;
    assign syndrome[0] = s1;

endmodule