`timescale 1ns/1ps


module tb_Display_Receptor;

    // Entradas del DUT
    logic [3:0] datos;
    logic       SEC;
    logic       DED;
    logic [2:0] sindrome;
    logic       SWITCH;

    // Salidas del DUT
    logic [3:0] LED_DATOS;
    logic       LED_SEC;
    logic       LED_DED;

    logic catodo_a, catodo_b, catodo_c, catodo_d, catodo_e, catodo_f, catodo_g;
    logic anodo_a,  anodo_b,  anodo_c,  anodo_d,  anodo_e,  anodo_f,  anodo_g;

    // DUT
    Display_Receptor dut (
        .datos     (datos),
        .SEC       (SEC),
        .DED       (DED),
        .sindrome  (sindrome),
        .SWITCH    (SWITCH),
        .LED_DATOS (LED_DATOS),
        .LED_SEC   (LED_SEC),
        .LED_DED   (LED_DED),
        .catodo_a(catodo_a), .catodo_b(catodo_b), .catodo_c(catodo_c), .catodo_d(catodo_d),
        .catodo_e(catodo_e), .catodo_f(catodo_f), .catodo_g(catodo_g),
        .anodo_a(anodo_a),   .anodo_b(anodo_b),   .anodo_c(anodo_c),   .anodo_d(anodo_d),
        .anodo_e(anodo_e),   .anodo_f(anodo_f),   .anodo_g(anodo_g)
    );

    // Vectores {a,b,c,d,e,f,g} para comparar
    logic [6:0] cat_vec, ano_vec;
    assign cat_vec = {catodo_a, catodo_b, catodo_c, catodo_d, catodo_e, catodo_f, catodo_g};
    assign ano_vec = {anodo_a,  anodo_b,  anodo_c,  anodo_d,  anodo_e,  anodo_f,  anodo_g};

    // ------------------------------------------------------------
    // Tabla de referencia: segmentos {a,b,c,d,e,f,g}, 1 = encendido
    // ------------------------------------------------------------
    function automatic logic [6:0] seg_ref (input logic [3:0] v);
        case (v)
            4'h0: seg_ref = 7'b1111110;
            4'h1: seg_ref = 7'b0110000;
            4'h2: seg_ref = 7'b1101101;
            4'h3: seg_ref = 7'b1111001;
            4'h4: seg_ref = 7'b0110011;
            4'h5: seg_ref = 7'b1011011;
            4'h6: seg_ref = 7'b1011111;
            4'h7: seg_ref = 7'b1110000;
            4'h8: seg_ref = 7'b1111111;
            4'h9: seg_ref = 7'b1111011;
            4'hA: seg_ref = 7'b1110111;
            4'hB: seg_ref = 7'b0011111; // b
            4'hC: seg_ref = 7'b1001110;
            4'hD: seg_ref = 7'b0111101; // d
            4'hE: seg_ref = 7'b1001111;
            4'hF: seg_ref = 7'b1000111;
            default: seg_ref = 7'bxxxxxxx;
        endcase
    endfunction

    // ------------------------------------------------------------
    // Verificacion de un estado
    // ------------------------------------------------------------
    integer errores = 0;
    integer pruebas = 0;

    task automatic verificar;
        logic [3:0] valor_esp;
        logic [6:0] seg_esp;
        begin
            #1; // dejar propagar la logica combinacional

            if (DED)          valor_esp = 4'hE;
            else if (SWITCH)  valor_esp = {1'b0, sindrome};
            else              valor_esp = datos;

            seg_esp = seg_ref(valor_esp);
            pruebas = pruebas + 1;

            if (cat_vec !== seg_esp) begin
                errores = errores + 1;
                $display("[ERROR] t=%0t CATODO: datos=%h sind=%b SW=%b SEC=%b DED=%b | esperado(abcdefg)=%b obtenido=%b",
                         $time, datos, sindrome, SWITCH, SEC, DED, seg_esp, cat_vec);
            end
            if (ano_vec !== ~seg_esp) begin
                errores = errores + 1;
                $display("[ERROR] t=%0t ANODO: datos=%h sind=%b SW=%b SEC=%b DED=%b | esperado(abcdefg)=%b obtenido=%b",
                         $time, datos, sindrome, SWITCH, SEC, DED, ~seg_esp, ano_vec);
            end
            if (LED_DATOS !== ~datos) begin
                errores = errores + 1;
                $display("[ERROR] t=%0t LED_DATOS: datos=%h esperado=%b obtenido=%b",
                         $time, datos, ~datos, LED_DATOS);
            end
            if (LED_SEC !== ~SEC) begin
                errores = errores + 1;
                $display("[ERROR] t=%0t LED_SEC: SEC=%b esperado=%b obtenido=%b",
                         $time, SEC, ~SEC, LED_SEC);
            end
            if (LED_DED !== ~DED) begin
                errores = errores + 1;
                $display("[ERROR] t=%0t LED_DED: DED=%b esperado=%b obtenido=%b",
                         $time, DED, ~DED, LED_DED);
            end
        end
    endtask

    // Caso dirigido con mensaje legible
    task automatic caso (
        input string      nombre,
        input logic [3:0] d,
        input logic       sec_i,
        input logic       ded_i,
        input logic [2:0] s,
        input logic       sw
    );
        begin
            datos = d; SEC = sec_i; DED = ded_i; sindrome = s; SWITCH = sw;
            verificar();
            $display("%-28s datos=%h sind=%h SW=%b SEC=%b DED=%b | cat(abcdefg)=%b ano(abcdefg)=%b | LEDs(DED,SEC,D3..D0)=%b%b%b",
                     nombre, d, s, sw, sec_i, ded_i, cat_vec, ano_vec, LED_DED, LED_SEC, LED_DATOS);
        end
    endtask

    // ------------------------------------------------------------
    // Estimulos
    // ------------------------------------------------------------
    integer i;

    initial begin
        $dumpfile("tb_Display_Receptor.vcd");
        $dumpvars(0, tb_Display_Receptor);

        datos = 4'h0; SEC = 1'b0; DED = 1'b0; sindrome = 3'b000; SWITCH = 1'b0;

        $display("=== Casos dirigidos ===");
        //     nombre                        datos  SEC  DED  sind   SW
        caso("Sin error, datos 0",           4'h0, 1'b0, 1'b0, 3'b000, 1'b0);
        caso("Sin error, datos 0, SW=1",     4'h0, 1'b0, 1'b0, 3'b000, 1'b1);
        caso("Sin error, datos 5",           4'h5, 1'b0, 1'b0, 3'b000, 1'b0);
        caso("Sin error, datos F",           4'hF, 1'b0, 1'b0, 3'b000, 1'b0);
        caso("Error solo en P, datos F",     4'hF, 1'b1, 1'b0, 3'b000, 1'b0);
        caso("Error solo en P, SW=1",        4'hF, 1'b1, 1'b0, 3'b000, 1'b1);
        caso("Error pos 2, datos 5, SW=0",   4'h5, 1'b1, 1'b0, 3'b010, 1'b0);
        caso("Error pos 2, datos 5, SW=1",   4'h5, 1'b1, 1'b0, 3'b010, 1'b1);
        caso("Error pos 3, datos 5, SW=1",   4'h5, 1'b1, 1'b0, 3'b011, 1'b1);
        caso("Error pos 7, datos F, SW=1",   4'hF, 1'b1, 1'b0, 3'b111, 1'b1);
        caso("Doble error, SW=0",            4'h6, 1'b0, 1'b1, 3'b011, 1'b0);
        caso("Doble error, SW=1",            4'h6, 1'b0, 1'b1, 3'b011, 1'b1);

        $display("=== Barrido exhaustivo (1024 combinaciones) ===");
        for (i = 0; i < 1024; i = i + 1) begin
            {DED, SEC, SWITCH, sindrome, datos} = i[9:0];
            verificar();
        end

        $display("-----------------------------------------------");
        $display("Pruebas ejecutadas: %0d", pruebas);
        if (errores == 0)
            $display("RESULTADO: TODAS LAS PRUEBAS PASARON");
        else
            $display("RESULTADO: %0d ERRORES", errores);
        $display("-----------------------------------------------");

        $finish;
    end

endmodule
