module Determinacion_Sindrome (
    input  logic [6:0] palabra_hamming, // [6]=B1 ... [0]=B7
    output logic       S1,
    output logic       S2,
    output logic       S4,
    output logic [2:0] sindrome
);
    assign S1 = palabra_hamming[6] ^ palabra_hamming[4] ^ palabra_hamming[2] ^ palabra_hamming[0]; // B1^B3^B5^B7
    assign S2 = palabra_hamming[5] ^ palabra_hamming[4] ^ palabra_hamming[1] ^ palabra_hamming[0]; // B2^B3^B6^B7
    assign S4 = palabra_hamming[3] ^ palabra_hamming[2] ^ palabra_hamming[1] ^ palabra_hamming[0]; // B4^B5^B6^B7

    assign sindrome = {S4, S2, S1};
endmodule
