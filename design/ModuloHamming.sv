// ============================================================
// ModuloHamming.v
// No calcula paridad (lo hacen los 74HC86 externos). Junta los
// 4 datos y los 3 sindromes en una palabra de 7 bits.
// ============================================================
module ModuloHamming (
    input D0, D1, D2, D3,   // Datos del usuario (pines 34, 40, 35, 41)
    input S1, S2, S3,       // Sindromes desde los 74HC86 (pines 42, 51, 53)
    output [6:0] palabra_codificada
);

    // Concatenacion: D0 queda en el bit 6 (MSB) y S3 en el bit 0 (LSB).
    assign palabra_codificada = {D0, D1, D2, D3, S1, S2, S3};

endmodule
