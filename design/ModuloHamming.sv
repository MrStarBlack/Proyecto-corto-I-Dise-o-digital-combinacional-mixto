// ============================================================
// ModuloHamming.sv
// Este modulo NO calcula la paridad (eso ya lo hacen los 3
// 74HC86 fisicos por fuera de la FPGA). Lo que hace el codigo es leer
// los 4 bits de datos que el usuario ingresó con los switches y leer
// los 3 sindromes de paridad (S1,S2,S3) que llegan ya calculados
// desde las salidas de los 74HC86, y juntarlos en una sola
// palabra de 7 bits para pasarla al siguiente subsistema
// de insercion de error.
// ============================================================

module ModuloHamming (
    input  logic D0, D1, D2, D3,   // datos del usuario: mismos nodos físicos
                                     // que ya usa el display del subsistema
                                     // anterior con los pines 34, 40, 35, 41.
    input  logic S1, S2, S3,        // sindromes de paridad ya calculados por
                                     // los 74HC86 (S1=pin42, S2=pin51,
                                     // S3=pin53).

    output logic [6:0] palabra_codificada
    // la palabra de 7 bits que sale de este modulo hacia el subsistema
    // de inserción de error. 'logic [6:0]' es simplemente un
    // cable (wire) agrupado de 7 líneas, no un registro con memoria,
    
);

    // 'assign' describe una conexión combinacional directa, la salida
    // sigue instantáneamente el valor de las entradas
    // Aquí no hay ninguna operación lógica real
  // (el cálculo de S1,S2,S3 ya lo hicieron las 74HC86); solo
    // se ordenan los 7 bits en el bus de salida según lo pedido:
    // D0, D1, D2, D3, S1, S2, S3.
    assign palabra_codificada = {D0, D1, D2, D3, S1, S2, S3};

endmodule
