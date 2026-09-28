module Determinacion_Sindrome (
    input  logic [6:0] palabra_hamming,
    output logic       S1,
    output logic       S2,
    output logic       S4,
    output logic [2:0] sindrome
);

    logic xor_s1_1;
    logic xor_s1_2;

    logic xor_s2_1;
    logic xor_s2_2;

    logic xor_s4_1;
    logic xor_s4_2;

    // ------------------------------------------------
    // S1 = B1 XOR B3 XOR B5 XOR B7
    // ------------------------------------------------

    assign xor_s1_1 = palabra_hamming[6] ^ palabra_hamming[4];
    assign xor_s1_2 = palabra_hamming[2] ^ palabra_hamming[0];

    assign S1 = xor_s1_1 ^ xor_s1_2;

    // ------------------------------------------------
    // S2 = B2 XOR B3 XOR B6 XOR B7
    // ------------------------------------------------

    assign xor_s2_1 = palabra_hamming[5] ^ palabra_hamming[4];
    assign xor_s2_2 = palabra_hamming[1] ^ palabra_hamming[0];

    assign S2 = xor_s2_1 ^ xor_s2_2;

    // ------------------------------------------------
    // S4 = B4 XOR B5 XOR B6 XOR B7
    // ------------------------------------------------

    assign xor_s4_1 = palabra_hamming[3] ^ palabra_hamming[2];
    assign xor_s4_2 = palabra_hamming[1] ^ palabra_hamming[0];

    assign S4 = xor_s4_1 ^ xor_s4_2;

    // ------------------------------------------------
    // Formación del síndrome
    // S4 S2 S1
    // ------------------------------------------------

    assign sindrome = {S4, S2, S1};

endmodule