module error_correction (
    input wire [6:0] hamming_recibido,
    input wire [2:0] syndrome,
    input wire error_paridad,

    output wire [6:0] palabra_corregida,
    output wire sec,
    output wire ded
);

    wire syndrome_activo;

    wire corregir_1;
    wire corregir_2;
    wire corregir_3;
    wire corregir_4;
    wire corregir_5;
    wire corregir_6;
    wire corregir_7;

    // ==========================================
    // DETECTAR SI EL SINDROME ES DIFERENTE DE 000
    // ==========================================

    assign syndrome_activo =
        syndrome[2] |
        syndrome[1] |
        syndrome[0];

    // ==========================================
    // SEC
    //
    // Paridad global incorrecta + syndrome != 000
    // ==========================================

    assign sec =
        error_paridad &
        syndrome_activo;

    // ==========================================
    // DED
    //
    // Paridad global correcta + syndrome != 000
    // ==========================================

    assign ded =
        ~error_paridad &
        syndrome_activo;

    // ==========================================
    // CORRECCION DE POSICION 1
    // syndrome = 001
    // ==========================================

    assign corregir_1 =
        sec &
        ~syndrome[2] &
        ~syndrome[1] &
         syndrome[0];

    // ==========================================
    // CORRECCION DE POSICION 2
    // syndrome = 010
    // ==========================================

    assign corregir_2 =
        sec &
        ~syndrome[2] &
         syndrome[1] &
        ~syndrome[0];

    // ==========================================
    // CORRECCION DE POSICION 3
    // syndrome = 011
    // ==========================================

    assign corregir_3 =
        sec &
        ~syndrome[2] &
         syndrome[1] &
         syndrome[0];

    // ==========================================
    // CORRECCION DE POSICION 4
    // syndrome = 100
    // ==========================================

    assign corregir_4 =
        sec &
         syndrome[2] &
        ~syndrome[1] &
        ~syndrome[0];

    // ==========================================
    // CORRECCION DE POSICION 5
    // syndrome = 101
    // ==========================================

    assign corregir_5 =
        sec &
         syndrome[2] &
        ~syndrome[1] &
         syndrome[0];

    // ==========================================
    // CORRECCION DE POSICION 6
    // syndrome = 110
    // ==========================================

    assign corregir_6 =
        sec &
         syndrome[2] &
         syndrome[1] &
        ~syndrome[0];

    // ==========================================
    // CORRECCION DE POSICION 7
    // syndrome = 111
    // ==========================================

    assign corregir_7 =
        sec &
         syndrome[2] &
         syndrome[1] &
         syndrome[0];

    // ==========================================
    // PALABRA CORREGIDA
    // ==========================================

    assign palabra_corregida[0] =
        hamming_recibido[0] ^ corregir_1;

    assign palabra_corregida[1] =
        hamming_recibido[1] ^ corregir_2;

    assign palabra_corregida[2] =
        hamming_recibido[2] ^ corregir_3;

    assign palabra_corregida[3] =
        hamming_recibido[3] ^ corregir_4;

    assign palabra_corregida[4] =
        hamming_recibido[4] ^ corregir_5;

    assign palabra_corregida[5] =
        hamming_recibido[5] ^ corregir_6;

    assign palabra_corregida[6] =
        hamming_recibido[6] ^ corregir_7;

endmodule