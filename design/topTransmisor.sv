// ============================================================
// topTransmisor.v
// Modulo raiz: solo conecta los submodulos. Sus puertos deben
// llamarse igual que en el archivo .cst.
// ============================================================
module top (
    input D0, D1, D2, D3,          // Switches de datos
    input S1, S2, S3,              // Sindromes de los 74HC86
    input [2:0] error1,            // Switches de error 1
    input [2:0] error2,            // Switches de error 2
    output seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,
    output [7:0] palabra_transmitida  // A los 8 LEDs
);

    // Cables internos entre submodulos.
    wire [6:0] palabra_codificada;
    wire [7:0] palabra_final;

    // 1) Display: {D3,D2,D1,D0} con D3 como bit mas significativo.
    // La salida transistor_en del decodificador queda sin conectar
    // (.transistor_en ()) porque la base del NPN ahora va directo al
    // 3V3 por medio de su resistencia, sin usar un pin de la FPGA.
    Decodificador7Segmentos u_display (
        .dato          ({D3, D2, D1, D0}),
        .seg_a         (seg_a),
        .seg_b         (seg_b),
        .seg_c         (seg_c),
        .seg_d         (seg_d),
        .seg_e         (seg_e),
        .seg_f         (seg_f),
        .seg_g         (seg_g),
        .transistor_en ()
    );

    // 2) Datos + sindromes -> palabra de 7 bits.
    ModuloHamming u_hamming (
        .D0(D0), .D1(D1), .D2(D2), .D3(D3),
        .S1(S1), .S2(S2), .S3(S3),
        .palabra_codificada(palabra_codificada)
    );

    // 3) Paridad global -> palabra de 8 bits.
    ModuloParidadDED u_paridad (
        .palabra_codificada(palabra_codificada),
        .palabra_final(palabra_final)
    );

    // 4) Insercion de errores -> LEDs.
    ModuloInyeccionErrores u_errores (
        .palabra_final(palabra_final),
        .error1(error1),
        .error2(error2),
        .palabra_transmitida(palabra_transmitida)
    );

endmodule
