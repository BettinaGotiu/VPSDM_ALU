`timescale 1ns / 1ps

module alu_tb;
    logic [3:0] a, b;
    logic [2:0] op;
    logic [3:0] result;
    logic carry, zero, negative, overflow;    
    logic [3:0] expected_result;
    logic expected_carry, expected_zero, expected_negative, expected_overflow;

    localparam ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, SHIFT_LEFT = 3'b100, SHIFT_RIGHT = 3'b101;

    // Instantiaterea modulului ALU
    alu myALU(.a(a), .b(b), .op(op), .result(result), .carry(carry), .zero(zero), .negative(negative), .overflow(overflow));
    // Instantiaterea monitorului
    alu_monitor monitor(.a(a), .b(b), .op(op), .result(result), .carry(carry), .zero(zero), .negative(negative), .overflow(overflow),
                        .expected_result(expected_result), .expected_carry(expected_carry), .expected_zero(expected_zero),
                        .expected_negative(expected_negative), .expected_overflow(expected_overflow));

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(1, alu_tb);

      $display("Teste pentru operatiile principale:");

        // Test ADD - Adunarea simpla
        a = 4'b0101; b = 4'b0011; op = ADD; 
        expected_result = 4'b1000; expected_carry = 0; expected_zero = 0; expected_negative = 1; expected_overflow = 1;
        #10; check_results("Adunare");

        // Test SUB - Scaderea simpla
        a = 4'b0110; b = 4'b0011; op = SUB; 
        expected_result = 4'b0011; expected_carry = 0; expected_zero = 0; expected_negative = 0; expected_overflow = 0;
        #10; check_results("Scadere");

        // Test AND - Operatia logica AND
        a = 4'b1100; b = 4'b1010; op = AND; 
        expected_result = 4'b1000; expected_carry = 0; expected_zero = 0; expected_negative = 1; expected_overflow = 0;
        #10; check_results("Operatie AND");

        // Test OR - Operatia logica OR
        a = 4'b0101; b = 4'b1010; op = OR; 
        expected_result = 4'b1111; expected_carry = 0; expected_zero = 0; expected_negative = 1; expected_overflow = 0;
        #10; check_results("Operatie OR");

        // Test SHIFT_LEFT - Shiftare la stanga
        a = 4'b0101; op = SHIFT_LEFT; 
        expected_result = 4'b1010; expected_carry = 0; expected_zero = 0; expected_negative = 1; expected_overflow = 0;
        #10; check_results("Shiftare la stanga");

        // Test SHIFT_RIGHT - Shiftare la dreapta
        a = 4'b0101; op = SHIFT_RIGHT; 
        expected_result = 4'b0010; expected_carry = 0; expected_zero = 0; expected_negative = 0; expected_overflow = 0;
        #10; check_results("Shiftare la dreapta");

      $display("Teste pentru Corner Cases:");

        // Carry Test pentru operatia ADD
        a = 4'b1111; b = 4'b0001; op = ADD; 
        expected_result = 4'b0000; expected_carry = 1; expected_zero = 1; expected_negative = 0; expected_overflow = 0;
        #10; check_results("Carry la adunare");

        // Overflow Test pentru operatia ADD
        a = 4'b0111; b = 4'b0111; op = ADD; 
        expected_result = 4'b1110; expected_carry = 0; expected_zero = 0; expected_negative = 1; expected_overflow = 1;
        #10; check_results("Overflow la adunare");

      	// Borrow Test pentru SUB
        a = 4'b0000; b = 4'b0001; op = SUB; 
        expected_result = 4'b1111; expected_carry = 1; expected_zero = 0; expected_negative = 1; expected_overflow = 0;
        #10; check_results("Borrow la scadere");

        // ADD cu operanzi zero
        a = 4'b0000; b = 4'b0000; op = ADD; 
        expected_result = 4'b0000; expected_carry = 0; expected_zero = 1; expected_negative = 0; expected_overflow = 0;
        #10; check_results("Adunare cu zero");

        // ADD cu valori maxime
        a = 4'b1111; b = 4'b1111; op = ADD; 
        expected_result = 4'b1110; expected_carry = 1; expected_zero = 0; expected_negative = 1; expected_overflow = 0;
        #10; check_results("Adunare cu valori maxime");

        // SUB cu calori maxime
        a = 4'b1111; b = 4'b1111; op = SUB; 
        expected_result = 4'b0000; expected_carry = 0; expected_zero = 1; expected_negative = 0; expected_overflow = 0;
        #10; check_results("Scadere cu valori maxime");

        // Shift left by max - Shiftare la stanga cu operanzi maximali
        a = 4'b0101; op = SHIFT_LEFT; 
        expected_result = 4'b1010; expected_carry = 0; expected_zero = 0; expected_negative = 1; expected_overflow = 0;
        #10; check_results("Shiftare la stanga la maxim");

        // Shift right by max - Shiftare la dreapta cu operanzi maximali
        a = 4'b0101; op = SHIFT_RIGHT; 
        expected_result = 4'b0010; expected_carry = 0; expected_zero = 0; expected_negative = 0; expected_overflow = 0;
        #10; check_results("Shiftare la dreapta la maxim");

      $display("Generare teste aleatorii:");
        repeat (10) begin
            a = $random % 16;
            b = $random % 16;
            op = $random % 6;
            expected_result = (op == ADD) ? a + b :
                              (op == SUB) ? a - b :
                              (op == AND) ? a & b :
                              (op == OR)  ? a | b :
                              (op == SHIFT_LEFT) ? a << 1 :
                              (op == SHIFT_RIGHT) ? a >> 1 : 4'bxxxx;
            expected_carry = (op == ADD) ? (a + b) > 4'b1111 :
                             (op == SUB) ? a < b : 0;
            expected_zero = (expected_result == 4'b0000);
            expected_negative = expected_result[3];
            expected_overflow = (op == ADD) ? (a[3] == b[3]) && (expected_result[3] != a[3]) :
                               (op == SUB) ? (a[3] != b[3]) && (expected_result[3] != a[3]) : 0;
            #10;
          check_results($sformatf("Test random cu a=%b, b=%b, op=%b", a, b, op));
        end

        $finish;
    end

    function void check_results(string msg);
        if (result !== expected_result || carry !== expected_carry || zero !== expected_zero || negative !== expected_negative || overflow !== expected_overflow) 
            $error("%s a esuat: rezultat asteptat %b, obtinut %b; carry asteptat %b, obtinut %b; zero asteptat %b, obtinut %b; negative asteptat %b, obtinut %b; overflow asteptat %b, obtinut %b", 
                   msg, expected_result, result, expected_carry, carry, expected_zero, zero, expected_negative, negative, expected_overflow, overflow);
        else 
            $display("%s a trecut: rezultat %b, carry %b, zero %b, negative %b, overflow %b", 
                     msg, result, carry, zero, negative, overflow);
    endfunction

endmodule