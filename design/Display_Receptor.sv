module Display_Receptor (
    input  logic [3:0] datos,
    input  logic       SEC,
    input  logic       DED,
    input  logic [2:0] sindrome,
    input  logic       SWITCH,

    output logic [3:0] LED_DATOS,
    output logic       LED_SEC,
    output logic       LED_DED,

    output logic catodo_a,
    output logic catodo_b,
    output logic catodo_c,
    output logic catodo_d,
    output logic catodo_e,
    output logic catodo_f,
    output logic catodo_g,

    output logic anodo_a,
    output logic anodo_b,
    output logic anodo_c,
    output logic anodo_d,
    output logic anodo_e,
    output logic anodo_f,
    output logic anodo_g
);

    logic [3:0] valor_display;

    logic seg_a;
    logic seg_b;
    logic seg_c;
    logic seg_d;
    logic seg_e;
    logic seg_f;
    logic seg_g;


    // =================================================
    // LEDS DE DATOS
    //
    // Los LEDs integrados de la Tang Nano 9K son
    // activos en bajo.
    // =================================================

    assign LED_DATOS = ~datos;

    assign LED_SEC = ~SEC;

    assign LED_DED = ~DED;


    // =================================================
    // SELECCION DEL VALOR A MOSTRAR
    //
    // SWITCH = 0:
    //     muestra los datos corregidos
    //
    // SWITCH = 1:
    //     muestra el sindrome
    //
    // DED = 1:
    //     muestra E = 1110
    // =================================================

    assign valor_display[3] =
        DED |
        (~DED & (
            (~SWITCH & datos[3]) |
            (SWITCH & 1'b0)
        ));

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
        (~DED & (
            (~SWITCH & datos[0]) |
            (SWITCH & sindrome[0])
        ));


    // =================================================
    // DECODIFICADOR HEXADECIMAL
    //
    // valor_display:
    //
    // 0000 = 0
    // 0001 = 1
    // ...
    // 1001 = 9
    // 1010 = A
    // 1011 = b
    // 1100 = C
    // 1101 = d
    // 1110 = E
    // 1111 = F
    //
    // Los segmentos son activos en alto.
    // =================================================


    // -------------------------------------------------
    // SEGMENTO A
    // -------------------------------------------------

    assign seg_a =
        (~valor_display[3] & ~valor_display[2] & ~valor_display[1]) |
        (~valor_display[3] & valor_display[2] & ~valor_display[0]) |
        (valor_display[3] & ~valor_display[2] & ~valor_display[1]) |
        (valor_display[3] & valor_display[2] & ~valor_display[1]);


    // -------------------------------------------------
    // SEGMENTO B
    // -------------------------------------------------

    assign seg_b =
        (~valor_display[3] & ~valor_display[2] & valor_display[1]) |
        (~valor_display[3] & valor_display[1] & ~valor_display[0]) |
        (~valor_display[3] & valor_display[2] & ~valor_display[1]) |
        (valor_display[3] & ~valor_display[2] & valor_display[1]) |
        (valor_display[3] & valor_display[2] & ~valor_display[1]);


    // -------------------------------------------------
    // SEGMENTO C
    // -------------------------------------------------

    assign seg_c =
        (~valor_display[3] & ~valor_display[2] & valor_display[0]) |
        (~valor_display[3] & valor_display[2] & ~valor_display[1]) |
        (~valor_display[3] & valor_display[2] & valor_display[0]) |
        (valor_display[3] & ~valor_display[2]) |
        (valor_display[3] & valor_display[1]);


    // -------------------------------------------------
    // SEGMENTO D
    // -------------------------------------------------

    assign seg_d =
        (~valor_display[3] & ~valor_display[2] & valor_display[0]) |
        (~valor_display[3] & valor_display[2] & ~valor_display[1]) |
        (~valor_display[3] & valor_display[2] & valor_display[1] & valor_display[0]) |
        (valor_display[3] & ~valor_display[2] & ~valor_display[1]) |
        (valor_display[3] & valor_display[2] & valor_display[1] & valor_display[0]);


    // -------------------------------------------------
    // SEGMENTO E
    // -------------------------------------------------

    assign seg_e =
        (~valor_display[3] & valor_display[0]) |
        (~valor_display[3] & valor_display[2] & ~valor_display[1]) |
        (~valor_display[2] & valor_display[0]) |
        (valor_display[3] & valor_display[2] & ~valor_display[1]) |
        (valor_display[3] & ~valor_display[1] & ~valor_display[0]);


    // -------------------------------------------------
    // SEGMENTO F
    // -------------------------------------------------

    assign seg_f =
        (~valor_display[3] & ~valor_display[2] & valor_display[0]) |
        (~valor_display[3] & ~valor_display[1]) |
        (~valor_display[3] & valor_display[2]) |
        (valor_display[3] & valor_display[1] & ~valor_display[0]) |
        (valor_display[3] & valor_display[2]);


    // -------------------------------------------------
    // SEGMENTO G
    // -------------------------------------------------

    assign seg_g =
        (~valor_display[3] & ~valor_display[2] & valor_display[1]) |
        (~valor_display[3] & valor_display[2] & ~valor_display[1]) |
        (~valor_display[3] & valor_display[2] & valor_display[0]) |
        (valor_display[3] & ~valor_display[2] & valor_display[1]) |
        (valor_display[3] & valor_display[2]);


    // =================================================
    // DISPLAY DE CATODO COMUN
    //
    // 1 = segmento encendido
    // 0 = segmento apagado
    // =================================================

    assign catodo_a = seg_a;
    assign catodo_b = seg_b;
    assign catodo_c = seg_c;
    assign catodo_d = seg_d;
    assign catodo_e = seg_e;
    assign catodo_f = seg_f;
    assign catodo_g = seg_g;


    // =================================================
    // DISPLAY DE ANODO COMUN
    //
    // 0 = segmento encendido
    // 1 = segmento apagado
    // =================================================

    assign anodo_a = ~seg_a;
    assign anodo_b = ~seg_b;
    assign anodo_c = ~seg_c;
    assign anodo_d = ~seg_d;
    assign anodo_e = ~seg_e;
    assign anodo_f = ~seg_f;
    assign anodo_g = ~seg_g;

endmodule
