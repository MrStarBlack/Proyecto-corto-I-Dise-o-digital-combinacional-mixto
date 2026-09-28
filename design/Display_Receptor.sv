module Display_Receptor (
    input  logic [3:0] datos,
    input  logic       SEC,
    input  logic       DED,
    input  logic [2:0] sindrome,
    input  logic       SWITCH,

    output logic [3:0] LED_DATOS,
    output logic       LED_SEC,
    output logic       LED_DED,

    output logic [6:0] display_catodo,
    output logic [6:0] display_anodo
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
    // LEDS
    // =================================================

    assign LED_DATOS = datos;

    assign LED_SEC = SEC;

    assign LED_DED = DED;


    // =================================================
    // SELECCION DE INFORMACION
    //
    // SWITCH = 0 -> datos corregidos
    // SWITCH = 1 -> sindrome
    //
    // Si DED = 1 se muestra E
    // =================================================

    assign valor_display[3] =
        DED |
        (~DED & (
            (~SWITCH & datos[3]) |
            (SWITCH & sindrome[2])
        ));

    assign valor_display[2] =
        DED |
        (~DED & (
            (~SWITCH & datos[2]) |
            (SWITCH & sindrome[1])
        ));

    assign valor_display[1] =
        DED |
        (~DED & (
            (~SWITCH & datos[1]) |
            (SWITCH & sindrome[0])
        ));

    assign valor_display[0] =
        (~DED & ~SWITCH & datos[0]);


    // =================================================
    // DECODIFICADOR HEXADECIMAL
    //
    // Entrada:
    // valor_display[3:0]
    //
    // Salidas:
    // seg_a, seg_b, seg_c, seg_d,
    // seg_e, seg_f, seg_g
    //
    // 1 = segmento encendido
    // =================================================

    assign seg_a =
        (~valor_display[3] & ~valor_display[2] &
         ~valor_display[1] & valor_display[0]) |

        (~valor_display[3] & ~valor_display[2] &
         valor_display[1] & ~valor_display[0]) |

        (~valor_display[3] & valor_display[2] &
         ~valor_display[1] & ~valor_display[0]) |

        (~valor_display[3] & valor_display[2] &
         valor_display[1] & valor_display[0]) |

        (valor_display[3] & ~valor_display[2] &
         ~valor_display[1] & valor_display[0]) |

        (valor_display[3] & ~valor_display[2] &
         valor_display[1] & ~valor_display[0]) |

        (valor_display[3] & valor_display[2] &
         ~valor_display[1] & ~valor_display[0]) |

        (valor_display[3] & valor_display[2] &
         valor_display[1] & valor_display[0]);


    assign seg_b =
        (~valor_display[3] & ~valor_display[2] &
         valor_display[1]) |

        (~valor_display[3] & valor_display[2] &
         ~valor_display[1]) |

        (~valor_display[3] & valor_display[2] &
         valor_display[0]) |

        (valor_display[3] & ~valor_display[2] &
         ~valor_display[0]) |

        (valor_display[3] & valor_display[2]);


    assign seg_c =
        (~valor_display[3] & ~valor_display[2] &
         ~valor_display[1] & valor_display[0]) |

        (~valor_display[3] & ~valor_display[2] &
         valor_display[1] & valor_display[0]) |

        (~valor_display[3] & valor_display[2] &
         ~valor_display[1]) |

        (valor_display[3] & ~valor_display[2]) |

        (valor_display[3] & valor_display[2] &
         valor_display[1]);


    assign seg_d =
        (~valor_display[3] & ~valor_display[2] &
         ~valor_display[1] & valor_display[0]) |

        (~valor_display[3] & valor_display[1] &
         ~valor_display[0]) |

        (~valor_display[3] & valor_display[2] &
         ~valor_display[1]) |

        (~valor_display[3] & valor_display[2] &
         valor_display[1] & valor_display[0]) |

        (valor_display[3] & ~valor_display[2] &
         ~valor_display[1]) |

        (valor_display[3] & valor_display[2] &
         valor_display[1] & valor_display[0]);


    assign seg_e =
        (~valor_display[3] & valor_display[0]) |

        (~valor_display[2] & valor_display[0]) |

        (~valor_display[3] & valor_display[1]) |

        (valor_display[3] & valor_display[1]) |

        (valor_display[3] & valor_display[2]);


    assign seg_f =
        (~valor_display[3] & ~valor_display[2] &
         ~valor_display[1] & valor_display[0]) |

        (~valor_display[3] & ~valor_display[1]) |

        (~valor_display[3] & valor_display[2]) |

        (valor_display[3] & valor_display[2]) |

        (valor_display[3] & valor_display[1]);


    assign seg_g =
        (~valor_display[3] & ~valor_display[2] &
         ~valor_display[1]) |

        (~valor_display[3] & valor_display[2] &
         valor_display[1] & valor_display[0]) |

        (valor_display[3] & ~valor_display[2] &
         ~valor_display[1]) |

        (valor_display[3] & valor_display[2]);


    // =================================================
    // DISPLAY CATOD COMUN
    //
    // 1 = ENCENDIDO
    // 0 = APAGADO
    // =================================================

    assign display_catodo[6] = seg_a;
    assign display_catodo[5] = seg_b;
    assign display_catodo[4] = seg_c;
    assign display_catodo[3] = seg_d;
    assign display_catodo[2] = seg_e;
    assign display_catodo[1] = seg_f;
    assign display_catodo[0] = seg_g;


    // =================================================
    // DISPLAY ANODO COMUN
    //
    // 0 = ENCENDIDO
    // 1 = APAGADO
    // =================================================

    assign display_anodo[6] = ~seg_a;
    assign display_anodo[5] = ~seg_b;
    assign display_anodo[4] = ~seg_c;
    assign display_anodo[3] = ~seg_d;
    assign display_anodo[2] = ~seg_e;
    assign display_anodo[1] = ~seg_f;
    assign display_anodo[0] = ~seg_g;

endmodule