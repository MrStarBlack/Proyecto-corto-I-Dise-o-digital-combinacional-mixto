// ============================================================
// ModuloInyeccionErrores.v
// Invierte 0, 1 o 2 bits de la palabra de 8 bits segun dos
// switches de 3 bits. El valor del switch (0-7) es directamente
// el indice del bit a invertir. Si ambos apuntan al mismo bit,
// se cancelan (doble negacion).
// ============================================================
module ModuloInyeccionErrores (
    input  [7:0] palabra_final,       // Desde ModuloParidadDED
    input  [2:0] error1,              // Pines 29, 30, 33
    input  [2:0] error2,              // Pines 49, 31, 32
    output [7:0] palabra_transmitida  // A los LEDs
);

    // Corrimiento a la izquierda: 00000001 << n deja un unico '1'
    // en la posicion n (decodificador binario a one-hot).
    wire [7:0] mascara1 = (error1 == 3'b000) ? 8'b00000000 : (8'b00000001 << (error1 - 3'd1));
    wire [7:0] mascara2 = (error2 == 3'b000) ? 8'b00000000 : (8'b00000001 << (error2 - 3'd1));

    // XOR con ambas mascaras: cada '1' invierte su bit. Si las dos
    // mascaras coinciden, 1^1 = 0 y el bit no cambia.
    assign palabra_transmitida = palabra_final ^ mascara1 ^ mascara2;

endmodule
