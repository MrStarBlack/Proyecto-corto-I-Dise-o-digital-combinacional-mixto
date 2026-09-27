// ============================================================
// Decodificador7Segmentos.sv
// Convierte una palabra binaria de 4 bits (D0-D3) en las señales
// necesarias para encender los segmentos correctos de un display
// de 7 segmentos de CÁTODO COMÚN, mostrando el dígito hexadecimal
// equivalente (0-9, A-F).
// ============================================================

module Decodificador7Segmentos (
    input  logic [3:0] dato,        // Entrada a los 4 bits D3 D2 D1 D0 a mostrar
    output logic        seg_a,       // Salida individual para cada segmento.
    output logic        seg_b,       // Cada una va directo al pin de la FPGA
    output logic        seg_c,       // que se asigno en este orden:38,37,36,39,25,26,27
    output logic        seg_d,
    output logic        seg_e,
    output logic        seg_f,
    output logic        seg_g,
    output logic        transistor_en // Controla la base del NPN (pin 28)
                                       // En '1' satura el transistor -> cátodo
                                       // a GND -> display encendido
);

    // 'logic' aquí cumple el mismo rol que un 'wire', pero es el tipo
    // moderno recomendado en SystemVerilog: representa una conexión física
    // (un cable) entre este modulo y lo que lo instancie. No almacena nada
    // por si sola; su valor lo determina lo que esté conectado a ella
    // (en este caso, el resultado del 'always_comb' de abajo).
    logic [6:0] segmentos; // Empaqueta las 7 salidas a,b,c,d,e,f,g en un solo bus
                           // interno, solo para que el 'case' sea más compacto
                           // de escribir (un assign en vez de siete).

    // 'always_comb' describe lógica puramente combinacional: la salida
    // se recalcula automáticamente cada vez que cambia 'dato', sin reloj
    // ni memoria de por medio porque no es permitido
    always_comb begin
        case (dato)
            // Orden de bits: {g,f,e,d,c,b,a}. Un 1 enciende el segmento
            // porque el display es cátodo común y cada pin de segmento
            // va conectado directo (sin transistor) desde la FPGA.
            4'h0: segmentos = 7'b0111111; // 0
            4'h1: segmentos = 7'b0000110; // 1
            4'h2: segmentos = 7'b1011011; // 2
            4'h3: segmentos = 7'b1001111; // 3
            4'h4: segmentos = 7'b1100110; // 4
            4'h5: segmentos = 7'b1101101; // 5
            4'h6: segmentos = 7'b1111101; // 6
            4'h7: segmentos = 7'b0000111; // 7
            4'h8: segmentos = 7'b1111111; // 8
            4'h9: segmentos = 7'b1101111; // 9
            4'hA: segmentos = 7'b1110111; // A
            4'hB: segmentos = 7'b1111100; // b
            4'hC: segmentos = 7'b0111001; // C
            4'hD: segmentos = 7'b1011110; // d
            4'hE: segmentos = 7'b1111001; // E
            4'hF: segmentos = 7'b1110001; // F
            default: segmentos = 7'b0000000; // Todo apagado por seguridad
        endcase
    end

    // Se reparte el bus interno 'segmentos' hacia los 7 pines individuales
    // de salida del modulo, en el mismo orden: g,f,e,d,c,b,a definido arriba.
    assign seg_g = segmentos[6];
    assign seg_f = segmentos[5];
    assign seg_e = segmentos[4];
    assign seg_d = segmentos[3];
    assign seg_c = segmentos[2];
    assign seg_b = segmentos[1];
    assign seg_a = segmentos[0];

    // El display siempre debe estar encendido en este subsistema
    // así que el transistor se mantiene saturado de forma constante.
    assign transistor_en = 1'b1;

endmodule
