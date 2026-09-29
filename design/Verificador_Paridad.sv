module Verificador_Paridad (
    input  logic [7:0] palabra_recibida,
    output logic       ERROR_PARIDAD
);
    assign ERROR_PARIDAD = ^palabra_recibida; // 1 = paridad impar (error)
endmodule
