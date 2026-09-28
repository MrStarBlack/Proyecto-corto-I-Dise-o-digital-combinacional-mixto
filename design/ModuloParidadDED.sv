// ============================================================
// ModuloParidadDED.v
// Calcula la paridad global (par) de los 7 bits y arma la
// palabra de 8 bits con esa paridad como MSB.
// ============================================================
module ModuloParidadDED (
    input  [6:0] palabra_codificada,  // D0,D1,D2,D3,S1,S2,S3
    output [7:0] palabra_final        // {paridad_global, 7 bits}
);

    wire paridad_global;

    // '^' delante de un bus es una reduccion: XOR de todos sus bits.
    assign paridad_global = ^palabra_codificada;

    // Paridad global como bit 7 (MSB).
    assign palabra_final = {paridad_global, palabra_codificada};

endmodule
