// ============================================================
// topTransmisor.sv
// No hace lógica propia ya que solo
// conecta entre si los 4 submodulos y expone hacia afuera los
// puertos que se asignan a pines físicos en el archivo .cst.
//
// Flujo de datos:
//   D0-D3 --> Decodificador7Segmentos --> display (muestra el dato)
//   D0-D3 + S1-S3 --> ModuloHamming --> palabra de 7 bits
//   7 bits --> ModuloParidadDED --> palabra de 8 bits
//   8 bits + error1 + error2 --> ModuloInyeccionErrores --> LEDs
//
// Los nombres de los puertos de este modulo deben coincidir
// exactamente con los nombres usados en el archivo .cst
// ============================================================

module topTransmisor (
    // ---- Entradas: datos del usuario (switches) ----
    input  logic D0, D1, D2, D3,

    // ---- Entradas: síndromes calculados por los 74HC86 ----
    input  logic S1, S2, S3,

    // ---- Entradas: switches de posición de error ----
    input  logic [2:0] error1,
    input  logic [2:0] error2,

    // ---- Salidas: display de 7 segmentos (cátodo común) ----
    output logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g,
    output logic transistor_en,   // base del NPN (pin 28)

    // ---- Salidas: palabra transmitida hacia los 8 LEDs ----
    output logic [7:0] palabra_transmitida
);

    // Cables internos conectan la salida de un submodulo con la
    // entrada del siguiente. 'logic' actúa aquí como un wire; no
    // guarda nada, solo transporta la señal entre modulos.
    logic [6:0] palabra_codificada; // Sale de ModuloHamming (7 bits)
    logic [7:0] palabra_final;      // Sale de ModuloParidadDED (8 bits)

    // ------------------------------------------------------------
    // 1) Display: muestra en hexadecimal el dato de 4 bits.
    // Se concatena {D3,D2,D1,D0} para que D3 sea el bit más
    // significativo del número mostrado (D0 es el menos significativo).
    // ------------------------------------------------------------
    Decodificador7Segmentos u_display (
        .dato          ({D3, D2, D1, D0}),
        .seg_a         (seg_a),
        .seg_b         (seg_b),
        .seg_c         (seg_c),
        .seg_d         (seg_d),
        .seg_e         (seg_e),
        .seg_f         (seg_f),
        .seg_g         (seg_g),
        .transistor_en (transistor_en)
    );

    // ------------------------------------------------------------
    // 2) Empaqueta datos + síndromes en la palabra de 7 bits.
    // ------------------------------------------------------------
    ModuloHamming u_hamming (
        .D0                 (D0),
        .D1                 (D1),
        .D2                 (D2),
        .D3                 (D3),
        .S1                 (S1),
        .S2                 (S2),
        .S3                 (S3),
        .palabra_codificada (palabra_codificada)
    );

    // ------------------------------------------------------------
    // 3) Calcula la paridad global y arma la palabra de 8 bits.
    // ------------------------------------------------------------
    ModuloParidadDED u_paridad (
        .palabra_codificada (palabra_codificada),
        .palabra_final      (palabra_final)
    );

    // ------------------------------------------------------------
    // 4) Inserta 0, 1 o 2 errores y entrega la palabra a los LEDs.
    // ------------------------------------------------------------
    ModuloInyeccionErrores u_errores (
        .palabra_final       (palabra_final),
        .error1              (error1),
        .error2              (error2),
        .palabra_transmitida (palabra_transmitida)
    );

endmodule
