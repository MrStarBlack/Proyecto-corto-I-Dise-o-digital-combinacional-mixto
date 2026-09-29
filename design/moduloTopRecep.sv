module moduloTopRecep (
    // Entradas individuales (0 = GND, 1 = 3.3 V)
    input  logic P_in,    // paridad global
    input  logic D0_in,   // dato 0 (posición Hamming 3)
    input  logic D1_in,   // dato 1 (posición Hamming 5)
    input  logic D2_in,   // dato 2 (posición Hamming 6)
    input  logic D3_in,   // dato 3 (posición Hamming 7)
    input  logic S1_in,   // paridad Hamming, posición 1
    input  logic S2_in,   // paridad Hamming, posición 2
    input  logic S3_in,   // paridad Hamming, posición 4

    // 0 = muestra datos, 1 = muestra síndrome
    input  logic SWITCH,

    // LEDs de la FPGA (activos en bajo)
    output logic [3:0] LED_DATOS,
    output logic       LED_SEC,
    output logic       LED_DED,

    output logic catodo_a, catodo_b, catodo_c, catodo_d,
    output logic catodo_e, catodo_f, catodo_g,

    output logic anodo_a, anodo_b, anodo_c, anodo_d,
    output logic anodo_e, anodo_f, anodo_g
);

    logic [7:0] palabra_entrada;
    logic       ERROR_PARIDAD;
    logic [6:0] palabra_hamming;
    logic       S1, S2, S4;
    logic [2:0] sindrome;
    logic [6:0] palabra_corregida;
    logic [3:0] datos;
    logic       SEC, DED;

    // Palabra completa de 8 bits (el XOR total no depende del orden)
    assign palabra_entrada = { P_in, D0_in, D1_in, D2_in,
                               D3_in, S1_in, S2_in, S3_in };

    // Posiciones Hamming: [6]=B1 ... [0]=B7
    // B1=S1  B2=S2  B3=D0  B4=S3  B5=D1  B6=D2  B7=D3
    assign palabra_hamming = { S1_in,   // B1
                               S2_in,   // B2
                               D0_in,   // B3
                               S3_in,   // B4
                               D1_in,   // B5
                               D2_in,   // B6
                               D3_in }; // B7

    Verificador_Paridad U_VERIFICADOR_PARIDAD (
        .palabra_recibida (palabra_entrada),
        .ERROR_PARIDAD    (ERROR_PARIDAD)
    );

    Determinacion_Sindrome U_DETERMINACION_SINDROME (
        .palabra_hamming (palabra_hamming),
        .S1(S1), .S2(S2), .S4(S4),
        .sindrome        (sindrome)
    );

    Correccion_error U_CORRECCION_ERROR (
        .palabra_hamming   (palabra_hamming),
        .ERROR_PARIDAD     (ERROR_PARIDAD),
        .sindrome          (sindrome),
        .palabra_corregida (palabra_corregida),
        .datos             (datos),
        .SEC               (SEC),
        .DED               (DED)
    );

    Display_Receptor U_DISPLAY_RECEPTOR (
        .datos     (datos),
        .SEC       (SEC),
        .DED       (DED),
        .sindrome  (sindrome),
        .SWITCH    (SWITCH),
        .LED_DATOS (LED_DATOS),
        .LED_SEC   (LED_SEC),
        .LED_DED   (LED_DED),
        .catodo_a(catodo_a), .catodo_b(catodo_b), .catodo_c(catodo_c), .catodo_d(catodo_d),
        .catodo_e(catodo_e), .catodo_f(catodo_f), .catodo_g(catodo_g),
        .anodo_a(anodo_a),   .anodo_b(anodo_b),   .anodo_c(anodo_c),   .anodo_d(anodo_d),
        .anodo_e(anodo_e),   .anodo_f(anodo_f),   .anodo_g(anodo_g)
    );

endmodule
