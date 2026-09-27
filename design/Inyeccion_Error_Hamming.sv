// ============================================================
// ModuloInyeccionErrores.sv
// Toma la palabra de 8 bits ya codificada (Hamming + paridad DED)
// y, según el valor de dos switches de 3 bits, invierte 0, 1 o 2
// bits de esa palabra antes de transmitirla (en este proyecto,
// antes de mandarla a los LEDs de salida porque nos atrasamos y ya no hay fpgas :c ).
//
// Se usó la convención de que el valor binario de cada switch (0 a 7) es
// directamente el índice del bit que se va a invertir.
// switch = 000 -> invierte bit0 (LSB)
// switch = 111 -> invierte bit7 (MSB, el de paridad global)
// ============================================================

module ModuloInyeccionErrores (
    input  logic [7:0] palabra_final,  // palabra ya codificada, entrada
                                         // desde ModuloParidadDED (bit7 =
                                         // paridad global, bit0 = S3, etc.)

    input  logic [2:0] error1,          // Switch de error 1: pines 29,30,33
    input  logic [2:0] error2,          // Switch de error 2: pines 49,31,32

    output logic [7:0] palabra_transmitida
    // Palabra final ya con los errores insertados, hacia los 8 LEDs
    // (pines 54,55,56,57,68,69,48,70).
);

    logic [7:0] mascara1; // máscara de 8 bits con un solo '1' en la
                           // posición que indica 'error1', y '0' en
                           // todas las demás posiciones.
    logic [7:0] mascara2; // Lo mismo, pero para 'error2'.

    // always_comb recalcula esta logica cada vez que cambia cualquier
    // entrada. Aqui se convertierte un numero de 3 bits (0-7) en un bus(palabra) de 8 bits donde
    // solo la posicion indicada por ese numero vale 1.
    //
    // La expresión 8'b1 << error1 es un corrimiento (shift): toma el
    // valor 00000001 y lo recorre 'error1' posiciones hacia la
    // izquierda. Por ejemplo, si error1 = 3 (011), el resultado es
    // 00001000 (el '1' quedo en la posición 3). Esto reemplaza tener
    // que escribir un case largo con las 8 combinaciones a mano.
    always_comb begin
        mascara1 = 8'b00000001 << error1;
        mascara2 = 8'b00000001 << error2;
    end

    // Se aplica XOR de la palabra original con ambas mascaras a la vez:
    // - Si un bit tiene un 1 en una sola mascara, ese bit se invierte
    //   (se introduce el error ahí).
    // - Si un bit tiene un 1 en las dos mascaras (ambos switches
    //   apuntan a la misma posición), el XOR de ambas mascaras en esa
    //   posición da 0 (1 XOR 1 = 0), asi que el bit no se invierte
    //   en neto: es la cancelacion por doble negacion que se pidio
    assign palabra_transmitida = palabra_final ^ mascara1 ^ mascara2;

endmodule
