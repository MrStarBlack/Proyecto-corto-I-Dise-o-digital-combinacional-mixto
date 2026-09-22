module display_decoder (
    input wire [6:0] palabra_corregida,
    input wire [2:0] syndrome,
    input wire ded,
    input wire switch_display,

    output wire [6:0] leds,
    output reg [6:0] segmentos
);

    reg [3:0] dato;
    reg [3:0] valor_display;

    // ==================================================
    // OBTENER LOS 4 BITS DE DATOS DEL HAMMING
    //
    // H1 H2 D1 H4 D2 D3 D4
    //
    // bit 0 = H1
    // bit 1 = H2
    // bit 2 = D1
    // bit 3 = H4
    // bit 4 = D2
    // bit 5 = D3
    // bit 6 = D4
    // ==================================================

    always @(*) begin

        dato[0] = palabra_corregida[2];
        dato[1] = palabra_corregida[4];
        dato[2] = palabra_corregida[5];
        dato[3] = palabra_corregida[6];

    end


    // ==================================================
    // SELECCIONAR QUE SE MUESTRA EN EL DISPLAY
    //
    // switch_display = 0 -> dato recibido
    // switch_display = 1 -> syndrome
    // ==================================================

    always @(*) begin

        if (switch_display == 1'b0)
            valor_display = dato;
        else
            valor_display = {1'b0, syndrome};

    end


    // ==================================================
    // DECODIFICADOR HEXADECIMAL
    //
    // segmentos[6:0] = G F E D C B A
    //
    // DISPLAY DE ANODO COMUN
    //
    // 0 = ENCENDIDO
    // 1 = APAGADO
    // ==================================================

    always @(*) begin

        case (valor_display)

            4'h0: segmentos = 7'b1000000;
            4'h1: segmentos = 7'b1111001;
            4'h2: segmentos = 7'b0100100;
            4'h3: segmentos = 7'b0110000;
            4'h4: segmentos = 7'b0011001;
            4'h5: segmentos = 7'b0010010;
            4'h6: segmentos = 7'b0000010;
            4'h7: segmentos = 7'b1111000;
            4'h8: segmentos = 7'b0000000;
            4'h9: segmentos = 7'b0010000;
            4'hA: segmentos = 7'b0001000;
            4'hB: segmentos = 7'b0000011;
            4'hC: segmentos = 7'b1000110;
            4'hD: segmentos = 7'b0100001;
            4'hE: segmentos = 7'b0000110;
            4'hF: segmentos = 7'b0001110;

            default:
                segmentos = 7'b1111111;

        endcase

    end


    // ==================================================
    // SALIDA DE LOS LEDS
    //
    // LED [0] = H1
    // LED [1] = H2
    // LED [2] = D1
    // LED [3] = H4
    // LED [4] = D2
    // LED [5] = D3
    // LED [6] = DED
    //
    // Los bits de paridad H1, H2 y H4 se muestran
    // apagados en esta visualización.
    // ==================================================

    assign leds = {
        ded,
        palabra_corregida[5],
        palabra_corregida[4],
        palabra_corregida[2],
        1'b0,
        1'b0,
        1'b0
    };

endmodule