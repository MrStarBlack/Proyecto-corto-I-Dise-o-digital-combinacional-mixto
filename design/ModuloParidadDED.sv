// ============================================================
// ModuloParidadDED.sv
// Calcula el octavo bit de paridad global (par) a partir de los
// 7 bits que ya salieron del módulo de Hamming, y empaqueta todo
// en una palabra final de 8 bits para el subsistema de inserción
// de error.
// ============================================================

module ModuloParidadDED (
    input  logic [6:0] palabra_codificada, // Entrada: D0,D1,D2,D3,S1,S2,S3
                                             // (siete bits del módulo anterior)

    output logic [7:0] palabra_final
    // Salida: la palabra completa de 8 bits, lista para el
    // subsistema de inserción de error.
);

    logic paridad_global; // Cable de 1 bit para guardar el resultado del XOR global.

    // El operador '^' usado así, delante de un bus completo (no entre dos
    // señales), es un operador de REDUCCIÓN: hace XOR de TODOS los bits
    // del bus entre sí en una sola operación. Es decir:
    // paridad_global = palabra_codificada[6] ^ palabra_codificada[5] ^ ... ^ palabra_codificada[0]
    // Esto es exactamente D0^D1^D2^D3^S1^S2^S3, como pide el enunciado.
    assign paridad_global = ^palabra_codificada;

    // Se arma la palabra final concatenando el bit de paridad global
    // (colocado como MSB, es decir, a la izquierda) con los 7 bits
    // que ya traía el módulo anterior, en el mismo orden que tenían.
    assign palabra_final = {paridad_global, palabra_codificada};

endmodule
