module moduloTop (
    // ==========================================
    // DATOS
    // ==========================================
    input wire [3:0] datos_i,

    // ==========================================
    // PARIDADES HAMMING
    // Pines físicos:
    // I1 = 40
    // I2 = 35
    // I3 = 41
    // ==========================================
    input wire I1_i,
    input wire I2_i,
    input wire I3_i,

    // ==========================================
    // SELECTOR ERROR 1
    // Pines:
    // 69, 68, 57
    // ==========================================
    input wire [2:0] err1_pos_i,

    // ==========================================
    // SELECTOR ERROR 2
    // Pines:
    // 70, 71, 72
    // ==========================================
    input wire [2:0] err2_pos_i,

    // ==========================================
    // DISPLAY
    // ==========================================
    output wire [6:0] seg_o,

    // ==========================================
    // PALABRA HAMMING TRANSMITIDA
    // ==========================================
    output wire D0_o,
    output wire D1_o,
    output wire D2_o,
    output wire D3_o,

    output wire I1_o,
    output wire I2_o,
    output wire I3_o,

    output wire P_o
);

    // ==========================================
    // DISPLAY
    // ==========================================

    Lectura_Palabra u_lectura_palabra (
        .datos_i(datos_i),
        .seg_o(seg_o)
    );

    // ==========================================
    // INYECCIÓN DE ERRORES
    // ==========================================

    Inyeccion_Error_Hamming u_inyeccion (
        .datos_i(datos_i),

        .I1_i(I1_i),
        .I2_i(I2_i),
        .I3_i(I3_i),

        .err1_pos_i(err1_pos_i),
        .err2_pos_i(err2_pos_i),

        .D0_o(D0_o),
        .D1_o(D1_o),
        .D2_o(D2_o),
        .D3_o(D3_o),

        .I1_o(I1_o),
        .I2_o(I2_o),
        .I3_o(I3_o),

        .P_o(P_o)
    );

endmodule