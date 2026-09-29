module Display_Receptor (
    input  logic [3:0] datos,
    input  logic       SEC,
    input  logic       DED,
    input  logic [2:0] sindrome,
    input  logic       SWITCH,

    output logic [3:0] LED_DATOS,
    output logic       LED_SEC,
    output logic       LED_DED,

    // ==========================================
    // DISPLAY DE CATODO COMUN
    // ==========================================

    output logic catodo_a,
    output logic catodo_b,
    output logic catodo_c,
    output logic catodo_d,
    output logic catodo_e,
    output logic catodo_f,
    output logic catodo_g,

    // ==========================================
    // DISPLAY DE ANODO COMUN
    // ==========================================

    output logic anodo_a,
    output logic anodo_b,
    output logic anodo_c,
    output logic anodo_d,
    output logic anodo_e,
    output logic anodo_f,
    output logic anodo_g
);

    // ==========================================
    // SEÑALES INTERNAS
    // ==========================================

    logic [3:0] valor_display;

    logic seg_a;
    logic seg_b;
    logic seg_c;
    logic seg_d;
    logic seg_e;
    logic seg_f;
    logic seg_g;


    // ==========================================
    // LEDS DE LA FPGA
    // ==========================================

    assign LED_DATOS = ~datos;
    assign LED_SEC   = ~SEC;
    assign LED_DED   = ~DED;


    // ==========================================
    // SELECCION DEL VALOR A MOSTRAR
    //
    // SWITCH = 0 -> DATOS
    // SWITCH = 1 -> SINDROME
    //
    // DED = 1 -> E
    // ==========================================

    // Cuando DED = 1:
    //     1110 = E
    //
    // Cuando DED = 0:
    //     SWITCH = 0 -> datos
    //     SWITCH = 1 -> sindrome

    assign valor_display[3] =
        DED |
        (~DED & ~SWITCH & datos[3]);

    assign valor_display[2] =
        DED |
        (~DED & (
            (~SWITCH & datos[2]) |
            (SWITCH & sindrome[2])
        ));

    assign valor_display[1] =
        DED |
        (~DED & (
            (~SWITCH & datos[1]) |
            (SWITCH & sindrome[1])
        ));

    assign valor_display[0] =
        ~DED & (
            (~SWITCH & datos[0]) |
            (SWITCH & sindrome[0])
        );

    // ==========================================
    // SEGMENTO A
    //
    // 0,2,3,5,6,7,8,9,A,C,E,F
    // ==========================================

    assign seg_a =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]);


    // ==========================================
    // SEGMENTO B
    //
    // 0,1,2,3,4,7,8,9,A,b,d
    // ==========================================

    assign seg_b =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]);


    // ==========================================
    // SEGMENTO C
    //
    // 0,1,3,4,5,6,7,8,9,A,b,d
    // ==========================================

    assign seg_c =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]);


    // ==========================================
    // SEGMENTO D
    //
    // 0,2,3,5,6,8,9,b,C,d,E
    // ==========================================

    assign seg_d =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]);


    // ==========================================
    // SEGMENTO E
    //
    // 0,2,6,8,A,b,C,d,E,F
    // ==========================================

    assign seg_e =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]);


    // ==========================================
    // SEGMENTO F
    //
    // 0,4,5,6,8,9,A,b,C,E,F
    // ==========================================

    assign seg_f =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]);


    // ==========================================
    // SEGMENTO G
    //
    // 2,3,4,5,6,8,9,A,b,d,E,F
    // ==========================================

    assign seg_g =
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        (~valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] & ~valor_display[2] &  valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] & ~valor_display[1] &  valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] & ~valor_display[0]) |
        ( valor_display[3] &  valor_display[2] &  valor_display[1] &  valor_display[0]);


    // ==========================================
    // DISPLAY DE CATODO COMUN
    //
    // 1 = encendido
    // 0 = apagado
    // ==========================================

    assign catodo_a = seg_a;
    assign catodo_b = seg_b;
    assign catodo_c = seg_c;
    assign catodo_d = seg_d;
    assign catodo_e = seg_e;
    assign catodo_f = seg_f;
    assign catodo_g = seg_g;


    // ==========================================
    // DISPLAY DE ANODO COMUN
    //
    // 0 = encendido
    // 1 = apagado
    // ==========================================

    assign anodo_a = ~seg_a;
    assign anodo_b = ~seg_b;
    assign anodo_c = ~seg_c;
    assign anodo_d = ~seg_d;
    assign anodo_e = ~seg_e;
    assign anodo_f = ~seg_f;
    assign anodo_g = ~seg_g;

endmodule
