module Display_Receptor (
    input  logic [3:0] datos,
    input  logic       SEC,
    input  logic       DED,
    input  logic [2:0] sindrome,
    input  logic       SWITCH,

    output logic [3:0] LED_DATOS,
    output logic       LED_SEC,
    output logic       LED_DED,

    output logic catodo_a, catodo_b, catodo_c, catodo_d,
    output logic catodo_e, catodo_f, catodo_g,

    output logic anodo_a, anodo_b, anodo_c, anodo_d,
    output logic anodo_e, anodo_f, anodo_g
);
    logic d3, d2, d1, d0;
    logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;
    logic m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15;

    // LEDs de la Tang Nano 9K: activos en bajo
    assign LED_DATOS = ~datos;
    assign LED_SEC   = ~SEC;
    assign LED_DED   = ~DED;

    // DED=1 -> 1110 (E) ; SWITCH=0 -> datos ; SWITCH=1 -> síndrome
    assign d3 = DED | (~SWITCH & datos[3]);
    assign d2 = DED | (~SWITCH & datos[2]) | (SWITCH & sindrome[2]);
    assign d1 = DED | (~SWITCH & datos[1]) | (SWITCH & sindrome[1]);
    assign d0 = ~DED & ((~SWITCH & datos[0]) | (SWITCH & sindrome[0]));

    // Minterms
    assign m0  = ~d3 & ~d2 & ~d1 & ~d0;
    assign m1  = ~d3 & ~d2 & ~d1 &  d0;
    assign m2  = ~d3 & ~d2 &  d1 & ~d0;
    assign m3  = ~d3 & ~d2 &  d1 &  d0;
    assign m4  = ~d3 &  d2 & ~d1 & ~d0;
    assign m5  = ~d3 &  d2 & ~d1 &  d0;
    assign m6  = ~d3 &  d2 &  d1 & ~d0;
    assign m7  = ~d3 &  d2 &  d1 &  d0;
    assign m8  =  d3 & ~d2 & ~d1 & ~d0;
    assign m9  =  d3 & ~d2 & ~d1 &  d0;
    assign m10 =  d3 & ~d2 &  d1 & ~d0;  // A
    assign m11 =  d3 & ~d2 &  d1 &  d0;  // b
    assign m12 =  d3 &  d2 & ~d1 & ~d0;  // C
    assign m13 =  d3 &  d2 & ~d1 &  d0;  // d
    assign m14 =  d3 &  d2 &  d1 & ~d0;  // E
    assign m15 =  d3 &  d2 &  d1 &  d0;  // F

    // Segmentos (1 = encendido)
    assign seg_a = m0|m2|m3|m5|m6|m7|m8|m9|m10|m12|m14|m15;
    assign seg_b = m0|m1|m2|m3|m4|m7|m8|m9|m10|m13;
    assign seg_c = m0|m1|m3|m4|m5|m6|m7|m8|m9|m10|m11|m13;
    assign seg_d = m0|m2|m3|m5|m6|m8|m9|m11|m12|m13|m14;
    assign seg_e = m0|m2|m6|m8|m10|m11|m12|m13|m14|m15;
    assign seg_f = m0|m4|m5|m6|m8|m9|m10|m11|m12|m14|m15;
    assign seg_g = m2|m3|m4|m5|m6|m8|m9|m10|m11|m13|m14|m15;

    // Cátodo común: 1 = enciende
    assign catodo_a = seg_a;  assign catodo_b = seg_b;
    assign catodo_c = seg_c;  assign catodo_d = seg_d;
    assign catodo_e = seg_e;  assign catodo_f = seg_f;
    assign catodo_g = seg_g;

    // Ánodo común: 0 = enciende
    assign anodo_a = ~seg_a;  assign anodo_b = ~seg_b;
    assign anodo_c = ~seg_c;  assign anodo_d = ~seg_d;
    assign anodo_e = ~seg_e;  assign anodo_f = ~seg_f;
    assign anodo_g = ~seg_g;
endmodule
