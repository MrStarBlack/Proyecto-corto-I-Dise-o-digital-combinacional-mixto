// ============================================================
// Decodificador7Segmentos.v
// Convierte 4 bits (dato) en los 7 segmentos de un display de
// CATODO COMUN, mostrando el digito hexadecimal 0-F.
// ============================================================
module Decodificador7Segmentos (
    input  [3:0] dato,        // {D3,D2,D1,D0} a mostrar
    output       seg_a,       // Un pin de FPGA por segmento
    output       seg_b,
    output       seg_c,
    output       seg_d,
    output       seg_e,
    output       seg_f,
    output       seg_g,
    output       transistor_en // Base del NPN (pin 28): 1 = display encendido
);

    // 'reg' es necesario porque este bus se asigna dentro de un always.
    // Aqui NO guarda memoria: el always @* es combinacional.
    reg [6:0] segmentos;  // Orden de bits: {g,f,e,d,c,b,a}

    // always @* se recalcula cada vez que cambia 'dato' (sin reloj).
    always @* begin
        case (dato)
            4'h0: segmentos = 7'b0111111;
            4'h1: segmentos = 7'b0000110;
            4'h2: segmentos = 7'b1011011;
            4'h3: segmentos = 7'b1001111;
            4'h4: segmentos = 7'b1100110;
            4'h5: segmentos = 7'b1101101;
            4'h6: segmentos = 7'b1111101;
            4'h7: segmentos = 7'b0000111;
            4'h8: segmentos = 7'b1111111;
            4'h9: segmentos = 7'b1101111;
            4'hA: segmentos = 7'b1110111;
            4'hB: segmentos = 7'b1111100;
            4'hC: segmentos = 7'b0111001;
            4'hD: segmentos = 7'b1011110;
            4'hE: segmentos = 7'b1111001;
            4'hF: segmentos = 7'b1110001;
            default: segmentos = 7'b0000000;
        endcase
    end

    // Se reparte el bus a los 7 pines individuales.
    assign seg_g = segmentos[6];
    assign seg_f = segmentos[5];
    assign seg_e = segmentos[4];
    assign seg_d = segmentos[3];
    assign seg_c = segmentos[2];
    assign seg_b = segmentos[1];
    assign seg_a = segmentos[0];

    // Transistor siempre saturado: el display queda encendido.
    assign transistor_en = 1'b1;

endmodule
