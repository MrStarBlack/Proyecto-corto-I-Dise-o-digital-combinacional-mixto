module Lectura_Palabra (
    input  [3:0] datos_i, // 4 bits de entrada: [3]=D3, [2]=D2, [1]=D1, [0]=D0
    output [6:0] seg_o    // 7 segmentos: [0]=A, [1]=B, [2]=C, [3]=D, [4]=E, [5]=F, [6]=G
);

    wire A, B, C, D;
    assign D = datos_i[3];
    assign C = datos_i[2];
    assign B = datos_i[1];
    assign A = datos_i[0];

    // Segmento 'a' (seg_o[0])
    assign seg_o[0] = (B & C) | (B & ~D) | (D & ~A) | (~A & ~C) | (A & C & ~D) | (D & ~B & ~C);

    // Segmento 'b' (seg_o[1])
    assign seg_o[1] = (~A & ~C) | (~C & ~D) | (A & B & ~D) | (A & D & ~B) | (~A & ~B & ~D);

    // Segmento 'c' (seg_o[2])
    assign seg_o[2] = (A & ~B) | (A & ~D) | (C & ~D) | (D & ~C) | (~B & ~D);

    // Segmento 'd' (seg_o[3])
    assign seg_o[3] = (D & ~B) | (A & B & ~C) | (A & C & ~B) | (B & C & ~A) | (~A & ~C & ~D);

    // Segmento 'e' (seg_o[4])
    assign seg_o[4] = (B & D) | (C & D) | (B & ~A) | (~A & ~C);

    // Segmento 'f' (seg_o[5])
    assign seg_o[5] = (B & D) | (C & ~A) | (D & ~C) | (~A & ~B) | (C & ~B & ~D);

    // Segmento 'g' (seg_o[6])
    assign seg_o[6] = (A & D) | (B & ~A) | (B & ~C) | (D & ~C) | (C & ~B & ~D);

endmodule