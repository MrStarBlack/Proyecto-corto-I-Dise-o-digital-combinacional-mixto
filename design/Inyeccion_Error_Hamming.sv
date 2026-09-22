
module Inyeccion_Error_Hamming (

    input  wire [3:0] datos_i,

    input  wire I1_i,
    input  wire I2_i,
    input  wire I3_i,

    input  wire [2:0] err1_pos_i,
    input  wire [2:0] err2_pos_i,

    input  wire error_P_i,

    output wire D0_o,
    output wire D1_o,
    output wire D2_o,
    output wire D3_o,

    output wire I1_o,
    output wire I2_o,
    output wire I3_o,

    output wire P_o
);

    // =========================================================
    // PALABRA HAMMING DE ENTRADA
    //
    // bit 0 = D0
    // bit 1 = D1
    // bit 2 = D2
    // bit 3 = D3
    // bit 4 = I1
    // bit 5 = I2
    // bit 6 = I3
    // bit 7 = P
    //
    // P se calcula a partir de las paridades.
    // error_P_i NO forma parte de la palabra base.
    // =========================================================

    wire [7:0] palabra_base;

    assign palabra_base = {
        (I1_i ^ I2_i ^ I3_i),  // bit 7 = P
        I3_i,                  // bit 6
        I2_i,                  // bit 5
        I1_i,                  // bit 4
        datos_i[3],            // bit 3
        datos_i[2],            // bit 2
        datos_i[1],            // bit 1
        datos_i[0]             // bit 0
    };


    // =========================================================
    // MASCARA ERROR 1
    //
    // 000 = ningún error
    // 001 = D0
    // 010 = D1
    // 011 = D2
    // 100 = D3
    // 101 = I1
    // 110 = I2
    // 111 = I3
    // =========================================================

    reg [7:0] mask_error1;

    always @(*) begin

        case (err1_pos_i)

            3'b000: mask_error1 = 8'b00000000;

            3'b001: mask_error1 = 8'b00000001; // D0
            3'b010: mask_error1 = 8'b00000010; // D1
            3'b011: mask_error1 = 8'b00000100; // D2
            3'b100: mask_error1 = 8'b00001000; // D3

            3'b101: mask_error1 = 8'b00010000; // I1
            3'b110: mask_error1 = 8'b00100000; // I2
            3'b111: mask_error1 = 8'b01000000; // I3

            default: mask_error1 = 8'b00000000;

        endcase

    end


    // =========================================================
    // MASCARA ERROR 2
    // =========================================================

    reg [7:0] mask_error2;

    always @(*) begin

        case (err2_pos_i)

            3'b000: mask_error2 = 8'b00000000;

            3'b001: mask_error2 = 8'b00000001; // D0
            3'b010: mask_error2 = 8'b00000010; // D1
            3'b011: mask_error2 = 8'b00000100; // D2
            3'b100: mask_error2 = 8'b00001000; // D3

            3'b101: mask_error2 = 8'b00010000; // I1
            3'b110: mask_error2 = 8'b00100000; // I2
            3'b111: mask_error2 = 8'b01000000; // I3

            default: mask_error2 = 8'b00000000;

        endcase

    end


    // =========================================================
    // ERROR DE PARIDAD GLOBAL
    //
    // error_P_i = 1 -> invertir P
    // error_P_i = 0 -> no modificar P
    // =========================================================

    wire [7:0] mask_errorP;

    assign mask_errorP = error_P_i
                       ? 8'b10000000
                       : 8'b00000000;


    // =========================================================
    // PALABRA FINAL CON ERRORES
    // =========================================================

    wire [7:0] palabra_con_error;

    assign palabra_con_error =
            palabra_base
          ^ mask_error1
          ^ mask_error2
          ^ mask_errorP;


    // =========================================================
    // SALIDAS
    // =========================================================

    assign D0_o = palabra_con_error[0];
    assign D1_o = palabra_con_error[1];
    assign D2_o = palabra_con_error[2];
    assign D3_o = palabra_con_error[3];

    assign I1_o = palabra_con_error[4];
    assign I2_o = palabra_con_error[5];
    assign I3_o = palabra_con_error[6];

    assign P_o = palabra_con_error[7];

endmodule

